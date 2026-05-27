# FreelancerEFKA

A luxury-themed iOS app for Greek freelancers (μπλοκάκι workers) with:
- **EFKA Calculator** — Social security contribution estimator with income tax, solidarity, and business tax projections
- **VAT Calculator** — ΦΠΑ obligation estimator with categories, island discounts, and filing rules
- **Property Purchasing Wizard** — Complete 8-step guide to buying property in Greece with checklists, cost breakdowns, and tax references

## Setup

### Option 1: XcodeGen (Recommended)
1. Install XcodeGen: `brew install xcodegen`
2. Run: `cd FreelancerEFKA && xcodegen`
3. Open `FreelancerEFKA.xcodeproj` in Xcode 15+
4. Select your development team in Signing & Capabilities
5. Run on iOS 17+ simulator or device

### Option 2: Manual
1. Open Xcode → Create New Project → iOS → App
2. Delete the default files
3. Drag all `.swift` files from the folders into the project
4. Add the `Resources` folder to the project
5. Set iOS Deployment Target to 17.0
6. Build and run

## Legal Notice
All calculations are estimates based on published Greek government rates (ΕΦΚΑ, ΑΑΔΕ) for 2024–2025. Actual obligations may vary ±5%. Always consult a certified accountant (λογιστής) and lawyer (δικηγόρος) for your specific situation.

## Tech Stack
- SwiftUI, iOS 17+
- Modern Swift concurrency (async/await, @Observable macro)
- Dark/gold luxury theme
