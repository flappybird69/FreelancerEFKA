import Foundation
import SwiftUI

@Observable
final class EFKACalculatorViewModel {
    var grossMonthlyIncome: Decimal = 2500
    var yearsActive: Int = 0
    var selectedClassIndex: Int = 0

    var result: EFKACalculationResult {
        EFKARates.calculate(
            grossMonthlyIncome: grossMonthlyIncome,
            yearsActive: yearsActive,
            classIndex: selectedClassIndex
        )
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

    var isReducedRate: Bool {
        yearsActive < 2
    }

    var classes: [EFKAContributionClass] {
        EFKAContributionClass.all
    }

    var yearOptions: [Int] {
        Array(0...30)
    }

    var recommendedClassIndex: Int {
        let recommended = EFKARates.recommendedClass(for: grossMonthlyIncome)
        return EFKAContributionClass.all.firstIndex { $0.id == recommended.id } ?? 0
    }

    func applyRecommendedClass() {
        selectedClassIndex = recommendedClassIndex
    }

    // MARK: - Breakdown components for display
    var mainPensionRateDisplay: String {
        "\((EFKARates.mainPensionRate * 100).formatted(.number.precision(.fractionLength(2))))%"
    }

    var healthRateDisplay: String {
        "\((EFKARates.healthRate * 100).formatted(.number.precision(.fractionLength(2))))%"
    }
}
