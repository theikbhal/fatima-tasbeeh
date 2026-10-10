import SwiftUI
import Charts

struct HistoryView: View {
    @EnvironmentObject var store: TasbihStore

    var body: some View {
        let data = store.last(days: 14)
        VStack(alignment: .leading, spacing: 16) {
            Text("History").font(.largeTitle.bold())
            HStack(spacing: 24) {
                stat("Current streak", "\(store.streak)")
                stat("Longest streak", "\(store.longestStreak)")
                stat("Total full sets", "\(store.records.values.reduce(0) { $0 + $1.sessions })")
            }
            Chart(data) { r in
                BarMark(x: .value("Day", String(r.date.suffix(5))), y: .value("Dhikr", r.total))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(height: 180)
            Table(store.records.values.sorted { $0.date > $1.date }) {
                TableColumn("Date", value: \.date)
                TableColumn("Subhan.") { Text("\($0.subhanAllah)") }
                TableColumn("Alham.") { Text("\($0.alhamdulillah)") }
                TableColumn("Akbar") { Text("\($0.allahuAkbar)") }
                TableColumn("Sets") { Text("\($0.sessions)") }
            }
        }
        .padding(24)
    }

    private func stat(_ t: String, _ v: String) -> some View {
        VStack(alignment: .leading) {
            Text(v).font(.system(size: 34, weight: .bold, design: .rounded))
            Text(t).font(.caption).foregroundStyle(.secondary)
        }
    }
}
