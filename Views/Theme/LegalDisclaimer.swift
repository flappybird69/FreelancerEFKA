import SwiftUI

// MARK: - Last Updated Badge
struct LastUpdatedBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.caption2)
            Text("Rates as of January 2025")
                .font(.caption2)
        }
        .foregroundColor(.secondary)
    }
}

// MARK: - Legal Disclaimer
struct LegalDisclaimer: View {
    let text: String
    var icon: String = "info.circle"

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top, 1)
            Text(text)
                .font(.caption2)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Source Citation
struct SourceCitation: View {
    let label: String
    let reference: String

    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
            Text(reference)
                .font(.caption2.weight(.medium))
                .foregroundColor(.accentPurple)
            Spacer()
        }
    }
}

// MARK: - Fine Print Sections
struct TekmartroDisclaimer: View {
    var body: some View {
        LegalDisclaimer(
            text: "The τεκμαρτό εισόδημα (deemed minimum income) rules may apply. Self-employed with declared income below the deemed minimum (calculated from housing, vehicles, etc.) may be taxed on the higher deemed amount per Ν. 4172/2013, Άρθρο 30.",
            icon: "exclamationmark.triangle"
        )
    }
}

struct ProfessionalDiscountDisclaimer: View {
    var body: some View {
        LegalDisclaimer(
            text: "A 20% discount on social security contributions applies for certain professions (doctors, pharmacists, engineers, lawyers, economists) during their first 3–5 years of activity, subject to income caps per Ν. 4670/2020, Άρθρο 39.",
            icon: "percent"
        )
    }
}

struct Law5073Disclaimer: View {
    var body: some View {
        LegalDisclaimer(
            text: "Ν. 5073/2023 introduced changes to freelance taxation, including adjusted solidarity thresholds and modified deductible expense rules. These estimates may not fully reflect individual circumstances under the new law.",
            icon: "doc.text"
        )
    }
}

// MARK: - Combined Disclaimer Footer
struct CombinedDisclaimer: View {
    var showProfessionalDiscount: Bool = false
    var showTekmartro: Bool = false
    var showLaw5073: Bool = false
    var showFMYCaveat: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            LastUpdatedBadge()

            if showTekmartro { TekmartroDisclaimer() }
            if showProfessionalDiscount { ProfessionalDiscountDisclaimer() }
            if showLaw5073 { Law5073Disclaimer() }

            if showFMYCaveat {
                LegalDisclaimer(
                    text: "The ΦΜΥ withholding rate of 20% is a simplification. The actual rate varies based on your tax bracket, number of clients, and whether you qualify as a 'μισθωτός' for EFKA purposes (single client ≥75% of income). Consult your λογιστής.",
                    icon: "exclamationmark.triangle"
                )
            }

            LegalDisclaimer(
                text: "Not affiliated with EFKA (e-ΕΦΚΑ), AADE, or any Greek government agency. Estimates only — always verify with your λογιστής.",
                icon: "info.circle"
            )
        }
    }
}
