import SwiftUI

struct TutorialView: View {
    @AppStorage("hasSeenTutorial") var hasSeenTutorial: Bool = false

    @State private var isVisible = true
    @State private var isDismissEnabled = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    if isDismissEnabled {
                        hasSeenTutorial = true
                    }
                }

            VStack(spacing: 20) {
                Text("できること")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 40)

                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        Image(systemName: "pencil.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                        Text("プロフィールを編集できます")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)

                    HStack {
                        Image(systemName: "chevron.backward.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                        Text("ユーザーリストに戻ります")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)
                    
                    HStack {
                        Image(systemName: "moon.stars.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                        Text("今日の占いを表示します")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 30)

                }

                Spacer()

                Text("画面のどこかをタップして閉じる")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 50)
                    .opacity(isVisible ? 0.8 : 0.3)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isVisible.toggle()
                        }
                    }
            }
            .padding(.top, 100)
            .onAppear {
                /// 1秒後にボタンを有効化
                /// 画面遷移直後の誤タップを防ぐため
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isDismissEnabled = true
                }
            }
        }
    }
}

#Preview {
    TutorialView()
}
