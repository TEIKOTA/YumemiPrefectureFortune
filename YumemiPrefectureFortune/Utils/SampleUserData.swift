import SwiftData
import UIKit
import Foundation


@MainActor
class SampleUserData {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: UserProfile.self,
                configurations: config
            )
            
            func randomBirthday() -> Date {
                let calendar = Calendar.current
                let year = Int.random(in: 1970...2010)
                let month = Int.random(in: 1...12)
                let day = Int.random(in: 1...28) // 全月対応のため28日まで
                return calendar.date(from: DateComponents(year: year, month: month, day: day))!
            }

            let mockUsers: [UserProfile] = [
                .init(
                    name: "山田 太郎",
                    birthday: randomBirthday(),
                    bloodType: .A,
                    introduction: "よろしくお願いします！",
                    icon: nil
                ),
                .init(
                    name: "鈴木 花子",
                    birthday: randomBirthday(),
                    bloodType: .B,
                    introduction: "nil",
                    icon: UIImage(systemName: "star.fill")?
                        .withTintColor(.yellow, renderingMode: .alwaysOriginal)
                        .pngData()
                ),
                .init(
                    name: "佐藤 次郎",
                    birthday: randomBirthday(),
                    bloodType: .O,
                    introduction: "サッカー大好き！⚽️",
                    icon: UIImage(systemName: "heart.fill")?
                        .withTintColor(.orange, renderingMode: .alwaysOriginal)
                        .pngData()
                ),
                .init(
                    name: "田渕 貴之",
                    birthday: randomBirthday(),
                    bloodType: .AB,
                    introduction: "音楽とコーヒー☕️",
                    icon: UIImage(systemName: "music.note")?
                        .withTintColor(.purple, renderingMode: .alwaysOriginal)
                        .pngData()
                )
            ]

            mockUsers.forEach { user in
                container.mainContext.insert(user)
            }

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}
