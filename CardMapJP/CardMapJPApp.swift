import SwiftUI

@main
struct CardMapJPApp: App {
    @StateObject private var shopStore = ShopStore()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .environmentObject(shopStore)

                if showSplash {
                    SplashScreen()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                await shopStore.fetchShops()

                // Show splash for at least 2 seconds
                try? await Task.sleep(for: .seconds(2))

                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}
