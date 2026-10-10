import SwiftUI
import AppKit

private let repoURL = "https://github.com/theikbhal/fatima-tasbeeh"

private let templates: [(name: String, text: String)] = [
    ("Invite",
     "Assalamu alaikum! I'm using a free, private Mac app called Fatima Tasbeeh to count the 33-33-34 tasbih after salah and keep a daily streak. Source and install steps: \(repoURL)"),
    ("Reminder",
     "Reminder: the Prophet ﷺ said that whoever says SubhanAllah 100 times in a day, a thousand good deeds are recorded for him or a thousand sins are erased (Sahih Muslim 2698). Small, steady dhikr adds up. May Allah accept from us."),
    ("33-33-34",
     "After each obligatory prayer: SubhanAllah ×33, Alhamdulillah ×33, Allahu Akbar ×34 (Sahih Muslim 596). Easy to start, easy to keep.")
]

struct ShareView: View {
    @State private var message = templates[0].text
    @State private var copied = false

    var body: some View {
        InfoPage(title: "Tell Others", subtitle: "Share the reminder with family and friends.") {
            InfoCard(title: "Convey from me",
                     text: "The Prophet ﷺ said: convey from me, even if it is one verse.",
                     source: "Sahih al-Bukhari 3461")
            InfoCard(title: "Guiding to good",
                     text: "Whoever guides to something good has a reward like the one who does it.",
                     source: "Sahih Muslim 1893")
            InfoCard(title: "Wisdom and good instruction",
                     text: "\"Invite to the way of your Lord with wisdom and good instruction.\"",
                     source: "Qur'an 16:125")

            Text("Message").font(.headline)
            HStack {
                ForEach(templates, id: \.name) { t in
                    Button(t.name) { message = t.text; copied = false }
                }
            }
            TextEditor(text: $message)
                .frame(height: 130)
                .padding(6)
                .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            HStack {
                ShareLink(item: message) { Label("Share…", systemImage: "square.and.arrow.up") }
                Button(copied ? "Copied" : "Copy") {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(message, forType: .string)
                    copied = true
                }
                Link("Open GitHub repo", destination: URL(string: repoURL)!)
            }
        }
    }
}
