import SwiftUI

struct SplashScreen: View {
    @State private var iconScale: CGFloat = 0.5
    @State private var iconOpacity: Double = 0
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.89, green: 0.20, blue: 0.05),
                    Color(red: 0.75, green: 0.12, blue: 0.03),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // App icon
                Image("AppIconImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
                    .scaleEffect(iconScale)
                    .opacity(iconOpacity)

                // Title
                VStack(spacing: 8) {
                    Text("CardMapJP")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .opacity(titleOpacity)

                    Text("Find Pokemon Card Shops in Japan")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.8))
                        .opacity(subtitleOpacity)
                }

                Spacer()

                // Loading indicator
                HStack(spacing: 8) {
                    ProgressView()
                        .tint(.white.opacity(0.7))
                    Text("Loading shops...")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }
                .opacity(subtitleOpacity)
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                iconScale = 1.0
                iconOpacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.3)) {
                titleOpacity = 1.0
            }

            withAnimation(.easeOut(duration: 0.5).delay(0.6)) {
                subtitleOpacity = 1.0
            }
        }
    }
}
