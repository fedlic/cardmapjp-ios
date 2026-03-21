import Foundation
import CoreLocation

struct Region: Identifiable, Hashable {
    static func == (lhs: Region, rhs: Region) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    let id: String
    let slug: String
    let nameEn: String
    let nameJp: String
    let city: String
    let prefecture: String
    let center: CLLocationCoordinate2D
    let regionId: String

    static let all: [Region] = [
        Region(id: "akihabara", slug: "akihabara", nameEn: "Akihabara", nameJp: "秋葉原", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731), regionId: "akihabara"),
        Region(id: "ikebukuro", slug: "ikebukuro", nameEn: "Ikebukuro", nameJp: "池袋", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.7295, longitude: 139.7109), regionId: "ikebukuro"),
        Region(id: "shibuya", slug: "shibuya", nameEn: "Shibuya", nameJp: "渋谷", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.6580, longitude: 139.7016), regionId: "shibuya"),
        Region(id: "shinjuku", slug: "shinjuku", nameEn: "Shinjuku", nameJp: "新宿", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.6938, longitude: 139.7034), regionId: "shinjuku"),
        Region(id: "nakano", slug: "nakano", nameEn: "Nakano", nameJp: "中野", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.7074, longitude: 139.6659), regionId: "nakano"),
        Region(id: "machida", slug: "machida", nameEn: "Machida", nameJp: "町田", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.5424, longitude: 139.4466), regionId: "machida"),
        Region(id: "tachikawa", slug: "tachikawa", nameEn: "Tachikawa", nameJp: "立川", city: "Tokyo", prefecture: "Tokyo", center: CLLocationCoordinate2D(latitude: 35.6980, longitude: 139.4089), regionId: "tachikawa"),
        Region(id: "yokohama", slug: "yokohama", nameEn: "Yokohama", nameJp: "横浜", city: "Yokohama", prefecture: "Kanagawa", center: CLLocationCoordinate2D(latitude: 35.4437, longitude: 139.6380), regionId: "yokohama"),
        Region(id: "omiya", slug: "omiya", nameEn: "Omiya", nameJp: "大宮", city: "Saitama", prefecture: "Saitama", center: CLLocationCoordinate2D(latitude: 35.9062, longitude: 139.6237), regionId: "omiya"),
        Region(id: "chiba", slug: "chiba", nameEn: "Chiba", nameJp: "千葉", city: "Chiba", prefecture: "Chiba", center: CLLocationCoordinate2D(latitude: 35.6074, longitude: 140.1065), regionId: "chiba"),
        Region(id: "nipponbashi", slug: "nipponbashi", nameEn: "Nipponbashi", nameJp: "日本橋", city: "Osaka", prefecture: "Osaka", center: CLLocationCoordinate2D(latitude: 34.6596, longitude: 135.5054), regionId: "nipponbashi"),
        Region(id: "kyoto", slug: "kyoto", nameEn: "Kyoto", nameJp: "京都", city: "Kyoto", prefecture: "Kyoto", center: CLLocationCoordinate2D(latitude: 35.0116, longitude: 135.7681), regionId: "kyoto"),
        Region(id: "kobe", slug: "kobe", nameEn: "Kobe", nameJp: "神戸", city: "Kobe", prefecture: "Hyogo", center: CLLocationCoordinate2D(latitude: 34.6901, longitude: 135.1956), regionId: "kobe"),
        Region(id: "osu", slug: "osu", nameEn: "Osu", nameJp: "大須", city: "Nagoya", prefecture: "Aichi", center: CLLocationCoordinate2D(latitude: 35.1575, longitude: 136.9025), regionId: "osu"),
        Region(id: "niigata", slug: "niigata", nameEn: "Niigata", nameJp: "新潟", city: "Niigata", prefecture: "Niigata", center: CLLocationCoordinate2D(latitude: 37.9161, longitude: 139.0364), regionId: "niigata"),
        Region(id: "kanazawa", slug: "kanazawa", nameEn: "Kanazawa", nameJp: "金沢", city: "Kanazawa", prefecture: "Ishikawa", center: CLLocationCoordinate2D(latitude: 36.5613, longitude: 136.6562), regionId: "kanazawa"),
        Region(id: "tenjin-hakata", slug: "tenjin-hakata", nameEn: "Tenjin / Hakata", nameJp: "天神・博多", city: "Fukuoka", prefecture: "Fukuoka", center: CLLocationCoordinate2D(latitude: 33.5904, longitude: 130.3990), regionId: "tenjin-hakata"),
        Region(id: "kumamoto", slug: "kumamoto", nameEn: "Kumamoto", nameJp: "熊本", city: "Kumamoto", prefecture: "Kumamoto", center: CLLocationCoordinate2D(latitude: 32.8032, longitude: 130.7079), regionId: "kumamoto"),
        Region(id: "naha", slug: "naha", nameEn: "Naha", nameJp: "那覇", city: "Naha", prefecture: "Okinawa", center: CLLocationCoordinate2D(latitude: 26.3344, longitude: 127.6809), regionId: "naha"),
        Region(id: "hiroshima", slug: "hiroshima", nameEn: "Hiroshima", nameJp: "広島", city: "Hiroshima", prefecture: "Hiroshima", center: CLLocationCoordinate2D(latitude: 34.3853, longitude: 132.4553), regionId: "hiroshima"),
        Region(id: "okayama", slug: "okayama", nameEn: "Okayama", nameJp: "岡山", city: "Okayama", prefecture: "Okayama", center: CLLocationCoordinate2D(latitude: 34.6551, longitude: 133.9195), regionId: "okayama"),
        Region(id: "sapporo", slug: "sapporo", nameEn: "Sapporo", nameJp: "札幌", city: "Sapporo", prefecture: "Hokkaido", center: CLLocationCoordinate2D(latitude: 43.0621, longitude: 141.3544), regionId: "sapporo"),
        Region(id: "sendai", slug: "sendai", nameEn: "Sendai", nameJp: "仙台", city: "Sendai", prefecture: "Miyagi", center: CLLocationCoordinate2D(latitude: 38.2682, longitude: 140.8694), regionId: "sendai"),
    ]
}
