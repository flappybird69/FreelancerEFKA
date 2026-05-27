import Foundation
import SwiftUI

@Observable
final class IncomeTaxViewModel {
    var annualIncome: Decimal = 30000
    var deductibleExpenses: Decimal = 5000

    var result: IncomeTaxResult {
        IncomeTaxCalculator.calculate(
            annualGrossIncome: annualIncome,
            deductibleExpenses: deductibleExpenses
        )
    }
}
