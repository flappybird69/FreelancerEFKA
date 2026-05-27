import Foundation

struct PropertyCostBreakdown: Identifiable {
    let id = UUID()
    let item: String
    let percentage: String
    let amount: Decimal
    let colorLabel: String
}

struct PropertyCostResult {
    let propertyValue: Decimal
    let isNewBuild: Bool
    let breakdown: [PropertyCostBreakdown]
    let totalCosts: Decimal
    let totalPercentage: String
    let grandTotal: Decimal
}

enum PropertyCostCalculator {

    static let transferTaxRate: Decimal = 0.03
    static let vatRate: Decimal = 0.24
    static let notaryMinRate: Decimal = 0.01
    static let notaryMaxRate: Decimal = 0.02
    static let lawyerRate: Decimal = 0.015
    static let registrationRate: Decimal = 0.0055
    static let certificateCosts: Decimal = 800

    static func calculate(propertyValue: Decimal, isNewBuild: Bool) -> PropertyCostResult {
        let mainTaxRate = isNewBuild ? vatRate : transferTaxRate
        let mainTax = (propertyValue * mainTaxRate).roundedTwoDecimals

        let notaryRate = propertyValue < 100000 ? notaryMaxRate : (propertyValue < 300000 ? Decimal(0.015) : notaryMinRate)
        let notary = (propertyValue * notaryRate).roundedTwoDecimals

        let lawyer = (propertyValue * lawyerRate).roundedTwoDecimals
        let registration = (propertyValue * registrationRate).roundedTwoDecimals

        var items: [PropertyCostBreakdown] = []

        if isNewBuild {
            items.append(PropertyCostBreakdown(item: "VAT (24%)", percentage: "24%", amount: mainTax, colorLabel: "red"))
        } else {
            items.append(PropertyCostBreakdown(item: "Transfer Tax (ΦΜΑ 3%)", percentage: "3%", amount: mainTax, colorLabel: "red"))
        }

        items.append(PropertyCostBreakdown(item: "Notary Fee", percentage: "\((notaryRate * 100).formatted(.number.precision(.fractionLength(1))))%", amount: notary, colorLabel: "orange"))
        items.append(PropertyCostBreakdown(item: "Lawyer Fee", percentage: "1.5%", amount: lawyer, colorLabel: "purple"))
        items.append(PropertyCostBreakdown(item: "Cadastre Registration", percentage: "0.55%", amount: registration, colorLabel: "teal"))
        items.append(PropertyCostBreakdown(item: "Certificates & Misc.", percentage: "fixed", amount: certificateCosts, colorLabel: "gray"))

        let total = (mainTax + notary + lawyer + registration + certificateCosts).roundedTwoDecimals
        let pct = propertyValue > 0 ? (total / propertyValue * 100).roundedTwoDecimals : 0

        return PropertyCostResult(
            propertyValue: propertyValue.roundedTwoDecimals,
            isNewBuild: isNewBuild,
            breakdown: items,
            totalCosts: total,
            totalPercentage: "\(pct.formatted(.number.precision(.fractionLength(1))))%",
            grandTotal: (propertyValue + total).roundedTwoDecimals
        )
    }
}
