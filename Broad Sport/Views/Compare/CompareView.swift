import SwiftUI

struct CompareView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedId1: UUID? = nil
    @State private var selectedId2: UUID? = nil
    @State private var openDropdown: Int? = nil

    private var selectedEntry1: SportEntry? { appState.mySports.first { $0.id == selectedId1 } }
    private var selectedEntry2: SportEntry? { appState.mySports.first { $0.id == selectedId2 } }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: screenHeight * 0.022) {
                    SportDropdown(
                        index: 1,
                        placeholder: "Select Sport 1",
                        options: appState.mySports,
                        selectedId: $selectedId1,
                        openDropdown: $openDropdown
                    )
                    .zIndex(openDropdown == 1 ? 10 : 0)

                    Text("VS")
                        .font(.sfPro(screenHeight * 0.032))
                        .foregroundColor(Color.appRed)

                    SportDropdown(
                        index: 2,
                        placeholder: "Select Sport 2",
                        options: appState.mySports,
                        selectedId: $selectedId2,
                        openDropdown: $openDropdown
                    )
                    .zIndex(openDropdown == 2 ? 10 : 0)

                    if let e1 = selectedEntry1, let e2 = selectedEntry2 {
                        comparisonTable(e1, e2)
                        resultBanner(e1, e2)
                    } else {
                        Text("Select two sports to compare")
                            .font(.sfPro(screenHeight * 0.016))
                            .foregroundColor(Color.appGray)
                            .padding(.top, screenHeight * 0.01)
                    }
                }
                .padding(.horizontal, screenHeight * 0.019)
                .padding(.top, screenHeight * 0.018)
                .padding(.bottom, screenHeight * 0.02)
            }
            .background(Color.white.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                AppNavBar(title: "VS Arena")
            }
            .onAppear { syncSelection() }
            .onChange(of: appState.comparisonSelection) { _ in syncSelection() }
        }
    }

    private func syncSelection() {
        let sel = appState.comparisonSelection
        if !sel.isEmpty {
            selectedId1 = sel[0].id
            selectedId2 = sel.count >= 2 ? sel[1].id : nil
        }
    }

    // MARK: - Comparison Table

    private func comparisonTable(_ e1: SportEntry, _ e2: SportEntry) -> some View {
        VStack(spacing: 0) {
            tableHeaderRow(name1: e1.sport.name, name2: e2.sport.name)
            tableRow("Cost",         v1: e1.cost,         v2: e2.cost,         scorer: Self.generalScore)
            tableRow("Time/week",    v1: e1.timePerWeek,  v2: e2.timePerWeek,  scorer: Self.timeScore)
            tableRow("Load",         v1: e1.load,         v2: e2.load,         scorer: Self.generalScore)
            tableRow("Availability", v1: e1.availability, v2: e2.availability, scorer: Self.availScore)
            tableRow("Equipment",    v1: e1.equipment,    v2: e2.equipment,    scorer: Self.generalScore)
            tableRow("Trainer",      v1: e1.trainer,      v2: e2.trainer,      scorer: Self.trainerScore, isLast: true)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.016))
        .overlay {
            RoundedRectangle(cornerRadius: screenHeight * 0.016)
                .strokeBorder(Color.appGray5, lineWidth: 1)
        }
    }

    private func tableHeaderRow(name1: String, name2: String) -> some View {
        HStack(spacing: 0) {
            Text("Parameter")
                .frame(maxWidth: .infinity)
            verticalDivider
            Text(name1)
                .frame(maxWidth: .infinity)
            verticalDivider
            Text(name2)
                .frame(maxWidth: .infinity)
        }
        .font(.sfPro(screenHeight * 0.013))
        .foregroundColor(Color.appGray)
        .padding(.vertical, screenHeight * 0.012)
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.appGray5).frame(height: 1)
        }
    }

    private func tableRow(_ label: String, v1: String, v2: String, scorer: (String) -> Int, isLast: Bool = false) -> some View {
        let s1 = scorer(v1), s2 = scorer(v2)
        return HStack(spacing: 0) {
            Text(label)
                .font(.sfPro(screenHeight * 0.015))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, screenHeight * 0.013)

            verticalDivider

            Text(v1)
                .font(.sfPro(screenHeight * 0.015))
                .foregroundColor(cellTextColor(s1, vs: s2))
                .frame(maxWidth: .infinity)
                .padding(.vertical, screenHeight * 0.013)
                .background(cellBgColor(s1, vs: s2))

            verticalDivider

            Text(v2)
                .font(.sfPro(screenHeight * 0.015))
                .foregroundColor(cellTextColor(s2, vs: s1))
                .frame(maxWidth: .infinity)
                .padding(.vertical, screenHeight * 0.013)
                .background(cellBgColor(s2, vs: s1))
        }
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle().fill(Color.appGray5).frame(height: 1)
            }
        }
    }

    private var verticalDivider: some View {
        Rectangle()
            .fill(Color.appGray5)
            .frame(width: 1)
    }

    private func cellTextColor(_ score: Int, vs other: Int) -> Color {
        if score < other { return .green }
        if score > other { return Color.appRed }
        return Color.appGray
    }

    private func cellBgColor(_ score: Int, vs other: Int) -> Color {
        if score < other { return Color.green.opacity(0.12) }
        if score > other { return Color.appRed.opacity(0.12) }
        return Color.clear
    }

    // MARK: - Result Banner

    private func resultBanner(_ e1: SportEntry, _ e2: SportEntry) -> some View {
        let (wins1, wins2) = calculateWins(e1, e2)
        let decided = wins1 + wins2
        let winnerName: String? = wins1 > wins2 ? e1.sport.name : (wins2 > wins1 ? e2.sport.name : nil)
        let pct = decided > 0 ? Int(round(Double(max(wins1, wins2)) * 100.0 / Double(decided))) : 0

        return VStack(spacing: screenHeight * 0.008) {
            Text("\(wins1) vs \(wins2)")
                .font(.sfPro(screenHeight * 0.042))
                .foregroundColor(.white)
            if let winner = winnerName {
                Text("\(winner) is better by \(pct)%")
                    .font(.sfPro(screenHeight * 0.018))
                    .foregroundColor(.white)
            } else {
                Text("It's a tie!")
                    .font(.sfPro(screenHeight * 0.018))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, screenHeight * 0.028)
        .background(Color.appRed)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.022))
    }

    // MARK: - Scoring

    private func calculateWins(_ e1: SportEntry, _ e2: SportEntry) -> (Int, Int) {
        let pairs: [(String, String, (String) -> Int)] = [
            (e1.cost,         e2.cost,         Self.generalScore),
            (e1.timePerWeek,  e2.timePerWeek,  Self.timeScore),
            (e1.load,         e2.load,         Self.generalScore),
            (e1.availability, e2.availability, Self.availScore),
            (e1.equipment,    e2.equipment,    Self.generalScore),
            (e1.trainer,      e2.trainer,      Self.trainerScore),
        ]
        var w1 = 0, w2 = 0
        for (v1, v2, scorer) in pairs {
            let s1 = scorer(v1), s2 = scorer(v2)
            if s1 < s2 { w1 += 1 } else if s2 < s1 { w2 += 1 }
        }
        return (w1, w2)
    }

    private static func generalScore(_ value: String) -> Int {
        switch value {
        case "Low":    return 1
        case "Medium": return 2
        default:       return 3
        }
    }

    private static func timeScore(_ value: String) -> Int {
        switch value {
        case "1x":   return 1
        case "2-3x": return 2
        default:     return 3
        }
    }

    private static func availScore(_ value: String) -> Int {
        switch value {
        case "Near":   return 1
        case "Medium": return 2
        default:       return 3
        }
    }

    private static func trainerScore(_ value: String) -> Int {
        value == "No" ? 1 : 2
    }
}

// MARK: - Dropdown

private struct SportDropdown: View {
    let index: Int
    let placeholder: String
    let options: [SportEntry]
    @Binding var selectedId: UUID?
    @Binding var openDropdown: Int?

    private var isOpen: Bool { openDropdown == index }
    private var selectedName: String? { options.first { $0.id == selectedId }?.sport.name }
    @State private var headerHeight: CGFloat = 0

    var body: some View {
        headerButton
            .background(
                GeometryReader { geo in
                    Color.appGray6
                        .onAppear { headerHeight = geo.size.height }
                        .onChange(of: geo.size.height) { headerHeight = $0 }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.016))
            .overlay(alignment: .top) {
                if isOpen {
                    floatingList
                        .offset(y: headerHeight)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
    }

    private var headerButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                openDropdown = isOpen ? nil : index
            }
        } label: {
            HStack {
                Text(selectedName ?? placeholder)
                    .font(.sfPro(screenHeight * 0.017))
                    .foregroundColor(selectedId == nil ? Color.appGray : .black)
                Spacer()
                Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    .font(.system(size: screenHeight * 0.015, weight: .medium))
                    .foregroundColor(Color.appGray)
            }
            .padding(.horizontal, screenHeight * 0.018)
            .padding(.vertical, screenHeight * 0.016)
        }
        .buttonStyle(.plain)
    }

    private var floatingList: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color.appGray4)
                .frame(height: 0.5)

            if options.isEmpty {
                Text("No sports added yet")
                    .font(.sfPro(screenHeight * 0.015))
                    .foregroundColor(Color.appGray)
                    .padding(screenHeight * 0.016)
                    .frame(maxWidth: .infinity)
            } else {
                ForEach(options) { entry in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedId = entry.id
                            openDropdown = nil
                        }
                    } label: {
                        Text(entry.sport.name)
                            .font(.sfPro(screenHeight * 0.017))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, screenHeight * 0.018)
                            .padding(.vertical, screenHeight * 0.013)
                    }
                    .buttonStyle(.plain)

                    if entry.id != options.last?.id {
                        Rectangle()
                            .fill(Color.appGray5)
                            .frame(height: 0.5)
                            .padding(.leading, screenHeight * 0.018)
                    }
                }
            }
        }
        .background(Color.appGray6)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.016))
        .shadow(color: .black.opacity(0.12), radius: screenHeight * 0.012, x: 0, y: screenHeight * 0.006)
    }
}

#Preview {
    CompareView()
        .environmentObject(AppState())
}
