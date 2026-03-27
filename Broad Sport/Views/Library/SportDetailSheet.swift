import SwiftUI

struct SportDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var appState: AppState
    let sport: Sport

    @State private var showParameters = false
    @State private var wasAdded = false

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.top, screenHeight * 0.022)
                .padding(.bottom, screenHeight * 0.016)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Image(sport.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: screenHeight * 0.24)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.016))
                        .padding(.horizontal, screenHeight * 0.022)

                    VStack(alignment: .leading, spacing: 0) {
                        infoRow(label: "CATEGORY", value: sport.category)
                        divider
                        infoRow(label: "DESCRIPTION", value: sport.description)
                        divider
                        doubleInfoRow(
                            label1: "TYPICAL COST",      value1: sport.cost,
                            label2: "TYPICAL TIME/WEEK", value2: sport.timePerWeek
                        )
                        divider
                        doubleInfoRow(
                            label1: "TYPICAL LOAD",         value1: sport.load,
                            label2: "TYPICAL AVAILABILITY", value2: sport.availability
                        )
                        divider
                        doubleInfoRow(
                            label1: "EQUIPMENT", value1: sport.equipment,
                            label2: "TRAINER",   value2: sport.trainer
                        )
                    }
                    .padding(.horizontal, screenHeight * 0.022)
                    .padding(.top, screenHeight * 0.018)
                }
            }

            addButton
                .padding(.horizontal, screenHeight * 0.022)
                .padding(.vertical, screenHeight * 0.018)
        }
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $showParameters) {
            SetParametersSheet(sport: sport, onDone: { wasAdded = true })
                .environmentObject(appState)
                .presentationDetents([.fraction(0.88)])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: wasAdded) { added in
            if added { dismiss() }
        }
    }

    private var header: some View {
        HStack {
            Text(sport.name)
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

    private var divider: some View {
        Divider()
            .padding(.vertical, screenHeight * 0.014)
    }

    private var addButton: some View {
        Button {
            if appState.isAdded(sport) {
                appState.remove(sport)
                dismiss()
            } else {
                showParameters = true
            }
        } label: {
            Text(appState.isAdded(sport) ? "Remove from My Sports" : "Add to My Sports")
                .font(.sfPro(screenHeight * 0.019))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: screenHeight * 0.066)
                .background(appState.isAdded(sport) ? Color.appGray3 : Color.appRed)
                .clipShape(Capsule())
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: screenHeight * 0.005) {
            Text(label)
                .font(.sfPro(screenHeight * 0.013))
                .foregroundColor(Color.appGray)
            Text(value)
                .font(.sfPro(screenHeight * 0.018))
                .foregroundColor(.black)
        }
    }

    private func doubleInfoRow(label1: String, value1: String, label2: String, value2: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                Text(label1)
                    .font(.sfPro(screenHeight * 0.013))
                    .foregroundColor(Color.appGray)
                Text(value1)
                    .font(.sfPro(screenHeight * 0.018))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: screenHeight * 0.005) {
                Text(label2)
                    .font(.sfPro(screenHeight * 0.013))
                    .foregroundColor(Color.appGray)
                Text(value2)
                    .font(.sfPro(screenHeight * 0.018))
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SportDetailSheet(sport: Sport.all[0])
        .environmentObject(AppState())
}
