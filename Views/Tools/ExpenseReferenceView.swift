import SwiftUI

struct ExpenseReferenceView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 6) {
                    Image(systemName: "list.bullet.rectangle")
                        .font(.system(size: 36))
                        .foregroundStyle(LinearGradient.primaryGradient)
                    Text("Deductible Expenses")
                        .font(.title2.weight(.semibold))
                        .foregroundColor(.primary)
                    Text("What you can write off · N. 4172/2013")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .padding(.vertical, 8)
            }

            ForEach(ExpenseCategory.all) { cat in
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle().fill(cat.icon == "fork.knife" ? Color.accentOrange : Color.accentPurple.opacity(0.1))
                                    .frame(width: 36, height: 36)
                                Image(systemName: cat.icon)
                                    .font(.callout)
                                    .foregroundColor(cat.icon == "fork.knife" ? .accentOrange : .accentPurple)
                            }

                            VStack(alignment: .leading, spacing: 1) {
                                Text(cat.name).font(.body.weight(.medium)).foregroundColor(.primary)
                                Text(cat.nameGreek).font(.caption).foregroundColor(.secondary)
                            }

                            Spacer()

                            Text(cat.deductiblePercent)
                                .font(.caption.weight(.bold))
                                .foregroundColor(.accentTeal)
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(Color.accentTeal.opacity(0.1))
                                .clipShape(Capsule())
                        }

                        if let cap = cat.cap {
                            HStack(spacing: 4) {
                                Image(systemName: "info.circle.fill").font(.caption2).foregroundColor(.accentOrange)
                                Text("Cap: \(cap)").font(.caption2).foregroundColor(.accentOrange)
                            }
                        }

                        Text(cat.notes).font(.caption).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)

                        Text("Ref: \(cat.legalReference)")
                            .font(.caption2).foregroundColor(.secondary)
                    }
                }
            }

            Section {
                Text("Always keep original receipts and invoices (τιμολόγια). AADE requires documentation for all deductions. ±5% margin on interpretations — consult your λογιστής.")
                    .font(.caption2).foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Expense Reference")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { ExpenseReferenceView() }
}
