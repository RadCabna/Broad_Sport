import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: AppTab = .sports

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            MySportsView(onOpenLibrary: { selectedTab = .library }, onCompare: { selectedTab = .compare })
                .environmentObject(appState)
                .opacity(selectedTab == .sports ? 1 : 0)
                .transaction { $0.animation = nil }

            LibraryView()
                .environmentObject(appState)
                .opacity(selectedTab == .library ? 1 : 0)
                .transaction { $0.animation = nil }

            CompareView()
                .environmentObject(appState)
                .opacity(selectedTab == .compare ? 1 : 0)
                .transaction { $0.animation = nil }

            CalendarView()
                .environmentObject(appState)
                .opacity(selectedTab == .calendar ? 1 : 0)
                .transaction { $0.animation = nil }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomBarView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
