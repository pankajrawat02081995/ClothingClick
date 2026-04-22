//
//  StoreLocationViewController.swift
//  ClothApp
//
//  Created by Apple on 26/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces


protocol StoreLocationDelegate {
    func LocationFormStoreLocationAdd(addressLists: [Locations?])
}

class StoreLocationViewController: BaseViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var txtPostalCode: CustomTextField!
    @IBOutlet weak var lblMonthlyRateTitle: UILabel!
    @IBOutlet weak var lblMonthlyRateValue: UILabel!
    @IBOutlet weak var btnAddAnotherLocation: CustomButton!
    @IBOutlet weak var btnNext: CustomButton!
    var storelocationdelegate : StoreLocationDelegate!
    var addresslist = [Locations?]()
    var cityList = [String]()
    var edit = false
    var lat = 1.1
    var log = 1.1
    var adddressArea = ""
    var address = ""
    var clearmarker:Bool = false
    var startadding = 0
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setInitDataUserLise(latitude: appDelegate.defaultLatitude, longitude: appDelegate.defaultLongitude, tital: "Address")
        self.setNavigationBarShadow(navigationBar: self.navBar)
        if self.edit {
            self.imgLogo.isHidden = true
            self.lblHeaderTitle.isHidden = false
            self.showCurrentLocationOnMap()
        }
        else {
            self.imgLogo.isHidden = false
            self.lblHeaderTitle.isHidden = true
        }
        if self.addresslist.count != 0 {
            self.startadding = self.addresslist.count
            self.showCurrentLocationOnMap()
        }
    }
    
    @IBAction func btnAddAnotherLocation_clicked(_ sender: Any) {
        if self.txtAddress.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
        }
        else if self.txtPostalCode.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter postalcode")
        }
        else {
            
            self.startadding = self.startadding + 1
            self.txtAddress.text = ""
            self.txtPostalCode.text = ""
            if txtPostalCode.isFirstResponder {
                self.txtAddress.becomeFirstResponder()
            }
            if self.addresslist.count == 0 {
                self.lblMonthlyRateValue.text = "Free"
            }
            else {
                self.lblMonthlyRateValue.text = appDelegate.generalSettings?.additional_store_location_rate
            }
            self.showCurrentLocationOnMap()
        }
    }
    
    @IBAction func btnNext_clicked(_ sender: Any) {
        if self.txtAddress.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
        }
//        else if self.txtPostalCode.text?.trim().count == 0 {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter postalcode")
//        }
        else {
            if self.storelocationdelegate != nil {
                self.storelocationdelegate.LocationFormStoreLocationAdd(addressLists: self.addresslist)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getlatLong (address : String){
        let address = address
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error)
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                
                self.lat = coordinates.latitude
                self.log = coordinates.longitude
                
                self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: self.txtAddress.text!)
            }
        })
    }
    
    func setInitDataUserLise(latitude: Double , longitude : CLLocationDegrees ,tital : String){
        if latitude != 0.0 || longitude != 0.0{
            
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           // let marker = GMSMarker(position: position)
            //marker.title = tital
            //marker.map = self.mapView
            let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
            self.mapView.camera = location
            self.mapView.animate(to: location)
            //            self.showCurrentLocationOnMap()
        }
    }
    func getLocationBound () -> GMSCoordinateBounds {
        var minLat = 90.0;
        var minLon = 180.0;
        var maxLat = -90.0;
        var maxLon = -180.0;
        for data in self.addresslist{
            let latitude = Double((data?.latitude!)! ) ?? 0.0
            let longitude =  Double((data?.longitude!)! ) ?? 0.0
            
            minLat = min(minLat, latitude)//Math.min(minLat, latitude);
            minLon = min(minLon, longitude);
            maxLat = max(maxLat, latitude);
            maxLon = max(maxLon, longitude);
        }
        let minLocation = CLLocationCoordinate2D(latitude: minLat, longitude: minLon)
        let maxLocation = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
        return GMSCoordinateBounds(coordinate: minLocation,coordinate: maxLocation)
    }
    func showCurrentLocationOnMap(){
        let bounds = GMSCoordinateBounds()
        for data in self.addresslist{
            let location = CLLocationCoordinate2D(latitude: Double((data?.latitude)!)!, longitude: Double((data?.longitude)!)!)
            print("location: \(location)")
            let marker = GMSMarker()
            marker.position = location
            marker.snippet = data?.address
            marker.map = mapView
            bounds.includingCoordinate(location)
            
        }
        let update = GMSCameraUpdate.fit(self.getLocationBound(), withPadding: 50.0)
        mapView.moveCamera(update)
    }
}

extension StoreLocationViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddress {
            let viewController = GMSAutocompleteViewController()
            viewController.delegate = self
            
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension StoreLocationViewController: GMSAutocompleteViewControllerDelegate  {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        print("Place name: ", place.name ?? "")
        print("Place address: ", place.formattedAddress ?? "")
        print("Place attributions: ", place.attributions ?? "")
        
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
//        self.txtAddress.text = place.formattedAddress!
        self.address = place.formattedAddress!
        
        
        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
        self.txtPostalCode.text = component.postalCode
        self.adddressArea = component.area ?? ""
        self.txtAddress.text = component.city ?? ""

       let city = component.city ?? ""
        
        let json = ["address": self.address,
                    "latitude" : String(self.lat),
                    "longitude" : String(self.log),
                    "city" : city,
                    "postal_code" : String(self.txtPostalCode.text ?? ""),
                    "area" : self.adddressArea
        ]
        
        let objet = Locations.init(JSON: json)
        
        if self.addresslist.count == self.startadding{
            self.addresslist.append(objet)
        }else{
            self.addresslist.remove(at: self.startadding)
            self.addresslist.insert(objet, at: self.startadding)
        }
        
      //  self.addresslist.append(objet)
        
        self.mapView.clear()
        self.showCurrentLocationOnMap()
        
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
