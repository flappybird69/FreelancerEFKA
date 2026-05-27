import Foundation
import SwiftUI

@Observable
final class VATCalculatorViewModel {
    private let defaults = UserDefaults.standard

    var netMonthlyIncome: Decimal {
        get { Decimal(defaults.double(forKey: "vat_income")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "vat_income") }
    }

    var monthlyDeductibleExpenses: Decimal {
        get { Decimal(defaults.double(forKey: "vat_expenses")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "vat_expenses") }
    }

    var selectedVatRateIndex: Int {
        get { defaults.integer(forKey: "vat_rateIndex") }
        set { defaults.set(newValue, forKey: "vat_rateIndex") }
    }

    var annualProjectedIncome: Decimal {
        get { Decimal(defaults.double(forKey: "vat_annual")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "vat_annual") }
    }

    var islandDiscount: Bool {
        get { defaults.bool(forKey: "vat_island") }
        set { defaults.set(newValue, forKey: "vat_island") }
    }

    var filingFrequency: VATFilingFrequency {
        get { defaults.bool(forKey: "vat_monthly") ? .monthly : .quarterly }
        set { defaults.set(newValue == .monthly, forKey: "vat_monthly") }
    }

    init() {
        if defaults.double(forKey: "vat_income") == 0 {
            defaults.set(2000, forKey: "vat_income")
            defaults.set(200, forKey: "vat_expenses")
            defaults.set(24000, forKey: "vat_annual")
        }
    }

    let vatRateOptions: [(label: String, rate: Decimal, category: VATCategory)] = [
        ("General 24%", 0.24, .general),
        ("Reduced 13%", 0.13, .foodNEmergy),
        ("Super Reduced 6%", 0.06, .pharmaceutical),
        ("Exempt 0%", 0.0, .exempt),
    ]

    var selectedVatRate: Decimal {
        guard selectedVatRateIndex < vatRateOptions.count else { return 0.24 }
        return vatRateOptions[selectedVatRateIndex].rate
    }

    var selectedCategory: VATCategory {
        guard selectedVatRateIndex < vatRateOptions.count else { return .general }
        return vatRateOptions[selectedVatRateIndex].category
    }

    var result: VATCalculationResult {
        VATCalculator.calculate(
            netMonthlyIncome: netMonthlyIncome,
            monthlyDeductibleExpenses: monthlyDeductibleExpenses,
            vatRate: selectedVatRate,
            annualProjectedIncome: annualProjectedIncome,
            islandDiscount: islandDiscount,
            filingFrequency: filingFrequency
        )
    }

    var suggestedFrequency: VATFilingFrequency {
        VATCalculator.suggestedFilingFrequency(for: annualProjectedIncome)
    }

    func updateAnnualProjection() {
        annualProjectedIncome = netMonthlyIncome * 12
    }
}
