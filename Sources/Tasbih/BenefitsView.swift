import SwiftUI

struct BenefitsView: View {
    @State private var query = ""
    @State private var open: Set<Int> = []

    private var filtered: [Benefit] {
        guard !query.isEmpty else { return allBenefits }
        return allBenefits.filter {
            ($0.title + $0.text + $0.source + $0.category).localizedCaseInsensitiveContains(query)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Benefits of Dhikr").font(.largeTitle.bold())
            HStack {
                Text("\(allBenefits.count) of \(benefitsTarget) verified entries")
                    .font(.callout).foregroundStyle(.secondary)
                ProgressView(value: Double(allBenefits.count), total: Double(benefitsTarget)).frame(width: 140)
            }
            TextField("Search benefits, sources…", text: $query).textFieldStyle(.roundedBorder)
            List {
                ForEach(Dictionary(grouping: filtered, by: \.category).keys.sorted(), id: \.self) { cat in
                    SwiftUI.Section(cat) {
                        ForEach(filtered.filter { $0.category == cat }) { b in
                            DisclosureGroup(isExpanded: Binding(
                                get: { open.contains(b.id) },
                                set: { if $0 { open.insert(b.id) } else { open.remove(b.id) } })) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(b.text)
                                    Label(b.source, systemImage: "bookmark").font(.caption).foregroundStyle(.secondary)
                                }.padding(.vertical, 4)
                            } label: { Text(b.title).font(.headline) }
                        }
                    }
                }
            }
        }
        .padding(24)
    }
}
