//
//  FindLocation.swift
//  Cloth App
//
//  Created by Rishi Vekariya on 11/02/2022.
//

import UIKit
import GoogleMaps
import Contacts
import GooglePlaces
import CoreLocation

class FindLocation: BaseViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnCopy: CustomButton!
    
    var addresslist = [Locations?]()
    var lat = 0.0
    var log = 0.0
    var adddressArea = ""
    var city = ""
    var address = ""
    var usertype = -1
    var userLocation: CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        var distances = [CLLocationDistance]()
        if let locations = appDelegate.userDetails?.locations
        {
            let Location = locations.filter {
                $0.is_default == 1
            }
            print(Location)
            if Location.count>0{
                let data = Location[0]
                let ulat = Double(data.latitude!)
                let ulong = Double(data.longitude!)
                userLocation = CLLocation(latitude: ulat!, longitude: ulong!)
                for location in addresslist{
                    let lat = Double(location?.latitude! ?? "0.0")!
                    let log = Double(location?.longitude! ?? "0.0")!
                    let coord = CLLocation(latitude: lat, longitude: log)
                   // let coord = CLLocation(latitude: location?.latitude!, longitude: location?.longitude!)
                    
                    distances.append(coord.distance(from: userLocation!))
                    print("distance = \(coord.distance(from: userLocation!))")
                    }
            }
        }
            let closest = distances.min()//shortest distance
        let position = distances.firstIndex(of: closest!)//index of shortest distance
        print("closest = \(closest!), index = \(position ?? 0)")
        lat = Double(addresslist[position!]?.latitude! ?? "0.0")!
        log = Double(addresslist[position!]?.longitude! ?? "0.0")!
        if usertype == USER_TYPE.USER.rawValue {
            self.setInitDataUserLise(latitude: lat, longitude: log, tital: adddressArea)
//            self.btnCopy.isHidden = true
        }
        else if usertype == USER_TYPE.STORE.rawValue{
            self.setInitDataUserLiseStoreWise(latitude: lat, longitude: log, tital: adddressArea)
//            self.btnCopy.isHidden = false
        }else{
            self.setInitDataUserLiseStoreWise(latitude: lat, longitude: log, tital: adddressArea)
//            self.btnCopy.isHidden = true
        }
    }
    
    func setInitDataUserLise(latitude: Double , longitude : CLLocationDegrees ,tital : String){
        if latitude != 0.0 || longitude != 0.0{
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
    func setInitDataUserLiseStoreWise(latitude: Double , longitude : CLLocationDegrees ,tital : String){
        if latitude != 0.0 || longitude != 0.0{
           // let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            for data in self.addresslist{
                let lat = data?.latitude!
                let log = data?.longitude!
                let position = CLLocationCoordinate2D(latitude: (lat! as NSString).doubleValue, longitude: (log! as NSString).doubleValue)
                let marker = GMSMarker(position: position)
                marker.title = data?.address
                marker.tracksInfoWindowChanges = true
                marker.map = self.mapView
                }
//            let marker = GMSMarker(position: position)
//            marker.title = tital
//            marker.map = self.mapView
           
            let location = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
            self.mapView.camera = location
            
            self.mapView.animate(to: location)
        }
    }
    @IBAction func btnCopy_clicked(_ sender: Any) {
        if self.adddressArea == "" {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please Select Pin")
        }else{
        UIAlertController().alertViewWithTitleAndMessage(self, message: "Address Copied")
        UIPasteboard.general.string = adddressArea
        }
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
}

extension FindLocation:GMSMapViewDelegate{

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        UIAlertController().alertViewWithTitleAndMessage(self, message: "\(marker.title!) Selected")
        self.adddressArea = marker.title!
        return true
    }
    
    
}
