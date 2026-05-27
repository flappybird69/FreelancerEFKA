import Foundation

// MARK: - Cost Item
struct CostItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let amount: String
    let percentage: String?
    let notes: String
}

// MARK: - Property Purchase Step
struct PropertyPurchaseStep: Identifiable, Hashable {
    let id = UUID()
    let stepNumber: Int
    let title: String
    let titleGreek: String
    let summary: String
    let detailedDescription: String
    let professionalsRequired: [String]
    let costItems: [CostItem]
    let estimatedDuration: String
    let iconName: String
    let checklist: [String]
    let legalReferences: String?
    let isOptional: Bool
    let riskLevel: RiskLevel
    let tips: [String]

    var isCompleted: Bool = false
    var isExpanded: Bool = false

    // MARK: - Risk Level
    enum RiskLevel: String {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case critical = "Critical"

        var colorHex: String {
            switch self {
            case .low: return "33CC66"
            case .medium: return "FFAA00"
            case .high: return "FF6600"
            case .critical: return "FF3333"
            }
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: PropertyPurchaseStep, rhs: PropertyPurchaseStep) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Tax & Fee Reference
struct PropertyTaxReference: Identifiable {
    let id = UUID()
    let name: String
    let nameGreek: String
    let rate: String
    let appliesWhen: String
    let paidBy: String
    let notes: String
}

// MARK: - All Predefined Steps
extension PropertyPurchaseStep {
    static let allSteps: [PropertyPurchaseStep] = [
        step1,
        step2,
        step3,
        step4,
        step5,
        step6,
        step7,
        step8,
    ]

    static var taxReferences: [PropertyTaxReference] = [
        PropertyTaxReference(
            name: "Property Transfer Tax (ΦΜΑ)",
            nameGreek: "Φόρος Μεταβίβασης Ακινήτου",
            rate: "3% of the highest between purchase price and objective value",
            appliesWhen: "On all used property purchases",
            paidBy: "Buyer",
            notes: "Paid at the notary before deed signing (Law 1587/1950, amended). Exemptions for first-time home buyers may apply under certain conditions."
        ),
        PropertyTaxReference(
            name: "VAT on New Properties",
            nameGreek: "ΦΠΑ Νεόδμητων",
            rate: "24% of the property value",
            appliesWhen: "On first-time sale of new buildings (building permit after 01/01/2006)",
            paidBy: "Buyer",
            notes: "Instead of ΦΜΑ. Can be suspended temporarily by government decree for certain periods."
        ),
        PropertyTaxReference(
            name: "Notary Fee",
            nameGreek: "Αμοιβή Συμβολαιογράφου",
            rate: "1–2% of property value (sliding scale)",
            appliesWhen: "On every transfer",
            paidBy: "Buyer (by law split 50-50 but practice varies)",
            notes: "Fee set by law (Ν. 2830/2000). The notary is responsible for drafting the deed, collecting taxes, and ensuring legal compliance."
        ),
        PropertyTaxReference(
            name: "Lawyer Fee",
            nameGreek: "Αμοιβή Δικηγόρου",
            rate: "1–2% of property value + 24% VAT",
            appliesWhen: "On engagement for due diligence and deed review",
            paidBy: "Buyer",
            notes: "Strongly recommended. The lawyer performs all due diligence, checks the title, and verifies the property is free of encumbrances."
        ),
        PropertyTaxReference(
            name: "Land Registry / Cadastre Registration",
            nameGreek: "Εγγραφή στο Κτηματολόγιο/Υποθηκοφυλακείο",
            rate: "0.5–0.6% of the purchase price",
            appliesWhen: "After deed signing, mandatory for ownership transfer",
            paidBy: "Buyer",
            notes: "The deed must be registered at the Cadastre (Κτηματολόγιο) or Land Registry (Υποθηκοφυλακείο) within 30 days. This is the final step to perfect ownership."
        ),
        PropertyTaxReference(
            name: "ENFIA (Annual Property Tax)",
            nameGreek: "Ενιαίος Φόρος Ιδιοκτησίας Ακινήτων",
            rate: "0.1–1.15% of objective value",
            appliesWhen: "Annually after purchase",
            paidBy: "Owner",
            notes: "Main tax: based on zone price, size, age, floor. Additional tax: 0.15–1.15% for total taxable value > €250,000. Paid in monthly installments through tax return."
        ),
        PropertyTaxReference(
            name: "Stamp Duty (Χαρτόσημο)",
            nameGreek: "Χαρτόσημο",
            rate: "3.6% on the purchase price (1.2% stamp + 2.4% OGA)",
            appliesWhen: "On loans, mortgages, and certain transfers",
            paidBy: "Varies",
            notes: "Reduced or eliminated in many cases. Apply to your lawyer for the specific situation."
        ),
        PropertyTaxReference(
            name: "Municipal Tax (Δημοτικός Φόρος/ΤΑΠ)",
            nameGreek: "Τέλος Ακίνητης Περιουσίας (ΤΑΠ)",
            rate: "0.025–0.035% of the property value (varies by municipality)",
            appliesWhen: "Annually, included in electricity bill",
            paidBy: "Owner",
            notes: "Collected through the DEH (Public Power Corporation) bill. Rate set by each municipality."
        ),
        PropertyTaxReference(
            name: "Capital Gains Tax",
            nameGreek: "Φόρος Υπεραξίας",
            rate: "15% on profit from sale",
            appliesWhen: "On future resale of the property (if sold within 5 years of purchase)",
            paidBy: "Seller",
            notes: "Introduced in 2014. Only applies if the property is sold within 5 years of acquisition. Calculated on the difference between sale price and purchase price (adjusted for inflation)."
        ),
    ]

    // MARK: - Step Definitions

    private static let step1 = PropertyPurchaseStep(
        stepNumber: 1,
        title: "Property Search & Identification",
        titleGreek: "Αναζήτηση & Εντοπισμός Ακινήτου",
        summary: "Identify prospective properties through agencies, online portals, and personal networks. Verify basic legal status before proceeding.",
        detailedDescription: """
        The first step is to identify suitable properties through real estate agencies (μεσιτικά γραφεία), online platforms like Spitogatos.gr, XE.gr, and local classifieds. During this phase, you should also perform a preliminary check on the property's legal status:
        • Verify the property has a valid building permit (οικοδομική άδεια)
        • Check if the property is listed as "εντός σχεδίου" (within town plan) or "εκτός σχεδίου" (outside town plan)
        • Request the Energy Performance Certificate (ΠΕΑ)
        • Confirm the property's objective value (αντικειμενική αξία) via the AADE system
        • Check if there are any outstanding debts (e.g., ENFIA, utility bills) attached to the property
        """,
        professionalsRequired: ["Real Estate Agent (optional)", "Lawyer (recommended for preliminary check)"],
        costItems: [
            CostItem(name: "Real Estate Agency Fee", amount: "€0–€5,000+", percentage: "0–2% of property value", notes: "Negotiable. Some agencies charge the seller only, others split with buyer."),
            CostItem(name: "Property Valuation (optional)", amount: "€200–€500", percentage: nil, notes: "Independent valuation by certified engineer or surveyor."),
            CostItem(name: "Preliminary Legal Check", amount: "€100–€300", percentage: nil, notes: "Quick check by lawyer for existing encumbrances and legal status."),
        ],
        estimatedDuration: "1–6 months (average 2–3 months)",
        iconName: "house.lodge",
        checklist: [
            "Define budget, location preferences, and property type",
            "Search online platforms and contact agencies",
            "Visit shortlisted properties in person",
            "Request and review the Energy Performance Certificate (ΠΕΑ)",
            "Verify building permit exists and matches the property",
            "Check the property's objective value on the AADE system",
            "Perform preliminary legal check with lawyer",
            "Negotiate price and terms with the seller",
        ],
        legalReferences: "Law 3741/1929 (horizontal ownership), Law 4067/2012 (building code), Ministerial Decision for Energy Performance Certificates",
        isOptional: false,
        riskLevel: .low,
        tips: [
            "Always visit the property in person—photos can be misleading",
            "Check the neighborhood at different times of day",
            "Ask the agency for the 'Φάκελος Ακινήτου' (property dossier)",
            "If buying off-plan, require the developer's building permit and insurance",
            "In popular areas (islands, city centers), act quickly—good properties sell in days"
        ]
    )

    private static let step2 = PropertyPurchaseStep(
        stepNumber: 2,
        title: "Engage a Lawyer — Full Due Diligence",
        titleGreek: "Πρόσληψη Δικηγόρου — Νομικός Έλεγχος",
        summary: "Hire a Greek lawyer to perform comprehensive due diligence: title search, encumbrance check, and verification of all legal documents.",
        detailedDescription: """
        A Greek lawyer is mandatory for the property purchase process. They will perform full due diligence (δέουσα επιμέλεια) on the property, which includes:
        • Title Search: Verify the seller's ownership title (τίτλος ιδιοκτησίας) chain
        • Encumbrance Certificate: Search at the Land Registry/Cadastre for mortgages, liens, lawsuits, prenotations (προσημειώσεις), or any third-party claims
        • Tax Certificate: Obtain the seller's tax clearance certificate from AADE
        • ENFIA Certificate: Confirm no outstanding property tax
        • Building Permit: Verify the property was built legally and matches the permit
        • Zoning Check: Confirm the property is in an area where residential use is permitted
        • Review Preliminary Agreement: Draft and review the προσύμφωνο
        """,
        professionalsRequired: ["Lawyer (Δικηγόρος) — MUST be registered with the Athens/Regional Bar Association"],
        costItems: [
            CostItem(name: "Lawyer Fee (due diligence + deed review)", amount: "€1,000–€3,000+", percentage: "1–2% of property value + 24% VAT", notes: "Fee is negotiable. Typically charged as a percentage of the property value."),
            CostItem(name: "Title Search (Υποθηκοφυλακείο)", amount: "€50–€150", percentage: nil, notes: "Fee paid to the Land Registry for the title search certificate."),
            CostItem(name: "Cadastre Certificate", amount: "€20–€50", percentage: nil, notes: "Certificate from the Hellenic Cadastre (Κτηματολόγιο) confirming registered ownership."),
            CostItem(name: "Tax Clearance Certificate", amount: "€10–€20", percentage: nil, notes: "Obtained from the AADE website (taxpayer must authorize the lawyer)."),
            CostItem(name: "Energy Performance Certificate", amount: "€100–€300", percentage: nil, notes: "Required for any sale. Must be less than 10 years old. Issued by a certified engineer."),
        ],
        estimatedDuration: "2–4 weeks",
        iconName: "person.fill.viewfinder",
        checklist: [
            "Hire a lawyer specialized in real estate law",
            "Lawyer performs title search at the Land Registry/Cadastre",
            "Verify the property is free of mortgages, liens, or lawsuits",
            "Obtain tax clearance certificate from AADE (seller's compliance)",
            "Obtain ENFIA clearance certificate (no outstanding property tax)",
            "Verify the building permit and completion certificate",
            "Check zoning and land use regulations",
            "Review the property's horizontal ownership agreement (κανονισμός πολυκατοικίας) if apartment",
            "Request and review the energy performance certificate (ΠΕΑ)",
            "Confirm the property's objective value for tax calculation",
        ],
        legalReferences: "Law 2830/2000 (Lawyer's Code), Law 2664/1998 (National Cadastre), Law 1587/1950 (Property Transfer), Civil Procedure Code",
        isOptional: false,
        riskLevel: .critical,
        tips: [
            "Do NOT skip this step—Greece has a complex property registry system with many unregistered properties",
            "Choose a lawyer who speaks your language if you are not Greek",
            "Ask the lawyer to check for 'αγροτεμάχια' (agricultural plots) if the property has land",
            "In areas with pending cadastre registration (υπό κτηματογράφηση), extra caution is needed",
            "Request a written legal opinion (νομική γνώμη) summarizing the due diligence findings"
        ]
    )

    private static let step3 = PropertyPurchaseStep(
        stepNumber: 3,
        title: "Collect Tax & Administrative Certificates",
        titleGreek: "Συλλογή Φορολογικών & Διοικητικών Πιστοποιητικών",
        summary: "Gather all necessary certificates from AADE, the Land Registry, and the municipality required for the transfer.",
        detailedDescription: """
        Before proceeding to the notary, all required certificates must be collected:
        • Tax Clearance Certificate (Αποδεικτικό Ενημερότητας): Proves the seller has paid all taxes
        • ENFIA Clearance Certificate: Confirms no outstanding property tax (Law 4223/2013)
        • Property Certificate (Πιστοποιητικό Ιδιοκτησίας): From the Cadastre or Land Registry
        • Certificate of Non-Encumbrance (Πιστοποιητικό Βαρών): Shows no mortgages/liens
        • Building Permit and Completion Certificate: (Οικοδομική Άδεια + Άδεια Νομιμοποίησης)
        • Energy Performance Certificate (Πιστοποιητικό Ενεργειακής Απόδοσης)
        • Topographical Survey (Τοπογραφικό Διάγραμμα): Required for land plots
        • Floor Plan (Κάτοψη Διαμερίσματος): For apartments
        • Common Charges Certificate: From the building management confirming no outstanding fees
        """,
        professionalsRequired: ["Lawyer (coordinates document collection)", "Accountant (Λογιστής) for tax certificates"],
        costItems: [
            CostItem(name: "Tax Clearance Certificate", amount: "€10", percentage: nil, notes: "Online issuance via AADE, free or nominal fee"),
            CostItem(name: "ENFIA Clearance Certificate", amount: "€10", percentage: nil, notes: "Issued online via AADE"),
            CostItem(name: "Cadastre Certificate", amount: "€20–€50", percentage: nil, notes: "Varies by region"),
            CostItem(name: "Energy Performance Certificate", amount: "€150–€300", percentage: nil, notes: "Valid for 10 years. Certified engineer required."),
            CostItem(name: "Topographical Survey (if needed)", amount: "€300–€1,000", percentage: nil, notes: "For land plots or properties outside town plan"),
        ],
        estimatedDuration: "2–4 weeks (can overlap with Step 2)",
        iconName: "doc.text.magnifyingglass",
        checklist: [
            "Tax clearance certificate (Αποδεικτικό Φορολογικής Ενημερότητας)",
            "ENFIA clearance (Πιστοποιητικό Εξόφλησης ΕΝΦΙΑ)",
            "Cadastre property certificate (Πιστοποιητικό Κτηματολογίου)",
            "Non-encumbrance certificate (Πιστοποιητικό Βαρών/Κατασχέσεων)",
            "Building permit and planning compliance certificate",
            "Energy Performance Certificate (ΠΕΑ)",
            "Topographical diagram (for land plots)",
            "Floor plan (for apartments)",
            "Building regulation compliance certificate",
            "Common area charges clearance from building manager",
        ],
        legalReferences: "Law 4223/2013 (ENFIA), Law 2664/1998 (Cadastre), KENAK (Energy Performance Regulations)",
        isOptional: false,
        riskLevel: .medium,
        tips: [
            "Many certificates can be obtained electronically from gov.gr",
            "Start collecting documents early—the ENFIA certificate can take time if the seller has outstanding debt",
            "The Energy Performance Certificate must be less than 10 years old",
            "If the property is in an area under cadastre registration (υπό κτηματογράφηση), the process is different"
        ]
    )

    private static let step4 = PropertyPurchaseStep(
        stepNumber: 4,
        title: "Sign Preliminary Agreement (Προσύμφωνο)",
        titleGreek: "Υπογραφή Προσυμφώνου",
        summary: "Sign a preliminary sales agreement with the seller, securing the property and establishing the terms. A deposit of 10–30% is paid.",
        detailedDescription: """
        The preliminary agreement (Προσύμφωνο or Σύμφωνο Προκαταβολής) is a legally binding contract that sets out:
        • The final purchase price and payment schedule
        • The deposit amount (usually 10–30% of the purchase price)
        • The timeline for signing the final deed (usually 1–3 months)
        • Penalty clauses: If the buyer backs out without justification, they lose the deposit
        • If the seller backs out, they must return double the deposit
        • Special conditions (e.g., subject to mortgage approval, subject to due diligence)
        • The property description, location, and unique identifiers

        The deposit is typically paid via:
        • Bank cheque (τραπεζική επιταγή)
        • Wire transfer (τραπεζικό έμβασμα)
        • Certified banker's draft
        """,
        professionalsRequired: ["Lawyer (mandatory — drafts/reviews agreement)", "Notary (optional at this stage)"],
        costItems: [
            CostItem(name: "Deposit (Προκαταβολή)", amount: "€10,000–€100,000+", percentage: "10–30% of purchase price", notes: "Held by seller or escrow. Risk of loss if buyer backs out."),
            CostItem(name: "Preliminary Agreement Legal Fee", amount: "€200–€500", percentage: nil, notes: "Lawyer fee for drafting/reviewing the προσύμφωνο"),
            CostItem(name: "Stamp Duty on Προσύμφωνο", amount: "€50–€200", percentage: "1–2% on deposit amount (varies)", notes: "Minor stamp duty may apply"),
        ],
        estimatedDuration: "1 day for signing; 1–2 weeks for legal preparation",
        iconName: "signature",
        checklist: [
            "Lawyer confirms all due diligence is satisfactory",
            "Finalize the purchase price and payment schedule",
            "Agree on the deposit amount (10–30%)",
            "Set the timeline for final deed signing",
            "Include penalty clauses (buyer loses deposit, seller returns double)",
            "Specify any conditions precedent (mortgage approval, permits, etc.)",
            "Sign the agreement in presence of lawyer",
            "Pay the deposit (preferably by bank cheque or wire transfer)",
            "Obtain a signed copy of the agreement with date and signatures",
            "File the agreement with the tax office (if required by law)",
        ],
        legalReferences: "Civil Code Articles 158–163, Law 4332/2015, Presidential Decree 34/1995",
        isOptional: false,
        riskLevel: .high,
        tips: [
            "Never sign the προσύμφωνο before the lawyer completes due diligence",
            "Always use bank instruments for the deposit—never cash",
            "Ensure the seller provides proof of identity and title ownership at signing",
            "The προσύμφωνο must clearly state the agreed price to avoid disputes at the notary",
            "If the property has tenants, include a clause about vacant possession by the date of the final deed"
        ]
    )

    private static let step5 = PropertyPurchaseStep(
        stepNumber: 5,
        title: "Arrange Financing & Secure Funds",
        titleGreek: "Τακτοποίηση Χρηματοδότησης",
        summary: "Secure your mortgage (if applicable) or prepare proof of funds. The bank will require their own property appraisal and legal due diligence.",
        detailedDescription: """
        If purchasing with a mortgage (στεγαστικό δάνειο), the bank's process runs in parallel:
        • Submit mortgage application with income documentation (tax returns, payslips, bank statements)
        • Bank's appraisal: The bank orders an independent valuation by certified appraiser
        • Bank's legal review: The bank's legal team performs their own due diligence (καθαρογράφημα)
        • Mortgage offer: Valid for 2–3 months, specifying the loan amount, interest rate, and terms
        • Disbursement: Funds are paid directly to the notary/seller at the deed signing

        If paying in cash:
        • Prepare proof of funds (bank statements, savings account)
        • Ensure funds are in a Greek bank account or can be transferred easily
        • Declaration of source of funds may be required under anti-money laundering regulations
        """,
        professionalsRequired: ["Bank / Mortgage Consultant", "Accountant (for financial documentation)"],
        costItems: [
            CostItem(name: "Bank Property Appraisal", amount: "€200–€500", percentage: nil, notes: "Ordered by the bank, paid by the borrower"),
            CostItem(name: "Bank's Legal Due Diligence", amount: "€300–€600", percentage: nil, notes: "Bank's lawyer reviews the property title"),
            CostItem(name: "Mortgage Arrangement Fee", amount: "€0–€1,000", percentage: "0–1% of loan amount", notes: "Varies by bank. Some banks charge zero arrangement fees."),
            CostItem(name: "Mortgage Stamp Duty", amount: "€200–€1,500", percentage: "1.2% of mortgage amount", notes: "Stamp duty on the mortgage deed (if applicable)"),
        ],
        estimatedDuration: "2–8 weeks (average 4 weeks for mortgage approval)",
        iconName: "banknote",
        checklist: [
            "Prepare financial documents (tax returns, payslips, bank statements)",
            "Submit mortgage application to 2–3 banks for comparison",
            "Compare interest rates, fees, and terms",
            "Bank orders independent property appraisal",
            "Bank's legal team performs their own due diligence",
            "Receive mortgage offer letter and review terms",
            "Accept the mortgage offer within the validity period",
            "Prepare proof of funds for the down payment and closing costs",
            "Ensure funds are in a Greek bank account (if required)",
            "If paying cash, prepare source of funds declaration",
        ],
        legalReferences: "Law 2251/1994 (Consumer Protection), Bank of Greece Governor's Acts (credit institutions), Anti-Money Laundering Law 4557/2018",
        isOptional: true,
        riskLevel: .medium,
        tips: [
            "Get pre-approved before you start property searching",
            "Compare offers from at least 3 banks—rates and fees vary significantly",
            "The bank's legal fee is separate from your lawyer's fee—both are needed",
            "Fixed vs variable rate: consider your risk tolerance and the current interest rate environment",
            "Non-residents may face additional requirements (higher down payment, additional documentation)",
            "Many Greek banks offer 'digital' mortgage applications now"
        ]
    )

    private static let step6 = PropertyPurchaseStep(
        stepNumber: 6,
        title: "Prepare Final Deed — Tax & Fee Calculation",
        titleGreek: "Προετοιμασία Συμβολαίου — Υπολογισμός Φόρων & Τελών",
        summary: "The notary drafts the final deed (συμβόλαιο) and calculates all taxes, fees, and amounts due before the signing date.",
        detailedDescription: """
        The notary (συμβολαιογράφος) is responsible for:
        • Drafting the Final Deed of Transfer (Συμβόλαιο Μεταβίβασης Ακινήτου)
        • Calculating all taxes:
          - Property Transfer Tax (ΦΜΑ): 3% of the highest between objective value and purchase price
          - OR VAT: 24% for new properties (first-time sale)
          - Municipality Tax (Δημοτικός Φόρος): typically 0.6–0.8% of the objective value
          - TAP (Τέλος Ακίνητης Περιουσίας): varies by municipality
        • Verifying all certificates are valid and current
        • Collecting identity documents from both parties (passport, Greek AFN required)
        • Arranging payment of taxes before the signing date

        The taxes must be paid at least 1–2 business days before the signing date through the notary's designated bank account.
        """,
        professionalsRequired: ["Notary Public (Συμβολαιογράφος)", "Lawyer (review deed before signing)", "Accountant (confirm tax calculations)"],
        costItems: [
            CostItem(name: "Property Transfer Tax (ΦΜΑ)", amount: "€3,000–€15,000+", percentage: "3% of property value", notes: "Largest single cost. Pay before deed signing."),
            CostItem(name: "Notary Fee", amount: "€2,000–€6,000+", percentage: "1–2% of property value + VAT", notes: "Set by law (Ν. 2830/2000). Increases with property value."),
            CostItem(name: "Municipality Tax (Δημοτικός Φόρος)", amount: "€200–€1,000", percentage: "0.6–0.8% of objective value", notes: "Paid to the municipality where the property is located."),
            CostItem(name: "Lawyer Fee for Deed Review", amount: "€500–€1,000", percentage: "Included in overall lawyer fee (Step 2)", notes: "Lawyer reviews the notary's draft deed"),
            CostItem(name: "TAP (Τέλος Ακίνητης Περιουσίας)", amount: "€100–€500", percentage: "0.025–0.035%/yr (first year)", notes: "Pro-rated first year, collected by notary"),
        ],
        estimatedDuration: "2–3 weeks for deed preparation",
        iconName: "doc.badge.plus",
        checklist: [
            "Notary requests all certificates and documents from lawyer",
            "Notary drafts the final deed (Συμβόλαιο Μεταβίβασης)",
            "Lawyer reviews the drafted deed",
            "Calculate all taxes: ΦΜΑ (3%) or VAT (24%), municipal fees",
            "Notary confirms the tax amounts and provides payment instructions",
            "Pay all taxes 2–3 business days before the signing date",
            "Confirm the seller's tax clearance is still valid",
            "Arrange payment of the remaining balance (purchase price minus deposit)",
            "Prepare identification documents (passport, AFN, marriage certificates if applicable)",
            "Schedule the signing appointment at the notary's office",
        ],
        legalReferences: "Law 1587/1950 (Property Transfer Tax), Law 4223/2013 (ENFIA), Law 2830/2000 (Notary Code), Civil Code Articles 1033–1043",
        isOptional: false,
        riskLevel: .high,
        tips: [
            "The notary is a public official—they represent the state, not you or the seller",
            "Taxes must be paid BEFORE the signing date—not at signing",
            "The ΦΜΑ is 3% of the HIGHER of: purchase price or objective value—choose the price structure carefully",
            "For new properties, decide whether ΦΜΑ (3%) or VAT (24%) applies based on the building permit date",
            "If your lawyer does not speak Greek fluently, ensure the notary drafts the deed in simple language"
        ]
    )

    private static let step7 = PropertyPurchaseStep(
        stepNumber: 7,
        title: "Sign Final Deed at Notary",
        titleGreek: "Υπογραφή Οριστικού Συμβολαίου",
        summary: "Both parties appear before the notary to sign the final deed. Ownership is transferred, and the remaining balance is paid.",
        detailedDescription: """
        The final deed signing (Υπογραφή Συμβολαίου) is the culmination of the entire process:
        • Both parties must appear in person before the notary (Συμβολαιογράφος)
        • Valid identification required: Greek police ID (ταυτότητα) or passport; AFN (ΑΦΜ) for both parties
        • Foreign buyers: must have a Greek Tax Identification Number (ΑΦΜ) and a Greek lawyer's representation certificate
        • The notary reads the deed aloud in Greek
        • Both parties sign the deed (and initial each page)
        • The remaining balance is paid: bank cheque (τραπεζική επιταγή) or wire transfer preferred
        • The notary issues a receipt for all taxes collected
        • Keys are handed over to the buyer

        The notary is responsible for forwarding the collected taxes to the tax authorities within the legal deadline.
        """,
        professionalsRequired: ["Notary Public", "Lawyer (present at signing)", "Both parties (buyer and seller)", "Interpreter (if needed, certified)"],
        costItems: [
            CostItem(name: "Remaining Balance Payment", amount: "€70,000–€450,000+", percentage: "70–90% of purchase price (after deposit)", notes: "Largest payment. Use bank cheque or wire."),
            CostItem(name: "Interpreter (if needed)", amount: "€50–€150/hr", percentage: nil, notes: "Certified interpreter required if foreign buyer does not speak Greek"),
            CostItem(name: "Notary Signing Fee", amount: "Included in notary fee (Step 6)", percentage: nil, notes: "Part of the overall notary fee"),
        ],
        estimatedDuration: "1 day (signing takes 1–2 hours)",
        iconName: "pencil.and.outline",
        checklist: [
            "Confirm all taxes have been paid (receipts from bank)",
            "Lawyer confirms the final deed matches the agreed terms",
            "Bring valid identification: passport/ID card for both parties",
            "Foreign buyers must have Greek ΑΦΜ (Tax Registration Number)",
            "Bring the signed preliminary agreement (προσύμφωνο)",
            "Prepare the remaining balance as a bank cheque or wire transfer",
            "Notary reads the deed aloud",
            "Both parties sign each page of the deed",
            "Receive the original notarial deed (συμβόλαιο)",
            "Seller hands over keys and any relevant documents (guarantees, manuals, etc.)",
            "Sign utility transfer forms (water, electricity, if applicable)",
        ],
        legalReferences: "Civil Code Articles 1033–1043 (Transfer of Ownership), Law 2830/2000 (Notary Code), Presidential Decree 342/1972, Anti-Money Laundering Law 4557/2018",
        isOptional: false,
        riskLevel: .high,
        tips: [
            "Arrive early—the notary will check all documents one last time",
            "Bring a certified translator if you don't understand Greek—never sign a document you don't understand",
            "The notary will keep the original deed and provide certified copies",
            "Request 3–5 certified copies of the deed (you will need them for the Land Registry, bank, and personal records)",
            "Make sure the seller provides a utility bill showing their name to confirm identity",
            "After signing, celebrate—but remember Step 8 (registration) is still pending"
        ]
    )

    private static let step8 = PropertyPurchaseStep(
        stepNumber: 8,
        title: "Register Deed at the Cadastre / Land Registry",
        titleGreek: "Εγγραφή Συμβολαίου στο Κτηματολόγιο/Υποθηκοφυλακείο",
        summary: "The deed must be registered with the Hellenic Cadastre (Κτηματολόγιο) or Land Registry to perfect your ownership rights.",
        detailedDescription: """
        This is the FINAL and ESSENTIAL step to complete the ownership transfer:
        • The notarised deed (συμβόλαιο) must be submitted to the Cadastre (Κτηματολόγιο) within 30 days of signing
        • In areas where the Cadastre is not yet operational, registration is at the Land Registry (Υποθηκοφυλακείο)
        • Registration fee: approximately 0.5–0.6% of the purchase price
        • The Cadastre issues a certificate of registration (Πιστοποιητικό Εγγραφής)
        • This registration perfects the transfer—ownership is officially recorded in the state's registry
        • After registration, the property is legally yours against all third parties
        • The process can take 1–3 months for the Cadastre to process

        Important: Without this registration, the transfer is not effective against third parties. If the seller has debts after the sale, creditors could seize the property if it's still registered in the seller's name.
        """,
        professionalsRequired: ["Lawyer (submits the deed to Cadastre)", "Notary (provides the certified copy for registration)"],
        costItems: [
            CostItem(name: "Cadastre Registration Fee", amount: "€500–€3,000+", percentage: "0.5–0.6% of purchase price", notes: "Paid to the Hellenic Cadastre. Largest post-purchase cost."),
            CostItem(name: "Land Registry Fee (if applicable)", amount: "€200–€1,000", percentage: "0.3–0.5%", notes: "In areas not yet covered by the Cadastre"),
            CostItem(name: "Lawyer Fee for Registration", amount: "€200–€500", percentage: nil, notes: "Lawyer arranges the submission"),
            CostItem(name: "Certificate of Registration", amount: "€20–€50", percentage: nil, notes: "Fee for issuing the registration certificate"),
        ],
        estimatedDuration: "1–3 months for Cadastre processing; registration submission within 30 days of signing",
        iconName: "building.columns",
        checklist: [
            "Lawyer obtains a certified copy of the deed from the notary",
            "Lawyer submits the deed to the Cadastre (Κτηματολόγιο)",
            "Pay the registration fee (0.5–0.6% of purchase price)",
            "Receive the registration application number",
            "Wait for the Cadastre to process the registration (1–3 months)",
            "Receive the Certificate of Registration (Πιστοποιητικό Εγγραφής)",
            "Update the property's cadastral sheet (κτηματολογικό φύλλο)",
            "File a copy of the registered deed with your tax office (ΔΟΥ)",
            "Update the ENFIA registration for property tax purposes",
            "Transfer utility accounts (electricity, water) to your name",
        ],
        legalReferences: "Law 2664/1998 (National Cadastre), Law 2308/1995 (Cadastre Registration), Presidential Decree 34/1995 (Land Registry), Civil Code Articles 1192–1201",
        isOptional: false,
        riskLevel: .high,
        tips: [
            "This step is often delayed by buyers—do not postpone it. Unregistered transfers are vulnerable",
            "In areas with the Cadastre operating, registration is faster and more reliable",
            "Check if the property is in a 'υπο κτηματογράφηση' (under cadastral survey) area—the process differs",
            "Keep a copy of the registration application as proof until the certificate arrives",
            "The registration fee is calculated on the purchase price declared in the deed",
            "After registration, update your will and estate planning documents to reflect the new property"
        ]
    )
}
