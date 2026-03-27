import SwiftUI

struct SetParametersSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState

    let sport: Sport
    let existingEntry: SportEntry?
    let onDone: () -> Void

    @State private var cost: String
    @State private var timePerWeek: String
    @State private var load: String
    @State private var availability: String
    @State private var equipment: String
    @State private var trainer: String

    private let costOptions         = ["Low", "Medium", "High"]
    private let timeOptions         = ["1x", "2-3x", "4+x"]
    private let loadOptions         = ["Low", "Medium", "High"]
    private let availabilityOptions = ["Near", "Medium", "Far"]
    private let equipmentOptions    = ["Low", "Medium", "High"]
    private let trainerOptions      = ["No", "Yes"]

    private var isEditing: Bool { existingEntry != nil }

    init(sport: Sport, existingEntry: SportEntry? = nil, onDone: @escaping () -> Void = {}) {
        self.sport = sport
        self.existingEntry = existingEntry
        self.onDone = onDone
        if let e = existingEntry {
            _cost         = State(initialValue: e.cost)
            _timePerWeek  = State(initialValue: e.timePerWeek)
            _load         = State(initialValue: e.load)
            _availability = State(initialValue: e.availability)
            _equipment    = State(initialValue: e.equipment)
            _trainer      = State(initialValue: e.trainer)
        } else {
            _cost         = State(initialValue: sport.cost)
            _timePerWeek  = State(initialValue: Self.mapTime(sport.timePerWeek))
            _load         = State(initialValue: sport.load)
            _availability = State(initialValue: Self.mapAvailability(sport.availability))
            _equipment    = State(initialValue: sport.equipment)
            _trainer      = State(initialValue: sport.trainer == "Optional" ? "No" : sport.trainer)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.top, screenHeight * 0.022)
                .padding(.bottom, screenHeight * 0.012)

            sportTitle
                .padding(.bottom, screenHeight * 0.018)

            ScrollView(showsIndicators: false) {
                VStack(spacing: screenHeight * 0.022) {
                    paramRow(emoji: "💰", label: "COST",            options: costOptions,         selected: $cost)
                    paramRow(emoji: "🕐", label: "TIME PER WEEK",   options: timeOptions,         selected: $timePerWeek)
                    paramRow(emoji: "🧠", label: "LOAD INTENSITY",  options: loadOptions,         selected: $load)
                    paramRow(emoji: "🏠", label: "AVAILABILITY",    options: availabilityOptions, selected: $availability)
                    paramRow(emoji: "💸", label: "EQUIPMENT COST",  options: equipmentOptions,    selected: $equipment)
                    paramRow(emoji: "👨‍🏫", label: "TRAINER NEEDED", options: trainerOptions,      selected: $trainer)
                }
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.bottom, screenHeight * 0.02)
            }

            addButton
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.vertical, screenHeight * 0.018)
        }
        .background(Color.white.ignoresSafeArea())
    }

    private var header: some View {
        HStack {
            Text("Set Parameters")
                .font(.sfPro(screenHeight * 0.027))
                .foregroundColor(.black)
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: screenHeight * 0.016, weight: .semibold))
                    .foregroundColor(Color.appGray)
                    .frame(width: screenHeight * 0.038, height: screenHeight * 0.038)
                    .background(Color.appGray5)
                    .clipShape(Circle())
            }
        }
    }

    private var sportTitle: some View {
        VStack(spacing: screenHeight * 0.004) {
            Text(sport.name)
                .font(.sfPro(screenHeight * 0.022))
                .foregroundColor(.black)
            Text(sport.category)
                .font(.sfPro(screenHeight * 0.016))
                .foregroundColor(Color.appGray)
        }
        .frame(maxWidth: .infinity)
    }

    private var addButton: some View {
        Button {
            if let existing = existingEntry {
                let updated = SportEntry(
                    id: existing.id,
                    sport: sport,
                    cost: cost,
                    timePerWeek: timePerWeek,
                    load: load,
                    availability: availability,
                    equipment: equipment,
                    trainer: trainer
                )
                appState.update(updated)
            } else {
                appState.add(SportEntry(
                    sport: sport,
                    cost: cost,
                    timePerWeek: timePerWeek,
                    load: load,
                    availability: availability,
                    equipment: equipment,
                    trainer: trainer
                ))
            }
            onDone()
            dismiss()
        } label: {
            Text(isEditing ? "Save Changes" : "Add to My Sports")
                .font(.sfPro(screenHeight * 0.019))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.066)
                .background(Color.appRed)
                .clipShape(Capsule())
        }
    }

    private func paramRow(emoji: String, label: String, options: [String], selected: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.01) {
            HStack(spacing: screenHeight * 0.007) {
                Text(emoji)
                    .font(.system(size: screenHeight * 0.018))
                Text(label)
                    .font(.sfPro(screenHeight * 0.013))
                    .foregroundColor(Color.appGray)
            }

            HStack(spacing: screenHeight * 0.01) {
                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    Button {
                        selected.wrappedValue = option
                    } label: {
                        Text(option)
                            .font(.sfPro(screenHeight * 0.016))
                            .foregroundColor(selected.wrappedValue == option ? .white : .black)
                            .frame(maxWidth: .infinity)
                            .frame(height: screenHeight * 0.052)
                            .background(
                                RoundedRectangle(cornerRadius: screenHeight * 0.014)
                                    .fill(selected.wrappedValue == option
                                          ? optionColor(index: index, total: options.count)
                                          : Color.appGray6)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func optionColor(index: Int, total: Int) -> Color {
        if index == 0 { return .green }
        if index == total - 1 { return Color.appRed }
        return Color.orange
    }

    private static func mapTime(_ value: String) -> String {
        let options = ["1x", "2-3x", "4+x"]
        if options.contains(value) { return value }
        if value.hasPrefix("1") { return "1x" }
        if let first = value.first, first >= "4" { return "4+x" }
        return "2-3x"
    }

    private static func mapAvailability(_ value: String) -> String {
        switch value {
        case "High":  return "Near"
        case "Low":   return "Far"
        default:      return "Medium"
        }
    }
}

#Preview {
    SetParametersSheet(sport: Sport.all[0])
        .environmentObject(AppState())
}
