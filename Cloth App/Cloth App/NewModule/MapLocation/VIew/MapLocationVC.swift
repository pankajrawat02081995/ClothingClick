import UIKit
import GoogleMaps
import GooglePlaces

final class MapLocationVC: BaseViewController {
    
    @IBOutlet private weak var txtPostal: UITextField!
    @IBOutlet private weak var mapView: GMSMapView!
    
    var onDataReceived: (([String: Any], String) -> Void)?
    var newLocation: ((Locations?) -> Void)?
    
    var addressList: [Locations?] = []
    var lat: Double = 0.0
    var log: Double = 0.0
    
    var isFromPostDetails = false
    var isFromDashboard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPostal.delegate = self
        setupInitialMap()
    }
    
    // MARK: - Setup
    
    private func setupInitialMap() {
        if isFromPostDetails, let firstAddress = addressList.first {
            txtPostal.text = firstAddress?.address
            setMapData(latitude: Double(firstAddress?.latitude ?? "") ?? 0,
                       longitude: Double(firstAddress?.longitude ?? "") ?? 0,
                       title: firstAddress?.address ?? "")
        } else if let userLocation = appDelegate.userLocation {
            txtPostal.text = userLocation.address
            setMapData(latitude: Double(userLocation.latitude ?? "") ?? 0,
                       longitude: Double(userLocation.longitude ?? "") ?? 0,
                       title: userLocation.address ?? "")
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func backOnPress(_ sender: UIButton) {
        popViewController()
    }
    
    @IBAction private func saveOnPress(_ sender: UIButton) {
        if isFromPostDetails {
            if let address = addressList.first{
                newLocation?(address)
            }
        }
        popViewController()
    }
}

// MARK: - UITextFieldDelegate
extension MapLocationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == txtPostal else { return true }
        
        let autocompleteVC = GMSAutocompleteViewController()
        autocompleteVC.delegate = self
        present(autocompleteVC, animated: true)
        return false
    }
}

// MARK: - Google Autocomplete Delegate
extension MapLocationVC: GMSAutocompleteViewControllerDelegate {
    
    private func setMapData(latitude: Double, longitude: Double, title: String) {
        guard latitude != 0.0, longitude != 0.0 else { return }
        
        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Draw radius circle
        let circle = GMSCircle(position: position, radius: 3000)
        if let blueColor = UIColor(named: "BlueColor") {
            circle.fillColor = blueColor.withAlphaComponent(0.2)
            circle.strokeColor = blueColor
        }
        circle.strokeWidth = 2
        circle.map = mapView
        
        // Animate camera
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        mapView.animate(to: camera)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true)
        
        txtPostal.text = place.formattedAddress
        lat = place.coordinate.latitude
        log = place.coordinate.longitude
        
        fetchLocationDetails(latitude: lat, longitude: log)
    }
    
    private func fetchLocationDetails(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocode error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            var result = UserLocation()
            result.address = self.txtPostal.text
            result.city = placemark.locality
            result.area = placemark.administrativeArea
            result.postal_code = placemark.postalCode
            result.latitude = String(latitude)
            result.longitude = String(longitude)
            
            if self.isFromPostDetails {
                let json: [String: Any] = [
                    "address": result.address ?? "",
                    "latitude": result.latitude ?? "",
                    "longitude": result.longitude ?? "",
                    "location_ids": "0",
                    "city": result.city ?? "",
                    "postal_code": result.postal_code ?? "",
                    "area": result.area ?? "",
                    "id": appDelegate.userDetails?.id ?? 0
                ]
                if let obj = Locations(JSON: json) {
                    self.addressList = [obj]
                }
            } else {
                appDelegate.userLocation = result
            }
            
            self.setMapData(latitude: latitude, longitude: longitude, title: result.address ?? "")
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        dismiss(animated: true)
        print("Autocomplete error: \(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }
}
