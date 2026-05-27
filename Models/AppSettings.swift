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

@Observable
final class AppSettings {
    var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "themeMode")
        }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "themeMode") ?? ThemeMode.system.rawValue
        themeMode = ThemeMode(rawValue: raw) ?? .system
    }
}
