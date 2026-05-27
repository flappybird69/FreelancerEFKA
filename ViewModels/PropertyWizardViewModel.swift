import Foundation
import SwiftUI

@Observable
final class PropertyWizardViewModel {
    var steps: [PropertyPurchaseStep] = PropertyPurchaseStep.allSteps

    var completedSteps: Int {
        steps.filter(\.isCompleted).count
    }

    var totalSteps: Int {
        steps.count
    }

    var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(completedSteps) / Double(totalSteps)
    }

    var isComplete: Bool {
        completedSteps == totalSteps
    }

    var nextIncompleteStep: PropertyPurchaseStep? {
        steps.first { !$0.isCompleted }
    }

    func toggleCompleted(_ step: PropertyPurchaseStep) {
        guard let index = steps.firstIndex(of: step) else { return }
        withAnimation(.spring(response: 0.35)) {
            steps[index].isCompleted.toggle()
        }
    }

    func toggleExpanded(_ step: PropertyPurchaseStep) {
        guard let index = steps.firstIndex(of: step) else { return }
        withAnimation(.spring(response: 0.35)) {
            steps[index].isExpanded.toggle()
        }
    }

    func resetAll() {
        withAnimation(.spring(response: 0.35)) {
            for index in steps.indices {
                steps[index].isCompleted = false
                steps[index].isExpanded = false
            }
        }
    }

    // MARK: - Estimated Total Costs
    var estimatedTotalCosts: String {
        // Rough minimum estimate based on a €200,000 property
        let propertyValue: Decimal = 200_000
        let transferTax = propertyValue * 0.03
        let notaryFee = propertyValue * 0.015
        let lawyerFee = propertyValue * 0.015
        let registrationFee = propertyValue * 0.0055
        let certificates: Decimal = 800
        let total = transferTax + notaryFee + lawyerFee + registrationFee + certificates

        return total.currencyFormatted
    }

    var estimatedTotalPercentage: String {
        let basePercentage: Decimal = 3.0 + 1.5 + 1.5 + 0.55
        return "\(basePercentage.formatted(.number.precision(.fractionLength(1))))% + certs (~€800)"
    }

    // MARK: - Tax Reference
    let taxReferences = PropertyPurchaseStep.taxReferences
}
