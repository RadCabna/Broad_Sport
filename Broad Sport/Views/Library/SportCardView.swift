import SwiftUI

struct SportCardView: View {
    let sport: Sport
    let isAdded: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    Image(sport.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: screenHeight * 0.115)
                        .clipped()

                    if isAdded {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: screenHeight * 0.032, height: screenHeight * 0.032)
                            .foregroundColor(.green)
                            .padding(screenHeight * 0.01)
                    }
                }

                VStack(alignment: .leading, spacing: screenHeight * 0.004) {
                    Text(sport.name)
                        .font(.sfPro(screenHeight * 0.019))
                        .foregroundColor(.black)
                        .lineLimit(1)

                    Text(sport.category)
                        .font(.sfPro(screenHeight * 0.014))
                        .foregroundColor(Color.appGray)
                }
                .padding(.horizontal, screenHeight * 0.014)
                .padding(.vertical, screenHeight * 0.012)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.016))
            .shadow(color: .black.opacity(0.08), radius: screenHeight * 0.01, x: 0, y: screenHeight * 0.004)
        }
        .buttonStyle(.plain)
    }
}
