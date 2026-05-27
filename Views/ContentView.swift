import SwiftUI

struct ContentView: View {
    @Environment(AppSettings.self) private var settings
    @State private var selectedTab: AppTab = .home

    var body: some View {
        @Bindable var s = settings
        Group {
            if s.hasSeenOnboarding {
                mainContent
            } else {
                OnboardingView(hasSeenOnboarding: $s.hasSeenOnboarding)
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.4), value: s.hasSeenOnboarding)
    }

    private var mainContent: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                tabContent(for: tab)
                    .tabItem {
                        Label(tab.rawValue,
                              systemImage: selectedTab == tab ? tab.activeIcon : tab.icon)
                    }
                    .tag(tab)
            }
        }
        .tint(.accentPurple)
    }

    @ViewBuilder
    private func tabContent(for tab: AppTab) -> some View {
        switch tab {
        case .home:     HomeView(selectedTab: $selectedTab)
        case .efka:     EFKACalculatorView()
        case .vat:      VATCalculatorView()
        case .assets:   PropertyWizardView()
        case .tools:    ToolsView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppSettings())
}
