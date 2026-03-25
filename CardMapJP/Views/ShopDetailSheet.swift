import SwiftUI
import MapKit

// MARK: - Shop Detail in Sheet (Google Maps style)

struct ShopDetailSheet: View {
    let shop: Shop
    let onBack: () -> Void
    @EnvironmentObject var shopStore: ShopStore
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                titleSection
                Divider()
                actionButtonsSection
                Divider()
                infoSection
                summarySection
                tipsSection
                inventorySection
                Spacer(minLength: 40)
            }
        }
        .task {
            await shopStore.fetchInventory(for: shop.id)
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView(items: [shareText])
        }
    }

    // MARK: - Detail Sub-views

    private var headerSection: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(shop.displayName)
                .font(.system(size: 22, weight: .bold))

            if !shop.displayNameJp.isEmpty {
                Text(shop.displayNameJp)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
            }

            ratingRow
            badgesRow
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }

    private var ratingRow: some View {
        HStack(spacing: 6) {
            if let rating = shop.googleRating {
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 14, weight: .semibold))
                StarRatingView(rating: rating, starSize: 11)
                if let count = shop.googleReviewCount {
                    Text("(\(count))")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                }
            }
            if let dist = shopStore.formattedDistance(to: shop) {
                Text("  \(dist)")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var badgesRow: some View {
        FlowLayout(spacing: 6) {
            if shop.englishStaff == true { Badge(text: "EN Staff", color: .blue) }
            if shop.beginnerFriendly == true { Badge(text: "Beginner OK", color: .green) }
            if shop.sellsEnglishCards == true { Badge(text: "English Cards", color: .orange) }
            if shop.sellsVintage == true { Badge(text: "Vintage", color: .brown) }
            if shop.sellsPsaGraded == true { Badge(text: "PSA Graded", color: .purple) }
            if shop.openHours?.isOpenNow == true {
                Badge(text: "Open Now", color: .green)
            } else if shop.openHours?.isOpenNow == false {
                Badge(text: "Closed", color: .red)
            }
        }
        .padding(.top, 4)
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 0) {
            if let coord = shop.coordinate {
                ActionButton(icon: "figure.walk", label: "Directions") {
                    let urlStr = "https://www.google.com/maps/dir/?api=1&destination=\(coord.latitude),\(coord.longitude)&travelmode=walking"
                    if let url = URL(string: urlStr) { UIApplication.shared.open(url) }
                }
            }
            if let phone = shop.phone {
                ActionButton(icon: "phone.fill", label: "Call") {
                    if let url = URL(string: "tel:\(phone)") { UIApplication.shared.open(url) }
                }
            }
            if let website = shop.websiteUrl, let url = URL(string: website) {
                ActionButton(icon: "safari", label: "Website") {
                    UIApplication.shared.open(url)
                }
            }
            ActionButton(icon: "square.and.arrow.up", label: "Share") {
                showShareSheet = true
            }
        }
        .padding(.vertical, 12)
    }

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let address = shop.addressEn ?? shop.addressJp {
                InfoRowGMaps(icon: "mappin", text: address)
            }
            if let hours = shop.openHours {
                InfoRowGMaps(icon: "clock", text: hoursText(hours))
            }
            if let methods = shop.paymentMethods, !methods.isEmpty {
                InfoRowGMaps(icon: "creditcard", text: methods.joined(separator: ", "))
            }
            if shop.atmNearby == true {
                InfoRowGMaps(icon: "banknote", text: "ATM \(shop.atmNote ?? "Nearby")")
            }
        }
    }

    @ViewBuilder
    private var summarySection: some View {
        if let summary = shop.aiSummary {
            Divider()
            VStack(alignment: .leading, spacing: 8) {
                Label("About", systemImage: "sparkles")
                    .font(.system(size: 15, weight: .semibold))
                Text(summary)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private var tipsSection: some View {
        if let tips = shop.visitorTips, !tips.isEmpty {
            Divider()
            VStack(alignment: .leading, spacing: 8) {
                Label("Visitor Tips", systemImage: "lightbulb.fill")
                    .font(.system(size: 15, weight: .semibold))
                Text(tips)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }
            .padding(20)
        }
    }

    @ViewBuilder
    private var inventorySection: some View {
        if let items = shopStore.inventoryForShop(shop.id), !items.isEmpty {
            Divider()
            InventoryGridView(items: items)
        }
    }

    private var shareText: String {
        let name = shop.displayName
        let jpName = shop.displayNameJp.isEmpty ? "" : " (\(shop.displayNameJp))"
        let mapsLink: String
        if let coord = shop.coordinate {
            mapsLink = "\nhttps://www.google.com/maps/search/?api=1&query=\(coord.latitude),\(coord.longitude)"
        } else {
            mapsLink = ""
        }
        return "\(name)\(jpName)\(mapsLink)"
    }

    private func hoursText(_ hours: OpenHours) -> String {
        if hours.isOpenNow == true {
            return "Open now"
        } else if hours.isOpenNow == false {
            return "Closed"
        }
        return "Hours available"
    }
}
