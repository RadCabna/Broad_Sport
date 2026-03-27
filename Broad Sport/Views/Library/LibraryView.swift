import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory = "All"
    @State private var selectedSport: Sport? = nil

    private let categories = [
        "All", "Combat Sports", "Water", "Flexibility", "Cardio",
        "Team Sports", "Cyclical", "Strength", "Functional", "Winter",
        "Extreme", "Contact", "Precision", "Speed", "Street",
        "Multi-sport", "Recovery", "Dance", "Winter/Ice"
    ]

    private var filteredSports: [Sport] {
        selectedCategory == "All"
            ? Sport.all
            : Sport.all.filter { $0.category == selectedCategory }
    }

    private var columns: [GridItem] {
        [
            GridItem(.flexible(), spacing: screenHeight * 0.015),
            GridItem(.flexible(), spacing: screenHeight * 0.015)
        ]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterRow

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: screenHeight * 0.015) {
                        ForEach(filteredSports) { sport in
                            SportCardView(
                                sport: sport,
                                isAdded: appState.isAdded(sport)
                            ) {
                                selectedSport = sport
                            }
                        }
                    }
                    .padding(.horizontal, screenHeight * 0.019)
                    .padding(.top, screenHeight * 0.015)
                    .padding(.bottom, screenHeight * 0.18)
                }
            }
            .background(Color.white.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                AppNavBar(title: "Library")
            }
            .sheet(item: $selectedSport) { sport in
                SportDetailSheet(sport: sport)
                    .environmentObject(appState)
                    .presentationDetents([.fraction(0.88)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var filterRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: screenHeight * 0.009) {
                ForEach(categories, id: \.self) { category in
                    FilterChipView(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, screenHeight * 0.019)
            .padding(.vertical, screenHeight * 0.012)
        }
    }
}

private struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.sfPro(screenHeight * 0.015))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, screenHeight * 0.016)
                .padding(.vertical, screenHeight * 0.008)
                .background {
                    Capsule()
                        .fill(isSelected ? Color.appRed : Color.appGray5)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LibraryView()
        .environmentObject(AppState())
}
