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
