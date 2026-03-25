import Foundation
import CoreLocation
#if os(iOS)
import UIKit
#endif

@MainActor
class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var showPermissionDeniedAlert = false

    /// True when user has explicitly denied or location is restricted.
    var isPermissionDenied: Bool {
        authorizationStatus == .denied || authorizationStatus == .restricted
    }

    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.distanceFilter = 50
        manager.delegate = self
    }

    func requestPermission() {
        if isPermissionDenied {
            showPermissionDeniedAlert = true
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }

    func startUpdating() {
        manager.startUpdatingLocation()
    }

    func stopUpdating() {
        manager.stopUpdatingLocation()
    }

    /// Open the Settings app so the user can re-enable location.
    func openSettings() {
        #if os(iOS)
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
        #endif
    }
}

extension LocationManager: @preconcurrency CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        #if os(iOS)
        let authorized = authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
        #else
        let authorized = authorizationStatus == .authorizedAlways
        #endif
        if authorized {
            manager.startUpdatingLocation()
        }
    }
}
