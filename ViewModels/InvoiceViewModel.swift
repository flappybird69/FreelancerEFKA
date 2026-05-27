import Foundation
import SwiftUI

@Observable
final class InvoiceViewModel {
    private let defaults = UserDefaults.standard

    var netAmount: Decimal {
        get { Decimal(defaults.double(forKey: "inv_net")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "inv_net") }
    }

    var selectedVatIndex: Int {
        get { defaults.integer(forKey: "inv_vatIndex") }
        set { defaults.set(newValue, forKey: "inv_vatIndex") }
    }

    var applyWithholding: Bool {
        get { defaults.object(forKey: "inv_withholding") == nil ? true : defaults.bool(forKey: "inv_withholding") }
        set { defaults.set(newValue, forKey: "inv_withholding") }
    }

    init() {
        if defaults.double(forKey: "inv_net") == 0 {
            defaults.set(1000, forKey: "inv_net")
        }
    }

    let vatOptions: [(String, Decimal)] = [("24%", 0.24), ("13%", 0.13), ("6%", 0.06), ("Exempt", 0)]

    var selectedVatRate: Decimal {
        guard selectedVatIndex < vatOptions.count else { return 0.24 }
        return vatOptions[selectedVatIndex].1
    }

    var result: InvoiceResult {
        InvoiceCalculator.calculate(netAmount: netAmount, vatRate: selectedVatRate, applyWithholding: applyWithholding)
    }
}
