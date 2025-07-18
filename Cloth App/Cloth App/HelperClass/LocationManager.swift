import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager() // Singleton instance
    
    private let locationManager = CLLocationManager()
    private var completion: ((Result<CLLocation, Error>) -> Void)?
    var isLocationSetNotNow : Bool?
    // Custom Error Enum
    enum LocationError: Error, LocalizedError {
        case servicesDisabled
        case permissionDenied
        case unableToGetLocation
        
        var errorDescription: String? {
            switch self {
            case .servicesDisabled:
                return "Location services are disabled. Please enable them in settings."
            case .permissionDenied:
                return "Location permissions are denied. Please enable them in settings."
            case .unableToGetLocation:
                return "Unable to retrieve location. Please try again."
            }
        }
    }
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    /// Check if location services are enabled
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// Request location permission from the user
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Fetch current location
    func getCurrentLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        guard isLocationServicesEnabled() else {
            completion(.failure(LocationError.servicesDisabled))
            return
        }
        
        let status = locationManager.authorizationStatus // Use instance method instead of static method
        switch status {
        case .notDetermined:
            self.completion = completion
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            completion(.failure(LocationError.permissionDenied))
        case .authorizedWhenInUse, .authorizedAlways:
            self.completion = completion
            locationManager.startUpdatingLocation()
        @unknown default:
            completion(.failure(LocationError.unableToGetLocation))
        }
    }
    
    /// Open Settings to enable location
    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            completion?(.failure(LocationError.permissionDenied))
            completion = nil
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            completion?(.failure(LocationError.unableToGetLocation))
            completion = nil
            return
        }
        
        completion?(.success(location))
        completion = nil
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
        completion = nil
    }
}
