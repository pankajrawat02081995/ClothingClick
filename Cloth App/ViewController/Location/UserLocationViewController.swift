//
//  UserLocationViewController.swift
//  ClothApp
//
//  Created by Apple on 26/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import GoogleMaps
import Contacts
import GooglePlaces

protocol UserLocationDelegate {
    func LocationFormAdddLocation(address: [Locations?])
}

class UserLocationViewController: BaseViewController {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblAddressSearchMessage: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var txtPostalCode: CustomTextField!
    @IBOutlet weak var btnNext: CustomButton!
    
    var locationdelegate : UserLocationDelegate!
    var edit = false
    var isPost = false
    var addresslist = [Locations?]()
    var lat = 0.0
    var log = 0.0
    var adddressArea = ""
    var city = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgLogo.isHidden = true
        self.lblHeaderTitle.isHidden = true
        
        if self.edit {
            let objet = self.addresslist
            if objet.count > 0 {
                self.lat = Double(objet[0]?.latitude ?? "0.0") ?? 0.0
                self.log = Double(objet[0]?.longitude ?? "0.0") ?? 0.0
                self.txtPostalCode.text = objet[0]?.postal_code
                self.txtAddress.text = objet[0]?.address
                self.adddressArea = objet[0]?.area ?? ""
                self.address = objet[0]?.address ?? ""
                self.city = objet[0]?.city ?? ""
                
            }else{
                self.lat = Double( "0.0") ?? 0.0
                self.log = Double("0.0") ?? 0.0
                self.txtPostalCode.text = ""
                self.txtAddress.text = ""
            }
            self.setNavigationBarShadow(navigationBar: self.navBar)
            self.imgLogo.isHidden = true
            self.lblHeaderTitle.isHidden = false
            //            self.txtAddress.placeholder = ""
           // self.lblAddressSearchMessage.isHidden = true
            
            self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: self.address)
        }
        else if self.isPost{
        //    self.lblAddressSearchMessage.isHidden = false
          //  self.txtAddress.isUserInteractionEnabled = false
            let objet = appDelegate.userDetails?.locations ?? []
            if objet.count > 0{
                self.lat = Double(objet[0].latitude ?? "0.0") ?? 0.0
                self.log = Double(objet[0].longitude ?? "0.0") ?? 0.0
            }else{
                self.lat = Double( "0.0") ?? 0.0
                self.log = Double("0.0") ?? 0.0
            }
            self.setNavigationBarShadow(navigationBar: self.navBar)
            self.setLocationData()
        }
        else {
            let objet = appDelegate.userDetails?.locations ?? []
            if objet.count > 0{
                self.lat = Double(objet[0].latitude ?? "0.0") ?? 0.0
                self.log = Double(objet[0].longitude ?? "0.0") ?? 0.0
            }else{
                self.lat = Double( "0.0") ?? 0.0
                self.log = Double("0.0") ?? 0.0
            }
          
            self.setNavigationBarShadow(navigationBar: self.navBar)
           // self.lblAddressSearchMessage.isHidden = true
            self.imgLogo.isHidden = false
            self.lblHeaderTitle.isHidden = true
        }
    }
    
    func setLocationData () {
        let objet = appDelegate.userDetails?.locations ?? []
        if objet.count > 0{
            self.lat = Double(objet[0].latitude ?? "0.0") ?? 0.0
            self.log = Double(objet[0].longitude ?? "0.0") ?? 0.0
        }else{
            self.lat = Double( "0.0") ?? 0.0
            self.log = Double("0.0") ?? 0.0
        }
        
        self.setInitDataUserLise(latitude:self.lat, longitude: self.log, tital: self.address)
        self.txtAddress.text  = objet[0].city
        self.txtPostalCode.text = objet[0].postal_code
    }
    func getlatLong (address : String){
        let address = address
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                self.setInitDataUserLise(latitude: coordinates.latitude, longitude: coordinates.longitude, tital: self.txtAddress.text!)
                self.lat = coordinates.latitude
                self.log = coordinates.longitude
                print("lat : \(self.lat) , long : \(self.log)")
            }
        })
    }
    
    func getLataLongFormPOstalCode (postalcode : String) {
        let geocoder = CLGeocoder()
            let postalAddress = CNMutablePostalAddress()
            postalAddress.postalCode = postalcode
        print(postalAddress)
            geocoder.geocodePostalAddress(postalAddress, preferredLocale: Locale(identifier: "en_US")) { (placemarks, err) in
                    if let placemark = placemarks?[0] {
                        print(placemark)
                        return
                    }
                    print(err)
            }
    }
    
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
  
   
    @IBAction func btnNext_clicked(_ sender: Any) {
        if  isPost {
            if self.locationdelegate != nil {
                self.locationdelegate.LocationFormAdddLocation(address: self.addresslist)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            if self.txtAddress.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
            }
//            if self.txtPostalCode.text?.trim().count == 0 {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Postalcode")
//            }
            else {
                self.getlatLong(address: self.txtAddress.text!)
                
                let json = ["address": self.address,
                            "latitude" : String(self.lat),
                            "longitude" : String(self.log),
                            "location_ids" : "0",
                            "city" : self.city,
                            "postal_code" : String(self.txtPostalCode.text ?? ""),
                            "area" : self.adddressArea
                ]
                let objet = Locations.init(JSON: json)
                self.addresslist.append(objet)
                if self.locationdelegate != nil {
                    self.locationdelegate.LocationFormAdddLocation(address: self.addresslist)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension UserLocationViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddress {
            let viewController = GMSAutocompleteViewController()
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        else if textField == txtPostalCode {
            let viewController = GMSAutocompleteViewController()
            viewController.delegate = self
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if textField == self.txtPostalCode {
//
//            let currentString: NSString = (textField.text ?? "") as NSString
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            if newString != "" {
//                self.getLataLongFormPOstalCode(postalcode: self.txtPostalCode.text!)
//                //self.callBrandSearchList(searchtext: (newString) as String, isShowHud: false )
//            }
//            else {
////                self.brandSearchList.removeAll()
////                self.tblBrand.reloadData()
//            }
//            return true
//        }
//        else {
//            return true
//        }
//    }
}

extension UserLocationViewController: GMSAutocompleteViewControllerDelegate  {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        print("Place name: ", place.name ?? "")
               print("Place address: ", place.formattedAddress ?? "")
               print("Place attributions: ", place.attributions ?? "")
        
       // self.addressFull = place.formattedAddress!
        self.txtAddress.text = place.formattedAddress
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
        self.txtAddress.text = place.formattedAddress!
        self.address = place.formattedAddress!
        self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: self.address)
        
        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
        self.txtPostalCode.text = component.postalCode
        self.adddressArea = component.city ?? ""
        if component.area == "" {
            self.city = component.city ?? ""
        }else{
        self.city = component.area ?? ""
        }
        let json = ["address": self.txtAddress.text!,
                    "latitude" : String(self.lat),
                    "longitude" : String(self.log),
                    "location_ids" : "0",
                    "city" : self.adddressArea,
                    "postal_code" : self.txtPostalCode.text!,
                    "area" : self.city,
                    "id" : appDelegate.userDetails?.id ?? 0] as [String : Any]
        let objet = Locations.init(JSON: json)
        self.addresslist.removeAll()
        self.addresslist.append(objet)
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
