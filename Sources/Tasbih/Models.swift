import Foundation

enum Dhikr: Int, CaseIterable {
    case subhanAllah, alhamdulillah, allahuAkbar

    var target: Int { self == .allahuAkbar ? 34 : 33 }
    var arabic: String {
        switch self {
        case .subhanAllah: return "سُبْحَانَ ٱللَّٰهِ"
        case .alhamdulillah: return "ٱلْحَمْدُ لِلَّٰهِ"
        case .allahuAkbar: return "ٱللَّٰهُ أَكْبَرُ"
        }
    }
    var transliteration: String {
        switch self {
        case .subhanAllah: return "SubhanAllah"
        case .alhamdulillah: return "Alhamdulillah"
        case .allahuAkbar: return "Allahu Akbar"
        }
    }
    var meaning: String {
        switch self {
        case .subhanAllah: return "Glory be to Allah"
        case .alhamdulillah: return "All praise is due to Allah"
        case .allahuAkbar: return "Allah is the Greatest"
        }
    }
}

struct DayRecord: Codable, Identifiable {
    var id: String { date }
    var date: String                 // yyyy-MM-dd
    var subhanAllah = 0
    var alhamdulillah = 0
    var allahuAkbar = 0
    var sessions = 0                 // completed 33/33/34 sets
    var total: Int { subhanAllah + alhamdulillah + allahuAkbar }
}

struct Benefit: Identifiable {
    let id: Int
    let category: String
    let title: String
    let text: String
    let source: String
}
