import SwiftUI

struct ContentView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label(AppTab.home.rawValue,
                          systemImage: selectedTab == .home ? AppTab.home.activeIcon : AppTab.home.icon)
                }
                .tag(AppTab.home)

            EFKACalculatorView()
                .tabItem {
                    Label(AppTab.efka.rawValue,
                          systemImage: selectedTab == .efka ? AppTab.efka.activeIcon : AppTab.efka.icon)
                }
                .tag(AppTab.efka)

            VATCalculatorView()
                .tabItem {
                    Label(AppTab.vat.rawValue,
                          systemImage: selectedTab == .vat ? AppTab.vat.activeIcon : AppTab.vat.icon)
                }
                .tag(AppTab.vat)

            PropertyWizardView()
                .tabItem {
                    Label(AppTab.assets.rawValue,
                          systemImage: selectedTab == .assets ? AppTab.assets.activeIcon : AppTab.assets.icon)
                }
                .tag(AppTab.assets)

            ToolsView()
                .tabItem {
                    Label(AppTab.tools.rawValue,
                          systemImage: selectedTab == .tools ? AppTab.tools.activeIcon : AppTab.tools.icon)
                }
                .tag(AppTab.tools)
        }
        .tint(.accentPurple)
    }
}

#Preview {
    ContentView()
}
