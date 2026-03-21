import SwiftUI

struct ShopListScreen: View {
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ShopFilter.allCases, id: \.self) { filter in
                            FilterChip(
                                title: filter.rawValue,
                                isActive: shopStore.activeFilters.contains(filter)
                            ) {
                                shopStore.toggleFilter(filter)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                Divider()

                if shopStore.isLoading {
                    Spacer()
                    ProgressView("Loading shops...")
                    Spacer()
                } else if shopStore.filteredShops.isEmpty {
                    ContentUnavailableView(
                        "No shops found",
                        systemImage: "magnifyingglass",
                        description: Text("Try adjusting your search or filters")
                    )
                } else {
                    List(shopStore.filteredShops) { shop in
                        NavigationLink(value: shop) {
                            ShopRow(shop: shop)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Shops")
            .navigationDestination(for: Shop.self) { shop in
                ShopDetailScreen(shop: shop)
            }
            .searchable(text: $shopStore.searchText, prompt: "Search shops...")
            .task {
                if shopStore.shops.isEmpty {
                    await shopStore.fetchShops()
                }
            }
        }
    }
}

struct ShopRow: View {
    let shop: Shop
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(shop.displayName)
                    .font(.headline)
                Spacer()
                if let dist = shopStore.formattedDistance(to: shop) {
                    Text(dist)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !shop.displayNameJp.isEmpty {
                Text(shop.displayNameJp)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 6) {
                if let rating = shop.googleRating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption2)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                        if let count = shop.googleReviewCount {
                            Text("(\(count))")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if shop.englishStaff == true {
                    Badge(text: "EN", color: .blue)
                }
                if shop.beginnerFriendly == true {
                    Badge(text: "Beginner", color: .green)
                }
                if shop.sellsPsaGraded == true {
                    Badge(text: "PSA", color: .purple)
                }
                if shop.sellsEnglishCards == true {
                    Badge(text: "English Cards", color: .orange)
                }

                if shop.openHours?.isOpenNow == true {
                    Badge(text: "Open", color: .green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct FilterChip: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isActive ? Color(red: 0.89, green: 0.20, blue: 0.05) : Color(.secondarySystemGroupedBackground))
                .foregroundStyle(isActive ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}

struct Badge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}
