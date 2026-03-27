import SwiftUI

struct AddTrainingSheet: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let date: Date

    @State private var sportName: String = ""
    @State private var location: String = ""
    @State private var repeatType: String = "Does not repeat"
    @State private var startTime: Date = Self.defaultStart()
    @State private var endTime: Date = Self.defaultEnd()

    @State private var showTimePicker = false
    @State private var editingStartTime = true
    @State private var openDropdown: SheetDropdown? = nil

    private enum SheetDropdown { case sport, repeat_ }
    private let repeatOptions = ["Does not repeat", "Daily", "Weekly"]

    private var isValid: Bool { !sportName.isEmpty && !location.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        ZStack(alignment: .bottom) {
            formView
                .background(Color.white.ignoresSafeArea())

            if showTimePicker {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) { showTimePicker = false }
                    }

                PickATimeView(
                    time: editingStartTime ? $startTime : $endTime,
                    onSave: {
                        withAnimation(.easeInOut(duration: 0.3)) { showTimePicker = false }
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showTimePicker)
        .onAppear {
            if let first = appState.mySports.first {
                sportName = first.sport.name
            }
        }
    }

    // MARK: - Form

    private var formView: some View {
        VStack(spacing: 0) {
            formHeader
            Divider()

            ScrollView(showsIndicators: false) {
                ZStack(alignment: .top) {
                    VStack(spacing: screenHeight * 0.02) {
                        sportField
                        dateField
                        timeFields
                        locationField
                        repeatField
                        Color.clear.frame(height: screenHeight * 0.08)
                    }
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.022)

                    floatingSportDropdown
                    floatingRepeatDropdown
                }
            }

            Divider()
            addButton
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.vertical, screenHeight * 0.018)
        }
    }

    private var formHeader: some View {
        ZStack {
            Text("Add Training")
                .font(.sfPro(screenHeight * 0.022))
                .foregroundColor(.black)
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: screenHeight * 0.018, weight: .medium))
                        .foregroundColor(Color.appGray)
                        .padding(screenHeight * 0.01)
                        .background(Color.appGray5)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                .padding(.trailing, screenHeight * 0.022)
            }
        }
        .frame(height: screenHeight * 0.062)
    }

    // MARK: - Fields

    private var sportField: some View {
        SheetDropdownField(
            label: "SPORT",
            value: sportName.isEmpty ? nil : sportName,
            placeholder: "Select a Sport",
            isOpen: openDropdown == .sport,
            onTap: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    openDropdown = openDropdown == .sport ? nil : .sport
                }
            }
        )
        .zIndex(openDropdown == .sport ? 10 : 0)
    }

    private var dateField: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.008) {
            fieldLabel("DATE")
            Text(dateString)
                .font(.sfPro(screenHeight * 0.017))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, screenHeight * 0.016)
                .padding(.vertical, screenHeight * 0.015)
                .background(Color.appGray6)
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014))
        }
    }

    private var timeFields: some View {
        HStack(spacing: screenHeight * 0.014) {
            VStack(alignment: .leading, spacing: screenHeight * 0.008) {
                fieldLabel("START TIME")
                timeButton(time: startTime) {
                    editingStartTime = true
                    withAnimation(.easeInOut(duration: 0.3)) { showTimePicker = true }
                }
            }
            VStack(alignment: .leading, spacing: screenHeight * 0.008) {
                fieldLabel("END TIME")
                timeButton(time: endTime) {
                    editingStartTime = false
                    withAnimation(.easeInOut(duration: 0.3)) { showTimePicker = true }
                }
            }
        }
    }

    private func timeButton(time: Date, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(timeString(time))
                .font(.sfPro(screenHeight * 0.017))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, screenHeight * 0.016)
                .padding(.vertical, screenHeight * 0.015)
                .background(Color.appGray6)
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014))
        }
        .buttonStyle(.plain)
    }

    private var locationField: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.008) {
            fieldLabel("LOCATION")
            TextField("Gym name or address", text: $location)
                .font(.sfPro(screenHeight * 0.017))
                .padding(.horizontal, screenHeight * 0.016)
                .padding(.vertical, screenHeight * 0.015)
                .background(Color.appGray6)
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014))
        }
    }

    private var repeatField: some View {
        SheetDropdownField(
            label: "REPEAT",
            value: repeatType,
            placeholder: "",
            isOpen: openDropdown == .repeat_,
            onTap: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    openDropdown = openDropdown == .repeat_ ? nil : .repeat_
                }
            }
        )
        .zIndex(openDropdown == .repeat_ ? 10 : 0)
    }

    // MARK: - Floating Dropdown Lists

    @State private var sportFieldY: CGFloat = 0
    @State private var repeatFieldY: CGFloat = 0

    private var floatingSportDropdown: some View {
        GeometryReader { _ in Color.clear }
            .frame(height: 0)
            .overlay(alignment: .top) {
                if openDropdown == .sport {
                    dropdownList(
                        options: appState.mySports.map(\.sport.name),
                        selected: sportName
                    ) { value in
                        sportName = value
                        withAnimation(.easeInOut(duration: 0.2)) { openDropdown = nil }
                    }
                    .offset(y: sportFieldOffset)
                    .padding(.horizontal, screenHeight * 0.022)
                    .zIndex(20)
                }
            }
    }

    private var floatingRepeatDropdown: some View {
        GeometryReader { _ in Color.clear }
            .frame(height: 0)
            .overlay(alignment: .top) {
                if openDropdown == .repeat_ {
                    dropdownList(
                        options: repeatOptions,
                        selected: repeatType
                    ) { value in
                        repeatType = value
                        withAnimation(.easeInOut(duration: 0.2)) { openDropdown = nil }
                    }
                    .offset(y: repeatFieldOffset)
                    .padding(.horizontal, screenHeight * 0.022)
                    .zIndex(20)
                }
            }
    }

    private var sportFieldOffset: CGFloat  { screenHeight * 0.022 + screenHeight * 0.062 }
    private var repeatFieldOffset: CGFloat { screenHeight * 0.022 + screenHeight * 0.062 * 5 + screenHeight * 0.02 * 4 }

    private func dropdownList(options: [String], selected: String, onSelect: @escaping (String) -> Void) -> some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                Button { onSelect(option) } label: {
                    HStack {
                        Text(option)
                            .font(.sfPro(screenHeight * 0.017))
                            .foregroundColor(.black)
                        Spacer()
                        if option == selected {
                            Image(systemName: "checkmark")
                                .font(.system(size: screenHeight * 0.014, weight: .semibold))
                                .foregroundColor(Color.appRed)
                        }
                    }
                    .padding(.horizontal, screenHeight * 0.016)
                    .padding(.vertical, screenHeight * 0.014)
                }
                .buttonStyle(.plain)
                if option != options.last {
                    Rectangle().fill(Color.appGray5).frame(height: 0.5)
                        .padding(.leading, screenHeight * 0.016)
                }
            }
        }
        .background(Color.appGray6)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014))
        .shadow(color: .black.opacity(0.1), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.005)
    }

    private var addButton: some View {
        Button {
            let training = Training(
                date: date,
                startTime: startTime,
                endTime: endTime,
                sportName: sportName,
                location: location.trimmingCharacters(in: .whitespaces),
                repeatType: repeatType
            )
            appState.addTraining(training)
            dismiss()
        } label: {
            Text("Add Training")
                .font(.sfPro(screenHeight * 0.019))
                .foregroundColor(isValid ? .white : Color.appGray)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.066)
                .background(isValid ? Color.appRed : Color.appGray5)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!isValid)
        .animation(.easeInOut(duration: 0.15), value: isValid)
    }

    // MARK: - Helpers

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.sfPro(screenHeight * 0.012))
            .foregroundColor(Color.appGray)
            .tracking(0.6)
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMMM d, yyyy"
        return f.string(from: date)
    }

    private func timeString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: d)
    }

    private static func defaultStart() -> Date {
        let cal = Calendar.current
        let now = Date()
        var comps = cal.dateComponents([.year, .month, .day, .hour], from: now)
        comps.hour = (comps.hour ?? 0) + 1
        comps.minute = 0
        return cal.date(from: comps) ?? now
    }

    private static func defaultEnd() -> Date {
        let cal = Calendar.current
        return cal.date(byAdding: .hour, value: 1, to: defaultStart()) ?? Date()
    }
}

// MARK: - SheetDropdownField

private struct SheetDropdownField: View {
    let label: String
    let value: String?
    let placeholder: String
    let isOpen: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.008) {
            Text(label)
                .font(.sfPro(screenHeight * 0.012))
                .foregroundColor(Color.appGray)
                .tracking(0.6)

            Button(action: onTap) {
                HStack {
                    Text(value ?? placeholder)
                        .font(.sfPro(screenHeight * 0.017))
                        .foregroundColor(value == nil ? Color.appGray : .black)
                    Spacer()
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .font(.system(size: screenHeight * 0.014, weight: .medium))
                        .foregroundColor(Color.appGray)
                }
                .padding(.horizontal, screenHeight * 0.016)
                .padding(.vertical, screenHeight * 0.015)
                .background(Color.appGray6)
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.014))
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - PickATimeView

private struct PickATimeView: View {
    @Binding var time: Date
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 0) {
                Rectangle().fill(Color.appGray4).frame(height: 0.5)
                Text("Pick a time")
                    .font(.sfPro(screenHeight * 0.02))
                    .foregroundColor(.black)
                    .padding(.vertical, screenHeight * 0.018)
                Rectangle().fill(Color.appGray4).frame(height: 0.5)

                DatePicker("", selection: $time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, screenHeight * 0.02)
                    .accentColor(Color.appRed)
                    .environment(\.colorScheme, .light)

                Rectangle().fill(Color.appGray4).frame(height: 0.5)

                Button(action: onSave) {
                    Text("Save")
                        .font(.sfPro(screenHeight * 0.02))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: screenHeight * 0.066)
                        .background(Color.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.018))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.vertical, screenHeight * 0.022)
            }
            .background(Color.appGray6)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    AddTrainingSheet(date: Date())
        .environmentObject(AppState())
}
