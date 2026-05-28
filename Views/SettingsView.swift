import SwiftUI

struct SettingsView: View {
    @Environment(AppSettings.self) private var settings
    @State private var notifManager = NotificationManager()
    @State private var showDeniedAlert = false

    var body: some View {
        NavigationStack {
            @Bindable var s = settings
            return List {
                headerSection
                themeSection
                languageSection
                notificationSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .alert("Notifications Blocked", isPresented: $showDeniedAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Enable notifications in iOS Settings to receive EFKA/VAT deadline reminders.")
            }
            .onAppear { notifManager.checkAuthorization() }
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

    // MARK: - Language
    private var languageSection: some View {
        @Bindable var s = settings
        return Section {
            ForEach(AppLanguage.allCases) { lang in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        s.appLanguage = lang
                    }
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(settings.appLanguage == lang ? Color.accentPurple : Color(.systemGray5))
                                .frame(width: 32, height: 32)
                            Image(systemName: lang.icon)
                                .font(.caption)
                                .foregroundColor(settings.appLanguage == lang ? .white : .secondary)
                        }

                        Text(lang.rawValue)
                            .font(.body)
                            .foregroundColor(.primary)

                        Spacer()

                        if settings.appLanguage == lang {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentPurple)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "globe")
                    .font(.caption)
                    .foregroundColor(.accentPurple)
                Text("Language")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        } footer: {
            Text("Changes the app language. 'System' uses your device language.")
                .font(.caption2)
        }
    }

    // MARK: - Notifications
    private var notificationSection: some View {
        Section {
            if notifManager.isAuthorized {
                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(Color.accentTeal.opacity(0.1)).frame(width: 32, height: 32)
                        Image(systemName: "bell.badge.fill").font(.caption).foregroundColor(.accentTeal)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Notifications Enabled").font(.body.weight(.medium)).foregroundColor(.primary)
                        Text("Weekly reminders + EFKA/VAT deadlines").font(.caption).foregroundColor(.secondary)
                    }
                }
            } else {
                Button {
                    notifManager.requestPermission()
                    if !notifManager.isAuthorized && notifManager.showDeniedAlert {
                        showDeniedAlert = true
                    }
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(Color.accentOrange.opacity(0.1)).frame(width: 32, height: 32)
                            Image(systemName: "bell").font(.caption).foregroundColor(.accentOrange)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Enable Notifications").font(.body.weight(.medium)).foregroundColor(.primary)
                            Text("Get reminders for EFKA, VAT, and tax deadlines").font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }

            if notifManager.isAuthorized {
                Button {
                    notifManager.scheduleDeadlines()
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle().fill(Color.accentPurple.opacity(0.1)).frame(width: 32, height: 32)
                            Image(systemName: "calendar.badge.clock").font(.caption).foregroundColor(.accentPurple)
                        }
                        Text("Schedule All Deadline Reminders").font(.body).foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.right").font(.caption).foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }
        } header: {
            HStack(spacing: 6) {
                Image(systemName: "bell.fill").font(.caption).foregroundColor(.accentPurple)
                Text("Notifications").font(.headline).foregroundColor(.primary)
            }
        } footer: {
            Text("Weekly reminders + EFKA, VAT, and income tax deadline notifications.")
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
                Image(systemName: "info.circle").font(.caption).foregroundColor(.accentPurple)
                Text("About").font(.headline).foregroundColor(.primary)
            }
        }
    }

    private func aboutRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.body).foregroundColor(.secondary)
            Spacer()
            Text(value).font(.subheadline.weight(.medium)).foregroundColor(.accentPurple)
        }
    }
}

#Preview {
    SettingsView()
        .environment(AppSettings())
}
