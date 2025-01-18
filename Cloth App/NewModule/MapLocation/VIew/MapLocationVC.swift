//
//  MapLocationVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 09/07/24.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IBAnimatable

class MapLocationVC: BaseViewController {

    @IBOutlet weak var txtPostal: AnimatableTextField!
    @IBOutlet weak var mapView: GMSMapView!
    
    var onDataReceived: (([String:Any], String) -> Void)?
    var locationdelegate : UserLocationDelegate!
    var edit = false
    var isPost = false
    var addresslist = [Locations?]()
    var lat = 0.0
    var log = 0.0
    var adddressArea = ""
    var city = ""
    var address = ""
    var isEdit : Bool?
    var address2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtPostal.delegate = self
        
        if let locations = appDelegate.userDetails?.locations{
            let Location = locations
            print(Location)
            if Location.count>0{
                let data = Location.first
                self.lat = Double(data?.latitude ?? "0.0") ?? 0.0
                self.log = Double(data?.longitude ?? "0.0") ?? 0.0
                self.txtPostal.text = data?.address
                self.address2 = data?.address ?? ""
                self.adddressArea = data?.area ?? ""
                self.address = data?.address ?? ""
                self.city = data?.city ?? ""
            }
        }
       
        self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: self.address)
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        self.updateLocation()
    }
    
}

extension MapLocationVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtPostal {
            let viewController = GMSAutocompleteViewController()
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension MapLocationVC: GMSAutocompleteViewControllerDelegate  {
    
    
    func setInitDataUserLise(latitude: Double , longitude : CLLocationDegrees ,tital : String){
        if latitude != 0.0 || longitude != 0.0{
            self.mapView.clear()
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            // let marker = GMSMarker(position: position)
            //  marker.title = tital
            //  marker.map = self.mapView
            let circle = GMSCircle(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), radius:3000)
            circle.fillColor = UIColor.init(named: "BlueColor")!.withAlphaComponent(0.2)
            circle.strokeWidth = 6
            circle.strokeColor = UIColor.init(named: "BlueColor")
            circle.map = self.mapView
            let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
            self.mapView.camera = location
            self.mapView.animate(to: location)
        }
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        print("Place name: ", place.name ?? "")
               print("Place address: ", place.formattedAddress ?? "")
               print("Place attributions: ", place.attributions ?? "")
        
//        self.txtPostal.text = place.formattedAddress
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
       // self.address = place.formattedAddress!
        self.getAddressFromLatLon(latitude: self.lat, longitude: self.log)
    }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            if placemarks == nil {
                return
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                print(addressString)
                
                let json = ["address": addressString,
                            "latitude" : String(self.lat),
                            "longitude" : String(self.log),
                            "location_ids" : "0",
                            "city" : pm.locality ?? "",
                            "postal_code" : self.txtPostal.text!,
                            "area" : pm.subLocality ?? "",
                            "id" : appDelegate.userDetails?.id ?? 0] as [String : Any]
                self.txtPostal.text = addressString
                self.address = addressString
                self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: addressString)
                let objet = Locations.init(JSON: json)
                self.addresslist.removeAll()
                self.addresslist.append(objet)
                debugPrint(self.addresslist)
            }
        })
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension MapLocationVC{
    func updateLocation(){
        var dictGeneral = [String:Any]()
        var address = [[String:Any]]()
        if title != "Edit Profile" {
            dictGeneral["name"] = appDelegate.userDetails?.name ?? ""
            dictGeneral["email"] = appDelegate.userDetails?.email ?? ""
            dictGeneral["username"] = appDelegate.userDetails?.username ?? ""
            dictGeneral["phone"] = appDelegate.userDetails?.phone ?? ""
            dictGeneral["country_code"] = appDelegate.userDetails?.country_code ?? ""
            dictGeneral["country_prefix"] = appDelegate.userDetails?.country_prefix ?? ""
        }
        for i in self.addresslist{
            var dict = [String:Any]()
            dict["id"] = "\(i?.id ?? 0)"
            dict["address"] = "\(i?.address ?? "")"
            dict["postal_code"] = "\(i?.postal_code ?? "")"
            dict["latitude"] = "\(i?.latitude ?? "")"
            dict["longitude"] = "\(i?.longitude ?? "")"
            dict["city"] = "\(i?.city ?? "")"
            dict["area"] = "\(i?.area ?? "")"
            self.address2 = "\(i?.address ?? "")"
            address.append(dict)
            print(address)
        }
        dictGeneral["locations"] = self.json(from: address)
        
        if title != "Edit Profile" {
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, method: .post, parameters: dictGeneral) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                        }
                        self.popViewController()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        } else {
            onDataReceived?(dictGeneral, self.address2)
            popViewController()
        }
    }
}
