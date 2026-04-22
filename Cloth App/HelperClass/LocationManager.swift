import Foundation
import CoreLocation
import UIKit

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    private var completion: ((Result<CLLocation, Error>) -> Void)?

    // Cache
    private var lastKnownLocation: CLLocation?
    private var lastLocationTime: Date?
    private let cacheExpiry: TimeInterval = 10 // seconds

    // User skipped location
    var isLocationSetNotNow: Bool = false

    enum LocationError: Error, LocalizedError {
        case servicesDisabled
        case permissionDenied
        case unableToGetLocation

        var errorDescription: String? {
            switch self {
            case .servicesDisabled:
                return "Location services are disabled."
            case .permissionDenied:
                return "Location permission denied."
            case .unableToGetLocation:
                return "Unable to retrieve location."
            }
        }
    }

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

// MARK: - Public API
extension LocationManager {

    /// ✔ Check if device-level location services are enabled
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }

    /// ✔ Get current location (cached + safe)
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {

        // If user previously selected "Not Now"
        if isLocationSetNotNow {
            completion(.failure(LocationError.permissionDenied))
            return
        }

        // If system location is OFF
        if !isLocationServicesEnabled() {
            completion(.failure(LocationError.servicesDisabled))
            return
        }

        // Return cached location
        if let loc = lastKnownLocation,
           let time = lastLocationTime,
           Date().timeIntervalSince(time) < cacheExpiry {

            completion(.success(loc))
            return
        }

        // Need to fetch new location
        self.completion = completion

        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .restricted, .denied:
            isLocationSetNotNow = true
            completion(.failure(LocationError.permissionDenied))
            self.completion = nil

        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()

        default:
            completion(.failure(LocationError.unableToGetLocation))
            self.completion = nil
        }
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Delegate Methods
extension LocationManager: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isLocationSetNotNow = false
            locationManager.startUpdatingLocation()

        case .denied, .restricted:
            isLocationSetNotNow = true
            completion?(.failure(LocationError.permissionDenied))
            completion = nil

        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {

        guard let loc = locations.last else {
            completion?(.failure(LocationError.unableToGetLocation))
            completion = nil
            return
        }

        lastKnownLocation = loc
        lastLocationTime = Date()
        isLocationSetNotNow = false

        completion?(.success(loc))
        completion = nil

        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        completion?(.failure(error))
        completion = nil
    }
}
