import Foundation
import SwiftUI

@Observable
final class PropertyCostViewModel {
    var propertyValue: Decimal = 200000
    var isNewBuild: Bool = false

    var result: PropertyCostResult {
        PropertyCostCalculator.calculate(propertyValue: propertyValue, isNewBuild: isNewBuild)
    }
}
