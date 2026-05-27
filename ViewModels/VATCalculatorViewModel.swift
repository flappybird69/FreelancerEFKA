import Foundation
import SwiftUI

@Observable
final class VATCalculatorViewModel {
    var netMonthlyIncome: Decimal = 2000
    var monthlyDeductibleExpenses: Decimal = 200
    var selectedVatRateIndex: Int = 0
    var annualProjectedIncome: Decimal = 24000

    var islandDiscount: Bool = false
    var filingFrequency: VATFilingFrequency = .quarterly

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

    var annualVATLiability: Decimal {
        result.annualVATDue
    }

    var suggestedFrequency: VATFilingFrequency {
        VATCalculator.suggestedFilingFrequency(for: annualProjectedIncome)
    }

    func updateAnnualProjection() {
        annualProjectedIncome = netMonthlyIncome * 12
    }
}
