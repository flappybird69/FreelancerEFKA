import Foundation

// MARK: - EFKA Contribution Breakdown
struct EFKAContributionBreakdown: Equatable {
    let mainPension: Decimal
    let health: Decimal
    let auxiliaryPension: Decimal?
    let lumpSum: Decimal?
    let unemploymentOAED: Decimal?

    var total: Decimal {
        mainPension + health + (auxiliaryPension ?? 0) + (lumpSum ?? 0) + (unemploymentOAED ?? 0)
    }
}

// MARK: - Insurance Class (Ασφαλιστική Κλάση)
struct EFKAContributionClass: Identifiable, Equatable {
    let id: Int // category number 1-6
    let monthlyMinimum: Decimal
    let annualMinimum: Decimal
    let bracketLabel: String
    let monthlyIncomeCeiling: Decimal?

    static let all: [EFKAContributionClass] = [
        EFKAContributionClass(id: 1, monthlyMinimum: 155.54, annualMinimum: 1866.48,
                              bracketLabel: "Up to €7,133/yr", monthlyIncomeCeiling: 594.42),
        EFKAContributionClass(id: 2, monthlyMinimum: 186.65, annualMinimum: 2239.80,
                              bracketLabel: "€7,134–€10,666/yr", monthlyIncomeCeiling: 888.89),
        EFKAContributionClass(id: 3, monthlyMinimum: 217.76, annualMinimum: 2613.12,
                              bracketLabel: "€10,667–€14,666/yr", monthlyIncomeCeiling: 1222.22),
        EFKAContributionClass(id: 4, monthlyMinimum: 248.86, annualMinimum: 2986.32,
                              bracketLabel: "€14,667–€18,666/yr", monthlyIncomeCeiling: 1555.56),
        EFKAContributionClass(id: 5, monthlyMinimum: 311.07, annualMinimum: 3732.84,
                              bracketLabel: "€18,667–€22,666/yr", monthlyIncomeCeiling: 1888.89),
        EFKAContributionClass(id: 6, monthlyMinimum: 373.29, annualMinimum: 4479.48,
                              bracketLabel: "€22,667+/yr", monthlyIncomeCeiling: nil),
    ]

    subscript(_ id: Int) -> EFKAContributionClass? {
        Self.all.first { $0.id == id }
    }
}

// MARK: - Detailed Calculation Result
struct EFKACalculationResult: Equatable {
    let grossMonthlyIncome: Decimal
    let annualGrossIncome: Decimal
    let selectedClass: EFKAContributionClass
    let contributionBreakdown: EFKAContributionBreakdown
    let totalMonthlyContribution: Decimal
    let totalAnnualContribution: Decimal
    let netMonthlyIncome: Decimal
    let netAnnualIncome: Decimal
    let effectiveRate: Decimal
    let isReducedRate: Bool
    let yearsActive: Int
    let contributionBasis: Decimal
    let businessTaxMonthly: Decimal
    let totalMonthlyBurden: Decimal

    // Income tax estimation (simplified progressive scale)
    let estimatedMonthlyIncomeTax: Decimal
    let solidarityContributionMonthly: Decimal

    var netAfterAllMonthly: Decimal {
        netMonthlyIncome - estimatedMonthlyIncomeTax - solidarityContributionMonthly - businessTaxMonthly
    }
}

// MARK: - EFKA Calculator Engine
enum EFKARates {

    // MARK: - Core Contribution Rates (2024–2025)
    /// Main pension (κύρια σύνταξη): 13.33% for μπλοκάκι workers classified as employees
    static let mainPensionRate: Decimal = 0.1333

    /// Health (υγειονομική περίθαλψη): 6.95%
    static let healthRate: Decimal = 0.0695

    /// Base total rate before any adjustments
    static let baseTotalRate: Decimal = mainPensionRate + healthRate // 20.28%

    // MARK: - Reduced Rates for New Entrants (Νέοι Ασφαλισμένοι)
    /// First year after registration: 14% total
    static let reducedRateYear1: Decimal = 0.14
    /// Second year: 17%
    static let reducedRateYear2: Decimal = 0.17
    /// Third year onwards: full rate
    static let fullRate: Decimal = baseTotalRate

    // MARK: - Income Limits
    /// Minimum annual income considered for EFKA (Ελάχιστη Ασφαλιστέα Αποδοχή)
    /// As of 2024: based on the minimum wage (€830/mo) × 12 × a coefficient
    static let minimumAnnualIncome: Decimal = 4923.00
    /// Maximum annual income cap (Ανώτατο Όριο Ασφαλιστέων Αποδοχών)
    static let maximumAnnualIncome: Decimal = 70330.00
    /// Minimum monthly income for calculation
    static let minimumMonthlyIncome: Decimal = minimumAnnualIncome / 12 // ~410.25

    // MARK: - Business Tax (Τέλος Επιτηδεύματος)
    /// Annual business tax for freelancers and self-employed (Law 4110/2013, updated)
    static let annualBusinessTax: Decimal = 650.00
    /// Monthly equivalent
    static var monthlyBusinessTax: Decimal { annualBusinessTax / 12 }

    // MARK: - Income Tax Brackets 2024 (Simplified for estimation)
    struct TaxBracket {
        let upperLimit: Decimal?
        let rate: Decimal
    }

    static let incomeTaxBrackets: [TaxBracket] = [
        TaxBracket(upperLimit: 10000, rate: 0.09),
        TaxBracket(upperLimit: 20000, rate: 0.22),
        TaxBracket(upperLimit: 30000, rate: 0.28),
        TaxBracket(upperLimit: 40000, rate: 0.36),
        TaxBracket(upperLimit: nil, rate: 0.44),
    ]

    // MARK: - Solidarity Contribution Brackets (2024)
    static let solidarityBrackets: [TaxBracket] = [
        TaxBracket(upperLimit: 12000, rate: 0),
        TaxBracket(upperLimit: 30000, rate: 0), // 0% for 0-30,000
        TaxBracket(upperLimit: 40000, rate: 0.02),
        TaxBracket(upperLimit: 65000, rate: 0.05),
        TaxBracket(upperLimit: 220000, rate: 0.09),
        TaxBracket(upperLimit: nil, rate: 0.10),
    ]

    // MARK: - Reduced Rate Calculator
    static func reducedRate(yearsActive: Int) -> Decimal? {
        switch yearsActive {
        case 0:  reducedRateYear1
        case 1:  reducedRateYear2
        default: nil // full rate applies
        }
    }

    // MARK: - Main Calculation
    static func calculate(
        grossMonthlyIncome: Decimal,
        yearsActive: Int,
        classIndex: Int
    ) -> EFKACalculationResult {

        let clampedIndex = max(0, min(classIndex, EFKAContributionClass.all.count - 1))
        let selectedClass = EFKAContributionClass.all[clampedIndex]

        // Determine effective rate
        let effectiveRate: Decimal
        if yearsActive == 0 {
            effectiveRate = reducedRateYear1
        } else if yearsActive == 1 {
            effectiveRate = reducedRateYear2
        } else {
            effectiveRate = baseTotalRate
        }

        // Contribution basis: max(actual income, class minimum, statutory minimum)
        let statutoryMinMonthly = minimumMonthlyIncome
        let contributionBasis = max(grossMonthlyIncome, selectedClass.monthlyMinimum, statutoryMinMonthly)

        // Total contribution
        let totalMonthlyContribution = (contributionBasis * effectiveRate).roundedTwoDecimals

        // Breakdown by component
        let mainPensionRateActual = min(effectiveRate, mainPensionRate) // proportional allocation
        let healthRateActual = effectiveRate - mainPensionRateActual

        let mainPension = (mainPensionRateActual * contributionBasis).roundedTwoDecimals
        let health = (healthRateActual * contributionBasis).roundedTwoDecimals

        let breakdown = EFKAContributionBreakdown(
            mainPension: mainPension,
            health: health,
            auxiliaryPension: nil,
            lumpSum: nil,
            unemploymentOAED: nil
        )

        let totalAnnualContribution = (totalMonthlyContribution * 12).roundedTwoDecimals
        let netMonthly = (grossMonthlyIncome - totalMonthlyContribution).roundedTwoDecimals
        let netAnnual = (netMonthly * 12).roundedTwoDecimals

        // Income tax estimation
        let annualGross = (grossMonthlyIncome * 12).roundedTwoDecimals
        let taxableIncome = max(annualGross - totalAnnualContribution, 0)

        let estimatedAnnualTax = Self.calculateIncomeTax(annualIncome: taxableIncome)
        let estimatedMonthlyTax = (estimatedAnnualTax / 12).roundedTwoDecimals

        // Solidarity contribution
        let solidarityAnnual = Self.calculateSolidarityContribution(annualIncome: taxableIncome)
        let solidarityMonthly = (solidarityAnnual / 12).roundedTwoDecimals

        let businessTaxMonthly = (annualBusinessTax / 12).roundedTwoDecimals
        let totalMonthlyBurden = (totalMonthlyContribution + estimatedMonthlyTax + solidarityMonthly + businessTaxMonthly).roundedTwoDecimals

        return EFKACalculationResult(
            grossMonthlyIncome: grossMonthlyIncome.roundedTwoDecimals,
            annualGrossIncome: annualGross,
            selectedClass: selectedClass,
            contributionBreakdown: breakdown,
            totalMonthlyContribution: totalMonthlyContribution,
            totalAnnualContribution: totalAnnualContribution,
            netMonthlyIncome: netMonthly,
            netAnnualIncome: netAnnual,
            effectiveRate: effectiveRate,
            isReducedRate: yearsActive < 2,
            yearsActive: yearsActive,
            contributionBasis: contributionBasis.roundedTwoDecimals,
            businessTaxMonthly: businessTaxMonthly,
            totalMonthlyBurden: totalMonthlyBurden,
            estimatedMonthlyIncomeTax: estimatedMonthlyTax,
            solidarityContributionMonthly: solidarityMonthly
        )
    }

    // MARK: - Income Tax Calculation (Progressive)
    static func calculateIncomeTax(annualIncome: Decimal) -> Decimal {
        var remaining = annualIncome
        var totalTax: Decimal = 0
        var previousLimit: Decimal = 0

        for bracket in incomeTaxBrackets {
            let bracketAmount: Decimal
            if let upper = bracket.upperLimit {
                bracketAmount = min(max(remaining, 0), upper - previousLimit)
                previousLimit = upper
            } else {
                bracketAmount = max(remaining, 0)
            }
            totalTax += bracketAmount * bracket.rate
            remaining -= bracketAmount
            if remaining <= 0 { break }
        }

        return totalTax.roundedTwoDecimals
    }

    // MARK: - Solidarity Contribution (Εισφορά Αλληλεγγύης)
    static func calculateSolidarityContribution(annualIncome: Decimal) -> Decimal {
        guard annualIncome > 12000 else { return 0 }

        var remaining = annualIncome - 12000
        var total: Decimal = 0
        var previousLimit: Decimal = 12000

        // We use 0-12000 0% already handled, now 12000-30000 0%
        let zeroBracket = 30000 - 12000
        remaining = max(remaining - Decimal(zeroBracket), 0)
        previousLimit = 30000

        for bracket in solidarityBrackets where bracket.rate > 0 {
            let bracketAmount: Decimal
            if let upper = bracket.upperLimit {
                let size = upper - previousLimit
                bracketAmount = min(max(remaining, 0), size)
                previousLimit = upper
            } else {
                bracketAmount = max(remaining, 0)
            }
            total += bracketAmount * bracket.rate
            remaining -= bracketAmount
            if remaining <= 0 { break }
        }

        return total.roundedTwoDecimals
    }

    // MARK: - Annual Projection
    static func annualProjection(from monthly: EFKACalculationResult) -> (
        totalPaid: Decimal,
        netAnnual: Decimal,
        totalBusinessTax: Decimal,
        estimatedAnnualIncomeTax: Decimal,
        estimatedAnnualSolidarity: Decimal
    ) {
        let totalPaid = (monthly.totalMonthlyContribution * 12).roundedTwoDecimals
        let netAnnual = (monthly.netMonthlyIncome * 12).roundedTwoDecimals
        let businessTax = annualBusinessTax
        let incomeTax = calculateIncomeTax(annualIncome: monthly.annualGrossIncome - totalPaid)
        let solidarity = calculateSolidarityContribution(annualIncome: monthly.annualGrossIncome - totalPaid)
        return (totalPaid, netAnnual, businessTax, incomeTax, solidarity)
    }

    // MARK: - Insurance Class Recommender
    static func recommendedClass(for monthlyIncome: Decimal) -> EFKAContributionClass {
        for c in EFKAContributionClass.all {
            if let ceiling = c.monthlyIncomeCeiling, monthlyIncome <= ceiling {
                return c
            }
        }
        return EFKAContributionClass.all.last ?? EFKAContributionClass(id: 6, monthlyMinimum: 373.29, annualMinimum: 4479.48, bracketLabel: "€22,667+/yr", monthlyIncomeCeiling: nil)
    }
}

// MARK: - Decimal Formatting Helpers
extension Decimal {
    var roundedTwoDecimals: Decimal {
        var selfCopy = self
        var result = Decimal()
        NSDecimalRound(&result, &selfCopy, 2, .plain)
        return result
    }

    var currencyFormatted: String {
        Self.currencyFormatter.string(for: self as NSDecimalNumber) ?? "€\(self.roundedTwoDecimals)"
    }

    private static let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "el_GR")
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        return f
    }()
}
