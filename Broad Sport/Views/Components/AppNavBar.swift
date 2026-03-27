import SwiftUI

struct AppNavBar<Trailing: View>: View {
    let title: String
    private let trailing: Trailing

    init(title: String, @ViewBuilder trailing: () -> Trailing) {
        self.title = title
        self.trailing = trailing()
    }

    var body: some View {
        ZStack {
            Text(title)
                .font(.sfPro(screenHeight * 0.024))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)

            HStack {
                Spacer()
                trailing
                    .padding(.trailing, screenHeight * 0.019)
            }
        }
        .frame(height: screenHeight * 0.052)
        .background(
            Color.appGray6
                .ignoresSafeArea(edges: .top)
        )
        .shadow(color: .black.opacity(0.1), radius: screenHeight * 0.007, x: 0, y: screenHeight * 0.005)
    }
}

extension AppNavBar where Trailing == EmptyView {
    init(title: String) {
        self.title = title
        self.trailing = EmptyView()
    }
}
