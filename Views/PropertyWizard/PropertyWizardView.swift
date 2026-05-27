import SwiftUI

struct PropertyWizardView: View {
    @State private var vm = PropertyWizardViewModel()
    @State private var costVM = PropertyCostViewModel()
    @State private var valueText: String = "200000"
    @State private var showTax = false
    @State private var showReset = false

    var body: some View {
        NavigationStack {
            List {
                headerSection
                if vm.isComplete { completionBanner }
                costCalculatorSection
                progressSection
                stepsList
                taxButton
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Property Wizard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if vm.completedSteps > 0 { showReset = true }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundColor(vm.completedSteps > 0 ? .accentPurple : .secondary)
                    }
                    .disabled(vm.completedSteps == 0)
                }
            }
            .alert("Reset Progress?", isPresented: $showReset) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) { withAnimation { vm.resetAll() } }
            }
            .sheet(isPresented: $showTax) { taxSheet }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        Section {
            VStack(spacing: 8) {
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(LinearGradient.primaryGradient)
                Text("Property Purchase Guide")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.primary)
                Text("Buying property in Greece · 8 steps")
                    .font(.subheadline).foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .padding(.vertical, 8)
        }
    }

    private var completionBanner: some View {
        Section {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.accentTeal)
                Text("All steps complete!").font(.body.weight(.semibold)).foregroundColor(.accentTeal)
            }
            .listRowBackground(Color.accentTeal.opacity(0.06))
        }
    }

    // MARK: - Cost Calculator
    private var costCalculatorSection: some View {
        Section {
            HStack(spacing: 12) {
                Text("€").font(.title2.weight(.bold)).foregroundColor(.accentPurple)
                TextField("Property value", text: $valueText)
                    .keyboardType(.decimalPad).font(.title2.weight(.bold))
                    .onChange(of: valueText) { _, nv in
                        if let v = Decimal(string: nv.replacingOccurrences(of: ",", with: ".")) { costVM.propertyValue = v }
                    }
            }

            Toggle(isOn: $costVM.isNewBuild) {
                HStack(spacing: 6) {
                    Image(systemName: "hammer.fill").font(.caption).foregroundColor(.accentOrange)
                    Text("New build (VAT 24% instead of ΦΜΑ)")
                        .font(.subheadline).foregroundColor(.primary)
                }
            }
            .tint(.accentOrange)

            VStack(spacing: 8) {
                ForEach(costVM.result.breakdown) { item in
                    HStack {
                        HStack(spacing: 6) {
                            Circle().fill(badgeColor(item.colorLabel)).frame(width: 6, height: 6)
                            Text(item.item).font(.subheadline).foregroundColor(.secondary)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Text(item.percentage).font(.caption2).foregroundColor(.secondary)
                            Text(item.amount.currencyFormatted).font(.body.monospaced().weight(.medium)).foregroundColor(.primary)
                        }
                    }
                }

                Divider()

                HStack {
                    Text("Total Costs").font(.headline).foregroundColor(.primary)
                    Spacer()
                    Text(costVM.result.totalPercentage).font(.caption).foregroundColor(.secondary).padding(.trailing, 4)
                    Text(costVM.result.totalCosts.currencyFormatted)
                        .font(.headline.monospaced().weight(.bold))
                        .foregroundColor(.negativeRed)
                }

                HStack {
                    Text("Grand Total (property + costs)").font(.subheadline).foregroundColor(.secondary)
                    Spacer()
                    Text(costVM.result.grandTotal.currencyFormatted)
                        .font(.body.monospaced().weight(.bold))
                        .foregroundColor(.accentPurple)
                }
            }
            .padding(.top, 8)
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "eurosign").font(.caption).foregroundColor(.accentPurple)
                Text("Purchase Cost Calculator").font(.headline).foregroundColor(.primary)
            }
        } footer: {
            Text("For used homes: ΦΜΑ 3%. For new builds (first sale): VAT 24%. Notary/lawyer fees vary by region and complexity.")
                .font(.caption2)
        }
    }

    private func badgeColor(_ label: String) -> Color {
        switch label {
        case "red": .negativeRed
        case "orange": .accentOrange
        case "purple": .accentPurple
        case "teal": .accentTeal
        default: .secondary
        }
    }

    // MARK: - Progress
    private var progressSection: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Progress").font(.callout).foregroundColor(.secondary)
                    Spacer()
                    Text("\(vm.completedSteps)/\(vm.totalSteps)")
                        .font(AppFont.monoBold()).foregroundColor(.accentPurple)
                }
                ProgressView(value: vm.progress).tint(.accentPurple)
                if let next = vm.nextIncompleteStep {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right").font(.caption).foregroundColor(.accentPurple)
                        Text("Next: \(next.stepNumber). \(next.title)")
                            .font(.caption).foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "chart.bar.fill").font(.caption).foregroundColor(.accentPurple)
                Text("Your Progress").font(.headline).foregroundColor(.primary)
            }
        }
    }

    // MARK: - Steps
    private var stepsList: some View {
        Section {
            ForEach(Array(vm.steps.enumerated()), id: \.offset) { _, step in
                StepCardView(
                    step: Binding(
                        get: { vm.steps.first { $0.id == step.id } ?? step },
                        set: { updated in
                            if let i = vm.steps.firstIndex(where: { $0.id == updated.id }) { vm.steps[i] = updated }
                        }
                    ),
                    onToggle: { vm.toggleCompleted(step) }
                )
            }
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "list.bullet").font(.caption).foregroundColor(.accentPurple)
                Text("Steps (\(vm.totalSteps))").font(.headline).foregroundColor(.primary)
            }
        }
    }

    // MARK: - Tax Button
    private var taxButton: some View {
        Section {
            Button { showTax = true } label: {
                HStack {
                    Image(systemName: "doc.text.magnifyingglass").foregroundColor(.accentPurple)
                    Text("Tax & Fee Reference").font(.body).foregroundColor(.primary)
                    Spacer()
                    Text("\(vm.taxReferences.count) items").font(.caption).foregroundColor(.secondary)
                    Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Tax Sheet
    private var taxSheet: some View {
        NavigationStack {
            List(vm.taxReferences) { tax in
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(tax.nameGreek).font(.body.weight(.semibold))
                                Text(tax.name).font(.caption).foregroundColor(.secondary)
                            }
                            Spacer()
                            Text(tax.rate).font(AppFont.monoBold(13)).foregroundColor(.accentPurple)
                        }
                        LabeledContent("Applies", value: tax.appliesWhen).font(.caption)
                        LabeledContent("Paid by", value: tax.paidBy).font(.caption)
                        Text(tax.notes).font(.caption).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Taxes & Fees").navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { Button("Done") { showTax = false } }
            }
        }
    }
}

#Preview {
    PropertyWizardView()
}
