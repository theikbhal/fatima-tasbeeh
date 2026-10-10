import Foundation
import SwiftUI

final class TasbihStore: ObservableObject {
    @Published private(set) var records: [String: DayRecord] = [:]
    @Published private(set) var phase: Int { didSet { UserDefaults.standard.set(phase, forKey: "phase") } }
    @Published private(set) var count: Int { didSet { UserDefaults.standard.set(count, forKey: "count") } }

    private let fileURL: URL
    private let cal = Calendar.current

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Tasbih", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("records.json")
        phase = UserDefaults.standard.integer(forKey: "phase")
        count = UserDefaults.standard.integer(forKey: "count")
        load()
    }

    // MARK: Keys & state
    private func key(_ d: Date) -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: d)
    }
    var todayKey: String { key(Date()) }
    var today: DayRecord { records[todayKey] ?? DayRecord(date: todayKey) }
    var currentDhikr: Dhikr { Dhikr(rawValue: phase) ?? .subhanAllah }

    var streak: Int {
        var day = cal.startOfDay(for: Date())
        if (records[key(day)]?.sessions ?? 0) == 0 { day = cal.date(byAdding: .day, value: -1, to: day)! }
        var n = 0
        while (records[key(day)]?.sessions ?? 0) > 0 {
            n += 1
            day = cal.date(byAdding: .day, value: -1, to: day)!
        }
        return n
    }

    var longestStreak: Int {
        let days = records.values.filter { $0.sessions > 0 }.map { $0.date }.sorted()
        let f = DateFormatter(); f.locale = Locale(identifier: "en_US_POSIX"); f.dateFormat = "yyyy-MM-dd"
        var best = 0, run = 0
        var prev: Date?
        for s in days {
            guard let d = f.date(from: s) else { continue }
            if let p = prev, cal.dateComponents([.day], from: p, to: d).day == 1 { run += 1 } else { run = 1 }
            best = max(best, run); prev = d
        }
        return best
    }

    func last(days n: Int) -> [DayRecord] {
        (0..<n).reversed().map { i in
            let d = cal.date(byAdding: .day, value: -i, to: Date())!
            return records[key(d)] ?? DayRecord(date: key(d))
        }
    }

    // MARK: Actions
    func tap() {
        var r = today
        switch currentDhikr {
        case .subhanAllah: r.subhanAllah += 1
        case .alhamdulillah: r.alhamdulillah += 1
        case .allahuAkbar: r.allahuAkbar += 1
        }
        count += 1
        if count >= currentDhikr.target {
            count = 0
            if phase == 2 { phase = 0; r.sessions += 1 } else { phase += 1 }
        }
        records[todayKey] = r
        save()
    }

    func undo() {
        var r = today
        if count == 0 {
            guard phase > 0 else { return }
            phase -= 1
            count = currentDhikr.target
        }
        count -= 1
        switch currentDhikr {
        case .subhanAllah: r.subhanAllah = max(0, r.subhanAllah - 1)
        case .alhamdulillah: r.alhamdulillah = max(0, r.alhamdulillah - 1)
        case .allahuAkbar: r.allahuAkbar = max(0, r.allahuAkbar - 1)
        }
        records[todayKey] = r
        save()
    }

    func resetSet() { phase = 0; count = 0 }

    func eraseAll() {
        records = [:]; phase = 0; count = 0; save()
    }

    // MARK: Storage
    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let list = try? JSONDecoder().decode([DayRecord].self, from: data) else { return }
        records = Dictionary(uniqueKeysWithValues: list.map { ($0.date, $0) })
    }

    private func save() {
        let list = records.values.sorted { $0.date < $1.date }
        let enc = JSONEncoder(); enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? enc.encode(list) { try? data.write(to: fileURL, options: .atomic) }
    }

    // MARK: Export
    func exportJSON() -> Data {
        let list = records.values.sorted { $0.date < $1.date }
        let enc = JSONEncoder(); enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        return (try? enc.encode(list)) ?? Data()
    }

    func exportCSV() -> Data {
        var s = "date,subhanallah,alhamdulillah,allahu_akbar,full_sets\n"
        for r in records.values.sorted(by: { $0.date < $1.date }) {
            s += "\(r.date),\(r.subhanAllah),\(r.alhamdulillah),\(r.allahuAkbar),\(r.sessions)\n"
        }
        return Data(s.utf8)
    }
}
