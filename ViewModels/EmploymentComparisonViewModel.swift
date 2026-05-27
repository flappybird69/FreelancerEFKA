import Foundation
import SwiftUI

@Observable
final class EmploymentComparisonViewModel {
    var grossMonthlyIncome: Decimal = 2500

    var results: [EmploymentComparison] {
        EmploymentComparisonEngine.compare(grossMonthly: grossMonthlyIncome)
    }
}
