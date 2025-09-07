import Foundation

/// APIはスネークケースのためキャメルケースにデコードの際は以下のように記述することで解決
/// decoder.keyDecodingStrategy = .convertFromSnakeCase

struct Prefecture: Decodable {
    let name: String
    let capital: String
    let citizenDay: MonthDay?
    let logoUrl: URL
    let brief: String
    let hasCoastLine: Bool
}

struct MonthDay: Decodable {
    let month: Int
    let day: Int
}
