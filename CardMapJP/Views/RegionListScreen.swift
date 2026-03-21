import SwiftUI

struct RegionListScreen: View {
    @EnvironmentObject var shopStore: ShopStore

    private var groupedRegions: [(String, [Region])] {
        let grouped = Dictionary(grouping: Region.all) { $0.prefecture }
        return grouped.sorted { a, b in
            let order = ["Tokyo", "Kanagawa", "Saitama", "Chiba", "Osaka", "Kyoto", "Hyogo", "Aichi", "Fukuoka", "Kumamoto", "Okinawa", "Hiroshima", "Okayama", "Niigata", "Ishikawa", "Hokkaido", "Miyagi"]
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
                                RegionRow(region: region, shopCount: shopStore.shopsForRegion(region.slug).count)
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
        shopStore.shopsForRegion(region.slug)
    }

    var body: some View {
        List(shops) { shop in
            NavigationLink(value: shop) {
                ShopRow(shop: shop)
            }
        }
        .listStyle(.plain)
        .navigationTitle("\(region.nameEn) (\(region.nameJp))")
        .navigationDestination(for: Shop.self) { shop in
            ShopDetailScreen(shop: shop)
        }
        .overlay {
            if shops.isEmpty {
                ContentUnavailableView(
                    "No shops in this region",
                    systemImage: "mappin.slash"
                )
            }
        }
    }
}
