import Foundation

struct EmploymentComparison: Identifiable {
    let id = UUID()
    let typeLabel: String
    let grossIncome: Decimal
    let employerCost: Decimal
    let employeeEFKA: Decimal
    let incomeTax: Decimal
    let netIncome: Decimal
    let netPct: String
    let colorLabel: String
}

enum EmploymentComparisonEngine {

    static func compare(grossMonthly: Decimal) -> [EmploymentComparison] {
        let annual = grossMonthly * 12

        // 1. Μπλοκάκι (self-employed with receipts)
        let blockakiEFKA = (annual * EFKARates.baseTotalRate).roundedTwoDecimals
        let blockakiTaxable = max(annual - blockakiEFKA, 0)
        let blockakiTax = IncomeTaxCalculator.calculate(annualGrossIncome: annual, deductibleExpenses: blockakiEFKA)
        let blockakiNet = annual - blockakiEFKA - blockakiTax.totalTax - blockakiTax.solidarityContribution - EFKARates.annualBusinessTax

        // 2. Employee (μισθωτός)
        let employeeEFKArate: Decimal = 0.158 // ~15.8% employee share
        let employerEFKArate: Decimal = 0.2456 // ~24.56% employer share
        let employeeEFKA = (annual * employeeEFKArate).roundedTwoDecimals
        let employerCost = annual + (annual * employerEFKArate).roundedTwoDecimals
        let employeeTaxable = max(annual - employeeEFKA, 0)
        let employeeTax = IncomeTaxCalculator.calculate(annualGrossIncome: annual, deductibleExpenses: employeeEFKA)
        let employeeNet = annual - employeeEFKA - employeeTax.totalTax - employeeTax.solidarityContribution

        // 3. Company (ΙΚΕ — minimal salary + dividends)
        let salary: Decimal = annual * 0.4
        let dividend: Decimal = annual * 0.6
        let companySalaryEFKA = (salary * employeeEFKArate).roundedTwoDecimals
        let companyEmployerEFKA = (salary * employerEFKArate).roundedTwoDecimals
        let companySalaryTaxable = max(salary - companySalaryEFKA, 0)
        let companySalaryTax = IncomeTaxCalculator.calculate(annualGrossIncome: salary, deductibleExpenses: companySalaryEFKA)
        let dividendTax = (dividend * 0.05).roundedTwoDecimals // 5% dividend tax
        let companyNet = (salary - companySalaryEFKA - companySalaryTax.totalTax - companySalaryTax.solidarityContribution)
                       + (dividend - dividendTax)
        let totalCompanyCost = (salary + companyEmployerEFKA + dividend).roundedTwoDecimals

        return [
            EmploymentComparison(typeLabel: "Μπλοκάκι", grossIncome: annual.roundedTwoDecimals,
                                employerCost: annual.roundedTwoDecimals,
                                employeeEFKA: blockakiEFKA,
                                incomeTax: (blockakiTax.totalTax + blockakiTax.solidarityContribution + EFKARates.annualBusinessTax).roundedTwoDecimals,
                                netIncome: max(blockakiNet, 0).roundedTwoDecimals,
                                netPct: annual > 0 ? "\((max(blockakiNet, 0) / annual * 100).roundedTwoDecimals.formatted(.number.precision(.fractionLength(1))))%" : "0%",
                                colorLabel: "accentPurple"),

            EmploymentComparison(typeLabel: "Employee", grossIncome: annual.roundedTwoDecimals,
                                employerCost: employerCost.roundedTwoDecimals,
                                employeeEFKA: employeeEFKA,
                                incomeTax: (employeeTax.totalTax + employeeTax.solidarityContribution).roundedTwoDecimals,
                                netIncome: max(employeeNet, 0).roundedTwoDecimals,
                                netPct: annual > 0 ? "\((max(employeeNet, 0) / annual * 100).roundedTwoDecimals.formatted(.number.precision(.fractionLength(1))))%" : "0%",
                                colorLabel: "accentTeal"),

            EmploymentComparison(typeLabel: "Company (ΙΚΕ)", grossIncome: annual.roundedTwoDecimals,
                                employerCost: totalCompanyCost.roundedTwoDecimals,
                                employeeEFKA: companySalaryEFKA,
                                incomeTax: (companySalaryTax.totalTax + companySalaryTax.solidarityContribution + dividendTax).roundedTwoDecimals,
                                netIncome: max(companyNet, 0).roundedTwoDecimals,
                                netPct: annual > 0 ? "\((max(companyNet, 0) / annual * 100).roundedTwoDecimals.formatted(.number.precision(.fractionLength(1))))%" : "0%",
                                colorLabel: "accentBlue"),
        ]
    }
}


