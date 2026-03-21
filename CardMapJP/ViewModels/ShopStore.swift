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
    @Published var inventory: [String: [ShopInventory]] = [:]
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchText = ""
    @Published var activeFilters: Set<ShopFilter> = []
    @Published var userLocation: CLLocation?

    var filteredShops: [Shop] {
        var result = shops

        if !searchText.isEmpty {
            let query = searchText.lowercased()
            result = result.filter {
                ($0.nameEn?.lowercased().contains(query) ?? false) ||
                ($0.nameJp?.contains(query) ?? false) ||
                ($0.addressEn?.lowercased().contains(query) ?? false)
            }
        }

        for filter in activeFilters {
            switch filter {
            case .openNow:
                result = result.filter { $0.openHours?.isOpenNow == true }
            case .englishStaff:
                result = result.filter { $0.englishStaff == true }
            case .psaGraded:
                result = result.filter { $0.sellsPsaGraded == true }
            case .boosterBox:
                result = result.filter { $0.sellsBoosterBox == true }
            case .beginnerFriendly:
                result = result.filter { $0.beginnerFriendly == true }
            }
        }

        if let location = userLocation {
            result.sort { a, b in
                guard let coordA = a.coordinate, let coordB = b.coordinate else { return false }
                let distA = location.distance(from: CLLocation(latitude: coordA.latitude, longitude: coordA.longitude))
                let distB = location.distance(from: CLLocation(latitude: coordB.latitude, longitude: coordB.longitude))
                return distA < distB
            }
        }

        return result
    }

    func shopsForRegion(_ regionSlug: String) -> [Shop] {
        filteredShops.filter { shop in
            guard let regionId = shop.regionId else { return false }
            return regionId == regionSlug
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

            inventory[shopId] = response
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
