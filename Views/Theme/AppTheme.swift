import SwiftUI

// MARK: - Accent Colors (same in light & dark)
extension Color {
    static let accentPurple = Color(r: 130, g: 87, b: 255)
    static let accentPink = Color(r: 255, g: 52, b: 120)
    static let accentTeal = Color(r: 0, g: 210, b: 170)
    static let accentBlue = Color(r: 60, g: 140, b: 255)
    static let accentOrange = Color(r: 255, g: 145, b: 55)
    static let negativeRed = Color(r: 255, g: 72, b: 92)

    private init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255, green: g / 255, blue: b / 255)
    }
}

// MARK: - Gradient
extension LinearGradient {
    static let primaryGradient = LinearGradient(
        colors: [.accentPurple, .accentPink],
        startPoint: .leading, endPoint: .trailing
    )
}

// MARK: - Typography
enum AppFont {
    static let title = Font.title.weight(.bold)
    static let title2 = Font.title2.weight(.semibold)
    static let headline = Font.headline.weight(.semibold)
    static let body = Font.body
    static let callout = Font.callout
    static let subheadline = Font.subheadline
    static let caption = Font.caption.weight(.medium)
    static let caption2 = Font.caption2

    static func mono(_ size: CGFloat = 15) -> Font {
        Font.system(size: size, weight: .medium, design: .monospaced)
    }

    static func monoBold(_ size: CGFloat = 15) -> Font {
        Font.system(size: size, weight: .bold, design: .monospaced)
    }
}

// MARK: - Native Components
struct AmountLabel: View {
    let amount: Decimal
    var color: Color = .primary

    var body: some View {
        Text(amount.currencyFormatted)
            .font(AppFont.monoBold())
            .foregroundColor(color)
    }
}

struct DetailLabel: View {
    let label: String
    let value: String
    var valueColor: Color = .secondary

    var body: some View {
        HStack {
            Text(label)
                .font(AppFont.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(AppFont.mono())
                .foregroundColor(valueColor)
        }
    }
}

struct SectionHeader: View {
    let title: String
    var icon: String? = nil

    var body: some View {
        HStack(spacing: 6) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundColor(.accentPurple)
            }
            Text(title)
                .font(AppFont.headline)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Copy & Share
struct CopyButton: View {
    let text: String
    @State private var copied = false

    var body: some View {
        Button {
            UIPasteboard.general.string = text
            withAnimation(.spring(response: 0.3)) { copied = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { copied = false }
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: copied ? "checkmark.circle.fill" : "doc.on.doc")
                    .font(.caption)
                Text(copied ? "Copied" : "Copy")
                    .font(.caption2.weight(.medium))
            }
            .foregroundColor(copied ? .accentTeal : .accentPurple)
        }
        .buttonStyle(.plain)
    }
}

struct ShareButton<Label: View>: View {
    let text: String
    @ViewBuilder var label: () -> Label

    var body: some View {
        ShareLink(item: text, preview: SharePreview("Freelancer EFKA", image: Image(systemName: "eurosign.circle.fill"))) {
            label()
        }
    }
}
