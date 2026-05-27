import SwiftUI

struct StepCardView: View {
    @Binding var step: PropertyPurchaseStep
    var onToggle: () -> Void

    private var riskColor: Color {
        switch step.riskLevel {
        case .low: return .accentTeal
        case .medium: return .accentOrange
        case .high, .critical: return .negativeRed
        }
    }

    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 14) {
                Text(step.summary)
                    .font(AppFont.callout)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if !step.costItems.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        sectionTitle("Cost Breakdown")
                        ForEach(step.costItems) { cost in
                            VStack(alignment: .leading, spacing: 2) {
                                Text(cost.name)
                                    .font(AppFont.caption.weight(.medium))
                                    .foregroundColor(.primary)
                                HStack(spacing: 8) {
                                    Text(cost.amount)
                                        .font(AppFont.caption.weight(.semibold))
                                        .foregroundColor(.accentPurple)
                                    if let pct = cost.percentage {
                                        Text(pct)
                                            .font(AppFont.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                if !cost.notes.isEmpty {
                                    Text(cost.notes)
                                        .font(AppFont.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.leading, 8)
                        }
                    }
                }

                if !step.professionalsRequired.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        sectionTitle("Professionals")
                        ForEach(step.professionalsRequired, id: \.self) { pro in
                            Label(pro, systemImage: "person.fill")
                                .font(AppFont.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.caption).foregroundColor(.secondary)
                    Text("Duration: \(step.estimatedDuration)")
                        .font(AppFont.caption)
                        .foregroundColor(.primary)
                }

                if !step.checklist.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        sectionTitle("Checklist (\(step.checklist.count))")
                        ForEach(Array(step.checklist.prefix(4).enumerated()), id: \.offset) { _, item in
                            Label(item, systemImage: "circle")
                                .font(AppFont.caption)
                                .foregroundColor(.secondary)
                        }
                        if step.checklist.count > 4 {
                            Text("+\(step.checklist.count - 4) more")
                                .font(AppFont.caption2)
                                .foregroundColor(.accentPurple)
                        }
                    }
                }

                if !step.tips.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        sectionTitle("Tips")
                        ForEach(Array(step.tips.prefix(2).enumerated()), id: \.offset) { _, tip in
                            Label(tip, systemImage: "lightbulb")
                                .font(AppFont.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                if let ref = step.legalReferences {
                    VStack(alignment: .leading, spacing: 4) {
                        sectionTitle("Legal References")
                        Text(ref)
                            .font(AppFont.caption2)
                            .foregroundColor(.secondary)
                    }
                }

                Button {
                    onToggle()
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: step.isCompleted ? "xmark.circle.fill" : "checkmark.circle.fill")
                        Text(step.isCompleted ? "Mark Incomplete" : "Mark Complete")
                        Spacer()
                    }
                    .font(AppFont.caption.weight(.semibold))
                    .foregroundColor(step.isCompleted ? .accentTeal : .accentPurple)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(step.isCompleted ? Color.accentTeal.opacity(0.3) : Color.accentPurple.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding(.leading, 4)
            .padding(.vertical, 8)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(step.isCompleted ? Color.accentTeal : Color.accentPurple.opacity(0.1))
                        .frame(width: 32, height: 32)
                    if step.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption.weight(.black))
                            .foregroundColor(.white)
                    } else {
                        Text("\(step.stepNumber)")
                            .font(AppFont.caption.weight(.bold))
                            .foregroundColor(.accentPurple)
                    }
                }

                VStack(alignment: .leading, spacing: 1) {
                    Text(step.titleGreek)
                        .font(AppFont.body.weight(.semibold))
                        .foregroundColor(.primary)
                    Text(step.title)
                        .font(AppFont.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if !step.isCompleted {
                    Text(step.riskLevel.rawValue)
                        .font(AppFont.caption2.weight(.bold))
                        .foregroundColor(riskColor)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(riskColor.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
        }
        .tint(.accentPurple)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(AppFont.caption.weight(.semibold))
            .foregroundColor(.accentPurple)
    }
}

#Preview {
    List {
        StepCardView(step: .constant(PropertyPurchaseStep.allSteps[0]), onToggle: {})
        StepCardView(step: .constant(PropertyPurchaseStep.allSteps[1]), onToggle: {})
    }
    .listStyle(.insetGrouped)
}
