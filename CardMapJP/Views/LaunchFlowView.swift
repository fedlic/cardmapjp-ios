import SwiftUI

struct LaunchFlowView: View {
    @State private var opacity: Double = 0
    @State private var showContent = false

    var body: some View {
        if showContent {
            MainTabView()
        } else {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Image("AppIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 22))

                    Text("CARDMAP JP")
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: "#CC0000"))
                        .tracking(4)
                }
            }
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 0.6)) {
                    opacity = 1.0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        showContent = true
                    }
                }
            }
        }
    }
}

// MARK: - Color hex extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 6:
            (r, g, b, a) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8:
            (r, g, b, a) = (int >> 24 & 0xFF, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b, a) = (0, 0, 0, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
