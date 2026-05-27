import SwiftUI

struct TaxDeadline: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let frequency: String
    let color: Color
    let notes: String
    let icon: String
}

struct TaxDeadlinesView: View {
    private let deadlines: [TaxDeadline] = [
        TaxDeadline(title: "EFKA Monthly Payment", date: "Last business day of each month", frequency: "Monthly",
                    color: .accentPurple, notes: "Pay your EFKA contribution for the current month via myEFKA or bank standing order.",
                    icon: "shield.checkered"),
        TaxDeadline(title: "VAT Return — Q1", date: "April 30", frequency: "Quarterly",
                    color: .accentPink, notes: "File and pay VAT for January–March.",
                    icon: "doc.text"),
        TaxDeadline(title: "VAT Return — Q2", date: "July 31", frequency: "Quarterly",
                    color: .accentPink, notes: "File and pay VAT for April–June.",
                    icon: "doc.text"),
        TaxDeadline(title: "VAT Return — Q3", date: "October 31", frequency: "Quarterly",
                    color: .accentPink, notes: "File and pay VAT for July–September.",
                    icon: "doc.text"),
        TaxDeadline(title: "VAT Return — Q4", date: "January 31", frequency: "Quarterly",
                    color: .accentPink, notes: "File and pay VAT for October–December.",
                    icon: "doc.text"),
        TaxDeadline(title: "Annual Income Tax Filing", date: "March–April 30", frequency: "Yearly",
                    color: .accentOrange, notes: "Submit annual tax return (Ε1) via AADE myTAXISnet. Pay any balance due.",
                    icon: "doc.text"),
        TaxDeadline(title: "Business Tax (Τέλος Επιτηδεύματος)", date: "With annual tax return", frequency: "Yearly",
                    color: .accentOrange, notes: "€650 for freelancers. Paid together with income tax.",
                    icon: "eurosign"),
        TaxDeadline(title: "ENFIA Property Tax", date: "Monthly installments (Apr–Sep)", frequency: "Yearly",
                    color: .accentTeal, notes: "Annual property tax paid in 6 monthly installments via tax return or standalone payment.",
                    icon: "house"),
        TaxDeadline(title: "EFKA Class Selection", date: "January 31", frequency: "Yearly",
                    color: .accentPurple, notes: "Choose your insurance class (1st–6th) for the current year. Default carries over.",
                    icon: "list.bullet"),
        TaxDeadline(title: "Social Insurance Certificate", date: "Before each contract", frequency: "As needed",
                    color: .accentBlue, notes: "Obtain Αποδεικτικό Ασφαλιστικής Ενημερότητας from myEFKA for contracting with clients.",
                    icon: "doc.checkmark"),
    ]

    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 36))
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Tax & EFKA Deadlines")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("Never miss a deadline")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 8)
            }

            ForEach(deadlines) { dl in
                Section {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(dl.color.opacity(0.1)).frame(width: 36, height: 36)
                            Image(systemName: dl.icon).font(.callout).foregroundColor(dl.color)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(dl.title).font(.body.weight(.medium)).foregroundColor(.primary)
                            Text(dl.date).font(.caption).foregroundColor(dl.color)
                            Text(dl.notes).font(.caption2).foregroundColor(.secondary).padding(.top, 2)
                        }
                        Spacer()
                        Text(dl.frequency)
                            .font(.caption2.weight(.bold))
                            .foregroundColor(dl.color)
                            .padding(.horizontal, 6).padding(.vertical, 2)
                            .background(dl.color.opacity(0.1))
                            .clipShape(Capsule())
                    }
                }
            }

            Section {
                Text("Deadlines are based on AADE and EFKA published schedules for 2025. Confirm with your λογιστής as dates may shift.")
                    .font(.caption2).foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Deadlines")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { TaxDeadlinesView() }
}
