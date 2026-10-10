import SwiftUI

@main
struct TasbihApp: App {
    @StateObject private var store = TasbihStore()
    @AppStorage("appearance") private var appearance = "system"

    private var scheme: ColorScheme? {
        switch appearance { case "light": return .light; case "dark": return .dark; default: return nil }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(scheme)
                .frame(minWidth: 820, minHeight: 580)
        }
        .commands {
            CommandMenu("Dhikr") {
                Button("Undo last count") { store.undo() }.keyboardShortcut("z", modifiers: .command)
                Button("Reset current set") { store.resetSet() }.keyboardShortcut("r", modifiers: .command)
            }
        }
    }
}
