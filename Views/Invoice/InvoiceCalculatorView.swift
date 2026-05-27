import SwiftUI

struct InvoiceCalculatorView: View {
    @State private var vm = InvoiceViewModel()
    @State private var amountText: String = "1000"
    @State private var showPDF = false

    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "doc.badge.plus")
                        .font(.system(size: 36))
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Μπλοκάκι Invoice Calculator")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("Calculate what to charge your client")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 8)
            }

            Section {
                HStack(spacing: 12) {
                    Text("€").font(.title2.weight(.bold)).foregroundColor(.accentPurple)
                    TextField("Net amount", text: $amountText)
                        .keyboardType(.decimalPad).font(.title2.weight(.bold))
                        .onChange(of: amountText) { _, nv in
                            if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) { vm.netAmount = v }
                        }
                }

                Picker("VAT Rate", selection: $vm.selectedVatIndex) {
                    ForEach(Array(vm.vatOptions.enumerated()), id: \.offset) { i, opt in
                        Text(opt.0).tag(i)
                    }
                }
                .pickerStyle(.menu).tint(.accentPurple)

                Toggle("Withholding Tax (ΦΜΥ 20%)", isOn: $vm.applyWithholding)
                    .tint(.accentPurple)
            } header: {
                SectionHeader(title: "Invoice Details", icon: "eurosign")
            }

            Section {
                DetailLabel(label: "Net Amount", value: vm.result.netAmount.currencyFormatted, valueColor: .primary)
                DetailLabel(label: "VAT (\((vm.result.vatRate * 100).formatted(.number.precision(.fractionLength(0))))%)",
                          value: vm.result.vatAmount.currencyFormatted, valueColor: .accentBlue)

                if vm.applyWithholding {
                    DetailLabel(label: "ΦΜΥ (20%)", value: "-\(vm.result.withholdingTax.currencyFormatted)", valueColor: .negativeRed)
                }

                Divider()

                HStack {
                    Text("Client Pays (Gross)").font(.headline)
                    Spacer()
                    Text(vm.result.grossAmount.currencyFormatted)
                        .font(.headline.monospaced().weight(.bold))
                        .foregroundColor(.accentPurple)
                }

                HStack {
                    Text("You Receive (Net)").font(.headline)
                    Spacer()
                    Text(vm.result.finalNet.currencyFormatted)
                        .font(.headline.monospaced().weight(.bold))
                        .foregroundColor(.accentTeal)
                }
            } header: {
                SectionHeader(title: "Invoice Breakdown", icon: "doc.text")
            }

            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("How it works").font(.subheadline.weight(.semibold))
                    Text("1. Net amount is your fee").font(.caption).foregroundColor(.secondary)
                    Text("2. VAT is added on top → Gross = Net + VAT").font(.caption).foregroundColor(.secondary)
                    Text("3. ΦΜΥ (20%) is withheld from the gross → you receive Gross − ΦΜΥ").font(.caption).foregroundColor(.secondary)
                    Text("4. You remit the VAT and ΦΜΥ to AADE").font(.caption).foregroundColor(.secondary)
                }
                .listRowBackground(Color.clear)
            }

            Section {
                HStack(spacing: 16) {
                    let summary = "Invoice — \(Date().formatted(date: .abbreviated, time: .omitted))\nNet: \(vm.result.netAmount.currencyFormatted)\nVAT: \(vm.result.vatAmount.currencyFormatted)\nGross: \(vm.result.grossAmount.currencyFormatted)\nΦΜΥ: \(vm.result.withholdingTax.currencyFormatted)\nYou Receive: \(vm.result.finalNet.currencyFormatted)"
                    CopyButton(text: summary)
                    ShareButton(text: summary) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up").font(.caption)
                            Text("Share").font(.caption2.weight(.medium))
                        }
                        .foregroundColor(.accentPurple)
                    }
                    Button { showPDF = true } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.richtext").font(.caption)
                            Text("Export PDF").font(.caption2.weight(.medium))
                        }
                        .foregroundColor(.accentPurple)
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)
            }

            Section {
                CombinedDisclaimer(showFMYCaveat: true)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Invoice Calculator")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showPDF) {
            NavigationStack {
                PDFPreviewView(data: InvoicePDFGenerator.generate(result: vm.result))
                    .navigationTitle("Invoice PDF")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) { Button("Done") { showPDF = false } }
                        ToolbarItem(placement: .bottomBar) {
                            ShareButton(text: "Invoice PDF") {
                                Label("Share PDF", systemImage: "square.and.arrow.up")
                                    .font(.subheadline)
                                    .foregroundColor(.accentPurple)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    NavigationStack { InvoiceCalculatorView() }
}
