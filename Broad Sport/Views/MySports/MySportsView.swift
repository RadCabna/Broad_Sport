import SwiftUI

struct MySportsView: View {
    @EnvironmentObject var appState: AppState
    var onOpenLibrary: () -> Void = {}
    var onCompare: () -> Void = {}

    @State private var entryToEdit: SportEntry? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                if appState.mySports.isEmpty {
                    emptyState
                } else {
                    VStack(spacing: 0) {
                        if !appState.comparisonSelection.isEmpty {
                            comparisonBanner
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                        sportsList
                    }
                    .animation(.easeInOut(duration: 0.2), value: appState.comparisonSelection.isEmpty)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                navBar
            }
            .sheet(item: $entryToEdit) { entry in
                SetParametersSheet(sport: entry.sport, existingEntry: entry)
                    .environmentObject(appState)
                    .presentationDetents([.fraction(0.88)])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var navBar: some View {
        AppNavBar(title: "My Sports") {
            Button {
                onOpenLibrary()
            } label: {
                Image("plusButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenHeight * 0.042, height: screenHeight * 0.042)
            }
        }
    }

    private var comparisonBanner: some View {
        HStack(spacing: screenHeight * 0.014) {
            Text("\(appState.comparisonSelection.count)/2 selected")
                .font(.sfPro(screenHeight * 0.016))
                .foregroundColor(Color.appRed)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: screenHeight * 0.009) {
                    ForEach(appState.comparisonSelection) { entry in
                        HStack(spacing: screenHeight * 0.007) {
                            Text(entry.sport.name)
                                .font(.sfPro(screenHeight * 0.014))
                                .foregroundColor(Color.appRed)
                            Button {
                                appState.toggleComparison(entry)
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: screenHeight * 0.011, weight: .bold))
                                    .foregroundColor(Color.appRed)
                            }
                        }
                        .padding(.horizontal, screenHeight * 0.013)
                        .padding(.vertical, screenHeight * 0.007)
                        .overlay {
                            Capsule().strokeBorder(Color.appRed, lineWidth: 1)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, screenHeight * 0.019)
        .padding(.vertical, screenHeight * 0.012)
        .frame(maxWidth: .infinity)
        .background(Color.appRed.opacity(0.1))
    }

    private var sportsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: screenHeight * 0.018) {
                ForEach(appState.mySports) { entry in
                    SportListCardView(
                        entry: entry,
                        isSelectedForComparison: appState.isSelectedForComparison(entry),
                        onCompare: { appState.toggleComparison(entry) },
                        onEditParams: { entryToEdit = entry },
                        onRemove: { appState.remove(entry.sport) }
                    )
                }
            }
            .padding(.horizontal, screenHeight * 0.019)
            .padding(.top, screenHeight * 0.015)
            .padding(.bottom, screenHeight * 0.18)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.appGray5)
                    .frame(width: screenHeight * 0.094, height: screenHeight * 0.094)

                Image("grayPlusButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenHeight * 0.038)
            }

            Spacer().frame(height: screenHeight * 0.022)

            Text("No Sports Yet")
                .font(.sfPro(screenHeight * 0.024))
                .foregroundColor(.black)

            Spacer().frame(height: screenHeight * 0.010)

            Text("Add sports from the library to start planning your activities")
                .font(.sfPro(screenHeight * 0.015))
                .foregroundColor(Color.appGray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, screenHeight * 0.06)

            Spacer().frame(height: screenHeight * 0.030)

            Button {
                onOpenLibrary()
            } label: {
                Text("Browse Library")
                    .font(.sfPro(screenHeight * 0.019))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: screenHeight * 0.066)
                    .background(Color.appRed)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, screenHeight * 0.030)

            Spacer()
        }
    }
}

#Preview {
    MySportsView()
        .environmentObject(AppState())
}
