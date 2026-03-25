import SwiftUI
import MapKit

struct HomeScreen: View {
    @EnvironmentObject var shopStore: ShopStore
    @StateObject private var locationManager = LocationManager()

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731),
            span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        )
    )
    @State private var selectedShop: Shop?
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var sheetDetent: PresentationDetent = .fraction(0.35)
    @State private var showDetail = false
    @State private var detailShop: Shop?
    @State private var searchFocused = false

    private var visibleShops: [Shop] {
        guard let region = visibleRegion else { return shopStore.filteredShops }
        let latD = region.span.latitudeDelta
        let lngD = region.span.longitudeDelta
        let latMin = region.center.latitude - latD
        let latMax = region.center.latitude + latD
        let lngMin = region.center.longitude - lngD
        let lngMax = region.center.longitude + lngD
        return shopStore.filteredShops.filter { shop in
            guard let c = shop.coordinate else { return false }
            return c.latitude >= latMin && c.latitude <= latMax &&
                   c.longitude >= lngMin && c.longitude <= lngMax
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            mapLayer
            overlayLayer
        }
        .sheet(isPresented: .constant(true)) {
            SheetContent(
                selectedShop: $selectedShop,
                detailShop: $detailShop,
                showDetail: $showDetail,
                sheetDetent: $sheetDetent,
                position: $position
            )
            .environmentObject(shopStore)
            .presentationDetents(
                [.fraction(0.08), .fraction(0.35), .fraction(0.85)],
                selection: $sheetDetent
            )
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled(upThrough: .fraction(0.35)))
            .presentationCornerRadius(20)
            .interactiveDismissDisabled()
        }
        .onChange(of: selectedShop) { _, newShop in
            if let shop = newShop {
                detailShop = shop
                showDetail = true
                withAnimation { sheetDetent = .fraction(0.35) }
            }
        }
        .onChange(of: locationManager.location) { _, newLocation in
            shopStore.userLocation = newLocation
        }
        .alert("Location Access Disabled", isPresented: $locationManager.showPermissionDeniedAlert) {
            Button("Open Settings") { locationManager.openSettings() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Enable Location Services in Settings to see nearby shops and get directions.")
        }
        .task { locationManager.requestPermission() }
    }

    private var mapLayer: some View {
        Map(position: $position, selection: $selectedShop) {
            UserAnnotation()
            ForEach(visibleShops) { shop in
                if let coord = shop.coordinate {
                    Marker(shop.displayName, systemImage: "creditcard.fill", coordinate: coord)
                        .tint(shop.englishStaff == true
                              ? Color(red: 0.89, green: 0.20, blue: 0.05)
                              : Color(red: 0.26, green: 0.52, blue: 0.96))
                        .tag(shop)
                }
            }
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            visibleRegion = context.region
        }
        .mapControls { MapCompass(); MapScaleView() }
        .ignoresSafeArea()
    }

    private var overlayLayer: some View {
        VStack(spacing: 0) {
            SearchBarOverlay(searchFocused: $searchFocused)
                .environmentObject(shopStore)
            if !searchFocused {
                FilterChipsBar().environmentObject(shopStore)
            }
            Spacer()
            HStack {
                Spacer()
                locationButton
            }
        }
        .padding(.top, 8)
    }

    private var locationButton: some View {
        Button {
            locationManager.requestPermission()
            if let loc = locationManager.location {
                withAnimation {
                    position = .region(MKCoordinateRegion(
                        center: loc.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    ))
                }
            }
        } label: {
            Image(systemName: locationManager.isPermissionDenied ? "location.slash.fill" : "location.fill")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(locationManager.isPermissionDenied ? Color.gray : Color.blue)
                .frame(width: 44, height: 44)
                .background(.regularMaterial, in: Circle())
                .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 8)
    }
}

// MARK: - Search Bar (Google Maps style)

struct SearchBarOverlay: View {
    @EnvironmentObject var shopStore: ShopStore
    @Binding var searchFocused: Bool
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.system(size: 16))
            TextField("Search Pokemon card shops", text: $shopStore.searchText)
                .font(.system(size: 16))
                .focused($isFocused)
            if !shopStore.searchText.isEmpty {
                Button { shopStore.searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.12), radius: 8, y: 2)
        .padding(.horizontal, 16)
        .onChange(of: isFocused) { _, focused in searchFocused = focused }
    }
}

// MARK: - Filter Chips Bar

struct FilterChipsBar: View {
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ShopFilter.allCases, id: \.self) { filter in
                    GMapsFilterChip(
                        title: filter.rawValue,
                        isActive: shopStore.activeFilters.contains(filter)
                    ) {
                        shopStore.toggleFilter(filter)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

struct GMapsFilterChip: View {
    let title: String
    let isActive: Bool
    let action: () -> Void

    private let activeColor = Color(red: 0.05, green: 0.35, blue: 0.75)
    private let activeBg = Color(red: 0.82, green: 0.93, blue: 1.0)

    var body: some View {
        Button(action: action) {
            if isActive {
                chipLabel
                    .background(activeBg)
                    .foregroundColor(activeColor)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(activeColor.opacity(0.3), lineWidth: 1))
            } else {
                chipLabel
                    .background(.regularMaterial)
                    .foregroundColor(.primary)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
            }
        }
    }

    private var chipLabel: some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
    }
}

// MARK: - Sheet Content

struct SheetContent: View {
    @EnvironmentObject var shopStore: ShopStore
    @Binding var selectedShop: Shop?
    @Binding var detailShop: Shop?
    @Binding var showDetail: Bool
    @Binding var sheetDetent: PresentationDetent
    @Binding var position: MapCameraPosition

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showDetail, let shop = detailShop {
                    ShopDetailSheet(shop: shop, onBack: {
                        withAnimation {
                            showDetail = false
                            detailShop = nil
                            selectedShop = nil
                        }
                    })
                    .environmentObject(shopStore)
                } else {
                    ShopListSheet(onSelectShop: selectShop)
                        .environmentObject(shopStore)
                }
                AdBannerView()
            }
        }
    }

    private func selectShop(_ shop: Shop) {
        detailShop = shop
        showDetail = true
        selectedShop = shop
        if let coord = shop.coordinate {
            withAnimation {
                position = .region(MKCoordinateRegion(
                    center: coord,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                ))
                sheetDetent = .fraction(0.35)
            }
        }
    }
}

// MARK: - Shop List in Sheet

struct ShopListSheet: View {
    @EnvironmentObject var shopStore: ShopStore
    let onSelectShop: (Shop) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Explore nearby")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 8)
            Divider()
            shopContent
        }
    }

    @ViewBuilder
    private var shopContent: some View {
        if shopStore.isLoading {
            Spacer()
            ProgressView("Loading shops...")
            Spacer()
        } else if shopStore.error != nil {
            ErrorRetryView(errorMessage: shopStore.error ?? "Unknown error") {
                Task { await shopStore.fetchShops() }
            }
        } else if shopStore.filteredShops.isEmpty {
            ContentUnavailableView(
                "No shops found",
                systemImage: "magnifyingglass",
                description: Text("Try adjusting your search or filters")
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(shopStore.filteredShops) { shop in
                        Button { onSelectShop(shop) } label: {
                            GMapsShopRow(shop: shop)
                                .environmentObject(shopStore)
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 72)
                    }
                }
            }
        }
    }
}

// MARK: - Google Maps Style Shop Row

struct GMapsShopRow: View {
    let shop: Shop
    @EnvironmentObject var shopStore: ShopStore

    var body: some View {
        HStack(spacing: 12) {
            shopIcon
            shopInfo
            Spacer()
            distanceLabel
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    private var shopIcon: some View {
        ZStack {
            Circle()
                .fill(Color(red: 0.26, green: 0.52, blue: 0.96).opacity(0.12))
                .frame(width: 48, height: 48)
            Image(systemName: "creditcard.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color(red: 0.26, green: 0.52, blue: 0.96))
        }
    }

    private var shopInfo: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(shop.displayName)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
                .lineLimit(1)
            ratingLine
            jpNameLine
            badgesLine
        }
    }

    @ViewBuilder
    private var ratingLine: some View {
        if let rating = shop.googleRating {
            HStack(spacing: 4) {
                Text(String(format: "%.1f", rating))
                    .font(.system(size: 12, weight: .semibold))
                StarRatingView(rating: rating, starSize: 8)
                if let count = shop.googleReviewCount {
                    Text("(\(count))")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var jpNameLine: some View {
        if !shop.displayNameJp.isEmpty {
            Text(shop.displayNameJp)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }

    private var badgesLine: some View {
        HStack(spacing: 4) {
            if shop.englishStaff == true { MicroBadge(text: "EN", color: .blue) }
            if shop.beginnerFriendly == true { MicroBadge(text: "Beginner", color: .green) }
            if shop.sellsPsaGraded == true { MicroBadge(text: "PSA", color: .purple) }
            if shop.openHours?.isOpenNow == true { MicroBadge(text: "Open", color: .green) }
        }
    }

    @ViewBuilder
    private var distanceLabel: some View {
        if let dist = shopStore.formattedDistance(to: shop) {
            Text(dist)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
    }
}
