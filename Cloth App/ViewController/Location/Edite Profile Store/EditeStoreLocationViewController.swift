//
//  EditeStoreLocationViewController.swift
//  Cloth App
//
//  Created by Apple on 01/07/21.
//

import UIKit
import GoogleMaps
import Contacts
import GooglePlaces

protocol EditStoreLocationDelegate {
    func LocationFormEditStoreLocationAdd(addressLists: [Locations?],deletedId : [String])
}

class EditeStoreLocationViewController: BaseViewController {

    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tblAddressList: UITableView!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var txtPostalCode: CustomTextField!
    @IBOutlet weak var conteHightFortblAddressList: NSLayoutConstraint!
    @IBOutlet weak var conteTopForlblMonthlyRateTitle: NSLayoutConstraint!
    @IBOutlet weak var lblMonthlyRateTitle: UILabel!
    @IBOutlet weak var lblMonthlyRateValue: UILabel!
    @IBOutlet weak var btnAddAnotherLocation: CustomButton!
    @IBOutlet weak var btnNext: CustomButton!
    var editStoreLocationDelegate : EditStoreLocationDelegate!
    var addresslist = [Locations?]()
    var lat = 0.0
    var log = 0.0
    var address = ""
    var city = ""
    var adddressArea = ""
    var deletedAddressId = [String]()
    var edmonton = false
    override func viewDidLoad() {
        super.viewDidLoad()
//        let address = appDelegate.userDetails?.locations as! [Locations]
//        for temp in address.count {
//            self.addressList.append(temp)
//        }
        self.setInitDataUserLise(latitude: appDelegate.defaultLatitude, longitude: appDelegate.defaultLongitude, tital: "Address")
        self.showCurrentLocationOnMap()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblAddressList.reloadData()
        self.tblAddressList.layoutIfNeeded()
        self.conteHightFortblAddressList.constant = self.tblAddressList.contentSize.height
    }
    
    @IBAction func btnNext_Clicked(_ button: UIButton) {
        if self.addresslist.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select address")
        }
        else {
            if self.editStoreLocationDelegate != nil {
                self.editStoreLocationDelegate.LocationFormEditStoreLocationAdd(addressLists: self.addresslist, deletedId: self.deletedAddressId)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func btnDelete_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblAddressList)
        if let indexPath = self.tblAddressList.indexPathForRow(at: buttonPosition) {
            self.deletedAddressId.append(String(self.addresslist[indexPath.row]?.id ?? 0))
            self.addresslist.remove(at: indexPath.row)
            self.tblAddressList.reloadData()
            self.tblAddressList.layoutIfNeeded()
            self.conteHightFortblAddressList.constant = self.tblAddressList.contentSize.height
            self.showCurrentLocationOnMap()
        }
    }
    
    func getLocationBound () -> GMSCoordinateBounds {
       var minLat = 90.0;
       var minLon = 180.0;
       var maxLat = -90.0;
       var maxLon = -180.0;
        for data in self.addresslist{
            let latitude = Double((data?.latitude ?? "0.0") ) ?? 0.0
            let longitude = Double((data?.longitude ?? "0.0") ) ?? 0.0
            
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
            let location = CLLocationCoordinate2D(latitude: Double(data?.latitude ?? "0.0")! , longitude: Double(data?.longitude ?? "0.0")!)
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
    
    func setInitDataUserLise(latitude: Double , longitude : CLLocationDegrees ,tital : String){
        if latitude != 0.0 || longitude != 0.0{
            
            let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let marker = GMSMarker(position: position)
//            marker.title = tital
//            marker.map = self.mapView
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
    
    @IBAction func btnAddAnotherLocation_clicked(_ sender: Any) {
//        self.showCurrentLocationOnMap()
        
        if self.txtAddress.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
        }
        else if self.txtPostalCode.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter postalcode")
        }
        else {
            let json = ["address": self.address,
                        "latitude" : String(self.lat),
                        "longitude" : String(self.log),
                        "city" : self.city,
                        "postal_code" : String(self.txtPostalCode.text ?? ""),
                        "area" : self.adddressArea
            ]
            
            let objet = Locations.init(JSON: json)
            self.addresslist.append(objet)
            self.tblAddressList.reloadData()
            self.tblAddressList.layoutIfNeeded()
            self.conteHightFortblAddressList.constant = self.tblAddressList.contentSize.height
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
}

extension EditeStoreLocationViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtAddress {
            let viewController = GMSAutocompleteViewController()
            viewController.delegate = self
            viewController.setFilter()
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        return true
    }
}

extension EditeStoreLocationViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditeAddressListCell") as! EditeAddressListCell
        let object = self.addresslist[indexPath.row]
//        if !(object?.isSelectedAddress() ?? false) {
//            cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked(sender:)), for: .touchUpInside)
//        }
        cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked(sender:)), for: .touchUpInside)
//        cell.btnDelete.isHidden = object?.isSelectedAddress() ?? false
        cell.lblAddressCount.text = "Location \(indexPath.row + 1)"
        cell.lblCity.text = object?.city
        cell.lblPostalCoud.text = object?.postal_code
        cell.lblAddress.text = object?.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

class EditeAddressListCell : UITableViewCell
{
    @IBOutlet weak var lblAddressCount: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPostalCoud: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
}

extension EditeStoreLocationViewController: GMSAutocompleteViewControllerDelegate  {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
        self.address = place.formattedAddress!
        
        print("Place name: ", place.name ?? "")
               print("Place address: ", place.formattedAddress ?? "")
               print("Place attributions: ", place.attributions ?? "")
        
        self.txtAddress.text = place.formattedAddress

        self.address = place.formattedAddress!
        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
        self.txtPostalCode.text = component.postalCode
        self.adddressArea = component.area ?? ""
        self.city = component.city ?? ""
     
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
