import SwiftUI

struct EFKACalculatorView: View {
    @State private var vm = EFKACalculatorViewModel()
    @State private var incomeText: String = "2500"
    @State private var showClassPicker = false

    var body: some View {
        NavigationStack {
            List {
                headerSection
                inputSection
                if vm.result.isReducedRate { reducedRateBanner }
                efkaBreakdown
                totalBurden
                annualProjection
                legalDisclaimer
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("EFKA Estimator")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            vm.applyRecommendedClass()
                            incomeText = "\(vm.grossMonthlyIncome)"
                        }
                    } label: {
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.accentPurple)
                    }
                }
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        Section {
            VStack(spacing: 8) {
                Image(systemName: "eurosign.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(LinearGradient.primaryGradient)
                    .padding(.bottom, 4)
                Text("Social Security Estimator")
                    .font(AppFont.title2)
                    .foregroundColor(.primary)
                Text("Μπλοκάκι · 2025 EFKA rates")
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Input
    private var inputSection: some View {
        Section {
            HStack(spacing: 12) {
                Text("€")
                    .font(AppFont.title)
                    .foregroundColor(.accentPurple)
                TextField("Gross monthly income", text: $incomeText)
                    .keyboardType(.decimalPad)
                    .font(AppFont.title)
                    .onChange(of: incomeText) { _, nv in
                        if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) {
                            vm.grossMonthlyIncome = v
                        }
                    }
            }

            Picker("Years active", selection: $vm.yearsActive) {
                ForEach(vm.yearOptions, id: \.self) { y in
                    Text("\(y) \(y == 1 ? "year" : "years")").tag(y)
                }
            }
            .tint(.accentPurple)

            Picker("Insurance class", selection: $vm.selectedClassIndex) {
                ForEach(Array(vm.classes.enumerated()), id: \.offset) { i, c in
                    Text("\(c.id). \(c.monthlyMinimum.currencyFormatted)/mo").tag(i)
                }
            }
            .tint(.accentPurple)
        } header: {
            SectionHeader(title: "Monthly Income", icon: "eurosign")
        }
    }

    // MARK: - Reduced Rate
    private var reducedRateBanner: some View {
        Section {
            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .foregroundColor(.accentTeal)
                Text("Reduced \((vm.effectiveRate * 100).formatted(.number.precision(.fractionLength(1))))% — year \(vm.yearsActive + 1)")
                    .font(AppFont.caption)
                    .foregroundColor(.accentTeal)
            }
            .listRowBackground(Color.accentTeal.opacity(0.08))
        }
    }

    // MARK: - EFKA
    private var efkaBreakdown: some View {
        Section {
            DetailLabel(label: "Gross Income", value: vm.result.grossMonthlyIncome.currencyFormatted, valueColor: .primary)

            DetailLabel(label: "Main Pension (\(vm.mainPensionRateDisplay))",
                        value: "-\(vm.result.contributionBreakdown.mainPension.currencyFormatted)", valueColor: .negativeRed)
            DetailLabel(label: "Health (\(vm.healthRateDisplay))",
                        value: "-\(vm.result.contributionBreakdown.health.currencyFormatted)", valueColor: .negativeRed)

            Divider()

            HStack {
                Text("Total EFKA")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                Spacer()
                AmountLabel(amount: vm.result.totalMonthlyContribution, color: .negativeRed)
            }

            HStack {
                Text("After EFKA")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                Spacer()
                AmountLabel(amount: vm.result.netMonthlyIncome, color: .accentTeal)
            }
        } header: {
            SectionHeader(title: "EFKA Contributions", icon: "shield.checkered")
        } footer: {
            Text("Contribution basis: \(vm.result.contributionBasis.currencyFormatted)")
                .font(AppFont.caption2)
        }
    }

    // MARK: - Total Burden
    private var totalBurden: some View {
        Section {
            DetailLabel(label: "Income Tax (progressive)",
                        value: "-\(vm.result.estimatedMonthlyIncomeTax.currencyFormatted)", valueColor: .negativeRed)
            if vm.result.solidarityContributionMonthly > 0 {
                DetailLabel(label: "Solidarity Contribution",
                            value: "-\(vm.result.solidarityContributionMonthly.currencyFormatted)", valueColor: .negativeRed)
            }
            DetailLabel(label: "Business Tax",
                        value: "-\(vm.result.businessTaxMonthly.currencyFormatted)", valueColor: .negativeRed)

            Divider()

            HStack {
                Text("Total Deductions")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                Spacer()
                AmountLabel(amount: vm.result.totalMonthlyBurden, color: .negativeRed)
            }

            HStack {
                Text("Net Pocket Income")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                Spacer()
                AmountLabel(amount: vm.result.netAfterAllMonthly, color: .accentTeal)
            }
        } header: {
            SectionHeader(title: "Total Monthly Burden", icon: "chart.pie")
        }
    }

    // MARK: - Annual
    private var annualProjection: some View {
        Section {
            DetailLabel(label: "EFKA (12×)", value: vm.annualProjection.totalPaid.currencyFormatted, valueColor: .negativeRed)
            DetailLabel(label: "Business Tax (year)", value: vm.annualProjection.totalBusinessTax.currencyFormatted, valueColor: .negativeRed)
            if vm.annualProjection.estimatedAnnualIncomeTax > 0 {
                DetailLabel(label: "Income Tax (est.)", value: vm.annualProjection.estimatedAnnualIncomeTax.currencyFormatted, valueColor: .negativeRed)
            }
            if vm.annualProjection.estimatedAnnualSolidarity > 0 {
                DetailLabel(label: "Solidarity (est.)", value: vm.annualProjection.estimatedAnnualSolidarity.currencyFormatted, valueColor: .negativeRed)
            }

            Divider()

            HStack {
                Text("Net Annual")
                    .font(AppFont.headline)
                    .foregroundColor(.primary)
                Spacer()
                AmountLabel(amount: vm.annualProjection.netAnnual, color: .accentTeal)
            }
        } header: {
            SectionHeader(title: "Annual Projection", icon: "calendar")
        }
    }

    // MARK: - Disclaimer
    private var legalDisclaimer: some View {
        Section {
            Text("Estimates based on published 2025 rates. ±5% margin. Income tax uses progressive brackets excluding deductions. Consult your λογιστής.")
                .font(AppFont.caption2)
                .foregroundColor(.secondary)
                .listRowBackground(Color.clear)
        }
    }
}

#Preview {
    EFKACalculatorView()
}
