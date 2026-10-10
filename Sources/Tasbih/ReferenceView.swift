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
