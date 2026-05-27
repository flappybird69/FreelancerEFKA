import Foundation
import SwiftUI

@Observable
final class InvoiceViewModel {
    var netAmount: Decimal = 1000
    var selectedVatIndex: Int = 0
    var applyWithholding: Bool = true

    let vatOptions: [(String, Decimal)] = [("24%", 0.24), ("13%", 0.13), ("6%", 0.06), ("Exempt", 0)]

    var selectedVatRate: Decimal {
        guard selectedVatIndex < vatOptions.count else { return 0.24 }
        return vatOptions[selectedVatIndex].1
    }

    var result: InvoiceResult {
        InvoiceCalculator.calculate(
            netAmount: netAmount,
            vatRate: selectedVatRate,
            applyWithholding: applyWithholding
        )
    }
}
