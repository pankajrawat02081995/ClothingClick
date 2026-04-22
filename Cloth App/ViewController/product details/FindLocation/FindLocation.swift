//
//  FindLocation.swift
//  Cloth App
//
//  Created by Rishi Vekariya on 11/02/2022.
//

import UIKit
import Contacts
import CoreLocation
import MapKit

class FindLocation: BaseViewController {
    
    @IBOutlet weak var mapView: MKMapView!
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
           let index = distances.firstIndex(of: closest),
           let selected = addresslist[index],
           let latStr = selected.latitude,
           let logStr = selected.longitude {
            
            lat = Double(latStr) ?? 0.0
            log = Double(logStr) ?? 0.0
            print("closest = \(closest), index = \(index)")
        }
    }
    
    private func setupMap() {
        if usertype == USER_TYPE.USER.rawValue {
            setInitDataUserWise(latitude: lat, longitude: log, tital: adddressArea)
        } else {
            setInitDataUserWiseStoreWise(latitude: lat, longitude: log)
        }
    }
    
    // MARK: - USER LOCATION (Circle 3km)
    func setInitDataUserWise(latitude: Double, longitude: Double, tital: String) {
        guard latitude != 0.0, longitude != 0.0 else { return }
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        // Circle Overlay (3 KM)
        let circle = MKCircle(center: coordinate, radius: 3000)
        mapView.addOverlay(circle)
        
        // Move Camera
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 8000,
                                        longitudinalMeters: 8000)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - STORE WISE LOCATION MARKERS
    func setInitDataUserWiseStoreWise(latitude: Double, longitude: Double) {
        
        for data in addresslist {
            if let latStr = data?.latitude,
               let logStr = data?.longitude,
               let lat = Double(latStr),
               let log = Double(logStr) {
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: log)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = data?.address
                mapView.addAnnotation(annotation)
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center,
                                        latitudinalMeters: 8000,
                                        longitudinalMeters: 8000)
        mapView.setRegion(region, animated: true)
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

extension FindLocation: MKMapViewDelegate {
    
    // Circle Renderer
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let render = MKCircleRenderer(circle: circle)
            render.lineWidth = 2
            render.strokeColor = UIColor(named: "BlueColor") ?? UIColor.blue
            render.fillColor = (UIColor(named: "BlueColor") ?? UIColor.blue).withAlphaComponent(0.2)
            return render
        }
        return MKOverlayRenderer()
    }
    
    // Annotation Tapped
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let title = view.annotation?.title ?? "" {
            adddressArea = title
            UIAlertController().alertViewWithTitleAndMessage(self, message: "\(title) Selected")
        }
    }
}
