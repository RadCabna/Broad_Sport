import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case sports, compare, library, calendar

    var id: String { rawValue }

    var title: String {
        switch self {
        case .sports:   return "Sports"
        case .compare:  return "Compare"
        case .library:  return "Library"
        case .calendar: return "Calendar"
        }
    }

    var iconName: String {
        switch self {
        case .sports:   return "sportsIcon"
        case .compare:  return "compareIcon"
        case .library:  return "libraryIcon"
        case .calendar: return "calendarIcon"
        }
    }
}

struct BottomBarView: View {
    @Binding var selectedTab: AppTab
    @Namespace private var tabAnimation

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                } label: {
                    BottomBarItemView(tab: tab, isSelected: selectedTab == tab, namespace: tabAnimation)
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, screenHeight * 0.007)
        .padding(.vertical, screenHeight * 0.009)
        .background {
            Image("bottomBarBack")
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.038))
        }
        .clipShape(RoundedRectangle(cornerRadius: screenHeight * 0.05))
        .shadow(color: .black.opacity(0.4), radius: screenHeight * 0.02, x: 0, y: 0)
        .padding(.horizontal, screenWidth * 0.05)
        .padding(.bottom, deviceHasSafeArea ? screenHeight * 0.033 : screenHeight * 0.014)
    }
}

private struct BottomBarItemView: View {
    let tab: AppTab
    let isSelected: Bool
    let namespace: Namespace.ID

    var body: some View {
        VStack(spacing: screenHeight * 0.006) {
            Image(tab.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: screenHeight * 0.031, height: screenHeight * 0.031)

            Text(tab.title)
                .font(.sfPro(screenHeight * 0.014))
                .foregroundColor(isSelected ? .white : Color.appGray2)
                .animation(nil, value: isSelected)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, screenHeight * 0.012)
        .padding(.horizontal, screenHeight * 0.005)
        .background {
            if isSelected {
                Capsule()
                    .fill(Color.appRed)
                    .matchedGeometryEffect(id: "activeTab", in: namespace)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.appGray4.ignoresSafeArea()
        VStack {
            Spacer()
            BottomBarView(selectedTab: .constant(.compare))
        }
    }
}
