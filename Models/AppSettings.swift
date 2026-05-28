import SwiftUI

enum ThemeMode: String, CaseIterable, Identifiable {
    case system = "System"
    case dark = "Dark"
    case light = "Light"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .system: "gearshape"
        case .dark: "moon.fill"
        case .light: "sun.max.fill"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: nil
        case .dark: .dark
        case .light: .light
        }
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    case system = "System"
    case english = "English"
    case greek = "Ελληνικά"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .system: "globe"
        case .english: "textformat.abc"
        case .greek: "textformat.abc.dottedline"
        }
    }

    var locale: Locale {
        switch self {
        case .system: Locale.current
        case .english: Locale(identifier: "en")
        case .greek: Locale(identifier: "el")
        }
    }

    var localeCode: String {
        switch self {
        case .system: ""
        case .english: "en"
        case .greek: "el"
        }
    }
}

@Observable
final class AppSettings {
    var themeMode: ThemeMode {
        didSet { UserDefaults.standard.set(themeMode.rawValue, forKey: "themeMode") }
    }

    var hasSeenOnboarding: Bool {
        didSet { UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding") }
    }

    var appLanguage: AppLanguage {
        didSet { UserDefaults.standard.set(appLanguage.rawValue, forKey: "appLanguage") }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "themeMode") ?? ThemeMode.system.rawValue
        themeMode = ThemeMode(rawValue: raw) ?? .system
        hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        let langRaw = UserDefaults.standard.string(forKey: "appLanguage") ?? AppLanguage.system.rawValue
        appLanguage = AppLanguage(rawValue: langRaw) ?? .system
    }
}
