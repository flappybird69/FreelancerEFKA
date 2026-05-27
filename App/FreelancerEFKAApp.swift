import SwiftUI

@main
struct FreelancerEFKAApp: App {
    @State private var settings = AppSettings()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashScreen {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            } else {
                ContentView()
                    .environment(settings)
                    .preferredColorScheme(settings.themeMode.colorScheme)
                    .transition(.opacity)
            }
        }
    }
}
