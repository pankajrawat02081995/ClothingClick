//
//  DistanceViewController.swift
//  ClothApp
//
//  Created by Apple on 02/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import GoogleMaps
import Contacts
import GooglePlaces

protocol DistnceDelegate {
    func selctedDistnce (distnce: String, Selecte:Bool, index : Int, hearderTitel: String)
}

class DistanceViewController: BaseViewController {
    
    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var lblSarchLocation: UILabel!
    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var sliderDistanceKm: UISlider!{
        didSet{
            sliderDistanceKm.maximumValue = 50
        }
    }
    @IBOutlet weak var lblDistanceKm: UILabel!
    @IBOutlet weak var btnViewItems: CustomButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    var distanceDelegate : DistnceDelegate!
    var selectedIndex = 0
    var headerTitle = ""
    var saveSearch = false
    var lat = 0.0
    var log = 0.0
    var circle = GMSCircle()
    var viewCount = 0
    var isMySize = ""
    var selectSubCategoryId = [String]()
    var selecteddistance = ""
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
//        sliderDistanceKm.maximumValue = 50
        let objet = appDelegate.userDetails?.locations
//        if objet?.count ?? 0 > 0 {
//            if let lat  = objet?[0].latitude {
//                self.lat = Double(lat) ?? 0.0
//            }
//            
//            if let lon = objet?[0].longitude {
//                self.log = Double(lon) ?? 0.0
//            }
//            self.lblSarchLocation.text = objet?[0].address
//        }
        
        self.lblSarchLocation.text = appDelegate.userLocation?.address ?? ""
        self.log = Double(appDelegate.userLocation?.longitude ?? "") ?? 0.0
        self.lat = Double(appDelegate.userLocation?.latitude ?? "") ?? 0.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        self.lblSarchLocation.isUserInteractionEnabled = true
        self.lblSarchLocation.addGestureRecognizer(tapGesture)
        
        self.sliderDistanceKm.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])

//        if self.saveSearch{
//            self.sliderDistanceKm.value = Float(self.selecteddistance) ?? 10.0
//        }else{
            self.sliderDistanceKm.value = Float(FilterSingleton.share.filter.distance ?? "") ?? 10.0
//        }
        self.lblDistanceKm.text = "\(Int(round(self.sliderDistanceKm.value))) Km"
    
        self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: "Address", radies: Int(round(self.sliderDistanceKm.value)))
        if self.isFilterProduct == true{
            self.btnViewItems.setTitle("Add", for: .normal)
        }else{
            if self.saveSearch {
                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
            }
            else {
                self.btnViewItems.setTitle("View 0 Items", for: .normal)
                self.callViewCount()
            }
        }
    }
    
    @objc func labelTapped() {
        print("Label was tapped!")
        let viewController = GMSAutocompleteViewController()
        viewController.delegate = self
        self.present(viewController, animated: true, completion: nil)
        self.callViewCount()
    }
    
    @objc func sliderDidEndSliding(_ sender: UISlider) {
        // Handle the action when the slider is released
        if !self.saveSearch{
            print("Slider released at value: \(sender.value)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.callViewCount()
            })
        }
    }
    
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.saveSearch || self.isFilterProduct == true{
//            if self.distanceDelegate != nil {
//                self.distanceDelegate.selctedDistnce(distnce: String(Int(round(self.sliderDistanceKm.value))) , Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
//            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            if self.viewCount != 0 {
//                self.distanceDelegate.selctedDistnce(distnce: String(Int(round(self.sliderDistanceKm.value))) , Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
                let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                viewController.titleStr = "Search Results"
//                viewController.isMySize = self.isMySize
//                viewController.selectSubCategoryId = self.selectSubCategoryId
//                viewController.selectSizeId = appDelegate.selectSizeId
//                viewController.selectColorId = appDelegate.selectColorId
//                viewController.selectConditionId = appDelegate.selectConditionId
//                viewController.selectPriceId = appDelegate.selectPriceId
//                viewController.priceFrom = appDelegate.priceFrom
//                viewController.priceTo = appDelegate.priceTo
//                viewController.selectDistnce = appDelegate.selectDistnce
//                viewController.selectSellerId = appDelegate.selectSellerId
//                viewController.selectBrandId = appDelegate.selectBrandId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnBack_Cliked(_ button: Any) {
        if self.distanceDelegate != nil {
            self.distanceDelegate.selctedDistnce(distnce: String(Int(round(self.sliderDistanceKm.value))) , Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SliderVelueChange(_ button: UISlider) {
        self.lblDistanceKm.text = "\(Int(round(self.sliderDistanceKm.value))) Km"
        self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: "Address", radies: Int(self.sliderDistanceKm.value))
        //        appDelegate.selectDistnce = "\(Int(self.sliderDistanceKm.value))"
        FilterSingleton.share.filter.distance = "\(Int(round(self.sliderDistanceKm.value)))"
        FilterSingleton.share.selectedFilter.distance = "\(Int(round(self.sliderDistanceKm.value))) Km"
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
        //            self.callViewCount()
        //        })
        
    }
    
    func getLocationBound (radies : Int) -> GMSCoordinateBounds {
        var minLat = 90.0;
        var minLon = 180.0;
        var maxLat = -90.0;
        var maxLon = -180.0;
//        for data in self.addresslist{
        let latitude = self.lat//Double((data?.latitude!)! ) ?? 0.0
        let longitude =  self.log//Double((data?.longitude!)! ) ?? 0.0
            
            minLat = min(minLat, latitude * Double(radies))//Math.min(minLat, latitude);
        minLon = min(minLon, longitude * Double(radies));
            maxLat = max(maxLat, latitude * Double(radies));
            maxLon = max(maxLon, longitude * Double(radies));
//        }
        let minLocation = CLLocationCoordinate2D(latitude: minLat, longitude: minLon)
        let maxLocation = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
        return GMSCoordinateBounds(coordinate: minLocation,coordinate: maxLocation)
    }
    
    func setInitDataUserLise(latitude: Double , longitude : CLLocationDegrees ,tital : String, radies : Int){
        if latitude != 0.0 || longitude != 0.0{
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let marker = GMSMarker(position: position)
//            marker.title = tital
//            marker.map = self.mapView
            self.circle.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.circle.radius = CLLocationDistance(radies * 1000)
            self.circle.fillColor = UIColor.init(named: "BlueColor")!.withAlphaComponent(0.2)
            self.circle.strokeWidth = 6
            self.circle.strokeColor = UIColor.init(named: "BlueColor")
            self.circle.map = self.mapView
            let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 8)//Float(zooming))
            self.mapView.camera = location
            self.mapView.animate(to: location)

        }
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.circle.position = position.target
        
    }
}

extension  DistanceViewController:GMSAutocompleteViewControllerDelegate{
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
    
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        print("Place name: ", place.name ?? "")
               print("Place address: ", place.formattedAddress ?? "")
               print("Place attributions: ", place.attributions ?? "")
        
        self.lblSarchLocation.text = place.formattedAddress
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
        self.setInitDataUserLise(latitude: self.lat, longitude: self.log, tital: place.formattedAddress ?? "", radies: Int(round(self.sliderDistanceKm.value)))
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
                            "postal_code" : self.txtSearchBar.text ?? "",
                            "area" : pm.subLocality ?? "",
                            "id" : appDelegate.userDetails?.id ?? 0] as [String : Any]
                if let objet = Locations.init(JSON: json){
                    if appDelegate.userDetails?.locations?.count ?? 0 > 0{
                        appDelegate.userDetails?.locations?[0] = objet
                    }else{
                        appDelegate.userDetails?.locations?.append(objet)
                    }
                }
            }
        })
    }
    
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            
//            let param = ["is_mysize":  "0" ,
//                         "gender_id" : appDelegate.selectGenderId,
//                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
//                         "sizes" : appDelegate.selectSizeId,
//                         "colors" : appDelegate.selectColorId,
//                         "condition_id" : appDelegate.selectConditionId ,
//                         "distance" : appDelegate.selectDistnce ,
//                         "seller" : appDelegate.selectSellerId,
//                         "brand_id" : appDelegate.selectBrandId ,
//                         "notification_item_counter" : "",
//                         "name" :  "",
//                         "price_type" : appDelegate.selectPriceId ,
//                         "price_from" : appDelegate.priceFrom ,
//                         "price_to" : appDelegate.priceTo,
//                         "is_only_count" : "1" ,
//                         "page" : "0"
//                        ]
            FilterSingleton.share.filter.is_only_count = "1"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
            dict["latitude"] = appDelegate.userLocation?.latitude ?? ""
            dict["longitude"] = appDelegate.userLocation?.longitude ?? ""

            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: dict) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.viewCount = data.total_posts ?? 0
                            if self.saveSearch {
                                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
                            }
                            else {
                            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                            }
                        }
                        
//                        self.navigateToHomeScreen()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}
