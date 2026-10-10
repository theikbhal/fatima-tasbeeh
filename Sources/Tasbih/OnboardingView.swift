import SwiftUI

struct OnboardingView: View {
    var done: () -> Void
    @State private var page = 0

    private let pages: [(String, String, String)] = [
        ("circle.dotted", "Welcome", "A simple, private tasbih counter for after-prayer dhikr. Everything stays on your Mac."),
        ("number", "33 · 33 · 34", "Count SubhanAllah 33, Alhamdulillah 33 and Allahu Akbar 34. The app moves to the next phrase automatically."),
        ("flame.fill", "Build a streak", "Finish a full set each day to grow your streak. Turn on a daily reminder in Settings.")
    ]

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: pages[page].0).font(.system(size: 54)).foregroundStyle(Color.accentColor)
            Text(pages[page].1).font(.largeTitle.bold())
            Text(pages[page].2).multilineTextAlignment(.center).foregroundStyle(.secondary).frame(maxWidth: 360)
            HStack {
                ForEach(0..<pages.count, id: \.self) { i in
                    Circle().fill(i == page ? Color.accentColor : Color.secondary.opacity(0.3)).frame(width: 8, height: 8)
                }
            }
            Button(page == pages.count - 1 ? "Get started" : "Next") {
                if page == pages.count - 1 { done() } else { page += 1 }
            }
            .keyboardShortcut(.defaultAction)
        }
        .padding(40)
        .frame(width: 480, height: 400)
    }
}
