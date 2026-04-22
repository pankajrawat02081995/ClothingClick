

import UIKit
import MapKit
import GooglePlaces

final class MapLocationVC: BaseViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet private weak var txtPostal: UITextField!

    var onDataReceived: (([String: Any], String) -> Void)?
    var newLocation: ((Locations?) -> Void)?

    var addressList: [Locations?] = []
    var lat: Double = 0.0
    var log: Double = 0.0

    var isFromPostDetails = false
    var isFromDashboard = false

    private var circleOverlay: MKCircle?
    private var pointAnnotation: MKPointAnnotation?
    private let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        txtPostal.delegate = self
        mapView.delegate = self

        setupInitialMap()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        cleanupMemory()  // 🔥 VERY IMPORTANT
    }

    deinit {
        print("MapLocationVC deallocated successfully")  // 🔥 Confirm no leaks
    }

    // MARK: - Memory Cleanup
    private func cleanupMemory() {
        geocoder.cancelGeocode()

        mapView.delegate = nil
        txtPostal.delegate = nil

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        circleOverlay = nil
        pointAnnotation = nil

        onDataReceived = nil
        newLocation = nil
    }

    // MARK: - Initial Setup
    private func setupInitialMap() {
        if isFromPostDetails, let first = addressList.first {
            txtPostal.text = first?.address
            setMapData(
                latitude: Double(first?.latitude ?? "") ?? 0,
                longitude: Double(first?.longitude ?? "") ?? 0,
                title: first?.address ?? ""
            )
        } else if let userLocation = appDelegate.userLocation {
            txtPostal.text = userLocation.address
            setMapData(
                latitude: Double(userLocation.latitude ?? "") ?? 0,
                longitude: Double(userLocation.longitude ?? "") ?? 0,
                title: userLocation.address ?? ""
            )
        }
    }

    // MARK: - Back
    @IBAction private func backOnPress(_ sender: UIButton) {
        popViewController()
    }

    // MARK: - Save
    @IBAction private func saveOnPress(_ sender: UIButton) {
        if isFromPostDetails {
            if let address = addressList.first {
                newLocation?(address)
            }
        }
        popViewController()
    }
}

// MARK: - Google Places Controller
extension MapLocationVC: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtPostal {
            let autocompleteVC = GMSAutocompleteViewController()
            autocompleteVC.delegate = self
            present(autocompleteVC, animated: true)
            return false
        }
        return true
    }
}

// MARK: - Google Places Delegate
extension MapLocationVC: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController,
                        didAutocompleteWith place: GMSPlace) {

        dismiss(animated: true)

        txtPostal.text = place.formattedAddress
        lat = place.coordinate.latitude
        log = place.coordinate.longitude

        fetchLocationDetails(latitude: lat, longitude: log)
    }

    func viewController(_ viewController: GMSAutocompleteViewController,
                        didFailAutocompleteWithError error: Error) {
        dismiss(animated: true)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }
}

// MARK: - Reverse Geocode
extension MapLocationVC {

    private func fetchLocationDetails(latitude: Double, longitude: Double) {

        geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { [weak self] placemarks, err in
            guard let self = self else { return }
            guard let placemark = placemarks?.first else { return }

            var result = UserLocation()
            result.address = self.txtPostal.text
            result.city = placemark.locality
            result.area = placemark.administrativeArea
            result.postal_code = placemark.postalCode
            result.latitude = "\(latitude)"
            result.longitude = "\(longitude)"

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

            self.setMapData(latitude: latitude,
                            longitude: longitude,
                            title: result.address ?? "")
        }
    }
}

// MARK: - Apple Map (Pin + Circle)
extension MapLocationVC {

    private func setMapData(latitude: Double, longitude: Double, title: String) {

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        // Pin
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        mapView.addAnnotation(pin)
        pointAnnotation = pin

        // Circle
        let circle = MKCircle(center: coordinate, radius: 3000)
        mapView.addOverlay(circle)
        circleOverlay = circle

        // Region
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 6000,
            longitudinalMeters: 6000
        )
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - Map Overlay Renderer
extension MapLocationVC: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            let blue = UIColor(named: "BlueColor") ?? .blue
            renderer.strokeColor = blue
            renderer.fillColor = blue.withAlphaComponent(0.25)
            renderer.lineWidth = 2
            return renderer
        }

        return MKOverlayRenderer()
    }
}
