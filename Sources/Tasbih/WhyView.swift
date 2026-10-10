import SwiftUI

struct WhyView: View {
    var body: some View {
        InfoPage(title: "Why Dhikr?", subtitle: "The reasons behind the habit, with sources.") {
            InfoCard(title: "Why remember Allah at all?",
                     text: "\"Verily, in the remembrance of Allah do hearts find rest.\" And: \"So remember Me; I will remember you.\"",
                     source: "Qur'an 13:28, Qur'an 2:152")
            InfoCard(title: "Why after the prayer?",
                     text: "The Prophet ﷺ taught words to say after the obligatory prayers whose sayer is never disappointed.",
                     source: "Sahih Muslim 596")
            InfoCard(title: "Why 33 · 33 · 34?",
                     text: "The narration gives 33 tasbih, 33 tahmid and 34 takbir, which makes 100. Another narration gives 33 of each and completes the hundred with La ilaha illallah wahdahu la sharika lah, lahul-mulku wa lahul-hamd, wa huwa ala kulli shay'in qadir. Authentic narrations also report other combinations, so ask a scholar if you want to follow a specific one.",
                     source: "Sahih Muslim 596, Sahih Muslim 597")
            InfoCard(title: "Why does it matter?",
                     text: "The reward is described as forgiveness of sins like the foam of the sea, and the poor companions were told it would raise them to the rank of those who gave in charity. See the Benefits page for more.",
                     source: "Sahih Muslim 597, Sahih al-Bukhari 843")
            InfoCard(title: "Why count?",
                     text: "A fixed number keeps your mind on the words instead of on how many are left, and a daily record turns a good intention into a habit you can see.")
        }
    }
}
