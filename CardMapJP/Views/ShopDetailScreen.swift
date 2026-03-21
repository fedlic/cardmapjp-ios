import SwiftUI
import MapKit

struct ShopDetailScreen: View {
    let shop: Shop
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                headerSection

                // AI Summary
                if let summary = shop.aiSummary {
                    SectionCard(title: "About", icon: "sparkles") {
                        Text(summary)
                            .font(.body)
                    }
                }

                // Visitor Tips
                if let tips = shop.visitorTips, !tips.isEmpty {
                    SectionCard(title: "Visitor Tips", icon: "lightbulb.fill") {
                        Text(tips)
                            .font(.body)
                    }
                }

                // Inventory
                if let items = shopStore.inventory[shop.id], !items.isEmpty {
                    SectionCard(title: "Inventory", icon: "cube.box.fill") {
                        inventoryGrid(items: items)
                    }
                }

                // Info
                infoSection

                // Hours
                if let hours = shop.openHours {
                    SectionCard(title: "Hours", icon: "clock.fill") {
                        hoursView(hours: hours)
                    }
                }

                // Map preview
                if let coord = shop.coordinate {
                    SectionCard(title: "Location", icon: "map.fill") {
                        Map {
                            Marker(shop.displayName, coordinate: coord)
                                .tint(.red)
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .allowsHitTesting(false)
                    }
                }

                Spacer(minLength: 80)
            }
            .padding()
        }
        .navigationTitle(shop.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            directionsButton
        }
        .task {
            await shopStore.fetchInventory(for: shop.id)
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !shop.displayNameJp.isEmpty {
                Text(shop.displayNameJp)
                    .font(.title2)
            }

            HStack(spacing: 12) {
                if let rating = shop.googleRating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(String(format: "%.1f", rating))
                            .font(.headline)
                        if let count = shop.googleReviewCount {
                            Text("(\(count) reviews)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if let dist = shopStore.formattedDistance(to: shop) {
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                        Text(dist)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                }
            }

            // Badges
            FlowLayout(spacing: 6) {
                if shop.englishStaff == true {
                    Badge(text: "EN Staff", color: .blue)
                }
                if shop.beginnerFriendly == true {
                    Badge(text: "Beginner Friendly", color: .green)
                }
                if shop.sellsEnglishCards == true {
                    Badge(text: "English Cards", color: .orange)
                }
                if shop.sellsVintage == true {
                    Badge(text: "Vintage", color: .brown)
                }
                if shop.sellsPsaGraded == true {
                    Badge(text: "PSA Graded", color: .purple)
                }
                if shop.openHours?.isOpenNow == true {
                    Badge(text: "Open Now", color: .green)
                } else if shop.openHours?.isOpenNow == false {
                    Badge(text: "Closed", color: .red)
                }
            }
        }
    }

    // MARK: - Inventory Grid

    private func inventoryGrid(items: [ShopInventory]) -> some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(item.categoryIcon)
                            .font(.title3)
                        Text(item.categoryLabel)
                            .font(.caption.weight(.medium))
                            .lineLimit(1)
                    }
                    Text(item.availabilityLabel)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(availabilityColor(item.availability))
                    if let price = item.priceRangeText {
                        Text(price)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    private func availabilityColor(_ availability: String) -> Color {
        switch availability {
        case "in_stock": return .green
        case "limited": return .orange
        case "sold_out": return .red
        default: return .gray
        }
    }

    // MARK: - Info

    private var infoSection: some View {
        SectionCard(title: "Info", icon: "info.circle.fill") {
            VStack(alignment: .leading, spacing: 10) {
                if let address = shop.addressEn ?? shop.addressJp {
                    InfoRow(icon: "mappin", label: "Address", value: address)
                }
                if let floor = shop.floorLabel {
                    InfoRow(icon: "building.2", label: "Floor", value: floor)
                }
                if let phone = shop.phone {
                    InfoRow(icon: "phone", label: "Phone", value: phone)
                }
                if let methods = shop.paymentMethods, !methods.isEmpty {
                    InfoRow(icon: "creditcard", label: "Payment", value: methods.joined(separator: ", "))
                }
                if shop.atmNearby == true {
                    InfoRow(icon: "banknote", label: "ATM", value: shop.atmNote ?? "Nearby")
                }
                if let website = shop.websiteUrl {
                    Link(destination: URL(string: website)!) {
                        InfoRow(icon: "globe", label: "Website", value: "Visit →")
                    }
                }
                if let twitter = shop.twitterHandle {
                    InfoRow(icon: "at", label: "Twitter", value: "@\(twitter)")
                }
            }
        }
    }

    // MARK: - Hours

    private func hoursView(hours: OpenHours) -> some View {
        let days: [(String, DayHours?)] = [
            ("Mon", hours.monday),
            ("Tue", hours.tuesday),
            ("Wed", hours.wednesday),
            ("Thu", hours.thursday),
            ("Fri", hours.friday),
            ("Sat", hours.saturday),
            ("Sun", hours.sunday),
        ]

        return VStack(alignment: .leading, spacing: 6) {
            ForEach(days, id: \.0) { day, dayHours in
                HStack {
                    Text(day)
                        .font(.subheadline.weight(.medium))
                        .frame(width: 40, alignment: .leading)
                    if let h = dayHours {
                        Text("\(h.open) - \(h.close)")
                            .font(.subheadline)
                    } else {
                        Text("Closed")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    // MARK: - Directions Button

    private var directionsButton: some View {
        Group {
            if let coord = shop.coordinate {
                Button {
                    let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(coord.latitude),\(coord.longitude)&travelmode=walking")!
                    UIApplication.shared.open(url)
                } label: {
                    Label("Get Directions", systemImage: "figure.walk")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.89, green: 0.20, blue: 0.05))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}

// MARK: - Helpers

struct SectionCard<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.subheadline)
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
