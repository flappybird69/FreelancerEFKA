import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: AppTab
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning ☀️"
        case 12..<17: return "Good afternoon 🌤"
        case 17..<22: return "Good evening 🌅"
        default: return "Good night 🌙"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    greetingCard
                    quickLinks
                    summaryFooter
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Greeting Card
    private var greetingCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text(greeting)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Here's your financial overview")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Divider()

            HStack(spacing: 0) {
                statItem("EFKA Rate", "20.28%", .negativeRed)
                Divider().frame(width: 1).overlay(Color(.separator))
                statItem("VAT", "24%", .accentPurple)
                Divider().frame(width: 1).overlay(Color(.separator))
                statItem("Biz Tax", "€650/yr", .accentOrange)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .accentPurple.opacity(0.06), radius: 16, y: 4)
        )
        .padding(.top, 8)
    }

    private func statItem(_ label: String, _ value: String, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Quick Links
    private var quickLinks: some View {
        VStack(spacing: 16) {
            Text("Quick Tools")
                .font(.headline.weight(.semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                toolCard(symbol: "eurosign.circle.fill", title: "EFKA", subtitle: "Social security", color: .accentPurple, tab: .efka)
                toolCard(symbol: "doc.text", title: "VAT", subtitle: "ΦΠA obligations", color: .accentPink, tab: .vat)
                toolCard(symbol: "building.columns.fill", title: "Assets", subtitle: "Purchase guide", color: .accentTeal, tab: .assets)
                toolCard(symbol: "wrench.adjustable.fill", title: "Tools", subtitle: "All calculators", color: .accentOrange, tab: .tools)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
        )
    }

    private func toolCard(symbol: String, title: String, subtitle: String, color: Color, tab: AppTab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(color)
                        .frame(width: 52, height: 52)

                    Image(systemName: symbol)
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.white)
                }

                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Footer
    private var summaryFooter: some View {
        VStack(spacing: 4) {
            Text("All estimates based on 2025 published rates")
                .font(.caption2)
                .foregroundColor(.secondary)
            Text("±5% margin · Consult your λογιστής")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
}
