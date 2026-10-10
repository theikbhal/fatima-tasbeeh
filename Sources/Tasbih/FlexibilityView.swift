import SwiftUI

struct FlexibilityView: View {
    var body: some View {
        InfoPage(title: "Flexibility", subtitle: "Keep it easy so you can keep it up.") {
            InfoCard(title: "The religion is ease",
                     text: "The Prophet ﷺ taught that the religion is easy, and that whoever makes it harder on himself will be overcome by it. Aim for steady and sustainable.",
                     source: "Sahih al-Bukhari 39")
            InfoCard(title: "Dhikr is not only after prayer",
                     text: "Believers remember Allah standing, sitting and lying on their sides, and Aisha reported that the Prophet ﷺ remembered Allah at all times.",
                     source: "Qur'an 3:191, Sahih Muslim 373")
            InfoCard(title: "Count in more than one sitting",
                     text: "You can do a set in one go or spread it out. The app remembers where you stopped, so you can carry on from the same number later.")
            InfoCard(title: "Other counts and combinations",
                     text: "Narrations mention other ways to complete the dhikr after prayer. This app uses 33 · 33 · 34. If you follow a different one, ask a scholar which is best for you.")
            InfoCard(title: "Make it fit your day",
                     text: "Use Space to count without the mouse, change the reminder time in Settings, and set a weekly goal on the Consistency page that you can realistically meet.")
        }
    }
}
