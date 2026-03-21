import Foundation
import CoreLocation

struct Shop: Codable, Identifiable, Hashable {
    let id: String
    let nameJp: String?
    let nameEn: String?
    let regionId: String?
    let buildingId: String?
    let floor: Int?
    let floorLabel: String?
    let addressJp: String?
    let addressEn: String?
    let lat: Double?
    let lng: Double?
    let googlePlaceId: String?
    let phone: String?
    let websiteUrl: String?
    let twitterHandle: String?
    let instagramHandle: String?
    let openHours: OpenHours?
    let englishStaff: Bool?
    let englishStaffDays: String?
    let paymentMethods: [String]?
    let atmNearby: Bool?
    let atmNote: String?
    let beginnerFriendly: Bool?
    let sellsSingles: Bool?
    let sellsBoosterBox: Bool?
    let sellsSealedPack: Bool?
    let sellsPsaGraded: Bool?
    let sellsRawRare: Bool?
    let sellsOripa: Bool?
    let sellsEnglishCards: Bool?
    let sellsVintage: Bool?
    let aiSummary: String?
    let aiSummaryUpdatedAt: String?
    let visitorTips: String?
    let ratingAvg: Double?
    let reviewCount: Int?
    let googleRating: Double?
    let googleReviewCount: Int?
    let isActive: Bool?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameJp = "name_jp"
        case nameEn = "name_en"
        case regionId = "region_id"
        case buildingId = "building_id"
        case floor
        case floorLabel = "floor_label"
        case addressJp = "address_jp"
        case addressEn = "address_en"
        case lat, lng
        case googlePlaceId = "google_place_id"
        case phone
        case websiteUrl = "website_url"
        case twitterHandle = "twitter_handle"
        case instagramHandle = "instagram_handle"
        case openHours = "open_hours"
        case englishStaff = "english_staff"
        case englishStaffDays = "english_staff_days"
        case paymentMethods = "payment_methods"
        case atmNearby = "atm_nearby"
        case atmNote = "atm_note"
        case beginnerFriendly = "beginner_friendly"
        case sellsSingles = "sells_singles"
        case sellsBoosterBox = "sells_booster_box"
        case sellsSealedPack = "sells_sealed_pack"
        case sellsPsaGraded = "sells_psa_graded"
        case sellsRawRare = "sells_raw_rare"
        case sellsOripa = "sells_oripa"
        case sellsEnglishCards = "sells_english_cards"
        case sellsVintage = "sells_vintage"
        case aiSummary = "ai_summary"
        case aiSummaryUpdatedAt = "ai_summary_updated_at"
        case visitorTips = "visitor_tips"
        case ratingAvg = "rating_avg"
        case reviewCount = "review_count"
        case googleRating = "google_rating"
        case googleReviewCount = "google_review_count"
        case isActive = "is_active"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    var coordinate: CLLocationCoordinate2D? {
        guard let lat, let lng else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }

    var displayName: String {
        nameEn ?? nameJp ?? "Unknown Shop"
    }

    var displayNameJp: String {
        nameJp ?? ""
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Shop, rhs: Shop) -> Bool {
        lhs.id == rhs.id
    }
}

struct OpenHours: Codable {
    let monday: DayHours?
    let tuesday: DayHours?
    let wednesday: DayHours?
    let thursday: DayHours?
    let friday: DayHours?
    let saturday: DayHours?
    let sunday: DayHours?

    func hours(for dayOfWeek: Int) -> DayHours? {
        switch dayOfWeek {
        case 1: return sunday
        case 2: return monday
        case 3: return tuesday
        case 4: return wednesday
        case 5: return thursday
        case 6: return friday
        case 7: return saturday
        default: return nil
        }
    }

    var isOpenNow: Bool? {
        let calendar = Calendar.current
        let now = Date()
        let dayOfWeek = calendar.component(.weekday, from: now)
        guard let todayHours = hours(for: dayOfWeek) else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")

        guard let openTime = formatter.date(from: todayHours.open),
              let closeTime = formatter.date(from: todayHours.close) else { return nil }

        let nowComponents = calendar.dateComponents(in: TimeZone(identifier: "Asia/Tokyo")!, from: now)
        let nowMinutes = (nowComponents.hour ?? 0) * 60 + (nowComponents.minute ?? 0)

        let openComponents = calendar.dateComponents([.hour, .minute], from: openTime)
        let openMinutes = (openComponents.hour ?? 0) * 60 + (openComponents.minute ?? 0)

        let closeComponents = calendar.dateComponents([.hour, .minute], from: closeTime)
        let closeMinutes = (closeComponents.hour ?? 0) * 60 + (closeComponents.minute ?? 0)

        if closeMinutes > openMinutes {
            return nowMinutes >= openMinutes && nowMinutes < closeMinutes
        } else {
            return nowMinutes >= openMinutes || nowMinutes < closeMinutes
        }
    }
}

struct DayHours: Codable {
    let open: String
    let close: String
}
