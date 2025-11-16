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
        mapView.delegate = self
        setupNearestLocation()
        setupMap()
    }
    
    private func setupNearestLocation() {
        guard let locations = appDelegate.userDetails?.locations,
              let defaultLocation = locations.first(where: { $0.is_default == 1 }),
              let ulat = Double(defaultLocation.latitude ?? ""),
              let ulong = Double(defaultLocation.longitude ?? "") else {
            return
        }
        
        userLocation = CLLocation(latitude: ulat, longitude: ulong)
        
        var distances: [CLLocationDistance] = []
        for location in addresslist {
            if let latStr = location?.latitude,
               let logStr = location?.longitude,
               let lat = Double(latStr),
               let log = Double(logStr),
               let userLocation = userLocation {
                
                let coord = CLLocation(latitude: lat, longitude: log)
                let distance = coord.distance(from: userLocation)
                distances.append(distance)
                print("distance = \(distance)")
            }
        }
        
        if let closest = distances.min(),
           let position = distances.firstIndex(of: closest),
           let selected = addresslist[position],
           let latStr = selected.latitude,
           let logStr = selected.longitude {
            
            lat = Double(latStr) ?? 0.0
            log = Double(logStr) ?? 0.0
            print("closest = \(closest), index = \(position)")
        }
    }
    
    private func setupMap() {
        if usertype == USER_TYPE.USER.rawValue {
            setInitDataUserLise(latitude: lat, longitude: log, tital: adddressArea)
        } else if usertype == USER_TYPE.STORE.rawValue {
            setInitDataUserLiseStoreWise(latitude: lat, longitude: log, tital: adddressArea)
        } else {
            setInitDataUserLiseStoreWise(latitude: lat, longitude: log, tital: adddressArea)
        }
    }
    
    func setInitDataUserLise(latitude: Double, longitude: CLLocationDegrees, tital: String) {
        guard latitude != 0.0, longitude != 0.0 else { return }
        
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let circle = GMSCircle(position: position, radius: 3000)
        if let blueColor = UIColor(named: "BlueColor") {
            circle.fillColor = blueColor.withAlphaComponent(0.2)
            circle.strokeColor = blueColor
        }
        circle.strokeWidth = 6
        circle.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        mapView.animate(to: camera)
    }
    
    func setInitDataUserLiseStoreWise(latitude: Double, longitude: CLLocationDegrees, tital: String) {
        guard latitude != 0.0, longitude != 0.0 else { return }
        
        for data in addresslist {
            if let latStr = data?.latitude,
               let logStr = data?.longitude,
               let lat = Double(latStr),
               let log = Double(logStr) {
                
                let position = CLLocationCoordinate2D(latitude: lat, longitude: log)
                let marker = GMSMarker(position: position)
                marker.title = data?.address
                marker.tracksInfoWindowChanges = true
                marker.map = mapView
            }
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12)
        mapView.animate(to: camera)
    }
    
    @IBAction func btnCopy_clicked(_ sender: Any) {
        if adddressArea.isEmpty {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please Select Pin")
        } else {
            UIPasteboard.general.string = adddressArea
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Address Copied")
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        popViewController()
    }
}

extension FindLocation: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let title = marker.title {
            adddressArea = title
            UIAlertController().alertViewWithTitleAndMessage(self, message: "\(title) Selected")
        }
        return true
    }
}
