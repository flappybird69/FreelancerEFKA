import SwiftUI

struct VATCalculatorView: View {
    @State private var vm = VATCalculatorViewModel()
    @State private var incomeText: String = "2000"
    @State private var expensesText: String = "200"
    @State private var showInfo = false

    var body: some View {
        NavigationStack {
            List {
                headerSection
                inputSection
                rateSection
                monthlySection
                quarterlySection
                annualSection
                legalDisclaimer
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("VAT Calculator")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.accentPurple)
                    }
                }
            }
            .sheet(isPresented: $showInfo) { categorySheet }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        Section {
            VStack(spacing: 8) {
                Image(systemName: "doc.text")
                    .font(.system(size: 48))
                    .foregroundStyle(LinearGradient.primaryGradient)
                    .padding(.bottom, 4)
                Text("ΦΠΑ Calculator")
                    .font(AppFont.title2)
                    .foregroundColor(.primary)
                Text("VAT for μπλοκάκι freelancers · 2025")
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
                Text("€").font(AppFont.title).foregroundColor(.accentPurple)
                TextField("Net monthly income", text: $incomeText)
                    .keyboardType(.decimalPad)
                    .font(AppFont.title)
                    .onChange(of: incomeText) { _, nv in
                        if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) {
                            vm.netMonthlyIncome = v
                            vm.updateAnnualProjection()
                        }
                    }
            }

            HStack(spacing: 12) {
                Text("€").font(AppFont.title).foregroundColor(.accentPink)
                TextField("Monthly expenses (with VAT)", text: $expensesText)
                    .keyboardType(.decimalPad)
                    .font(AppFont.title)
                    .onChange(of: expensesText) { _, nv in
                        if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) {
                            vm.monthlyDeductibleExpenses = v
                        }
                    }
            }

            Toggle(isOn: $vm.islandDiscount) {
                HStack(spacing: 8) {
                    Image(systemName: "sun.horizon.fill")
                        .foregroundColor(.accentOrange)
                    Text("Aegean Island –30%")
                        .font(AppFont.body)
                }
            }
            .tint(.accentOrange)
        } header: {
            SectionHeader(title: "Income & Expenses", icon: "eurosign")
        }
    }

    // MARK: - Rate
    private var rateSection: some View {
        Section {
            Picker("Rate", selection: $vm.selectedVatRateIndex) {
                ForEach(Array(vm.vatRateOptions.enumerated()), id: \.offset) { i, opt in
                    Text(opt.label).tag(i)
                }
            }
            .pickerStyle(.menu)
            .tint(.accentPurple)

            Text(vm.selectedCategory.shortDescription)
                .font(AppFont.caption2)
                .foregroundColor(.secondary)
        } header: {
            SectionHeader(title: "VAT Rate", icon: "doc.text")
        }
    }

    // MARK: - Monthly
    private var monthlySection: some View {
        Section {
            if vm.result.isExempt {
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.accentOrange)
                    Text("Under €\(Int(truncating: VATRates.exemptionThresholdAnnual as NSDecimalNumber))/yr — VAT exempt")
                        .font(AppFont.caption)
                        .foregroundColor(.accentOrange)
                }
                .listRowBackground(Color.accentOrange.opacity(0.06))
            }

            DetailLabel(label: "Net Income", value: vm.result.netMonthlyIncome.currencyFormatted, valueColor: .primary)
            DetailLabel(label: "VAT Charged", value: vm.result.vatChargedMonthly.currencyFormatted, valueColor: .accentBlue)
            DetailLabel(label: "VAT Deductible", value: "-\(vm.result.vatDeductibleMonthly.currencyFormatted)", valueColor: .accentTeal)
            Divider()
            HStack {
                Text("VAT Payable").font(AppFont.headline)
                Spacer()
                AmountLabel(amount: vm.result.vatPayableMonthly,
                            color: vm.result.vatPayableMonthly > 0 ? .negativeRed : .accentTeal)
            }
            HStack {
                Text("Gross to Client").font(AppFont.headline)
                Spacer()
                AmountLabel(amount: vm.result.grossMonthlyIncome, color: .primary)
            }
        } header: {
            SectionHeader(title: "Monthly VAT", icon: "doc.text")
        }
    }

    // MARK: - Quarterly
    private var quarterlySection: some View {
        Section {
            HStack {
                Text("Quarterly VAT Due").font(AppFont.headline)
                Spacer()
                AmountLabel(amount: vm.result.quarterlyVATDue,
                            color: vm.result.quarterlyVATDue > 0 ? .negativeRed : .accentTeal)
            }
            HStack {
                Text("Filing frequency").font(AppFont.body).foregroundColor(.secondary)
                Spacer()
                Text(vm.result.isExempt ? "None" :
                        vm.suggestedFrequency == .quarterly ? "Quarterly" : "Monthly")
                    .font(AppFont.body.weight(.semibold))
                    .foregroundColor(.accentPurple)
            }
        } header: {
            SectionHeader(title: "Quarterly Filing", icon: "calendar.badge.clock")
        }
    }

    // MARK: - Annual
    private var annualSection: some View {
        Section {
            DetailLabel(label: "Projected Turnover", value: vm.result.grossAnnualIncome.currencyFormatted, valueColor: .primary)
            DetailLabel(label: "Annual VAT", value: vm.result.annualVATDue.currencyFormatted, valueColor: .negativeRed)
            DetailLabel(label: "Income Tax (est.)", value: vm.result.estimatedAnnualIncomeTax.currencyFormatted, valueColor: .negativeRed)
            DetailLabel(label: "Business Tax", value: vm.result.annualBusinessTax.currencyFormatted, valueColor: .negativeRed)
            Divider()
            HStack {
                Text("Net After All").font(AppFont.headline)
                Spacer()
                AmountLabel(amount: vm.result.netAnnualAfterAll, color: .accentTeal)
            }
        } header: {
            SectionHeader(title: "Annual Projection", icon: "calendar")
        }
    }

    // MARK: - Disclaimer
    private var legalDisclaimer: some View {
        Section {
            Text("Estimates based on AADE ΦΠΑ rates 2025. ±5% margin. Consult your λογιστής for exact obligations.")
                .font(AppFont.caption2)
                .foregroundColor(.secondary)
                .listRowBackground(Color.clear)
        }
    }

    // MARK: - Category Sheet
    private var categorySheet: some View {
        NavigationStack {
            List {
                ForEach(VATCategory.allCases) { cat in
                    Section(cat.rawValue) {
                        Text(cat.description)
                            .font(AppFont.caption)
                            .foregroundColor(.secondary)
                        if cat.rate > 0 {
                            HStack {
                                Text("Rate")
                                    .font(AppFont.body)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("\((cat.rate * 100).formatted(.number.precision(.fractionLength(0))))%")
                                    .font(AppFont.monoBold())
                                    .foregroundColor(.accentPurple)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("VAT Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showInfo = false }
                }
            }
        }
    }
}

extension VATCategory {
    var shortDescription: String {
        switch self {
        case .general: "Most goods, electronics, vehicles, telecom, professional services"
        case .foodNEmergy: "Food, energy, hotel accommodation, water, books"
        case .pharmaceutical: "Selected pharma, newspapers, theatre tickets"
        case .exempt: "Insurance, education, healthcare, postal services"
        }
    }
}

#Preview {
    VATCalculatorView()
}
