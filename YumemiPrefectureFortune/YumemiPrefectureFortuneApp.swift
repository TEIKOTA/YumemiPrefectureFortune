import SwiftUI
import SwiftData


@main
struct YumemiPrefectureFortuneApp: App {
    var sharedModelContainer: ModelContainer = {
        // UIテスト実行中は、サンプルデータを含むインメモリコンテナを返す
        if ProcessInfo.processInfo.arguments.contains("-UITesting") {
            return SampleUserData.previewContainer
        }
        
        // 通常起動時は、永続化コンテナを返す
        let schema = Schema([
            UserProfile.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FortuneUserListView()
        }
        .modelContainer(sharedModelContainer)
    }
}