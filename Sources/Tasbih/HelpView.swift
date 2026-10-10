import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Help").font(.largeTitle.bold())
                item("Counting", "Click the circle or press Space. ⌘Z undoes the last count, ⌘R resets the current set.")
                item("Streak", "A day counts when you finish a full 33 · 33 · 34 set. Missing a day resets the streak.")
                item("Storage", "Data is saved locally at ~/Library/Application Support/Tasbih/records.json. Nothing leaves your Mac.")
                item("Export", "Settings → Export CSV or JSON.")
                item("Reminders", "Settings → Daily reminder. Allow notifications for Tasbih when macOS asks.")
                item("Benefits", "Each entry lists its source. Verify references and gradings before sharing them.")
            }.padding(24).frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    private func item(_ t: String, _ b: String) -> some View {
        VStack(alignment: .leading, spacing: 4) { Text(t).font(.headline); Text(b).foregroundStyle(.secondary) }
    }
}
