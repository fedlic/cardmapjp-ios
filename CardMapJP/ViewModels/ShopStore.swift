import Foundation
import CoreLocation
import Combine

enum ShopFilter: String, CaseIterable {
    case openNow = "Open Now"
    case englishStaff = "EN Staff"
    case psaGraded = "PSA"
    case boosterBox = "BOX"
    case beginnerFriendly = "Beginner"
}

@MainActor
class ShopStore: ObservableObject {
    @Published var shops: [Shop] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText = ""
    @Published var activeFilters: Set<ShopFilter> = []
    @Published var userLocation: CLLocation?

    /// Cached filtered/sorted shops — recomputed only when inputs change.
    @Published private(set) var filteredShops: [Shop] = []

    /// LRU inventory cache with a max size to prevent unbounded growth.
    private var inventory: [String: [ShopInventory]] = [:]
    private var inventoryAccessOrder: [String] = []
    private let maxInventoryCacheSize = 20

    private var cancellables = Set<AnyCancellable>()

    /// Pre-computed distance cache to avoid creating CLLocation objects on every sort.
    private var distanceCache: [String: Double] = [:]

    init() {
        // Recompute filteredShops only when inputs actually change, debounced.
        Publishers.CombineLatest4(
            $shops,
            $searchText.debounce(for: .milliseconds(300), scheduler: RunLoop.main),
            $activeFilters,
            $userLocation
                .removeDuplicates { a, b in
                    // Only recalculate when the user has moved more than 50m.
                    guard let a, let b else { return a == nil && b == nil }
                    return a.distance(from: b) < 50
                }
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] shops, searchText, activeFilters, userLocation in
            self?.recomputeFilteredShops(
                shops: shops,
                searchText: searchText,
                activeFilters: activeFilters,
                userLocation: userLocation
            )
        }
        .store(in: &cancellables)
    }

    private func recomputeFilteredShops(
        shops: [Shop],
        searchText: String,
        activeFilters: Set<ShopFilter>,
        userLocation: CLLocation?
    ) {
        var result = shops

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                ($0.nameEn?.lowercased().contains(query) ?? false) ||
                ($0.nameJp?.contains(query) ?? false) ||
                ($0.addressEn?.lowercased().contains(query) ?? false)
            }
        }

        if !activeFilters.isEmpty {
            result = result.filter { shop in
                activeFilters.allSatisfy { filter in
                    switch filter {
                    case .openNow: return shop.openHours?.isOpenNow == true
                    case .englishStaff: return shop.englishStaff == true
                    case .psaGraded: return shop.sellsPsaGraded == true
                    case .boosterBox: return shop.sellsBoosterBox == true
                    case .beginnerFriendly: return shop.beginnerFriendly == true
                    }
                }
            }
        }

        if let location = userLocation {
            // Rebuild distance cache once, not per-comparison.
            distanceCache.removeAll(keepingCapacity: true)
            for shop in result {
                if let coord = shop.coordinate {
                    distanceCache[shop.id] = location.distance(
                        from: CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                    )
                }
            }
            result.sort { a, b in
                (distanceCache[a.id] ?? .greatestFiniteMagnitude) <
                (distanceCache[b.id] ?? .greatestFiniteMagnitude)
            }
        }

        filteredShops = result
    }

    func shopsForRegion(_ region: Region) -> [Shop] {
        filteredShops.filter { shop in
            guard let regionId = shop.regionId else { return false }
            return regionId == region.regionId
        }
    }

    func fetchShops() async {
        isLoading = true
        error = nil

        do {
            let response: [Shop] = try await supabase
                .from("shops_with_coords")
                .select()
                .eq("is_active", value: true)
                .order("name_en")
                .execute()
                .value

            shops = response
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func inventoryForShop(_ shopId: String) -> [ShopInventory]? {
        inventory[shopId]
    }

    func fetchInventory(for shopId: String) async {
        guard inventory[shopId] == nil else { return }

        do {
            let response: [ShopInventory] = try await supabase
                .from("shop_inventory")
                .select()
                .eq("shop_id", value: shopId)
                .order("category")
                .execute()
                .value

            // Evict oldest entries if cache is full.
            if inventoryAccessOrder.count >= maxInventoryCacheSize {
                let evictId = inventoryAccessOrder.removeFirst()
                inventory.removeValue(forKey: evictId)
            }
            inventory[shopId] = response
            inventoryAccessOrder.append(shopId)
        } catch {
            print("Failed to fetch inventory: \(error)")
        }
    }

    func toggleFilter(_ filter: ShopFilter) {
        if activeFilters.contains(filter) {
            activeFilters.remove(filter)
        } else {
            activeFilters.insert(filter)
        }
    }

    func distance(to shop: Shop) -> Double? {
        if let cached = distanceCache[shop.id] { return cached }
        guard let location = userLocation, let coord = shop.coordinate else { return nil }
        return location.distance(from: CLLocation(latitude: coord.latitude, longitude: coord.longitude))
    }

    func formattedDistance(to shop: Shop) -> String? {
        guard let dist = distance(to: shop) else { return nil }
        if dist < 1000 {
            return "\(Int(dist))m"
        }
        return String(format: "%.1f km", dist / 1000)
    }
}
