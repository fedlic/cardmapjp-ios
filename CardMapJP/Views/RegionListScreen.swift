import SwiftUI
import MapKit

struct RegionListScreen: View {
    @EnvironmentObject var shopStore: ShopStore

    private var groupedRegions: [(String, [Region])] {
        let grouped = Dictionary(grouping: Region.all) { $0.prefecture }
        let order = ["Tokyo", "Kanagawa", "Saitama", "Chiba", "Osaka", "Kyoto", "Hyogo", "Aichi", "Fukuoka", "Kumamoto", "Okinawa", "Hiroshima", "Okayama", "Niigata", "Ishikawa", "Hokkaido", "Miyagi"]
        return grouped.sorted { a, b in
            let indexA = order.firstIndex(of: a.key) ?? 99
            let indexB = order.firstIndex(of: b.key) ?? 99
            return indexA < indexB
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedRegions, id: \.0) { prefecture, regions in
                    Section(prefecture) {
                        ForEach(regions) { region in
                            NavigationLink(value: region) {
                                RegionRow(region: region, shopCount: shopStore.shopsForRegion(region).count)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Regions")
            .navigationDestination(for: Region.self) { region in
                RegionDetailScreen(region: region)
            }
            .task {
                if shopStore.shops.isEmpty {
                    await shopStore.fetchShops()
                }
            }
        }
    }
}

struct RegionRow: View {
    let region: Region
    let shopCount: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(region.nameEn)
                    .font(.headline)
                Text(region.nameJp)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if shopCount > 0 {
                Text("\(shopCount) shops")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct RegionDetailScreen: View {
    let region: Region
    @EnvironmentObject var shopStore: ShopStore

    var shops: [Shop] {
        shopStore.shopsForRegion(region)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero
                VStack(alignment: .leading, spacing: 8) {
                    Text(region.nameJp)
                        .font(.largeTitle.weight(.bold))
                    Text(region.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        Label("\(shops.count) shops", systemImage: "mappin.circle.fill")
                        let enCount = shops.filter { $0.englishStaff == true }.count
                        if enCount > 0 {
                            Label("\(enCount) EN staff", systemImage: "globe")
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Map preview
                Map {
                    ForEach(shops) { shop in
                        if let coord = shop.coordinate {
                            Marker(shop.displayName, coordinate: coord)
                                .tint(.red)
                        }
                    }
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // About
                if !region.description.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("About", systemImage: "info.circle.fill")
                            .font(.headline)
                        ForEach(region.description, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(.body)
                        }
                    }
                    .padding(.horizontal)
                }

                // Getting There
                if !region.gettingThere.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Getting There", systemImage: "tram.fill")
                            .font(.headline)
                        ForEach(Array(region.gettingThere.enumerated()), id: \.offset) { _, transit in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(transit.line)
                                    .font(.subheadline.weight(.semibold))
                                if !transit.station.isEmpty {
                                    Text(transit.station)
                                        .font(.caption)
                                        .foregroundStyle(.blue)
                                }
                                Text(transit.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal)
                }

                // Tips
                if !region.tips.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Visitor Tips", systemImage: "lightbulb.fill")
                            .font(.headline)
                        ForEach(Array(region.tips.enumerated()), id: \.offset) { _, tip in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(tip.title)
                                    .font(.subheadline.weight(.semibold))
                                Text(tip.body)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.secondary.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .padding(.horizontal)
                }

                // Shop list
                VStack(alignment: .leading, spacing: 12) {
                    Label("Shops (\(shops.count))", systemImage: "list.bullet")
                        .font(.headline)
                        .padding(.horizontal)

                    if shops.isEmpty {
                        Text("No shops found in this region")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    } else {
                        ForEach(shops) { shop in
                            NavigationLink(value: shop) {
                                RegionShopRow(shop: shop)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(region.nameEn)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Shop.self) { shop in
            RegionShopDetailView(shop: shop)
        }
    }
}

// MARK: - Simple shop row for region list

struct RegionShopRow: View {
    let shop: Shop

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(shop.displayName)
                .font(.subheadline.weight(.medium))
            if !shop.displayNameJp.isEmpty {
                Text(shop.displayNameJp)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                if let rating = shop.googleRating {
                    StarRatingView(rating: rating, starSize: 9)
                    Text(String(format: "%.1f", rating))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                if shop.englishStaff == true {
                    MicroBadge(text: "EN", color: .blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Simple shop detail for region navigation

struct RegionShopDetailView: View {
    let shop: Shop
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(shop.displayName)
                    .font(.title2.weight(.bold))
                if !shop.displayNameJp.isEmpty {
                    Text(shop.displayNameJp)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let address = shop.addressEn ?? shop.addressJp {
                    Label(address, systemImage: "mappin")
                        .font(.subheadline)
                }
                if let summary = shop.aiSummary {
                    Text(summary)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                if let coord = shop.coordinate {
                    Link(destination: URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(coord.latitude),\(coord.longitude)&travelmode=walking")!) {
                        Label("Get Directions", systemImage: "figure.walk")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle(shop.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }
}
