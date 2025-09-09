import SwiftUI
import SwiftData


struct FortuneProfileFormView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
    }
}

#Preview("light") {
    FortuneProfileFormView()
        .preferredColorScheme(.light)
}

#Preview("dark") {
    FortuneProfileFormView()
        .preferredColorScheme(.dark)
}
