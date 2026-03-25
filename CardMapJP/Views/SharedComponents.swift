import SwiftUI

// MARK: - Star Rating

struct StarRatingView: View {
    let rating: Double
    var starSize: CGFloat = 11

    var body: some View {
        HStack(spacing: 1) {
            ForEach(0..<5) { i in
                Image(systemName: i < Int(rating.rounded()) ? "star.fill" : "star")
                    .font(.system(size: starSize))
                    .foregroundStyle(.orange)
            }
        }
    }
}

// MARK: - Inventory Grid

struct InventoryGridView: View {
    let items: [ShopInventory]
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Inventory", systemImage: "cube.box.fill")
                .font(.system(size: 15, weight: .semibold))
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(items) { item in
                    InventoryItemView(item: item)
                }
            }
        }
        .padding(20)
    }
}

struct InventoryItemView: View {
    let item: ShopInventory

    var body: some View {
        HStack(spacing: 6) {
            Text(item.categoryIcon)
                .font(.title3)
            VStack(alignment: .leading, spacing: 1) {
                Text(item.categoryLabel)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                Text(item.availabilityLabel)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(availabilityColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var availabilityColor: Color {
        switch item.availability {
        case "in_stock": return .green
        case "limited": return .orange
        default: return .red
        }
    }
}

// MARK: - Action Button (Google Maps style)

struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color(red: 0.26, green: 0.52, blue: 0.96))
                Text(label)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(red: 0.26, green: 0.52, blue: 0.96))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Info Row (Google Maps style)

struct InfoRowGMaps: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 14))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }
}

// MARK: - Micro Badge

struct MicroBadge: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .padding(.horizontal, 5)
            .padding(.vertical, 1.5)
            .background(color.opacity(0.12))
            .foregroundStyle(color)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

// MARK: - Error Retry View

struct ErrorRetryView: View {
    let errorMessage: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "wifi.slash")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            Text("Connection Error")
                .font(.headline)
            Text(errorMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button(action: onRetry) {
                Label("Try Again", systemImage: "arrow.clockwise")
                    .font(.system(size: 15, weight: .medium))
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.26, green: 0.52, blue: 0.96))
            Spacer()
        }
    }
}

// MARK: - Share Sheet (UIKit bridge)

struct ShareSheetView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Ad Banner Placeholder
// To integrate Google AdMob:
// 1. Add GoogleMobileAds SDK via SPM: https://github.com/googleads/swift-package-manager-google-mobile-ads
// 2. Add your AdMob App ID to Info.plist (GADApplicationIdentifier)
// 3. Replace the placeholder below with GADBannerView wrapped in UIViewRepresentable

struct AdBannerView: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "megaphone.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.tertiary)
                    Text("Ad")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.tertiary)
                }
                Spacer()
            }
            .frame(height: 50)
            .background(Color(.secondarySystemGroupedBackground))
        }
    }
}
