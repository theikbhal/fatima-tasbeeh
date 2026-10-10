import SwiftUI

enum Page: String, CaseIterable, Identifiable {
    case counter = "Counter", benefits = "Benefits", history = "History", settings = "Settings", help = "Help"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .counter: return "circle.dotted"
        case .benefits: return "book.closed"
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
            .navigationSplitViewColumnWidth(min: 160, ideal: 180)
        } detail: {
            switch selection ?? .counter {
            case .counter: CounterView()
            case .benefits: BenefitsView()
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
