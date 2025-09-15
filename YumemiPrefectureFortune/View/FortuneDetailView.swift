import SwiftUI

struct FortuneDetailView: View {
    @StateObject var viewModel: FortuneDetailViewModel
    
    var body: some View {
        // TODO: 背景色はプレースホルダーの段階で見やすくするためだけなので実装時は削除
        ScrollView {
            Image("")
                .resizable()
                .frame(height: 200)
                .background(.green)

            HStack {
                Image("")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .background(.red)
                    .clipShape(Circle())
                    .padding(.top, -40)
                    .padding(.leading, 20)
                Spacer()
                Button(action: {
                    // 編集ボタンを押したときの処理
                }) {
                    Text("編集")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    
                }
                .padding(.trailing, 20)
            }
            
            Text("名前")
                .font(.system(size: 32, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack {
                Spacer()
                Text("X型")
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
                /// gift.fillは誕生日のアイコンとする
                /// birthdaycakeは複雑すぎて今回のサイズでは視認性が悪いため却下
                Image(systemName: "gift.fill")
                    .scaleEffect(0.8)
                    .padding(.leading, 20)
                    .padding(.trailing, -8)

                Text("YYYY/MM/DD")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.trailing, 20)
                    .lineLimit(1)
            }
            .padding(.bottom, 8)
            Text("自己紹介\n2行目\n3行目\n4行目")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            /// 高さを取りすぎないように4行に制限
                .lineLimit(4)
            
            
            VStack {
                VStack(spacing: 16) {
                    Text("今日の都道府県")
                        .font(.system(size: 32, weight: .semibold))
                    
                    HStack {
                        VStack {
                            Spacer()
                            Text("XX県")
                                .font(.system(size: 50, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("xx市")
                                .font(.system(size: 35, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        }
                        Image("")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .background(.red)
                            .clipShape(Circle())
                        
                    }
                    
                    Text("Wikipediaによる概要")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)

                    HStack {
                        Text("県民の日")
                            .font(.system(size: 35, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("MM/DD")
                            .font(.system(size: 35, weight: .semibold))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Text("内陸／海沿い")
                        .font(.system(size: 32, weight: .semibold))
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.yellow)
            .cornerRadius(20)
            .padding(20)
        }
        .ignoresSafeArea(edges: .top)
    }
}

#Preview("light") {
    let viewModel = FortuneDetailViewModel(user: SampleUserData.sampleUser)
    FortuneDetailView(viewModel: viewModel)
        .preferredColorScheme(.light)
}

#Preview("dark") {
    let viewModel = FortuneDetailViewModel(user: SampleUserData.sampleUser)
    FortuneDetailView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}
