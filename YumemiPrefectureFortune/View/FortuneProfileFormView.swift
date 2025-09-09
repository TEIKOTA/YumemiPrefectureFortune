import SwiftUI
import SwiftData


struct FortuneProfileFormView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
    }
}

#Preview("light") {
    PreviewSheetWrapper()
        .preferredColorScheme(.light)
}

#Preview("dark") {
    PreviewSheetWrapper()
        .preferredColorScheme(.dark)
}

struct PreviewSheetWrapper: View {
    @State private var showSheet = true
    
    var body: some View {
        EmptyView()
            .sheet(isPresented: $showSheet) {
            FortuneProfileFormView()
        }
    }
}
