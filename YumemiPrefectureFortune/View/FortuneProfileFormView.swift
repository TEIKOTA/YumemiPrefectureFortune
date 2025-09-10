import SwiftUI
import SwiftData


struct FortuneProfileFormView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                HStack {
                    Text("名前")
                        .frame(width: 80, alignment: .leading)
                    // 名前入力欄
                    Spacer()
                }
                HStack {
                    Text("血液型")
                        .frame(width: 80, alignment: .leading)
                    // 血液型入力欄
                    Spacer()
                }
                HStack {
                    Text("生年月日")
                        .frame(width: 80, alignment: .leading)
                    // 生年月日入力欄
                    Spacer()
                }
                HStack {
                    Text("自己紹介")
                        .frame(width: 80, alignment: .leading)
                    // 自己紹介入力欄
                    Spacer()
                }
                Spacer()
                
            }
            .padding(24)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        // キャンセル処理
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        // 保存処理
                    } label: {
                        Text("保存")
                    }
                }
            }
        }
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
        Text("Preview")
            .sheet(isPresented: $showSheet) {
                FortuneProfileFormView()
                    .presentationCornerRadius(24)
            }
    }
}
