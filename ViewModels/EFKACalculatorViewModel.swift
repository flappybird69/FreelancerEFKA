import Foundation
import SwiftUI

@Observable
final class EFKACalculatorViewModel {
    private let defaults = UserDefaults.standard

    var grossMonthlyIncome: Decimal {
        get { Decimal(defaults.double(forKey: "efka_income")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "efka_income") }
    }

    var yearsActive: Int {
        get { defaults.integer(forKey: "efka_years") }
        set { defaults.set(newValue, forKey: "efka_years") }
    }

    var selectedClassIndex: Int {
        get { defaults.integer(forKey: "efka_class") }
        set { defaults.set(newValue, forKey: "efka_class") }
    }

    init() {
        if defaults.double(forKey: "efka_income") == 0 {
            defaults.set(2500, forKey: "efka_income")
        }
    }

    var result: EFKACalculationResult {
        EFKARates.calculate(grossMonthlyIncome: grossMonthlyIncome, yearsActive: yearsActive, classIndex: selectedClassIndex)
    }

    var annualProjection: (totalPaid: Decimal, netAnnual: Decimal, totalBusinessTax: Decimal, estimatedAnnualIncomeTax: Decimal, estimatedAnnualSolidarity: Decimal) {
        EFKARates.annualProjection(from: result)
    }

    var selectedClass: EFKAContributionClass {
        guard selectedClassIndex >= 0, selectedClassIndex < EFKAContributionClass.all.count else {
            return EFKAContributionClass.all[0]
        }
        return EFKAContributionClass.all[selectedClassIndex]
    }

    var effectiveRate: Decimal {
        if yearsActive == 0 { return EFKARates.reducedRateYear1 }
        if yearsActive == 1 { return EFKARates.reducedRateYear2 }
        return EFKARates.baseTotalRate
    }

    var isReducedRate: Bool { yearsActive < 2 }

    var classes: [EFKAContributionClass] { EFKAContributionClass.all }
    var yearOptions: [Int] { Array(0...30) }

    var recommendedClassIndex: Int {
        let recommended = EFKARates.recommendedClass(for: grossMonthlyIncome)
        return EFKAContributionClass.all.firstIndex { $0.id == recommended.id } ?? 0
    }

    func applyRecommendedClass() { selectedClassIndex = recommendedClassIndex }

    var mainPensionRateDisplay: String { "\((EFKARates.mainPensionRate * 100).formatted(.number.precision(.fractionLength(2))))%" }
    var healthRateDisplay: String { "\((EFKARates.healthRate * 100).formatted(.number.precision(.fractionLength(2))))%" }

    // MARK: - Multi-year projection
    func multiYearProjection(years: Int = 10) -> [(year: Int, efkaPaid: Decimal, taxPaid: Decimal, netIncome: Decimal)] {
        var results: [(year: Int, efkaPaid: Decimal, taxPaid: Decimal, netIncome: Decimal)] = []
        let annual = grossMonthlyIncome * 12
        for y in 0..<years {
            let rate = y == 0 ? EFKARates.reducedRateYear1 : (y == 1 ? EFKARates.reducedRateYear2 : EFKARates.baseTotalRate)
            let efka = (annual * rate).roundedTwoDecimals
            let tax = EFKARates.calculateIncomeTax(annualIncome: max(annual - efka, 0))
            let solidarity = EFKARates.calculateSolidarityContribution(annualIncome: max(annual - efka, 0))
            let net = (annual - efka - tax - solidarity - EFKARates.annualBusinessTax).roundedTwoDecimals
            results.append((year: y + 1, efkaPaid: efka, taxPaid: (tax + solidarity + EFKARates.annualBusinessTax).roundedTwoDecimals, netIncome: max(net, 0)))
        }
        return results
    }
}
