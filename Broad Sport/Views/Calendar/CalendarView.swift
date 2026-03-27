import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var appState: AppState
    @State private var displayedMonth = Date()
    @State private var selectedDate: Date? = nil
    @State private var showAddTraining = false
    @State private var trainingToDelete: Training? = nil

    private let cal = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    private var upcomingReminder: Training? {
        let now = Date()
        let soon = now.addingTimeInterval(3600)
        return appState.trainings.first {
            cal.isDateInToday($0.date) &&
            $0.startTime >= now &&
            $0.startTime <= soon
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if upcomingReminder != nil {
                    reminderBanner
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                ScrollView(showsIndicators: false) {
                    VStack(spacing: screenHeight * 0.024) {
                        calendarCard

                        if let date = selectedDate {
                            trainingsBlock(for: date)
                        } else {
                            emptyState
                        }
                    }
                    .padding(.horizontal, screenHeight * 0.019)
                    .padding(.top, screenHeight * 0.018)
                    .padding(.bottom, screenHeight * 0.01)
                }

            }
            .background(Color.white.ignoresSafeArea())
            .animation(.easeInOut(duration: 0.2), value: upcomingReminder?.id)
            .animation(.easeInOut(duration: 0.2), value: selectedDate.map { isPast($0) })
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                AppNavBar(title: "Calendar")
            }
            .alert("Remove training?", isPresented: Binding(
                get: { trainingToDelete != nil },
                set: { if !$0 { trainingToDelete = nil } }
            )) {
                Button("Cancel", role: .cancel) { trainingToDelete = nil }
                Button("Remove", role: .destructive) {
                    if let t = trainingToDelete {
                        withAnimation { appState.removeTraining(t) }
                    }
                    trainingToDelete = nil
                }
            } message: {
                Text("Are you sure you want to remove this training?")
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                if let date = selectedDate, !isPast(date) {
                    addTrainingButton
                        .padding(.horizontal, screenHeight * 0.019)
                        .padding(.vertical, screenHeight * 0.012)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .sheet(isPresented: $showAddTraining) {
                if let date = selectedDate {
                    AddTrainingSheet(date: date)
                        .environmentObject(appState)
                        .presentationDetents([.fraction(0.88)])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }

    // MARK: - Reminder Banner

    private var reminderBanner: some View {
        Text("Your training starts in 1 hour")
            .font(.sfPro(screenHeight * 0.016))
            .foregroundColor(Color.appRed)
            .frame(maxWidth: .infinity)
            .padding(.vertical, screenHeight * 0.012)
            .background(Color.appRed.opacity(0.12))
    }

    // MARK: - Calendar Card

    private var calendarCard: some View {
        VStack(spacing: screenHeight * 0.016) {
            monthNavigator
            weekdayHeader
            daysGrid
        }
        .padding(screenHeight * 0.018)
        .background(Color.appGray6)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.022))
    }

    private var monthNavigator: some View {
        HStack {
            Button { changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: screenHeight * 0.016, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: screenHeight * 0.042, height: screenHeight * 0.042)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            Spacer()

            Text(monthYearString)
                .font(.sfPro(screenHeight * 0.024))
                .foregroundColor(.black)

            Spacer()

            Button { changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: screenHeight * 0.016, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(width: screenHeight * 0.042, height: screenHeight * 0.042)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
    }

    private var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(Array(weekdays.enumerated()), id: \.offset) { _, day in
                Text(day)
                    .font(.sfPro(screenHeight * 0.014))
                    .foregroundColor(Color.appGray)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var daysGrid: some View {
        LazyVGrid(columns: columns, spacing: screenHeight * 0.004) {
            ForEach(Array(gridDays.enumerated()), id: \.offset) { _, date in
                if let date {
                    dayCell(date)
                } else {
                    Color.clear.frame(height: screenHeight * 0.052)
                }
            }
        }
    }

    private func dayCell(_ date: Date) -> some View {
        let today = isToday(date)
        let selected = isSelected(date)
        let past = isPast(date)
        let hasDot = appState.hasTrainings(on: date)

        return Button {
            if !past { selectedDate = date }
        } label: {
            VStack(spacing: screenHeight * 0.003) {
                Text("\(cal.component(.day, from: date))")
                    .font(.sfPro(screenHeight * 0.016))
                    .foregroundColor(cellTextColor(today: today, selected: selected, past: past))
                    .frame(width: screenHeight * 0.044, height: screenHeight * 0.044)
                    .background { cellBackground(today: today, selected: selected) }

                Circle()
                    .fill(hasDot && !today ? Color.appRed : Color.clear)
                    .frame(width: screenHeight * 0.006, height: screenHeight * 0.006)
            }
        }
        .buttonStyle(.plain)
        .disabled(past)
    }

    private func cellTextColor(today: Bool, selected: Bool, past: Bool) -> Color {
        if past     { return Color.appGray4 }
        if today    { return .white }
        if selected { return Color.appRed }
        return .black
    }

    @ViewBuilder
    private func cellBackground(today: Bool, selected: Bool) -> some View {
        if today {
            Circle().fill(Color.appRed)
        } else if selected {
            Circle().strokeBorder(Color.appRed, lineWidth: 1.5)
        } else {
            Color.clear
        }
    }

    // MARK: - Trainings Block

    private func trainingsBlock(for date: Date) -> some View {
        let items = appState.trainings(for: date)
        return VStack(alignment: .leading, spacing: screenHeight * 0.014) {
            Text("Trainings on \(dayMonthString(date))")
                .font(.sfPro(screenHeight * 0.026))
                .foregroundColor(.black)

            if items.isEmpty {
                emptyState
            } else {
                ForEach(items) { training in
                    trainingCard(training)
                }
            }
        }
    }

    private func trainingCard(_ training: Training) -> some View {
        HStack(alignment: .top, spacing: screenHeight * 0.012) {
            VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                Text(training.sportName)
                    .font(.sfPro(screenHeight * 0.018))
                    .foregroundColor(.black)
                Text("\(timeString(training.startTime)) - \(timeString(training.endTime))")
                    .font(.sfPro(screenHeight * 0.015))
                    .foregroundColor(Color.appGray)
                if !training.location.isEmpty {
                    Text(training.location)
                        .font(.sfPro(screenHeight * 0.015))
                        .foregroundColor(Color.appGray)
                }
            }
            Spacer()
            Button {
                trainingToDelete = training
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: screenHeight * 0.014, weight: .medium))
                    .foregroundColor(Color.appGray)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, screenHeight * 0.018)
        .padding(.vertical, screenHeight * 0.016)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.016))
        .overlay {
            RoundedRectangle(cornerRadius: screenHeight * 0.016)
                .strokeBorder(Color.appGray5, lineWidth: 1)
        }
    }

    private var emptyState: some View {
        VStack(spacing: screenHeight * 0.008) {
            Text("No trainings planned")
                .font(.sfPro(screenHeight * 0.02))
                .foregroundColor(.black)
            Text("Tap \"Add Training\" to schedule your first workout.")
                .font(.sfPro(screenHeight * 0.015))
                .foregroundColor(Color.appGray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, screenHeight * 0.022)
    }

    private var addTrainingButton: some View {
        Button { showAddTraining = true } label: {
            Text("Add Training")
                .font(.sfPro(screenHeight * 0.018))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.046)
                .background(Color.appRed)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.bottom, screenHeight*0.13)
    }

    // MARK: - Helpers

    private var monthYearString: String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: displayedMonth)
    }

    private func dayMonthString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM d"
        return f.string(from: date)
    }

    private var gridDays: [Date?] {
        let comps = cal.dateComponents([.year, .month], from: displayedMonth)
        let firstDay = cal.date(from: comps)!
        let weekday = cal.component(.weekday, from: firstDay)
        let count = cal.range(of: .day, in: .month, for: firstDay)!.count

        var grid: [Date?] = Array(repeating: nil, count: weekday - 1)
        for day in 0..<count {
            grid.append(cal.date(byAdding: .day, value: day, to: firstDay))
        }
        while grid.count % 7 != 0 { grid.append(nil) }
        return grid
    }

    private func changeMonth(by value: Int) {
        withAnimation(.easeInOut(duration: 0.2)) {
            displayedMonth = cal.date(byAdding: .month, value: value, to: displayedMonth)!
            selectedDate = nil
        }
    }

    private func isToday(_ date: Date) -> Bool { cal.isDateInToday(date) }

    private func isSelected(_ date: Date) -> Bool {
        guard let sel = selectedDate else { return false }
        return cal.isDate(date, inSameDayAs: sel)
    }

    private func isPast(_ date: Date) -> Bool {
        cal.startOfDay(for: date) < cal.startOfDay(for: Date())
    }

    private func timeString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }
}

#Preview {
    CalendarView()
        .environmentObject(AppState())
}
