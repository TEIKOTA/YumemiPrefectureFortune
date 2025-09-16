import SwiftUI

struct JumpingArrowView: View {
    @State private var offset: CGSize = .zero
    @State private var jump: Bool = false

    var body: some View {
        Image(systemName: "arrow.down.right")
            .font(.system(size: 40, weight: .black))
            .foregroundColor(.secondary)
            .offset(offset)
            .onAppear {
                let jumpAmount: CGFloat = -10
                let duration = 0.9

                Timer.scheduledTimer(withTimeInterval: duration, repeats: true) { _ in
                    withAnimation(.easeInOut(duration: duration)) {
                        
                        offset = jump ? .zero : CGSize(width: jumpAmount, height: jumpAmount)
                        jump.toggle()
                    }
                }
            }
    }
}

#Preview("light") {
    JumpingArrowView()
        .preferredColorScheme(.light)
}

#Preview("dark") {
    JumpingArrowView()
            .preferredColorScheme(.dark)
}
