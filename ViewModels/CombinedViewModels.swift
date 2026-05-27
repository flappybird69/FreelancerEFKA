import Foundation
import SwiftUI

@Observable
final class IncomeTaxViewModel {
    private let defaults = UserDefaults.standard

    var annualIncome: Decimal {
        get { Decimal(defaults.double(forKey: "tax_income")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "tax_income") }
    }

    var deductibleExpenses: Decimal {
        get { Decimal(defaults.double(forKey: "tax_expenses")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "tax_expenses") }
    }

    init() {
        if defaults.double(forKey: "tax_income") == 0 {
            defaults.set(30000, forKey: "tax_income")
            defaults.set(5000, forKey: "tax_expenses")
        }
    }

    var result: IncomeTaxResult {
        IncomeTaxCalculator.calculate(annualGrossIncome: annualIncome, deductibleExpenses: deductibleExpenses)
    }
}

@Observable
final class EmploymentComparisonViewModel {
    private let defaults = UserDefaults.standard

    var grossMonthlyIncome: Decimal {
        get { Decimal(defaults.double(forKey: "comp_income")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "comp_income") }
    }

    init() {
        if defaults.double(forKey: "comp_income") == 0 {
            defaults.set(2500, forKey: "comp_income")
        }
    }

    var results: [EmploymentComparison] {
        EmploymentComparisonEngine.compare(grossMonthly: grossMonthlyIncome)
    }
}

@Observable
final class PropertyCostViewModel {
    private let defaults = UserDefaults.standard

    var propertyValue: Decimal {
        get { Decimal(defaults.double(forKey: "prop_value")) }
        set { defaults.set(Double(truncating: newValue as NSDecimalNumber), forKey: "prop_value") }
    }

    var isNewBuild: Bool {
        get { defaults.bool(forKey: "prop_newBuild") }
        set { defaults.set(newValue, forKey: "prop_newBuild") }
    }

    init() {
        if defaults.double(forKey: "prop_value") == 0 {
            defaults.set(200000, forKey: "prop_value")
        }
    }

    var result: PropertyCostResult {
        PropertyCostCalculator.calculate(propertyValue: propertyValue, isNewBuild: isNewBuild)
    }
}
