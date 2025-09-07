import Foundation


struct Prefecture {
    var name: String
    var capital: String
    var citizenDay: MonthDay?
    var logoURL: URL
    var brief: String
    var hasCoastLine: Bool
}

struct MonthDay {
    var month: Int
    var day: Int
}
