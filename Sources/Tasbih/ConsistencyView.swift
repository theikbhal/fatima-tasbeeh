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
