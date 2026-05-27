import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case efka = "EFKA"
    case vat = "VAT"
    case assets = "Assets"
    case tools = "Tools"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: "house"
        case .efka: "eurosign.circle"
        case .vat: "doc.text"
        case .assets: "building.columns"
        case .tools: "wrench.adjustable"
        }
    }

    var activeIcon: String {
        icon + ".fill"
    }
}
