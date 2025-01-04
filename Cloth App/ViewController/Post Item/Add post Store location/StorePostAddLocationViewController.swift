//
//  StorePostAddLocationViewController.swift
//  Cloth App
//
//  Created by Apple on 28/06/21.
//

import UIKit
import GoogleMaps
import Contacts
import GooglePlaces

protocol StorePostLocationDelegate {
    func LocationFormStorePostLocationAdd(addressLists: [Locations?])
}


class StorePostAddLocationViewController: BaseViewController {

    @IBOutlet weak var btnDon: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tblAddressList: UITableView!
    @IBOutlet weak var conteHightFortblAddressList: NSLayoutConstraint!
    
    var storePostlocationdelegate : StorePostLocationDelegate!
    var addresslist = [Locations?]()
    var selectedAddressList = [Locations?]()
    var lat = 0.0
    var log = 0.0
    var adddressArea = ""
    var address = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.selectedAddressList.count != 0 {
            for i in 0..<self.addresslist.count {
                for j in 0..<self.selectedAddressList.count {
                    if self.addresslist[i]?.id == self.selectedAddressList[j]?.id{
                        self.addresslist[i]?.is_Selected = true
                        break
                    }
                    else {
                        self.addresslist[i]?.is_Selected = false
                    }
                }
            }
        }
        else {
            for i in 0..<self.addresslist.count {
                self.addresslist[i]?.is_Selected = true
                self.selectedAddressList.append( self.addresslist[i])
            }
        }
        
        
        if addresslist.count == 1 {
            let lat = Double(self.addresslist[0]?.latitude ?? "0.0")
            let long = Double(self.addresslist[0]?.longitude ?? "0.0")
            let address = self.addresslist[0]?.address ?? "0.0"
            self.setInitDataUserLise(latitude: lat! , longitude: long!, tital: address)
        }
        else {
            self.showCurrentLocationOnMap(addressList: self.selectedAddressList)
            self.setInitDataUserLise(latitude: appDelegate.defaultLatitude, longitude: appDelegate.defaultLongitude, tital: "Address")
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblAddressList.reloadData()
        self.tblAddressList.layoutIfNeeded()
        self.conteHightFortblAddressList.constant = self.tblAddressList.contentSize.height
    }
    @IBAction func btnDone_Clicked(_ button: UIButton) {
        if self.selectedAddressList.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select address")
        }
        else {
            if self.storePostlocationdelegate != nil {
                self.storePostlocationdelegate.LocationFormStorePostLocationAdd(addressLists: self.selectedAddressList)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getLocationBound () -> GMSCoordinateBounds {
       var minLat = 90.0;
       var minLon = 180.0;
       var maxLat = -90.0;
       var maxLon = -180.0;
        for data in self.selectedAddressList{
            let latitude = Double((data?.latitude!)! ) ?? 0.0
            let longitude = Double((data?.longitude!)! ) ?? 0.0
            
            minLat = min(minLat, latitude)//Math.min(minLat, latitude);
            minLon = min(minLon, longitude);
            maxLat = max(maxLat, latitude);
            maxLon = max(maxLon, longitude);
        }
        let minLocation = CLLocationCoordinate2D(latitude: minLat, longitude: minLon)
        let maxLocation = CLLocationCoordinate2D(latitude: maxLat, longitude: maxLon)
        return GMSCoordinateBounds(coordinate: minLocation,coordinate: maxLocation)
    }
    func showCurrentLocationOnMap(addressList: [Locations?] ){
     let bounds = GMSCoordinateBounds()
        for data in addressList{
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
}

extension StorePostAddLocationViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresslist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressListCell") as! AddressListCell
        let object = self.addresslist[indexPath.row]
            if (object?.is_Selected) ?? false {
                cell.imgcheck.borderColor = .black
                cell.imgcheck.backgroundColor = UIColor.init(named: "BlueColor")
            }
            else{
                cell.imgcheck.borderColor = .lightGray
                cell.imgcheck.backgroundColor = .systemBackground
                
            }
            cell.lblAddressCount.text = "Location \(indexPath.row + 1)"
            cell.lblCity.text = object?.city
            cell.lblPostalCoud.text = object?.postal_code
            cell.lblAddress.text = object?.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.addresslist[indexPath.row]?.is_Selected == true {
            self.addresslist[indexPath.row]?.is_Selected = false
        }
        else {
            self.addresslist[indexPath.row]?.is_Selected = true

        }
        self.selectedAddressList.removeAll()
        for i in 0..<self.addresslist.count  {
            if self.addresslist[i]?.is_Selected == true {
                self.selectedAddressList.append(self.addresslist[i])
            }
        }
        self.showCurrentLocationOnMap(addressList: self.selectedAddressList)
        self.tblAddressList.reloadData()
    }
}

class AddressListCell : UITableViewCell
{
    @IBOutlet weak var lblAddressCount: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPostalCoud: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgcheck: CustomImageView!
}
