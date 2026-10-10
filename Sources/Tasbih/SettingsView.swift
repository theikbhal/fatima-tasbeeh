import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject var store: TasbihStore
    @AppStorage("appearance") private var appearance = "system"
    @AppStorage("remindersOn") private var remindersOn = false
    @AppStorage("reminderMinutes") private var reminderMinutes = 13 * 60
    @AppStorage("onboarded") private var onboarded = true
    @State private var confirmErase = false

    private var timeBinding: Binding<Date> {
        Binding(
            get: { Calendar.current.date(bySettingHour: reminderMinutes / 60, minute: reminderMinutes % 60, second: 0, of: Date())! },
            set: {
                let c = Calendar.current.dateComponents([.hour, .minute], from: $0)
                reminderMinutes = (c.hour ?? 0) * 60 + (c.minute ?? 0)
                Notifier.schedule(enabled: remindersOn, minutesAfterMidnight: reminderMinutes)
            })
    }

    var body: some View {
        Form {
            Picker("Appearance", selection: $appearance) {
                Text("System").tag("system"); Text("Light").tag("light"); Text("Dark").tag("dark")
            }.pickerStyle(.segmented)

            Toggle("Daily reminder", isOn: $remindersOn)
                .onChange(of: remindersOn) { on in Notifier.schedule(enabled: on, minutesAfterMidnight: reminderMinutes) }
            DatePicker("Reminder time", selection: timeBinding, displayedComponents: .hourAndMinute)
                .disabled(!remindersOn)

            HStack {
                Button("Export CSV…") { export(store.exportCSV(), name: "tasbih.csv", type: .commaSeparatedText) }
                Button("Export JSON…") { export(store.exportJSON(), name: "tasbih.json", type: .json) }
            }
            Button("Show welcome again") { onboarded = false }
            Button("Erase all data…", role: .destructive) { confirmErase = true }
        }
        .formStyle(.grouped)
        .navigationTitle("Settings")
        .confirmationDialog("Erase all history and streaks?", isPresented: $confirmErase) {
            Button("Erase", role: .destructive) { store.eraseAll() }
        }
    }

    private func export(_ data: Data, name: String, type: UTType) {
        let p = NSSavePanel()
        p.nameFieldStringValue = name
        p.allowedContentTypes = [type]
        if p.runModal() == .OK, let url = p.url { try? data.write(to: url) }
    }
}
