import SwiftUI

struct QuickLink: Identifiable {
    let id = UUID()
    let name: String
    let url: String
    let description: String
    let icon: String
    let color: Color
}

struct QuickLinksView: View {
    private let links: [QuickLink] = [
        QuickLink(name: "myEFKA (e-ΕΦΚΑ)", url: "https://www.e-efka.gov.gr",
                  description: "Pay contributions, view insurance history, print certificates",
                  icon: "shield.checkered", color: .accentPurple),
        QuickLink(name: "AADE myTAXISnet", url: "https://www.aade.gr/myTAXISnet",
                  description: "File taxes, VAT returns, income tax, view tax info",
                  icon: "doc.text", color: .accentPink),
        QuickLink(name: "gov.gr", url: "https://www.gov.gr",
                  description: "Government digital services portal — property, certificates, IDs",
                  icon: "building.columns", color: .accentBlue),
        QuickLink(name: "Hellenic Cadastre (Κτηματολόγιο)", url: "https://www.ktimatologio.gr",
                  description: "Property registration, cadastral sheets, deeds",
                  icon: "map", color: .accentTeal),
        QuickLink(name: "OAED (ΔΥΠΑ)", url: "https://www.dypa.gov.gr",
                  description: "Unemployment benefits, job programs, subsidies",
                  icon: "person.fill.questionmark", color: .accentOrange),
        QuickLink(name: "GSIS (ΓΓΠΣ)", url: "https://www.gsis.gr",
                  description: "General government IT — invoicing, payroll, tax info systems",
                  icon: "globe", color: .accentPurple),
        QuickLink(name: "EFKA Insurance Classes", url: "https://www.e-efka.gov.gr/el/plirofories/asfalistikes-eisfores",
                  description: "View current insurance class rates and minimums",
                  icon: "list.bullet", color: .accentPink),
        QuickLink(name: "AADE VAT Info", url: "https://www.aade.gr/epiheiriseis/forologikes-ypiresies/fpa",
                  description: "VAT rates, returns, exemptions, and filing instructions",
                  icon: "doc.text", color: .accentBlue),
    ]

    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "link.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Quick Links")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("One-tap access to government portals")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 8)
            }

            ForEach(links) { link in
                if let url = URL(string: link.url) {
                    Link(destination: url) {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(link.color.opacity(0.1)).frame(width: 40, height: 40)
                            Image(systemName: link.icon).font(.callout).foregroundColor(link.color)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(link.name).font(.body.weight(.medium)).foregroundColor(.primary)
                            Text(link.description).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption).foregroundColor(.accentPurple)
                    }
                    .padding(.vertical, 4)
                }
                }
            }

            Section {
                Text("Links open in Safari. You may need to log in with your TaxisNet credentials. Keep your credentials secure.")
                    .font(.caption2).foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Quick Links")
        .navigationBarTitleDisplayMode(.inline)
    }

}

#Preview {
    NavigationStack { QuickLinksView() }
}
