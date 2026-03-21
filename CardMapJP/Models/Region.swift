import Foundation
import CoreLocation

struct TransitInfo {
    let line: String
    let station: String
    let detail: String
}

struct TipInfo {
    let title: String
    let body: String
}

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
    let regionId: String // UUID from Supabase
    let subtitle: String
    let description: [String]
    let gettingThere: [TransitInfo]
    let tips: [TipInfo]

    static let all: [Region] = [
        Region(
            id: "akihabara", slug: "akihabara", nameEn: "Akihabara", nameJp: "秋葉原",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731),
            regionId: "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
            subtitle: "The ultimate guide for foreign collectors visiting Tokyo's card paradise",
            description: [
                "Akihabara in central Tokyo is the world's largest concentration of Pokemon card shops. Within a 10-minute walk from Akihabara Station, you'll find over 78 shops selling everything from the latest booster boxes to vintage Base Set holos and PSA-graded slabs.",
                "Whether you're hunting for Japanese-exclusive art rares, sealed vintage product, or graded investment pieces, Akihabara has it all — often at prices significantly below international market value.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Yamanote Line", station: "Akihabara Station (Electric Town exit)", detail: "The main loop line connecting Shibuya, Shinjuku, Ikebukuro, and Tokyo Station."),
                TransitInfo(line: "Tokyo Metro Hibiya Line", station: "Akihabara Station", detail: "Direct from Roppongi and Ginza."),
                TransitInfo(line: "From Narita Airport", station: "", detail: "Take JR Narita Express to Tokyo Station, then JR Yamanote Line (2 stops). About 80 minutes."),
            ],
            tips: [
                TipInfo(title: "Tax-free shopping", body: "Most larger shops offer tax-free for tourists (passport required, min 5,000 yen)."),
                TipInfo(title: "Payment", body: "Cash is king at smaller shops. Larger stores accept credit cards and IC cards."),
                TipInfo(title: "Best time to visit", body: "Weekday mornings (11am-1pm) are quietest. Weekends are very crowded."),
                TipInfo(title: "English support", body: "Many shops have English-speaking staff. Look for the EN badge in our listings."),
                TipInfo(title: "Condition grading", body: "Japanese shops grade strictly. 'Near Mint' in Japan is often better than NM in Western markets."),
            ]
        ),
        Region(
            id: "ikebukuro", slug: "ikebukuro", nameEn: "Ikebukuro", nameJp: "池袋",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.7295, longitude: 139.7189),
            regionId: "d1000000-0000-0000-0000-000000000001",
            subtitle: "Tokyo's second otaku district — a growing hub for card collectors",
            description: [
                "Ikebukuro is Tokyo's second-largest otaku hub after Akihabara, centered around Sunshine City and the east side of Ikebukuro Station. The area has seen rapid growth in Pokemon card shops.",
                "With fewer tourists than Akihabara, Ikebukuro offers a more relaxed shopping experience and occasionally better prices on competitive singles.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Yamanote Line", station: "Ikebukuro Station (East exit)", detail: "Major stop on the loop line."),
                TransitInfo(line: "Tokyo Metro Marunouchi Line", station: "Ikebukuro Station", detail: "Direct from Tokyo Station."),
            ],
            tips: [
                TipInfo(title: "Sunshine City", body: "Several card shops are inside or near Sunshine City mall complex."),
                TipInfo(title: "Otome Road", body: "The area around Otome Road has multiple card and hobby shops."),
            ]
        ),
        Region(
            id: "shibuya", slug: "shibuya", nameEn: "Shibuya", nameJp: "渋谷",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.6621, longitude: 139.698),
            regionId: "d3000000-0000-0000-0000-000000000001",
            subtitle: "Tokyo's trendiest district — card shops mixed with fashion and culture",
            description: [
                "Shibuya is one of Tokyo's most iconic districts, famous for its crossing and youth culture. Card shops here cater to both collectors and casual fans.",
                "While not as dense as Akihabara, Shibuya's shops tend to carry trendy items and limited releases that sell out elsewhere.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Yamanote Line", station: "Shibuya Station", detail: "Major hub with connections to many lines."),
                TransitInfo(line: "Tokyo Metro Ginza Line", station: "Shibuya Station", detail: "Direct from Asakusa and Ueno."),
            ],
            tips: [
                TipInfo(title: "Nearby areas", body: "Harajuku is one stop away on the Yamanote Line — combine both areas in one trip."),
            ]
        ),
        Region(
            id: "shinjuku", slug: "shinjuku", nameEn: "Shinjuku", nameJp: "新宿",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.6907, longitude: 139.7002),
            regionId: "d2000000-0000-0000-0000-000000000001",
            subtitle: "Tokyo's busiest station area — convenient card shopping for travelers",
            description: [
                "Shinjuku Station is the world's busiest railway station, making it an incredibly convenient location for card shopping. Shops are scattered around the east and south exits.",
                "Perfect for a quick card run if you're passing through — many shops are within 5 minutes of the station.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Yamanote Line", station: "Shinjuku Station (East exit)", detail: "World's busiest station, connections to everywhere."),
                TransitInfo(line: "From Narita Airport", station: "", detail: "Narita Express direct to Shinjuku. About 90 minutes."),
            ],
            tips: [
                TipInfo(title: "Navigation", body: "Shinjuku Station is huge. Use the East exit for most card shops."),
            ]
        ),
        Region(
            id: "nakano", slug: "nakano", nameEn: "Nakano", nameJp: "中野",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.7078, longitude: 139.6655),
            regionId: "d4000000-0000-0000-0000-000000000001",
            subtitle: "Nakano Broadway — Tokyo's hidden gem for serious card collectors",
            description: [
                "Nakano Broadway is a legendary multi-floor shopping complex packed with collectible shops. It's considered the original otaku shopping destination, predating even Akihabara's transformation.",
                "The building houses numerous card shops across multiple floors, many specializing in rare and vintage items. Prices can be better than Akihabara for knowledgeable buyers.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Chuo Line", station: "Nakano Station (North exit)", detail: "5 minutes from Shinjuku. Walk through Sun Mall arcade to Broadway."),
            ],
            tips: [
                TipInfo(title: "Explore all floors", body: "Don't skip upper floors — some of the best card shops are on 3F and 4F."),
                TipInfo(title: "Mandarake", body: "The famous Mandarake stores here often have rare vintage Pokemon cards."),
            ]
        ),
        Region(
            id: "machida", slug: "machida", nameEn: "Machida", nameJp: "町田",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.5424, longitude: 139.4455),
            regionId: "e4000000-0000-0000-0000-000000000001",
            subtitle: "Southwest Tokyo's busy shopping town — card shops near the station",
            description: [
                "Machida is a major commercial center in southwestern Tokyo, with a lively shopping district around the station. Several card shops serve the local collector community.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Yokohama Line", station: "Machida Station", detail: "About 35 minutes from Tokyo Station."),
                TransitInfo(line: "Odakyu Line", station: "Machida Station", detail: "Direct from Shinjuku. About 30 minutes by express."),
            ],
            tips: [
                TipInfo(title: "Combined trip", body: "Machida is between Tokyo and Yokohama — easy to combine with either."),
            ]
        ),
        Region(
            id: "tachikawa", slug: "tachikawa", nameEn: "Tachikawa", nameJp: "立川",
            city: "Tokyo", prefecture: "Tokyo",
            center: CLLocationCoordinate2D(latitude: 35.6971, longitude: 139.4133),
            regionId: "e5000000-0000-0000-0000-000000000001",
            subtitle: "Western Tokyo's commercial center — card shops in the Tama area",
            description: [
                "Tachikawa is the main commercial hub of western Tokyo's Tama area, with a growing selection of card shops around the station.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Chuo Line", station: "Tachikawa Station", detail: "About 25 minutes from Shinjuku by Chuo Special Rapid."),
            ],
            tips: [
                TipInfo(title: "LaLaport", body: "Check shops in and around the major shopping malls near the station."),
            ]
        ),
        Region(
            id: "yokohama", slug: "yokohama", nameEn: "Yokohama", nameJp: "横浜",
            city: "Yokohama", prefecture: "Kanagawa",
            center: CLLocationCoordinate2D(latitude: 35.4662, longitude: 139.6221),
            regionId: "e1000000-0000-0000-0000-000000000001",
            subtitle: "Japan's second-largest city — great card shops just 30 minutes from Tokyo",
            description: [
                "Yokohama is Japan's second-largest city and just 30 minutes from central Tokyo by train. The card shopping scene is centered around Yokohama Station and the surrounding area.",
                "With the Pokemon Center Yokohama nearby, the city has a strong Pokemon collecting culture and dedicated shops.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Tokaido Line", station: "Yokohama Station", detail: "About 25 minutes from Tokyo Station."),
                TransitInfo(line: "Tokyu Toyoko Line", station: "Yokohama Station", detail: "Direct from Shibuya. About 30 minutes."),
            ],
            tips: [
                TipInfo(title: "Chinatown", body: "Yokohama Chinatown is nearby — great for lunch between card shopping."),
            ]
        ),
        Region(
            id: "omiya", slug: "omiya", nameEn: "Omiya", nameJp: "大宮",
            city: "Saitama", prefecture: "Saitama",
            center: CLLocationCoordinate2D(latitude: 35.903, longitude: 139.629),
            regionId: "e2000000-0000-0000-0000-000000000001",
            subtitle: "Saitama's main hub — card shopping north of Tokyo",
            description: [
                "Omiya is the main commercial center of Saitama Prefecture, about 30 minutes north of Tokyo. The station area has several card shops popular with local collectors.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Takasaki/Utsunomiya Line", station: "Omiya Station", detail: "About 30 minutes from Ueno or Tokyo Station."),
                TransitInfo(line: "Shinkansen", station: "Omiya Station", detail: "Many bullet trains stop here — convenient from northern Japan."),
            ],
            tips: [
                TipInfo(title: "Railway Museum", body: "The Railway Museum is nearby if you want to combine sightseeing."),
            ]
        ),
        Region(
            id: "chiba", slug: "chiba", nameEn: "Chiba", nameJp: "千葉",
            city: "Chiba", prefecture: "Chiba",
            center: CLLocationCoordinate2D(latitude: 35.6107, longitude: 140.1137),
            regionId: "e3000000-0000-0000-0000-000000000001",
            subtitle: "Chiba's card shopping district — east of Tokyo with solid selection",
            description: [
                "Chiba Station area has a growing number of card shops serving the eastern Tokyo metropolitan area. Less tourist traffic means potential for better deals.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Sobu Line", station: "Chiba Station", detail: "About 40 minutes from Tokyo Station."),
            ],
            tips: [
                TipInfo(title: "Narita connection", body: "Chiba is on the way to/from Narita Airport — stop by on arrival or departure day."),
            ]
        ),
        Region(
            id: "nipponbashi", slug: "nipponbashi", nameEn: "Nipponbashi", nameJp: "日本橋",
            city: "Osaka", prefecture: "Osaka",
            center: CLLocationCoordinate2D(latitude: 34.659, longitude: 135.5055),
            regionId: "b1000000-0000-0000-0000-000000000001",
            subtitle: "Osaka's legendary Den Den Town — the Kansai collector's paradise",
            description: [
                "Nipponbashi, often called 'Den Den Town,' is Osaka's answer to Akihabara and the largest card shopping district in western Japan. Stretching along Sakai-suji street south of Namba.",
                "Den Den Town offers a more relaxed experience than Akihabara, with generally lower prices and fewer crowds. Many shops specialize in competitive singles and rare Japanese-exclusive cards.",
            ],
            gettingThere: [
                TransitInfo(line: "Osaka Metro Sakaisuji Line", station: "Ebisucho Station (Exit 1-A)", detail: "Right in the heart of Den Den Town."),
                TransitInfo(line: "Nankai Railway", station: "Namba Station", detail: "Direct from Kansai Airport. About 45 minutes by Nankai Rapid."),
            ],
            tips: [
                TipInfo(title: "Combine with food", body: "Dotonbori and Shinsekai are walking distance. Plan lunch around your card shopping."),
                TipInfo(title: "Bargain hunting", body: "Check junk bins for hidden gems at 10-50 yen each."),
                TipInfo(title: "Tax-free", body: "Card Labo and Dragon Star offer tax-free for tourists. Bring your passport."),
            ]
        ),
        Region(
            id: "kyoto", slug: "kyoto", nameEn: "Teramachi / Kawaramachi", nameJp: "寺町・河原町",
            city: "Kyoto", prefecture: "Kyoto",
            center: CLLocationCoordinate2D(latitude: 35.0035, longitude: 135.7685),
            regionId: "aa000000-0000-0000-0000-000000000001",
            subtitle: "Japan's ancient capital — card shops along Teramachi and Kawaramachi",
            description: [
                "Kyoto's card shops are concentrated along the historic Teramachi and Kawaramachi shopping streets, blending modern hobby culture with Japan's ancient capital.",
            ],
            gettingThere: [
                TransitInfo(line: "Hankyu Kyoto Line", station: "Kyoto-Kawaramachi Station", detail: "Direct from Osaka-Umeda. About 45 minutes."),
                TransitInfo(line: "From Kyoto Station", station: "", detail: "Take bus 205 or subway to Shijo, then walk east."),
            ],
            tips: [
                TipInfo(title: "Temple visits", body: "Combine card shopping with nearby Nishiki Market and temple visits."),
            ]
        ),
        Region(
            id: "kobe", slug: "kobe", nameEn: "Sannomiya", nameJp: "三宮",
            city: "Kobe", prefecture: "Hyogo",
            center: CLLocationCoordinate2D(latitude: 35.1915, longitude: 135.1905),
            regionId: "ab000000-0000-0000-0000-000000000001",
            subtitle: "Kobe's central district — card shops in the heart of Sannomiya",
            description: [
                "Sannomiya is Kobe's central shopping and entertainment district. Card shops are clustered around the station area, easily accessible from Osaka and Kyoto.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Tokaido-Sanyo Line", station: "Sannomiya Station", detail: "About 20 minutes from Osaka Station."),
            ],
            tips: [
                TipInfo(title: "Kansai triangle", body: "Kobe is easy to combine with Osaka and Kyoto — all within 30-60 minutes of each other."),
            ]
        ),
        Region(
            id: "osu", slug: "osu", nameEn: "Osu", nameJp: "大須",
            city: "Nagoya", prefecture: "Aichi",
            center: CLLocationCoordinate2D(latitude: 35.1593, longitude: 136.906),
            regionId: "c1000000-0000-0000-0000-000000000001",
            subtitle: "Nagoya's vibrant Osu Shopping Street — Central Japan's card collecting hub",
            description: [
                "Osu is Nagoya's most exciting shopping district, centered around the covered Osu Shopping Street near Osu Kannon Temple. Card shops mix with traditional stores and quirky boutiques.",
                "While smaller than Akihabara, Osu offers unique charm. Card shops often carry inventory that has sold out in Tokyo and Osaka. Nagoya's central location makes it an easy Shinkansen day trip.",
            ],
            gettingThere: [
                TransitInfo(line: "Nagoya Subway Tsurumai Line", station: "Kamimaezu Station (Exit 9)", detail: "1 minute walk to Osu Shopping Street."),
                TransitInfo(line: "From Nagoya Station", station: "", detail: "Higashiyama Line to Sakae, transfer to Meijo Line to Kamimaezu. About 15 minutes."),
            ],
            tips: [
                TipInfo(title: "Osu Kannon Temple", body: "Visit the historic temple at the entrance to the shopping street."),
                TipInfo(title: "Street food", body: "The area is famous for diverse food stalls — fuel up between shops."),
            ]
        ),
        Region(
            id: "tenjin-hakata", slug: "tenjin-hakata", nameEn: "Tenjin / Hakata", nameJp: "天神・博多",
            city: "Fukuoka", prefecture: "Fukuoka",
            center: CLLocationCoordinate2D(latitude: 33.592, longitude: 130.399),
            regionId: "f1000000-0000-0000-0000-000000000001",
            subtitle: "Kyushu's gateway city — Fukuoka's growing card collecting scene",
            description: [
                "Fukuoka is Kyushu's largest city, with card shops split between the Tenjin shopping district and the Hakata Station area. The scene is growing rapidly.",
            ],
            gettingThere: [
                TransitInfo(line: "Shinkansen", station: "Hakata Station", detail: "Terminal station for the Sanyo/Kyushu Shinkansen."),
                TransitInfo(line: "Fukuoka Subway", station: "Tenjin Station", detail: "2 stops from Hakata. About 5 minutes."),
            ],
            tips: [
                TipInfo(title: "Yatai stalls", body: "Don't miss Fukuoka's famous ramen yatai (street stalls) along the river at night."),
            ]
        ),
        Region(
            id: "sapporo", slug: "sapporo", nameEn: "Sapporo", nameJp: "札幌",
            city: "Sapporo", prefecture: "Hokkaido",
            center: CLLocationCoordinate2D(latitude: 43.0563, longitude: 141.3507),
            regionId: "ac000000-0000-0000-0000-000000000001",
            subtitle: "Hokkaido's capital — card shopping along Tanukikoji and Susukino",
            description: [
                "Sapporo is Hokkaido's vibrant capital, with card shops scattered around the Tanukikoji shopping arcade and Susukino entertainment district.",
            ],
            gettingThere: [
                TransitInfo(line: "JR Line", station: "Sapporo Station", detail: "Airport express from New Chitose Airport. About 40 minutes."),
                TransitInfo(line: "Sapporo Subway", station: "Odori Station", detail: "Central station near Tanukikoji arcade."),
            ],
            tips: [
                TipInfo(title: "Winter visiting", body: "Many shops are underground or in heated arcades — comfortable even in Hokkaido's harsh winters."),
            ]
        ),
        Region(
            id: "sendai", slug: "sendai", nameEn: "Sendai", nameJp: "仙台",
            city: "Sendai", prefecture: "Miyagi",
            center: CLLocationCoordinate2D(latitude: 38.2603, longitude: 140.8822),
            regionId: "ad000000-0000-0000-0000-000000000001",
            subtitle: "Tohoku's largest city — card shops around Sendai Station",
            description: [
                "Sendai is the largest city in the Tohoku region, known as the 'City of Trees.' Card shops are conveniently located around Sendai Station and the nearby shopping arcades.",
            ],
            gettingThere: [
                TransitInfo(line: "Tohoku Shinkansen", station: "Sendai Station", detail: "About 90 minutes from Tokyo Station."),
            ],
            tips: [
                TipInfo(title: "Gyutan", body: "Sendai is famous for beef tongue (gyutan) — a must-try between card shops."),
            ]
        ),
        Region(
            id: "niigata", slug: "niigata", nameEn: "Niigata", nameJp: "新潟",
            city: "Niigata", prefecture: "Niigata",
            center: CLLocationCoordinate2D(latitude: 37.9128, longitude: 139.0598),
            regionId: "bc000000-0000-0000-0000-000000000001",
            subtitle: "Japan Sea coast city — card shops in the rice country capital",
            description: [
                "Niigata is the main city on Japan's Sea of Japan coast, known for rice and sake. A small but dedicated card collecting scene exists around the station area.",
            ],
            gettingThere: [
                TransitInfo(line: "Joetsu Shinkansen", station: "Niigata Station", detail: "About 2 hours from Tokyo Station."),
            ],
            tips: [
                TipInfo(title: "Sake tasting", body: "Niigata is Japan's top sake-producing region — visit Ponshukan sake tasting at the station."),
            ]
        ),
        Region(
            id: "kanazawa", slug: "kanazawa", nameEn: "Kanazawa", nameJp: "金沢",
            city: "Kanazawa", prefecture: "Ishikawa",
            center: CLLocationCoordinate2D(latitude: 36.5782, longitude: 136.6477),
            regionId: "bd000000-0000-0000-0000-000000000001",
            subtitle: "Historic castle town — card shops in the Hokuriku region",
            description: [
                "Kanazawa is a beautifully preserved castle town famous for Kenrokuen Garden. The card scene is small but growing, centered around the station and Katamachi areas.",
            ],
            gettingThere: [
                TransitInfo(line: "Hokuriku Shinkansen", station: "Kanazawa Station", detail: "About 2.5 hours from Tokyo Station."),
            ],
            tips: [
                TipInfo(title: "Kenrokuen", body: "One of Japan's top 3 gardens is right here — perfect for a break from card hunting."),
            ]
        ),
        Region(
            id: "kumamoto", slug: "kumamoto", nameEn: "Kumamoto", nameJp: "熊本",
            city: "Kumamoto", prefecture: "Kumamoto",
            center: CLLocationCoordinate2D(latitude: 32.79, longitude: 130.709),
            regionId: "ba000000-0000-0000-0000-000000000001",
            subtitle: "Kyushu's castle city — card shops in central Kumamoto",
            description: [
                "Kumamoto is known for its impressive castle and as the home of Kumamon, the famous bear mascot. Card shops are located around the Shimotori shopping arcade.",
            ],
            gettingThere: [
                TransitInfo(line: "Kyushu Shinkansen", station: "Kumamoto Station", detail: "About 30 minutes from Hakata by Shinkansen."),
            ],
            tips: [
                TipInfo(title: "Kumamoto Castle", body: "The restored castle is a must-see, walkable from the card shopping area."),
            ]
        ),
        Region(
            id: "naha", slug: "naha", nameEn: "Naha", nameJp: "那覇",
            city: "Naha", prefecture: "Okinawa",
            center: CLLocationCoordinate2D(latitude: 26.2257, longitude: 127.6945),
            regionId: "bb000000-0000-0000-0000-000000000001",
            subtitle: "Japan's tropical paradise — card shops in Okinawa's capital",
            description: [
                "Naha is the capital of Okinawa, Japan's tropical prefecture. While the card scene is smaller, dedicated shops exist around Kokusai Street and the Makishi area.",
            ],
            gettingThere: [
                TransitInfo(line: "Yui Rail", station: "Kencho-mae or Makishi Station", detail: "Monorail from Naha Airport. About 15 minutes."),
            ],
            tips: [
                TipInfo(title: "Kokusai Street", body: "Naha's main tourist street has some card shops mixed in with souvenir stores."),
            ]
        ),
        Region(
            id: "hiroshima", slug: "hiroshima", nameEn: "Hiroshima", nameJp: "広島",
            city: "Hiroshima", prefecture: "Hiroshima",
            center: CLLocationCoordinate2D(latitude: 34.394, longitude: 132.4555),
            regionId: "ca000000-0000-0000-0000-000000000001",
            subtitle: "Peace city — card shops in Hiroshima's central shopping district",
            description: [
                "Hiroshima's card shops are located around the Hondori shopping arcade and near Hiroshima Station. The city is a popular tourist destination, making card shopping easy to combine with sightseeing.",
            ],
            gettingThere: [
                TransitInfo(line: "Sanyo Shinkansen", station: "Hiroshima Station", detail: "About 4 hours from Tokyo, 90 minutes from Osaka."),
                TransitInfo(line: "Hiroshima Streetcar", station: "Hondori Station", detail: "Streetcar from Hiroshima Station to the shopping district."),
            ],
            tips: [
                TipInfo(title: "Miyajima", body: "Take the ferry to Miyajima Island for the famous floating torii gate — easy half-day trip."),
            ]
        ),
        Region(
            id: "okayama", slug: "okayama", nameEn: "Okayama", nameJp: "岡山",
            city: "Okayama", prefecture: "Okayama",
            center: CLLocationCoordinate2D(latitude: 34.6655, longitude: 133.9185),
            regionId: "cb000000-0000-0000-0000-000000000001",
            subtitle: "Land of Momotaro — card shops near Okayama Station",
            description: [
                "Okayama is a mid-sized city between Osaka and Hiroshima, known for Korakuen Garden and the Momotaro legend. A few card shops serve the local collector community near the station.",
            ],
            gettingThere: [
                TransitInfo(line: "Sanyo Shinkansen", station: "Okayama Station", detail: "About 3.5 hours from Tokyo, 50 minutes from Osaka."),
            ],
            tips: [
                TipInfo(title: "Korakuen Garden", body: "One of Japan's top 3 gardens — worth a visit between card shops."),
            ]
        ),
    ]
}
