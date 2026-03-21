import Foundation
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()

    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.delegate = self
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func startUpdating() {
        manager.startUpdatingLocation()
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
