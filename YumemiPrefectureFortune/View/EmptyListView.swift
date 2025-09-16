import SwiftUI

struct EmptyListView: View {
    @State private var stars: [Star] = []
    let starCount = 10
    let margin: CGFloat = 20

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            ForEach(stars) { star in
                Image(systemName: "star.fill")
                    .foregroundColor(.accent)
                    .frame(width: star.size, height: star.size)
                    .position(x: star.x, y: star.y)
                    .opacity(star.opacity)
                    .animation(.easeInOut(duration: 0.5), value: star.opacity)
            }

            VStack(spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(.accent)
                
                Text("プロフィールを入力して\nぴったりの都道府県を占おう！")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height

            // 星の初期生成
            for _ in 0..<starCount {
                let star = Star(
                    x: CGFloat.random(in: margin...(screenWidth - margin)),
                    y: CGFloat.random(in: margin...(screenHeight - margin)),
                    size: CGFloat.random(in: 4...10),
                    opacity: 0.0
                )
                stars.append(star)
                scheduleStarToggle(for: star.id, screenWidth: screenWidth, screenHeight: screenHeight)
            }
        }
    }
    
    func scheduleStarToggle(for id: UUID, screenWidth: CGFloat, screenHeight: CGFloat) {
        let duration = Double.random(in: 1.0...3.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            if let index = stars.firstIndex(where: { $0.id == id }) {
                if stars[index].opacity > 0 {
                    withAnimation(.easeOut(duration: 0.5)) {
                        stars[index].opacity = 0.0
                    }
                } else {
                    stars[index].x = CGFloat.random(in: margin...(screenWidth - margin))
                    stars[index].y = CGFloat.random(in: margin...(screenHeight - margin))
                    withAnimation(.easeIn(duration: 0.5)) {
                        stars[index].opacity = 1.0

                    }
                }

                scheduleStarToggle(for: id, screenWidth: screenWidth, screenHeight: screenHeight)
            }
        }
    }
}

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
}

#Preview {
    EmptyListView()
}
