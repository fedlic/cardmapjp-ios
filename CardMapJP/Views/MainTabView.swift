import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MapScreen()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            ShopListScreen()
                .tabItem {
                    Label("Shops", systemImage: "list.bullet")
                }
            RegionListScreen()
                .tabItem {
                    Label("Regions", systemImage: "globe.asia.australia.fill")
                }
        }
        .tint(Color(red: 0.89, green: 0.20, blue: 0.05))
    }
}
