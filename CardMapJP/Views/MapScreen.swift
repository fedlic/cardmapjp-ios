import SwiftUI
import MapKit

struct MapScreen: View {
    @EnvironmentObject var shopStore: ShopStore
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731), // Akihabara
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )
    @State private var selectedShop: Shop?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $position, selection: $selectedShop) {
                    UserAnnotation()

                    ForEach(shopStore.filteredShops) { shop in
                        if let coord = shop.coordinate {
                            Marker(
                                shop.displayName,
                                systemImage: "creditcard.fill",
                                coordinate: coord
                            )
                            .tint(markerColor(for: shop))
                            .tag(shop)
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }

                if let shop = selectedShop {
                    NavigationLink(value: shop) {
                        ShopCardCompact(shop: shop)
                    }
                    .buttonStyle(.plain)
                    .padding()
                    .transition(.move(edge: .bottom))
                }
            }
            .navigationTitle("CardMapJP")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Shop.self) { shop in
                ShopDetailScreen(shop: shop)
            }
            .task {
                locationManager.requestPermission()
                if shopStore.shops.isEmpty {
                    await shopStore.fetchShops()
                }
            }
            .onChange(of: locationManager.location) { _, newLocation in
                shopStore.userLocation = newLocation
            }
            .animation(.easeInOut, value: selectedShop)
        }
    }

    private func markerColor(for shop: Shop) -> Color {
        if shop.englishStaff == true {
            return Color(red: 0.89, green: 0.20, blue: 0.05) // Red for EN staff
        }
        return .blue
    }
}

struct ShopCardCompact: View {
    let shop: Shop
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(shop.displayName)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !shop.displayNameJp.isEmpty {
                    Text(shop.displayNameJp)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 8) {
                    if let rating = shop.googleRating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption2)
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                        }
                    }
                    if shop.englishStaff == true {
                        Badge(text: "EN", color: .blue)
                    }
                    if shop.beginnerFriendly == true {
                        Badge(text: "Beginner OK", color: .green)
                    }
                }
            }

            Spacer()

            if let dist = shopStore.formattedDistance(to: shop) {
                Text(dist)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
