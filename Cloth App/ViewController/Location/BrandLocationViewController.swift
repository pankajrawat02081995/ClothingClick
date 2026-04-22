//
//  BrandLocationViewController.swift
//  ClothApp
//
//  Created by Apple on 26/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import ObjectMapper

protocol BrandLocationDelegate {
    func LocationFormBrandLocationAdd(addressLists: [Locations?])
}
protocol EditBrandLocationDelegate {
    func LocationFormEditBrandLocationAdd(addressLists: [Locations?],deletedId : [String])
}

class BrandLocationViewController: BaseViewController {
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtSearchCity: UITextField!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var tblLocation: UITableView!
    @IBOutlet weak var lblMonthlyRateTitle: UILabel!
    @IBOutlet weak var lblMonthlyRateValue: UILabel!
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var btnAddCity: CustomButton!

    var brandlocationdelegate : BrandLocationDelegate!
    var editeBrandlocationdelegate : EditBrandLocationDelegate!
    var cityList = [[String : AnyObject]]()
    var edit = false
    var selectedIndexPaths = [Int]()
    var addresslist = [Locations?]()
    var seleAddress = [Locations?]()
    var area = ""
    var addressFull = ""
    var city = ""
    var postalCode = ""
    var lat = 1.1
    var log = 1.1
    var totalLocationPrice = 0
    var post = false
    var addressId = [String]()
    var deletedAddressId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarShadow(navigationBar: self.navBar)
        
        let object = appDelegate.userDetails?.locations
        if self.edit {
            self.imgLogo.isHidden = true
            self.lblHeaderTitle.isHidden = false
            for i in 0..<object!.count {
                self.addresslist.append(object?[i])
                if object?[i].isPayAddress() ?? false || object?[i].isSelectedAddress() ?? false {
                    self.addresslist[i]?.is_Selected = true
                    self.seleAddress.append(self.addresslist[i])
                }
            }
            self.tblLocation.reloadData()
        }
        else {
            self.imgLogo.isHidden = false
            self.lblHeaderTitle.isHidden = true
//            for i in 0..<self.addresslist.count {
//                if object?[i].isPayAddress() ?? false || object?[i].isSelectedAddress() ?? false {
//                    self.addresslist[i]?.is_Selected = true
//                }
//            }
//            self.tblLocation.reloadData()
        }
        if post {
            self.setDeta()
            self.btnAddCity.isHidden = true
        }
        else {
            self.btnAddCity.isHidden = false
        }
    }
    
    func setDeta(){
        for i in 0..<self.addresslist.count {
            if self.addressId.count != 0 {
                for temp in 0..<self.addressId.count {
                    if self.addressId[temp] == String(self.addresslist[i]?.id ?? 0){
                        self.selectedIndexPaths.append(i)
                        self.addresslist[i]?.is_Selected = true
                    }
                }
            }
            else {
                self.addresslist[i]?.is_Selected = true
            }
            
        }
    }
    
    @IBAction func btnNext_clicked(_ sender: Any) {
        self.seleAddress.removeAll()
        for i in 0..<self.addresslist.count {
            if self.addresslist[i]?.is_Selected == true {
                self.seleAddress.append(self.addresslist[i])
            }
            else {
                self.deletedAddressId.append(String(self.addresslist[i]?.id ?? 0))
            }
        }
        if self.seleAddress.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select any one address")
        }
        else {
            if self.edit {
                if self.editeBrandlocationdelegate != nil {
                    self.editeBrandlocationdelegate.LocationFormEditBrandLocationAdd(addressLists: self.seleAddress, deletedId: self.deletedAddressId)
                }
            }
            else {
                print(self.seleAddress)
                if self.brandlocationdelegate != nil {
                    self.brandlocationdelegate.LocationFormBrandLocationAdd(addressLists: self.seleAddress)
                }
            }
                
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnAddCity_clicked(_ sender: Any) {
        let viewController = GMSAutocompleteViewController()
        viewController.delegate = self
        viewController.setFilter(filterOption: GMSPlacesAutocompleteTypeFilter.city)
//        Place.Field.ID,
//                    Place.Field.NAME,
//                    Place.Field.ADDRESS,
//                    Place.Field.ADDRESS_COMPONENTS,
//                    Place.Field.LAT_LNG,
//                    Place.Field.PLUS_CODE
//        viewController.placeFields = GMSPlaceField()
        self.present(viewController, animated: true, completion: nil)
    }

}
extension BrandLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        
        cell.btnCheck.setImage(#imageLiteral(resourceName: "checkbox_sel_ic").imageWithColor(color1: UIColor().blueColor), for: .selected)
        
        let objet = self.addresslist[indexPath.row]
        cell.imgDefaultLocactionSelect.isHidden = true
        cell.lblLocationPrice.isHidden = true
        if let cityname = objet?.city {
            cell.lblLocationName.text = cityname
        }
        if self.edit {
            cell.imgDefaultLocactionSelect.isHidden = true
            cell.btnCheck.isHidden = false
            if objet?.isSelectedAddress() ?? false{
                cell.imgDefaultLocactionSelect.isHidden = false
                cell.btnCheck.isHidden = true
            }
            cell.lblLocationPrice.isHidden = false
            cell.lblLocationPrice.text = "$\(String(describing: objet?.price ?? 0))/Month"
        }
        if objet?.is_Selected ?? false  {//self.selectedIndexPaths.contains(indexPath.row) {
            cell.btnCheck.isSelected = true
        }
        else {
            cell.btnCheck.isSelected = false
        }
        cell.btnCheck.addTarget(self, action: #selector(self.btnCheck_clicked), for: .touchUpInside)
        return cell
    }
    
    @objc func btnCheck_clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblLocation)
        if let indexPath = self.tblLocation.indexPathForRow(at: buttonPosition) {
            if self.addresslist[indexPath.row]?.is_Selected == true {
                self.addresslist[indexPath.row]?.is_Selected = false
                if indexPath.item == 0 {
                    self.addresslist[indexPath.row]?.is_default = 0
                }
            }
            else {
                self.addresslist[indexPath.row]?.is_Selected = true
                if indexPath.item == 0 {
                    self.addresslist[indexPath.row]?.is_default = 1
                }
            }
            self.totalOfLOcation(index: indexPath.item)
            self.tblLocation.reloadData()
        }
    }
    
    func totalOfLOcation (index : Int) {
        var count = 0
        for i in 0..<self.addresslist.count{
            if self.addresslist[i]?.is_Selected == true  {
                if self.addresslist[i]?.is_default == nil || self.addresslist[i]?.is_default != 1 {
                    count = count + 1
                }
            }
        }
        self.totalLocationPrice = Int((appDelegate.generalSettings?.additional_brand_location_rate)!)! * (count)
        print(self.totalLocationPrice)
        self.lblMonthlyRateValue.text = String(self.totalLocationPrice)
    }
}

class LocationCell: UITableViewCell {
    @IBOutlet weak var lblLocationName: UILabel!
    @IBOutlet weak var lblLocationPrice: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var imgDefaultLocactionSelect: UIImageView!
}

extension BrandLocationViewController: GMSAutocompleteViewControllerDelegate  {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
        print("Place name: ", place.name ?? "")
        print("Place address: ", place.formattedAddress ?? "")
        print("Place attributions: ", place.attributions ?? "")
        
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
//        self.txtAddress.text = place.formattedAddress!
        self.addressFull = place.formattedAddress!
        
        
        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
        self.postalCode = component.postalCode ?? ""
              self.area = component.area ?? ""
               self.city = component.city ?? ""
//        self.addressFull = place.formattedAddress!
//        print(place.addressComponents)
////        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
////        self.postalCode = component.postalCode ?? ""
////        self.area = component.area ?? ""
////        self.city = component.city ?? ""
//
//        if place.addressComponents != nil {
//            for addressComponent in (place.addressComponents)! {
//                for type in (addressComponent.types){
//
//                    switch(type){
//                    case "locality":
//                        print("locality Name :- \(addressComponent.name)")
//                        self.city = addressComponent.name // city
//                    case "sublocality_level_2":
//                        print(addressComponent.name)
//                    case "sublocality_level_1":
//                        print("ariya \(addressComponent.name)") //ariya
//                        self.area = addressComponent.name
//                    case "administrative_area_level_2":
//                        print("city \(addressComponent.name)")
//
//                    case "administrative_area_level_1":
//                        print(addressComponent.name)
//                    case "country":
//                        print(addressComponent.name)
//                    case "postal_code":
//                        print("postalcode \(addressComponent.name)")
//                        self.postalCode = addressComponent.name
//                    default:
//                        break
//                    }
//                }
//            }
//        }
        let json = ["address": self.addressFull,
                    "latitude" : String(self.lat),
                    "longitude" : String(self.log),
                    "location_ids" : "0",
                    "city" : self.city,
                    "postal_code" : String(self.postalCode),
                    "area" : self.area
        ]
        let objet = Locations.init(JSON: json)
        self.addresslist.append(objet)
        self.tblLocation.reloadData()
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
