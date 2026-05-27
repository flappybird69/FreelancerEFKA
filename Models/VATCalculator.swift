import Foundation

// MARK: - VAT Calculation Result (Detailed)
struct VATCalculationResult: Identifiable {
    let id = UUID()
    let netMonthlyIncome: Decimal
    let annualNetIncome: Decimal

    // VAT rates
    let selectedVatRate: Decimal
    let vatChargedMonthly: Decimal
    let vatDeductibleMonthly: Decimal
    let vatPayableMonthly: Decimal

    // Gross amounts
    let grossMonthlyIncome: Decimal
    let grossAnnualIncome: Decimal

    // Exemption
    let isExempt: Bool
    let exemptionThreshold: Decimal

    // Quarterly VAT return estimate
    let quarterlyVATDue: Decimal

    // Annual VAT liability
    let annualVATDue: Decimal

    // Island discounts (if applicable)
    let islandDiscountRate: Decimal
    let adjustedVATRate: Decimal

    // Income tax estimation
    let estimatedAnnualIncomeTax: Decimal
    let estimatedMonthlyIncomeTax: Decimal

    // Business tax
    let annualBusinessTax: Decimal

    // Total monthly burden
    var totalMonthlyObligations: Decimal {
        vatPayableMonthly + estimatedMonthlyIncomeTax + (annualBusinessTax / 12)
    }

    var netAnnualAfterAll: Decimal {
        grossAnnualIncome - (annualVATDue + estimatedAnnualIncomeTax + annualBusinessTax)
    }
}

// MARK: - VAT Rates & Categories (Official AADE 2024–2025)
enum VATRates {
    /// Standard rate 24% (most goods and services)
    static let standard: Decimal = 0.24

    /// Reduced rate 13% (food, energy, hotels, water, etc.)
    static let reduced: Decimal = 0.13

    /// Super-reduced rate 6% (pharmaceuticals, newspapers, theatre tickets)
    static let superReduced: Decimal = 0.06

    /// Exemption threshold for small businesses (απαλλαγή ΦΠΑ)
    static let exemptionThresholdAnnual: Decimal = 10_000

    static let allRates: [(label: String, rate: Decimal, description: String)] = [
        ("Standard 24%", 0.24, "Most goods, services, electronics, vehicles, alcohol, tobacco, restaurants, bars, professional services, telecommunication, energy products"),
        ("Reduced 13%", 0.13, "Foodstuffs, water, pharmaceuticals, medical equipment, hotel accommodation, agricultural inputs, energy (natural gas, electricity, district heating), social services, cultural services (theatre/concert tickets)"),
        ("Super reduced 6%", 0.06, "Selected pharmaceuticals, newspapers, periodicals, theatre and concert tickets, certain medical devices"),
        ("Exempt 0%", 0.0, "Insurance, education, healthcare, postal services, financial services, real estate rental (residential)"),
    ]

    /// Island discount rate (30% reduction for specific Aegean islands)
    static let islandDiscountRate: Decimal = 0.30

    /// Islands where reduced rates apply (Law 4229/2014): Leros, Lesbos, Kos, Samos, Chios
    static let discountedIslands: Set<String> = ["Leros", "Lesbos", "Kos", "Samos", "Chios"]

    static func adjustedRate(base: Decimal, islandDiscount: Bool) -> Decimal {
        guard islandDiscount else { return base }
        return (base * (1 - islandDiscountRate)).roundedTwoDecimals
    }
}

// MARK: - VAT Category Classification
enum VATCategory: String, CaseIterable, Identifiable {
    case general = "General (24%)"
    case foodNEmergy = "Food & Energy (13%)"
    case pharmaceutical = "Pharmaceutical (6%)"
    case exempt = "Exempt (0%)"

    var id: String { rawValue }

    var rate: Decimal {
        switch self {
        case .general: return VATRates.standard
        case .foodNEmergy: return VATRates.reduced
        case .pharmaceutical: return VATRates.superReduced
        case .exempt: return 0
        }
    }

    var description: String {
        switch self {
        case .general:
            return "Professional services (μπλοκάκι), electronics, vehicles, alcohol, tobacco, restaurants, bars, telecommunications, clothing, furniture, household appliances, motor vehicles, domestic/international passenger transport, immovable property (new buildings)"
        case .foodNEmergy:
            return "Basic foodstuffs, natural gas, electricity, district heating, water supplies, hotel accommodation, agricultural inputs, medical equipment for disabled, children's car seats, books, newspapers, periodicals, cable TV, social housing, renovation/repair of dwellings, restaurant and catering services, use of sporting facilities"
        case .pharmaceutical:
            return "Selected pharmaceutical products, newspapers, periodicals, theatre and concert tickets, certain medical devices, admission to cultural services"
        case .exempt:
            return "Insurance transactions, education, healthcare services, postal services, financial services, real estate rental (residential), supply of goods/services where the supplier is not established in Greece"
        }
    }
}

// MARK: - VAT Filing Rules
enum VATFilingFrequency {
    case quarterly   // Single-entry books (απλογραφικά), turnover < €1,500,000
    case monthly     // Double-entry books (διπλογραφικά), turnover ≥ €1,500,000

    var periodsPerYear: Int {
        switch self {
        case .quarterly: return 4
        case .monthly: return 12
        }
    }
}

// MARK: - VAT Calculator Engine
enum VATCalculator {

    // MARK: - Core Calculation
    static func calculate(
        netMonthlyIncome: Decimal,
        monthlyDeductibleExpenses: Decimal,
        vatRate: Decimal = VATRates.standard,
        annualProjectedIncome: Decimal,
        islandDiscount: Bool = false,
        filingFrequency: VATFilingFrequency = .quarterly
    ) -> VATCalculationResult {

        let annualNetIncome = (netMonthlyIncome * 12).roundedTwoDecimals
        let isExempt = annualProjectedIncome < VATRates.exemptionThresholdAnnual

        let effectiveRate = VATRates.adjustedRate(base: vatRate, islandDiscount: islandDiscount)
        let islandDiscountRateApplied = islandDiscount ? VATRates.islandDiscountRate : 0

        // VAT charged on sales
        let vatChargedMonthly = isExempt ? 0 : (netMonthlyIncome * effectiveRate).roundedTwoDecimals

        // VAT deductible on expenses (business costs with VAT)
        let vatDeductibleMonthly = isExempt ? 0 : (monthlyDeductibleExpenses * effectiveRate).roundedTwoDecimals

        // Net VAT payable
        let vatPayableMonthly = max((vatChargedMonthly - vatDeductibleMonthly), 0).roundedTwoDecimals

        // Gross income (charged to client)
        let grossMonthly = (netMonthlyIncome + vatChargedMonthly).roundedTwoDecimals
        let grossAnnual = (grossMonthly * 12).roundedTwoDecimals

        // Quarterly VAT estimate
        let quarterlyVATDue = (vatPayableMonthly * 3).roundedTwoDecimals

        // Annual VAT
        let annualVAT = (vatPayableMonthly * 12).roundedTwoDecimals

        // Estimate income tax (after deducting EFKA and expenses)
        let efkaAnnual = netMonthlyIncome * 12 * EFKARates.baseTotalRate // rough estimate
        let deductibleExpensesAnnual = monthlyDeductibleExpenses * 12
        let taxableIncome = max(annualProjectedIncome - efkaAnnual - deductibleExpensesAnnual, 0)
        let estimatedAnnualTax = EFKARates.calculateIncomeTax(annualIncome: taxableIncome)
        let estimatedMonthlyTax = (estimatedAnnualTax / 12).roundedTwoDecimals

        // Business tax (always applies for freelancers)
        let annualBusinessTax = EFKARates.annualBusinessTax

        return VATCalculationResult(
            netMonthlyIncome: netMonthlyIncome.roundedTwoDecimals,
            annualNetIncome: annualNetIncome,
            selectedVatRate: vatRate,
            vatChargedMonthly: vatChargedMonthly,
            vatDeductibleMonthly: vatDeductibleMonthly,
            vatPayableMonthly: vatPayableMonthly,
            grossMonthlyIncome: grossMonthly,
            grossAnnualIncome: grossAnnual,
            isExempt: isExempt,
            exemptionThreshold: VATRates.exemptionThresholdAnnual,
            quarterlyVATDue: quarterlyVATDue,
            annualVATDue: annualVAT,
            islandDiscountRate: islandDiscountRateApplied,
            adjustedVATRate: effectiveRate,
            estimatedAnnualIncomeTax: estimatedAnnualTax,
            estimatedMonthlyIncomeTax: estimatedMonthlyTax,
            annualBusinessTax: annualBusinessTax
        )
    }

    // MARK: - Convenience: Quarterly vs Monthly obligation
    static func suggestedFilingFrequency(for annualTurnover: Decimal) -> VATFilingFrequency {
        annualTurnover < 1_500_000 ? .quarterly : .monthly
    }

    static func vatReturnDueDates(for frequency: VATFilingFrequency) -> String {
        switch frequency {
        case .quarterly:
            return """
            Q1 (Jan–Mar): due by April 30
            Q2 (Apr–Jun): due by July 31
            Q3 (Jul–Sep): due by October 31
            Q4 (Oct–Dec): due by January 31
            """
        case .monthly:
            return "Due by the 20th day of the following month (e.g., January return due February 20)"
        }
    }
}
