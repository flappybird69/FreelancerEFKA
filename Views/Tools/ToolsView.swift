import SwiftUI

struct ToolsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    toolRow("doc.text.magnifyingglass", "Income Tax Calculator", "Progressive brackets 9–44%", .accentPurple, IncomeTaxCalculatorView())
                    toolRow("doc.badge.plus", "Invoice Calculator", "Net → gross with VAT & ΦΜΥ", .accentPink, InvoiceCalculatorView())
                    toolRow("calendar.badge.clock", "Tax Deadlines", "EFKA, VAT, income tax dates", .accentOrange, TaxDeadlinesView())
                    toolRow("link.circle", "Quick Links", "AADE, EFKA, gov.gr portals", .accentBlue, QuickLinksView())
                    toolRow("list.bullet.rectangle", "Expense Reference", "Deductible categories & caps", .accentTeal, ExpenseReferenceView())
                    toolRow("arrow.left.arrow.right", "Employment Comparison", "Μπλοκάκι vs Employee vs Company", Color.accentPurple, EmploymentComparisonView())
                } header: {
                    HStack(spacing: 6) {
                        Image(systemName: "wrench.adjustable.fill").font(.caption).foregroundColor(.accentPurple)
                        Text("Financial Tools").font(.headline).foregroundColor(.primary)
                    }
                }

                Section {
                    NavigationLink(destination: SettingsView()) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle().fill(Color.accentPurple.opacity(0.1)).frame(width: 36, height: 36)
                                Image(systemName: "gearshape.fill").font(.callout).foregroundColor(.accentPurple)
                            }
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Settings").font(.body.weight(.medium)).foregroundColor(.primary)
                                Text("Theme, appearance & about").font(.caption).foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section {
                    Text("All tools are estimates based on 2025 published rates. ±5% margin. Consult your λογιστής for exact figures.")
                        .font(.caption2).foregroundColor(.secondary)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Tools")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private func toolRow<Destination: View>(_ icon: String, _ title: String, _ subtitle: String, _ color: Color, _ destination: Destination) -> some View {
        NavigationLink(destination: destination) {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(color.opacity(0.1)).frame(width: 36, height: 36)
                    Image(systemName: icon).font(.callout).foregroundColor(color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.body.weight(.medium)).foregroundColor(.primary)
                    Text(subtitle).font(.caption).foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    ToolsView()
}
