import SwiftUI

struct CounterView: View {
    @EnvironmentObject var store: TasbihStore

    var body: some View {
        let d = store.currentDhikr
        VStack(spacing: 18) {
            HStack {
                Label("\(store.streak)-day streak", systemImage: "flame.fill").foregroundStyle(.orange)
                Spacer()
                Text("Today: \(store.today.sessions) full set\(store.today.sessions == 1 ? "" : "s") · \(store.today.total) total")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(d.arabic).font(.system(size: 56))
            Text(d.transliteration).font(.title2.weight(.semibold))
            Text(d.meaning).foregroundStyle(.secondary)

            Button { store.tap() } label: {
                ZStack {
                    Circle().stroke(.quaternary, lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: CGFloat(store.count) / CGFloat(d.target))
                        .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 0.15), value: store.count)
                    VStack {
                        Text("\(store.count)").font(.system(size: 72, weight: .bold, design: .rounded))
                        Text("of \(d.target)").foregroundStyle(.secondary)
                    }
                }
                .frame(width: 240, height: 240)
                .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .keyboardShortcut(.space, modifiers: [])

            HStack(spacing: 8) {
                ForEach(Dhikr.allCases, id: \.rawValue) { x in
                    Capsule().fill(x.rawValue <= store.phase ? Color.accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 40, height: 6)
                }
            }
            HStack {
                Button("Undo") { store.undo() }
                Button("Reset set") { store.resetSet() }
            }
            Text("Click the circle or press Space to count").font(.caption).foregroundStyle(.secondary)
            Spacer()
        }
        .padding(30)
    }
}
