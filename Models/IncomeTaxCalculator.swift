import Foundation

struct IncomeTaxResult: Identifiable {
    let id = UUID()
    let annualGrossIncome: Decimal
    let annualDeductibleExpenses: Decimal
    let taxableIncome: Decimal
    let bracketBreakdown: [BracketBreakdown]
    let totalTax: Decimal
    let effectiveRate: Decimal
    let solidarityContribution: Decimal
    let netAnnual: Decimal
    let netMonthly: Decimal
}

struct BracketBreakdown: Identifiable {
    let id = UUID()
    let bracketLabel: String
    let amount: Decimal
    let rate: Decimal
    let tax: Decimal
}

enum IncomeTaxCalculator {

    static let brackets: [(limit: Decimal?, rate: Decimal)] = [
        (10000, 0.09),
        (20000, 0.22),
        (30000, 0.28),
        (40000, 0.36),
        (nil, 0.44),
    ]

    static let solidarityBrackets: [(limit: Decimal?, rate: Decimal)] = [
        (12000, 0),
        (30000, 0),
        (40000, 0.02),
        (65000, 0.05),
        (220000, 0.09),
        (nil, 0.10),
    ]

    static func calculate(annualGrossIncome: Decimal, deductibleExpenses: Decimal) -> IncomeTaxResult {
        let taxableIncome = max(annualGrossIncome - deductibleExpenses, 0)
        var remaining = taxableIncome
        var previousLimit: Decimal = 0
        var breakdown: [BracketBreakdown] = []
        var totalTax: Decimal = 0

        for bracket in brackets {
            let bracketAmount: Decimal
            if let upper = bracket.limit {
                bracketAmount = min(max(remaining, 0), upper - previousLimit)
                previousLimit = upper
            } else {
                bracketAmount = max(remaining, 0)
            }
            let tax = (bracketAmount * bracket.rate).roundedTwoDecimals
            if bracketAmount > 0 {
                let label = bracket.limit.map { "Up to €\(Int(truncating: $0 as NSDecimalNumber))" } ?? "Over €40,000"
                breakdown.append(BracketBreakdown(bracketLabel: label, amount: bracketAmount, rate: bracket.rate, tax: tax))
            }
            totalTax += tax
            remaining -= bracketAmount
            if remaining <= 0 { break }
        }

        let solidarity = Self.calculateSolidarity(taxableIncome)
        let netAnnual = (annualGrossIncome - deductibleExpenses - totalTax - solidarity).roundedTwoDecimals
        let effectiveRate = taxableIncome > 0 ? (totalTax / taxableIncome).roundedTwoDecimals : 0

        return IncomeTaxResult(
            annualGrossIncome: annualGrossIncome.roundedTwoDecimals,
            annualDeductibleExpenses: deductibleExpenses.roundedTwoDecimals,
            taxableIncome: taxableIncome.roundedTwoDecimals,
            bracketBreakdown: breakdown,
            totalTax: totalTax.roundedTwoDecimals,
            effectiveRate: effectiveRate,
            solidarityContribution: solidarity.roundedTwoDecimals,
            netAnnual: netAnnual,
            netMonthly: (netAnnual / 12).roundedTwoDecimals
        )
    }

    static func calculateSolidarity(_ income: Decimal) -> Decimal {
        guard income > 12000 else { return 0 }
        var remaining = income - 12000
        var total: Decimal = 0
        var prev: Decimal = 12000

        let zeroBracket = (Decimal(30000) - Decimal(12000))
        remaining = max(remaining - zeroBracket, 0)
        prev = 30000

        for bracket in solidarityBrackets where bracket.rate > 0 {
            let amount: Decimal
            if let upper = bracket.limit {
                let size = upper - prev
                amount = min(max(remaining, 0), size)
                prev = upper
            } else {
                amount = max(remaining, 0)
            }
            total += amount * bracket.rate
            remaining -= amount
            if remaining <= 0 { break }
        }
        return total.roundedTwoDecimals
    }
}
