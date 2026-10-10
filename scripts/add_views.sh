#!/bin/bash
# Run from the repo root:  bash ~/Downloads/add_views.sh [--push]
# Adds: Why, References, Consistency, Flexibility, Tell Others views
# and rewrites ContentView.swift to include them in the sidebar.
set -euo pipefail

[ -f Package.swift ] || { echo "Run this from the repo root (Package.swift not found)."; exit 1; }
D=Sources/Tasbih
[ -d "$D" ] || { echo "$D not found."; exit 1; }

# ---------------------------------------------------------------- shared UI
cat > $D/InfoViews.swift <<'EOF'
import SwiftUI

struct InfoPage<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(title).font(.largeTitle.bold())
                Text(subtitle).foregroundStyle(.secondary)
                content
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct InfoCard: View {
    let title: String
    let text: String
    var source: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(text)
            if let source {
                Label(source, systemImage: "bookmark")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
    }
}
EOF

# ---------------------------------------------------------------- Why
cat > $D/WhyView.swift <<'EOF'
import SwiftUI

struct WhyView: View {
    var body: some View {
        InfoPage(title: "Why Dhikr?", subtitle: "The reasons behind the habit, with sources.") {
            InfoCard(title: "Why remember Allah at all?",
                     text: "\"Verily, in the remembrance of Allah do hearts find rest.\" And: \"So remember Me; I will remember you.\"",
                     source: "Qur'an 13:28, Qur'an 2:152")
            InfoCard(title: "Why after the prayer?",
                     text: "The Prophet ﷺ taught words to say after the obligatory prayers whose sayer is never disappointed.",
                     source: "Sahih Muslim 596")
            InfoCard(title: "Why 33 · 33 · 34?",
                     text: "The narration gives 33 tasbih, 33 tahmid and 34 takbir, which makes 100. Another narration gives 33 of each and completes the hundred with La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa ala kulli shay'in qadir. Authentic narrations also report other combinations, so ask a scholar if you want to follow a specific one.",
                     source: "Sahih Muslim 596, Sahih Muslim 597")
            InfoCard(title: "Why does it matter?",
                     text: "The reward is described as forgiveness of sins like the foam of the sea, and the poor companions were told it would raise them to the rank of those who gave in charity. See the Benefits page for more.",
                     source: "Sahih Muslim 597, Sahih al-Bukhari 843")
            InfoCard(title: "Why count?",
                     text: "A fixed number keeps your mind on the words instead of on how many are left, and a daily record turns a good intention into a habit you can see.")
        }
    }
}
EOF

# ---------------------------------------------------------------- References
cat > $D/ReferenceView.swift <<'EOF'
import SwiftUI

struct RefLink: Identifiable {
    let label: String
    let url: URL?
    var id: String { label }
}

enum References {
    static func links(from source: String) -> [RefLink] {
        source.components(separatedBy: ", ").map { RefLink(label: $0, url: url(for: $0)) }
    }

    static func url(for ref: String) -> URL? {
        if ref.hasPrefix("Qur") {
            guard let last = ref.split(separator: " ").last else { return nil }
            let parts = last.replacingOccurrences(of: "–", with: "-").split(separator: ":")
            guard parts.count == 2 else { return nil }
            return URL(string: "https://quran.com/\(parts[0])/\(parts[1])")
        }
        guard let number = ref.split(separator: " ").last, Int(number) != nil else { return nil }
        let collection: String
        if ref.contains("Bukhari") { collection = "bukhari" }
        else if ref.contains("Muslim") { collection = "muslim" }
        else if ref.contains("Tirmidhi") { collection = "tirmidhi" }
        else { return nil }
        return URL(string: "https://sunnah.com/\(collection):\(number)")
    }
}

struct ReferenceView: View {
    private var entries: [(ref: RefLink, titles: [String])] {
        var dict: [String: (RefLink, [String])] = [:]
        for b in allBenefits {
            for l in References.links(from: b.source) {
                var cur = dict[l.label] ?? (l, [])
                cur.1.append(b.title)
                dict[l.label] = cur
            }
        }
        return dict.values.sorted { $0.0.label < $1.0.label }.map { (ref: $0.0, titles: $0.1) }
    }

    var body: some View {
        InfoPage(title: "References", subtitle: "Every source used in the app. Tap a link to read it and verify.") {
            ForEach(entries, id: \.ref.id) { e in
                VStack(alignment: .leading, spacing: 4) {
                    if let url = e.ref.url {
                        Link(destination: url) { Label(e.ref.label, systemImage: "link") }
                            .font(.headline)
                    } else {
                        Text(e.ref.label).font(.headline)
                    }
                    ForEach(e.titles, id: \.self) { t in
                        Text("• \(t)").foregroundStyle(.secondary)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
            }
            InfoCard(title: "Verify for yourself",
                     text: "Hadith numbering and gradings can differ between editions. Check the wording and grading on these sites, and ask a trusted scholar when unsure.")
            HStack(spacing: 20) {
                Link("sunnah.com", destination: URL(string: "https://sunnah.com")!)
                Link("quran.com", destination: URL(string: "https://quran.com")!)
            }
        }
    }
}
EOF

# ---------------------------------------------------------------- Consistency
cat > $D/ConsistencyView.swift <<'EOF'
import SwiftUI

struct ConsistencyView: View {
    @EnvironmentObject var store: TasbihStore
    @AppStorage("weeklyGoal") private var weeklyGoal = 5

    private func color(_ r: DayRecord) -> Color {
        if r.sessions > 0 { return .accentColor }
        if r.total > 0 { return Color.accentColor.opacity(0.4) }
        return Color.secondary.opacity(0.2)
    }

    var body: some View {
        let week = store.last(days: 7)
        let done = week.filter { $0.sessions > 0 }.count
        let grid = store.last(days: 84)

        InfoPage(title: "Consistency", subtitle: "Small and steady beats big and rare.") {
            HStack(spacing: 28) {
                stat("Current streak", "\(store.streak)")
                stat("Longest streak", "\(store.longestStreak)")
                stat("This week", "\(done)/\(weeklyGoal)")
            }
            InfoCard(title: "The most beloved deeds",
                     text: "The most beloved deeds to Allah are the most consistent, even if they are small.",
                     source: "Sahih al-Bukhari 6464, Sahih Muslim 783")

            VStack(alignment: .leading, spacing: 8) {
                ProgressView(value: Double(min(done, weeklyGoal)), total: Double(weeklyGoal))
                Stepper("Weekly goal: \(weeklyGoal) day\(weeklyGoal == 1 ? "" : "s")", value: $weeklyGoal, in: 1...7)
            }

            Text("Last 12 weeks (oldest to newest)").font(.headline)
            LazyHGrid(rows: Array(repeating: GridItem(.fixed(16), spacing: 4), count: 7), spacing: 4) {
                ForEach(grid) { r in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color(r))
                        .frame(width: 16, height: 16)
                        .help("\(r.date): \(r.sessions) full set(s), \(r.total) total")
                }
            }
            .frame(height: 7 * 16 + 6 * 4)
            Text("Solid = full set done · light = partial · grey = none").font(.caption).foregroundStyle(.secondary)

            InfoCard(title: "Tips",
                     text: "Attach it to a prayer you never miss. Start with one set a day. If you miss a day, begin again today instead of waiting for a fresh week.")
        }
    }

    private func stat(_ t: String, _ v: String) -> some View {
        VStack(alignment: .leading) {
            Text(v).font(.system(size: 34, weight: .bold, design: .rounded))
            Text(t).font(.caption).foregroundStyle(.secondary)
        }
    }
}
EOF

# ---------------------------------------------------------------- Flexibility
cat > $D/FlexibilityView.swift <<'EOF'
import SwiftUI

struct FlexibilityView: View {
    var body: some View {
        InfoPage(title: "Flexibility", subtitle: "Keep it easy so you can keep it up.") {
            InfoCard(title: "The religion is ease",
                     text: "The Prophet ﷺ taught that the religion is easy, and that whoever makes it harder on himself will be overcome by it. Aim for steady and sustainable.",
                     source: "Sahih al-Bukhari 39")
            InfoCard(title: "Dhikr is not only after prayer",
                     text: "Believers remember Allah standing, sitting and lying on their sides, and Aisha reported that the Prophet ﷺ remembered Allah at all times.",
                     source: "Qur'an 3:191, Sahih Muslim 373")
            InfoCard(title: "Count in more than one sitting",
                     text: "You can do a set in one go or spread it out. The app remembers where you stopped, so you can carry on from the same number later.")
            InfoCard(title: "Other counts and combinations",
                     text: "Narrations mention other ways to complete the dhikr after prayer. This app uses 33 · 33 · 34. If you follow a different one, ask a scholar which is best for you.")
            InfoCard(title: "Make it fit your day",
                     text: "Use Space to count without the mouse, change the reminder time in Settings, and set a weekly goal on the Consistency page that you can realistically meet.")
        }
    }
}
EOF

# ---------------------------------------------------------------- Tell others
cat > $D/ShareView.swift <<'EOF'
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
EOF

# ---------------------------------------------------------------- ContentView
cat > $D/ContentView.swift <<'EOF'
import SwiftUI

enum Page: String, CaseIterable, Identifiable {
    case counter = "Counter"
    case why = "Why"
    case benefits = "Benefits"
    case references = "References"
    case consistency = "Consistency"
    case flexibility = "Flexibility"
    case share = "Tell Others"
    case history = "History"
    case settings = "Settings"
    case help = "Help"

    var id: String { rawValue }
    var icon: String {
        switch self {
        case .counter: return "circle.dotted"
        case .why: return "questionmark.bubble"
        case .benefits: return "book.closed"
        case .references: return "link"
        case .consistency: return "flame"
        case .flexibility: return "arrow.triangle.2.circlepath"
        case .share: return "person.2"
        case .history: return "chart.bar"
        case .settings: return "gearshape"
        case .help: return "questionmark.circle"
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var store: TasbihStore
    @AppStorage("onboarded") private var onboarded = false
    @State private var selection: Page? = .counter

    var body: some View {
        NavigationSplitView {
            List(Page.allCases, selection: $selection) { p in
                Label(p.rawValue, systemImage: p.icon).tag(p)
            }
            .navigationSplitViewColumnWidth(min: 170, ideal: 190)
        } detail: {
            switch selection ?? .counter {
            case .counter: CounterView()
            case .why: WhyView()
            case .benefits: BenefitsView()
            case .references: ReferenceView()
            case .consistency: ConsistencyView()
            case .flexibility: FlexibilityView()
            case .share: ShareView()
            case .history: HistoryView()
            case .settings: SettingsView()
            case .help: HelpView()
            }
        }
        .sheet(isPresented: Binding(get: { !onboarded }, set: { _ in })) {
            OnboardingView { onboarded = true }
        }
    }
}
EOF

echo "Files written. Building…"
swift build 2>&1 | tail -n 25
echo "Build OK."

git add -A
git commit -m "Add Why, References, Consistency, Flexibility and Tell Others views" || true
if [ "${1:-}" = "--push" ]; then git push; fi
echo "Done. Install with ./scripts/install.sh"