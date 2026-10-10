import Foundation
import UserNotifications

enum Notifier {
    static func schedule(enabled: Bool, minutesAfterMidnight: Int) {
        guard Bundle.main.bundleIdentifier != nil else { return } // needs the packaged .app
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily-dhikr"])
        guard enabled else { return }
        center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = "Time for dhikr"
            content.body = "SubhanAllah 33 · Alhamdulillah 33 · Allahu Akbar 34"
            content.sound = .default
            var dc = DateComponents()
            dc.hour = minutesAfterMidnight / 60
            dc.minute = minutesAfterMidnight % 60
            let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
            center.add(UNNotificationRequest(identifier: "daily-dhikr", content: content, trigger: trigger))
        }
    }
}
