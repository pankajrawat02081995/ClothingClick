import UIKit
import GoogleMaps
import GooglePlaces
import IBAnimatable

class MapLocationVC: BaseViewController {

    @IBOutlet weak var txtPostal: AnimatableTextField!
    @IBOutlet weak var mapView: GMSMapView!

    var onDataReceived: (([String: Any], String) -> Void)?
    var locationDelegate: UserLocationDelegate!
    var isPost = false
    var addressList = [Locations?]()
    var lat = 0.0
    var log = 0.0
    var addressArea = ""
    var city = ""
    var address = ""
    var isEdit: Bool?
    var address2 = String()

    var newLocation: ((Locations?) -> Void)?
    var isFromPostDetails = false
    var isFromDashboard = false

    override func viewDidLoad() {
        super.viewDidLoad()

        txtPostal.delegate = self

        // Initialize map with user location or fallback to default
        if self.isFromPostDetails == true &&  self.addressList.count > 0{
            let userLocation = addressList.first
            txtPostal.text = userLocation??.address ?? ""
            setInitDataUserLise(
                latitude: Double(userLocation??.latitude ?? "") ?? 0.0,
                longitude: Double(userLocation??.longitude ?? "") ?? 0.0,
                title: userLocation??.address ?? ""
            )
        }else{
            let userLocation = appDelegate.userLocation
            txtPostal.text = userLocation?.address ?? ""
            setInitDataUserLise(
                latitude: Double(userLocation?.latitude ?? "") ?? 0.0,
                longitude: Double(userLocation?.longitude ?? "") ?? 0.0,
                title: userLocation?.address ?? ""
            )
        }
    }

    @IBAction func backOnPress(_ sender: UIButton) {
        popViewController()
    }

    @IBAction func saveOnPress(_ sender: UIButton) {
        if self.isFromPostDetails == true{
            self.newLocation?(self.addressList.first as? Locations)
        }
        popViewController()
    }
}

extension MapLocationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard textField == txtPostal else { return true }

        let viewController = GMSAutocompleteViewController()
        viewController.delegate = self
        present(viewController, animated: true)
        return false
    }
}

extension MapLocationVC: GMSAutocompleteViewControllerDelegate {

    func setInitDataUserLise(latitude: Double, longitude: CLLocationDegrees, title: String) {
        guard latitude != 0.0 || longitude != 0.0 else { return }

        mapView.clear()
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circle = GMSCircle(position: position, radius: 3000)
        circle.fillColor = UIColor(named: "BlueColor")?.withAlphaComponent(0.2) ?? .clear
        circle.strokeWidth = 6
        circle.strokeColor = UIColor(named: "BlueColor") ?? .clear
        circle.map = mapView

        let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        mapView.camera = location
        mapView.animate(to: location)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true)
        
        debugPrint(place.formattedAddress ?? "")
        txtPostal.text = place.formattedAddress
        lat = place.coordinate.latitude
        log = place.coordinate.longitude

        // Fetch city/state details asynchronously
        getCityOrState(from: place.coordinate.latitude, longitude: place.coordinate.longitude) { result in
            switch result {
            case .success(let location):
                print("Location: \(location)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    private func getCityOrState(from latitude: Double, longitude: Double, completion: @escaping (Result<Bool, Error>) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let placemark = placemarks?.first else {
                completion(.failure(NSError(domain: "LocationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No location data found."])))
                return
            }

            var result = UserLocation()
            result.address = self.txtPostal.text ?? ""
            result.city = placemark.locality
            result.area = placemark.administrativeArea
            result.postal_code = placemark.postalCode
            result.latitude = String(latitude)
            result.longitude = String(longitude)

            if result.city?.isEmpty == true && result.area?.isEmpty == true {
                completion(.failure(NSError(domain: "LocationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "City and state not found."])))
            } else {
                if self.isFromPostDetails == true{
                    let json = ["address": result.address ?? "",
                                "latitude" : result.latitude ?? "",
                                "longitude" : result.longitude ?? "",
                                "location_ids" : "0",
                                "city" : result.city ?? "",
                                "postal_code" : result.postal_code ?? "",
                                "area" : result.area ?? "",
                                "id" : appDelegate.userDetails?.id ?? 0] as [String : Any]
                    let objet = Locations.init(JSON: json)
                    self.addressList.removeAll()
                    self.addressList.append(objet)
                }else{
                    appDelegate.userLocation = result
                }
                self.setInitDataUserLise(
                    latitude: Double(result.latitude ?? "") ?? 0.0,
                    longitude: Double(result.longitude ?? "") ?? 0.0,
                    title: result.address ?? ""
                )
                completion(.success(true))
            }
        }
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true)
    }

    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//extension MapLocationVC {
//    func updateLocation() {
//        var dictGeneral = [String: Any]()
//        var address = [[String: Any]]()
//
//        if title != "Edit Profile" {
//            dictGeneral["name"] = appDelegate.userDetails?.name ?? ""
//            dictGeneral["email"] = appDelegate.userDetails?.email ?? ""
//            dictGeneral["username"] = appDelegate.userDetails?.username ?? ""
//            dictGeneral["phone"] = appDelegate.userDetails?.phone ?? ""
//            dictGeneral["country_code"] = appDelegate.userDetails?.country_code ?? ""
//            dictGeneral["country_prefix"] = appDelegate.userDetails?.country_prefix ?? ""
//        }
//
//        for location in addressList {
//            var dict = [String: Any]()
//            dict["id"] = "\(location?.id ?? 0)"
//            dict["address"] = "\(location?.address ?? "")"
//            dict["postal_code"] = "\(location?.postal_code ?? "")"
//            dict["latitude"] = "\(location?.latitude ?? "")"
//            dict["longitude"] = "\(location?.longitude ?? "")"
//            dict["city"] = "\(location?.city ?? "")"
//            dict["area"] = "\(location?.area ?? "")"
//            self.address2 = "\(location?.address ?? "")"
//            address.append(dict)
//        }
//
//        dictGeneral["locations"] = self.json(from: address)
//
//        if title != "Edit Profile" {
//            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, method: .post, parameters: dictGeneral) { response, error in
//                if let error = error {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error.domain ?? ErrorMessage)
//                    return
//                }
//
//                if let response = response, let userDetails = response.dictData {
//                    self.saveUserDetails(userDetails: userDetails)
//                }
//
//                if self.isFromDashboard {
//                    if let newLocation = self.addressList.first {
//                        self.newLocation?(newLocation)
//                        self.popViewController()
//                    }
//                } else {
//                    self.popViewController()
//                }
//            }
//        } else {
//            onDataReceived?(dictGeneral, self.address2)
//            popViewController()
//        }
//    }
//}
