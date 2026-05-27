import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var page = 0

    private let pages: [(icon: String, title: String, subtitle: String, color: Color)] = [
        ("eurosign.circle.fill", "EFKA Calculator", "Calculate your social security contributions, income tax, and net income as a μπλοκάκι worker.", .accentPurple),
        ("doc.text", "VAT & Invoices", "Estimate VAT obligations, calculate invoices with ΦΜΥ withholding, and track filing deadlines.", .accentPink),
        ("building.columns.fill", "Property Guide", "8-step property purchase wizard with cost calculator, checklists, and tax references.", .accentTeal),
        ("wrench.adjustable.fill", "Financial Tools", "Income tax calculator, expense reference, employment comparison, and government links.", .accentOrange),
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            VStack(spacing: 0) {
                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { i, p in
                        VStack(spacing: 24) {
                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(p.color.opacity(0.12))
                                    .frame(width: 120, height: 120)
                                Image(systemName: p.icon)
                                    .font(.system(size: 52))
                                    .foregroundColor(p.color)
                            }

                            Text(p.title)
                                .font(.title2.weight(.bold))
                                .foregroundColor(.primary)

                            Text(p.subtitle)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            Spacer()
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

                // Page dots + button
                VStack(spacing: 16) {
                    Button {
                        if page < pages.count - 1 {
                            withAnimation { page += 1 }
                        } else {
                            hasSeenOnboarding = true
                        }
                    } label: {
                        Text(page < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(pages[page].color)
                            )
                    }
                    .padding(.horizontal, 24)

                    Button("Skip") {
                        hasSeenOnboarding = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    OnboardingView(hasSeenOnboarding: .constant(false))
}
