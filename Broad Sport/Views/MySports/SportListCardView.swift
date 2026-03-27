import SwiftUI

struct SportListCardView: View {
    @EnvironmentObject var appState: AppState
    let entry: SportEntry
    let isSelectedForComparison: Bool
    let onCompare: () -> Void
    let onEditParams: () -> Void
    let onRemove: () -> Void

    @State private var showRemoveAlert = false

    var body: some View {
        VStack(spacing: 0) {
            imageSection

            VStack(alignment: .leading, spacing: 0) {
                Text(entry.sport.name)
                    .font(.sfPro(screenHeight * 0.026))
                    .foregroundColor(.black)

                Spacer().frame(height: screenHeight * 0.004)

                Text(entry.sport.category)
                    .font(.sfPro(screenHeight * 0.017))
                    .foregroundColor(Color.appGray)

                Spacer().frame(height: screenHeight * 0.016)

                statsRow

                Spacer().frame(height: screenHeight * 0.018)

                compareButton

                Spacer().frame(height: screenHeight * 0.012)

                actionButtons
            }
            .padding(screenHeight * 0.02)
            
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.022))
        .shadow(color: .black.opacity(0.08), radius: screenHeight * 0.012, x: 0, y: screenHeight * 0.005)
        .alert("Remove \(entry.sport.name)?", isPresented: $showRemoveAlert) {
            Button("No", role: .cancel) {}
            Button("Remove", role: .destructive) { onRemove() }
        } message: {
            Text("This sport will be removed from My Sports.")
        }
    }

    private var imageSection: some View {
        ZStack(alignment: .topTrailing) {
            Image(entry.sport.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: screenHeight * 0.25)
                .frame(maxWidth: .infinity)
                .clipped()

            if let dotColor = trainingDotColor {
                Circle()
                    .fill(dotColor)
                    .frame(width: screenHeight * 0.022, height: screenHeight * 0.022)
                    .padding(screenHeight * 0.016)
            }
        }
    }

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem(emoji: "💰", value: entry.cost)
            Spacer()
            statItem(emoji: "🕐", value: entry.timePerWeek + "/wk")
            Spacer()
            statItem(emoji: "🧠", value: entry.load)
        }
    }

    private func statItem(emoji: String, value: String) -> some View {
        HStack(spacing: screenHeight * 0.006) {
            Text(emoji)
                .font(.system(size: screenHeight * 0.018))
            Text(value)
                .font(.sfPro(screenHeight * 0.016))
                .foregroundColor(Color.appGray)
        }
    }

    private var compareButton: some View {
        Button(action: onCompare) {
            Text(isSelectedForComparison ? "Added" : "Compare")
                .font(.sfPro(screenHeight * 0.018))
                .foregroundColor(isSelectedForComparison ? Color.appRed : .white)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.058)
                .background(isSelectedForComparison ? Color.appRed.opacity(0.12) : Color.appRed)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelectedForComparison)
    }

    private var actionButtons: some View {
        HStack(spacing: screenHeight * 0.012) {
            Button(action: onEditParams) {
                HStack(spacing: screenHeight * 0.007) {
                    Image(systemName: "pencil")
                        .font(.system(size: screenHeight * 0.016))
                    Text("Edit Params")
                        .font(.sfPro(screenHeight * 0.016))
                }
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.054)
                .background(Color.appGray6)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Button(action: { showRemoveAlert = true }) {
                HStack(spacing: screenHeight * 0.007) {
                    Image(systemName: "trash")
                        .font(.system(size: screenHeight * 0.016))
                    Text("Remove")
                        .font(.sfPro(screenHeight * 0.016))
                }
                .foregroundColor(Color.appRed)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.054)
                .overlay {
                    Capsule()
                        .strokeBorder(Color.appRed, lineWidth: 1.5)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var trainingDotColor: Color? {
        let now = Date()
        let todayTrainings = appState.trainings.filter {
            Calendar.current.isDateInToday($0.date) && $0.sportName == entry.sport.name
        }
        guard !todayTrainings.isEmpty else { return nil }
        let soonest = todayTrainings.min { $0.startTime < $1.startTime }
        if let t = soonest, t.startTime >= now && t.startTime <= now.addingTimeInterval(3600) {
            return .orange
        }
        return .green
    }
}
