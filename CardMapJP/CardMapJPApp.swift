import SwiftUI

@main
struct CardMapJPApp: App {
    @StateObject private var shopStore = ShopStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(shopStore)
        }
    }
}
