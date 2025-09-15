import SwiftUI

struct FortuneDetailView: View {
    @StateObject var viewModel: FortuneDetailViewModel
    
    var body: some View {
        // TODO: 背景色はプレースホルダーの段階で見やすくするためだけなので実装時は削除
        ScrollView {
            if let headerImage = viewModel.headerImage {
                Image(uiImage: headerImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            } else {
                // 画像読み込み中のプレースホルダー
                Rectangle()
                    .fill(Color(UIColor.systemGray4))
                    .frame(height: 180)
                    .overlay {
                        ProgressView()
                            .padding(.top, 40)
                    }
            }
            HStack {
                if let iconData = viewModel.user.icon, let uiImage = UIImage(data: iconData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding(.top, -40)
                        .padding(.leading, 20)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(UIColor.placeholderText))
                        .background()
                        .clipShape(Circle())
                        .padding(.top, -40)
                        .padding(.leading, 20)
                }
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
            
            Text(viewModel.user.name)
                .font(.system(size: 32, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack {
                Spacer()
                Text(viewModel.user.bloodType.displayName + "型")
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(1)
                /// gift.fillは誕生日のアイコンとする
                /// birthdaycakeは複雑すぎて今回のサイズでは視認性が悪いため却下
                Image(systemName: "gift.fill")
                    .scaleEffect(0.8)
                    .padding(.leading, 20)
                    .padding(.trailing, -8)
                
                Text(formatDate(viewModel.user.birthday))
                    .font(.system(size: 16, weight: .medium))
                    .padding(.trailing, 20)
                    .lineLimit(1)
            }
            .padding(.bottom, 8)
            Text(viewModel.user.introduction ?? "")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            /// 高さを取りすぎないように4行に制限
                .lineLimit(4)
            
            if let result = viewModel.user.fortuneResult {
                VStack(spacing: 16) {
                    Text("今日の都道府県")
                        .font(.system(size: 32, weight: .semibold))
                    
                    HStack {
                        VStack {
                            Spacer()
                            Text(result.prefecture.name)
                                .font(.system(size: 50, weight: .bold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(result.prefecture.capital)
                                .font(.system(size: 35, weight: .medium))
                                .frame(maxWidth: .infinity, alignment: .center)
                            Spacer()
                        }
                        if let iconImage = viewModel.logoImage {
                            Image(uiImage: iconImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(.clear)
                                .frame(width: 100, height: 100)
                                .overlay {
                                    ProgressView()
                                }
                        }
                    }
                    
                    Text(result.prefecture.brief)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    if let citizenDay = result.prefecture.citizenDay {
                        HStack {
                            Text("県民の日")
                                .font(.system(size: 35, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(formatMonthDay(citizenDay))
                                .font(.system(size: 35, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    Text(result.prefecture.hasCoastLine ? "海沿い" : "内陸")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(.background)
                .cornerRadius(20)
                .padding(20)
                .shadow(color:.primary.opacity(0.4), radius: 10, x: 0, y: 4)
            } else {
                ProgressView()
                    .padding(30)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/M/d"
        return formatter.string(from: date)
    }
    
    func formatMonthDay(_ monthDay: MonthDay) -> String {
        return("\(monthDay.month)/\(monthDay.day)")
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
