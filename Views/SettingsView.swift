import SwiftUI

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        NavigationStack {
            @Bindable var s = settings
            return List {
                headerSection
                themeSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        Section {
            VStack(spacing: 8) {
                Image(systemName: "gearshape.circle.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(LinearGradient.primaryGradient)
                    .padding(.bottom, 4)
                Text("Freelancer EFKA")
                    .font(.title2.weight(.bold))
                    .foregroundColor(.primary)
                Text("v1.0 · 2025 rates")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.clear)
            .padding(.vertical, 16)
        }
    }

    // MARK: - Theme
    private var themeSection: some View {
        @Bindable var s = settings
        return Section {
            ForEach(ThemeMode.allCases) { mode in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        s.themeMode = mode
                    }
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(settings.themeMode == mode ? Color.accentPurple : Color(.systemGray5))
                                .frame(width: 32, height: 32)
                            Image(systemName: mode.icon)
                                .font(.caption)
                                .foregroundColor(settings.themeMode == mode ? .white : .secondary)
                        }

                        Text(mode.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)

                        Spacer()

                        if settings.themeMode == mode {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentPurple)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "paintbrush.fill")
                    .font(.caption)
                    .foregroundColor(.accentPurple)
                Text("Appearance")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        } footer: {
            Text("Accent colors stay the same — only backgrounds adapt to light/dark mode.")
                .font(.caption2)
        }
    }

    // MARK: - About
    private var aboutSection: some View {
        Section {
            aboutRow("EFKA Rates", "Law 4670/2020, 2025")
            aboutRow("VAT Rates", "AADE ΦΠΑ 2025")
            aboutRow("Income Tax", "Ν. 4172/2013 progressive")
            aboutRow("Business Tax", "€650/yr (τέλος επιτηδεύματος)")
            aboutRow("Margin", "±5% — consult your λογιστής")

            Divider()

            Text("Data sourced from published Greek government rates. All figures are estimates. Always verify with a certified professional.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundColor(.accentPurple)
                Text("About")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
    }

    private func aboutRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.accentPurple)
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}
