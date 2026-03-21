import Foundation

struct ShopInventory: Codable, Identifiable {
    let id: String
    let shopId: String
    let category: String
    let availability: String
    let priceRangeMin: Int?
    let priceRangeMax: Int?
    let notesEn: String?
    let lastVerifiedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case shopId = "shop_id"
        case category
        case availability
        case priceRangeMin = "price_range_min"
        case priceRangeMax = "price_range_max"
        case notesEn = "notes_en"
        case lastVerifiedAt = "last_verified_at"
    }

    var categoryLabel: String {
        Self.categoryLabels[category] ?? category
    }

    var categoryIcon: String {
        Self.categoryIcons[category] ?? "📦"
    }

    var availabilityLabel: String {
        Self.availabilityLabels[availability] ?? availability
    }

    var priceRangeText: String? {
        guard let min = priceRangeMin else { return nil }
        if let max = priceRangeMax {
            return "¥\(min.formatted()) - ¥\(max.formatted())"
        }
        return "¥\(min.formatted())~"
    }

    static let categoryLabels: [String: String] = [
        "booster_box": "Booster Box",
        "sealed_pack": "Sealed Pack",
        "single_common": "Singles (Common)",
        "single_rare": "Singles (Rare)",
        "single_sr": "Singles (SR/SAR)",
        "single_sar": "Singles (Art Rare)",
        "psa_graded": "PSA Graded",
        "bgs_graded": "BGS Graded",
        "vintage_pack": "Vintage Pack",
        "vintage_box": "Vintage Box",
        "oripa": "Oripa",
        "deck": "Deck",
        "accessories": "Accessories",
    ]

    static let categoryIcons: [String: String] = [
        "booster_box": "📦",
        "sealed_pack": "🎴",
        "single_common": "🃏",
        "single_rare": "⭐",
        "single_sr": "💎",
        "single_sar": "🎨",
        "psa_graded": "🏆",
        "bgs_graded": "🥇",
        "vintage_pack": "📜",
        "vintage_box": "🗃️",
        "oripa": "🎰",
        "deck": "🎯",
        "accessories": "🛡️",
    ]

    static let availabilityLabels: [String: String] = [
        "in_stock": "In Stock",
        "limited": "Limited",
        "sold_out": "Sold Out",
        "unknown": "Unknown",
    ]
}
