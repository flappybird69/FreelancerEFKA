import SwiftUI

struct EmploymentComparisonView: View {
    @State private var vm = EmploymentComparisonViewModel()
    @State private var incomeText: String = "2500"

    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 36))
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Employment Comparison")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("Μπλοκάκι vs Employee vs Company (ΙΚΕ)")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 8)
            }

            Section {
                HStack(spacing: 12) {
                    Text("€").font(.title2.weight(.bold)).foregroundColor(.accentPurple)
                    TextField("Gross monthly income", text: $incomeText)
                        .keyboardType(.decimalPad).font(.title2.weight(.bold))
                        .onChange(of: incomeText) { _, nv in
                            if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) { vm.grossMonthlyIncome = v }
                        }
                }
            } header: {
                SectionHeader(title: "Monthly Gross Income", icon: "eurosign")
            }

            ForEach(vm.results) { comp in
                Section {
                    HStack {
                        Text(comp.typeLabel).font(.title3.weight(.bold)).foregroundColor(.primary)
                        Spacer()
                        Text(comp.netPct).font(.title3.weight(.bold).monospaced()).foregroundColor(compColor(comp.colorLabel))
                    }

                    Divider()

                    DetailLabel(label: "Annual Gross", value: comp.grossIncome.currencyFormatted, valueColor: .primary)
                    DetailLabel(label: "Employer Cost", value: comp.employerCost.currencyFormatted, valueColor: .secondary)
                    DetailLabel(label: "EFKA", value: "-\(comp.employeeEFKA.currencyFormatted)", valueColor: .negativeRed)
                    DetailLabel(label: "Taxes", value: "-\(comp.incomeTax.currencyFormatted)", valueColor: .negativeRed)

                    Divider()

                    HStack {
                        Text("Net Annual").font(.headline).foregroundColor(.primary)
                        Spacer()
                        Text(comp.netIncome.currencyFormatted)
                            .font(.headline.monospaced().weight(.bold))
                            .foregroundColor(compColor(comp.colorLabel))
                    }
                } header: {
                    HStack(spacing: 6) {
                        Circle().fill(compColor(comp.colorLabel)).frame(width: 8, height: 8)
                        Text(comp.typeLabel).font(.subheadline.weight(.semibold)).foregroundColor(.secondary)
                    }
                }
            }

            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Assumptions").font(.subheadline.weight(.semibold))
                    Text("• Μπλοκάκι: 20.28% EFKA + business tax €650/yr").font(.caption2).foregroundColor(.secondary)
                    Text("• Employee: 15.8% employee + 24.56% employer EFKA").font(.caption2).foregroundColor(.secondary)
                    Text("• Company (ΙΚΕ): 40% salary, 60% dividends (5% tax)").font(.caption2).foregroundColor(.secondary)
                    Text("• Income tax uses progressive 9–44% scale").font(.caption2).foregroundColor(.secondary)
                    Text("• Simplified model — consult your λογιστής for exact figures").font(.caption2).foregroundColor(.accentPurple)
                }
                .listRowBackground(Color.clear)
            }

            Section {
                CombinedDisclaimer(showTekmartro: true, showLaw5073: true)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Comparison")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func compColor(_ label: String) -> Color {
        switch label {
        case "accentPurple": .accentPurple
        case "accentTeal": .accentTeal
        case "accentBlue": .accentBlue
        default: .primary
        }
    }
}

#Preview {
    NavigationStack { EmploymentComparisonView() }
}
