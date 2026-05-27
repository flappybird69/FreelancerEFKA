import SwiftUI

struct IncomeTaxCalculatorView: View {
    @State private var vm = IncomeTaxViewModel()
    @State private var incomeText: String = "30000"
    @State private var expensesText: String = "5000"

    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 36))
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Income Tax Calculator")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("2025 progressive scale · 9%–44%")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 8)
            }

            Section {
                HStack(spacing: 12) {
                    Text("€").font(.title2.weight(.bold)).foregroundColor(.accentPurple)
                    TextField("Annual gross income", text: $incomeText)
                        .keyboardType(.decimalPad).font(.title2.weight(.bold))
                        .onChange(of: incomeText) { _, nv in
                            if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) { vm.annualIncome = v }
                        }
                }
                HStack(spacing: 12) {
                    Text("€").font(.title2.weight(.bold)).foregroundColor(.accentOrange)
                    TextField("Deductible expenses", text: $expensesText)
                        .keyboardType(.decimalPad).font(.title2.weight(.bold))
                        .onChange(of: expensesText) { _, nv in
                            if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) { vm.deductibleExpenses = v }
                        }
                }
            } header: {
                SectionHeader(title: "Annual Income", icon: "eurosign")
            }

            Section {
                HStack {
                    Text("Taxable Income").font(.body).foregroundColor(.secondary)
                    Spacer()
                    AmountLabel(amount: vm.result.taxableIncome, color: .primary)
                }

                ForEach(vm.result.bracketBreakdown) { bracket in
                    HStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(bracket.bracketLabel).font(.caption).foregroundColor(.secondary)
                            Text("\((bracket.rate * 100).formatted(.number.precision(.fractionLength(0))))% × \(bracket.amount.currencyFormatted)")
                                .font(.caption2).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(bracket.tax.currencyFormatted)
                            .font(.body.monospaced().weight(.medium))
                            .foregroundColor(.negativeRed)
                    }
                }

                Divider()

                HStack {
                    Text("Total Income Tax").font(.headline)
                    Spacer()
                    Text(vm.result.totalTax.currencyFormatted)
                        .font(.body.monospaced().weight(.bold))
                        .foregroundColor(.negativeRed)
                }

                HStack {
                    Text("Solidarity Contribution").font(.body).foregroundColor(.secondary)
                    Spacer()
                    Text(vm.result.solidarityContribution.currencyFormatted)
                        .font(.body.monospaced()).foregroundColor(.negativeRed)
                }

                Divider()

                HStack {
                    Text("Effective Rate").font(.body).foregroundColor(.secondary)
                    Spacer()
                    Text("\((vm.result.effectiveRate * 100).formatted(.number.precision(.fractionLength(1))))%")
                        .font(.body.monospaced().weight(.bold))
                        .foregroundColor(.accentPurple)
                }

                HStack {
                    Text("Net Annual Income").font(.headline).foregroundColor(.primary)
                    Spacer()
                    Text(vm.result.netAnnual.currencyFormatted)
                        .font(.body.monospaced().weight(.bold))
                        .foregroundColor(.accentTeal)
                }

                HStack {
                    Text("Net Monthly").font(.body).foregroundColor(.secondary)
                    Spacer()
                    Text(vm.result.netMonthly.currencyFormatted)
                        .font(.body.monospaced()).foregroundColor(.accentTeal)
                }
            } header: {
                SectionHeader(title: "Tax Calculation", icon: "chart.bar.fill")
            }

            Section {
                Text("Based on Ν. 4172/2013 progressive scale. Solidarity contribution applies above €30,000. Does not include special deductions or tax credits.")
                    .font(.caption2).foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Income Tax")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { IncomeTaxCalculatorView() }
}
