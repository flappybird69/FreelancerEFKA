import Foundation

struct InvoiceResult: Identifiable {
    let id = UUID()
    let netAmount: Decimal
    let vatRate: Decimal
    let vatAmount: Decimal
    let withholdingTaxRate: Decimal
    let withholdingTax: Decimal
    let grossAmount: Decimal
    let finalNet: Decimal
}

enum InvoiceCalculator {
    static let withholdingRate: Decimal = 0.20

    static func calculate(netAmount: Decimal, vatRate: Decimal, applyWithholding: Bool = true) -> InvoiceResult {
        let vatAmount = (netAmount * vatRate).roundedTwoDecimals
        let grossAmount = (netAmount + vatAmount).roundedTwoDecimals
        let withholdingTax = applyWithholding ? (grossAmount * withholdingRate).roundedTwoDecimals : 0
        let finalNet = (grossAmount - withholdingTax).roundedTwoDecimals

        return InvoiceResult(
            netAmount: netAmount.roundedTwoDecimals,
            vatRate: vatRate,
            vatAmount: vatAmount,
            withholdingTaxRate: withholdingRate,
            withholdingTax: withholdingTax,
            grossAmount: grossAmount,
            finalNet: finalNet
        )
    }
}
