//
//  DistanceViewController.swift
//  ClothApp
//
//  Created by Apple on 02/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import Contacts
import CoreLocation
import MapKit

protocol DistnceDelegate: AnyObject {
    func selctedDistnce(distnce: String, Selecte: Bool, index: Int, hearderTitel: String)
}

// MARK: - Place Search (MapKit replacement for Google Autocomplete)
final class PlaceSearchViewController: UIViewController, UISearchResultsUpdating, MKLocalSearchCompleterDelegate, UITableViewDataSource, UITableViewDelegate {

    var onSelectPlace: ((MKLocalSearchCompletion) -> Void)?

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let completer = MKLocalSearchCompleter()
    private var results: [MKLocalSearchCompletion] = []

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Location"
        view.backgroundColor = .systemBackground

        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(closeTapped))
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        completer.queryFragment = text
    }

    // MARK: MKLocalSearchCompleterDelegate
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results
        tableView.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("MKLocalSearchCompleter error:", error.localizedDescription)
    }

    // MARK: UITableViewDataSource/Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { results.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let item = results[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectPlace?(results[indexPath.row])
    }
}

class DistanceViewController: BaseViewController, MKMapViewDelegate {

    @IBOutlet weak var imgMap: UIImageView!
    @IBOutlet weak var lblSarchLocation: UILabel!
    @IBOutlet weak var txtSearchBar: UITextField!
    @IBOutlet weak var sliderDistanceKm: UISlider! {
        didSet {
            sliderDistanceKm.maximumValue = 50
        }
    }
    @IBOutlet weak var lblDistanceKm: UILabel!
    @IBOutlet weak var btnViewItems: CustomButton!

    // NOTE: Keeping outlet name "mapView" and type UIView as you have in storyboard.
    // We'll embed an MKMapView inside it so your flow doesn't break.
    @IBOutlet weak var mapView: UIView! {
        didSet {
            mapView.isHidden = false
        }
    }

    private let mkMapView = MKMapView()
    private var circleOverlay: MKCircle?
    private var centerAnnotation: MKPointAnnotation?

    weak var distanceDelegate: DistnceDelegate?
    var selectedIndex = 0
    var headerTitle = ""
    var saveSearch = false
    var lat = 0.0
    var log = 0.0
    var viewCount = 0
    var isMySize = ""
    var selectSubCategoryId = [String]()
    var selecteddistance = ""
    var isSaveSearch: Bool?
    var isFilterProduct: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        let _ = appDelegate.userDetails?.locations

        lblSarchLocation.text = appDelegate.userLocation?.address ?? ""
        log = Double(appDelegate.userLocation?.longitude ?? "") ?? 0.0
        lat = Double(appDelegate.userLocation?.latitude ?? "") ?? 0.0

        // Embed MKMapView into your UIView outlet (flow-safe)
        setupMapKit()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblSarchLocation.isUserInteractionEnabled = true
        lblSarchLocation.addGestureRecognizer(tapGesture)

        sliderDistanceKm.addTarget(self,
                                   action: #selector(sliderDidEndSliding),
                                   for: [.touchUpInside, .touchUpOutside])

        sliderDistanceKm.value = Float(FilterSingleton.share.filter.distance ?? "") ?? 10.0
        lblDistanceKm.text = "\(Int(round(sliderDistanceKm.value))) Km"

        setInitDataUserLise(latitude: lat,
                            longitude: log,
                            tital: "Address",
                            radies: Int(round(sliderDistanceKm.value)))

        if isFilterProduct == true {
            btnViewItems.setTitle("Add", for: .normal)
        } else {
            if saveSearch {
                btnViewItems.setTitle("Add to saved Search", for: .normal)
            } else {
                btnViewItems.setTitle("View 0 Items", for: .normal)
                callViewCount()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mkMapView.frame = mapView.bounds
    }

    private func setupMapKit() {
        mkMapView.frame = mapView.bounds
        mkMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mkMapView.delegate = self
        mkMapView.showsUserLocation = false
        mkMapView.isRotateEnabled = false

        // If this VC can be re-used, avoid duplicate subviews
        if mkMapView.superview == nil {
            mapView.addSubview(mkMapView)
        }
    }

    @objc func labelTapped() {
        print("Label was tapped!")

        let searchVC = PlaceSearchViewController()
        searchVC.onSelectPlace = { [weak self] completion in
            guard let self = self else { return }

            let request = MKLocalSearch.Request(completion: completion)
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                if let error = error {
                    print("MKLocalSearch error:", error.localizedDescription)
                    return
                }
                guard let item = response?.mapItems.first, let placemark = item.placemark.location else { return }

                self.lat = placemark.coordinate.latitude
                self.log = placemark.coordinate.longitude

                let formatted = self.formatPlacemarkAddress(item.placemark)
                self.lblSarchLocation.text = formatted.isEmpty ? (item.name ?? "") : formatted

                self.setInitDataUserLise(latitude: self.lat,
                                        longitude: self.log,
                                        tital: self.lblSarchLocation.text ?? "",
                                        radies: Int(round(self.sliderDistanceKm.value)))

                self.getAddressFromLatLon(latitude: self.lat, longitude: self.log)

                // close search
                self.dismiss(animated: true) {
                    self.callViewCount()
                }
            }
        }

        let nav = UINavigationController(rootViewController: searchVC)
        present(nav, animated: true, completion: nil)
    }

    private func formatPlacemarkAddress(_ placemark: MKPlacemark) -> String {
        var parts: [String] = []

        if let subLocality = placemark.subLocality, !subLocality.isEmpty { parts.append(subLocality) }
        if let thoroughfare = placemark.thoroughfare, !thoroughfare.isEmpty { parts.append(thoroughfare) }
        if let locality = placemark.locality, !locality.isEmpty { parts.append(locality) }
        if let country = placemark.country, !country.isEmpty { parts.append(country) }
        if let postalCode = placemark.postalCode, !postalCode.isEmpty { parts.append(postalCode) }

        return parts.joined(separator: ", ")
    }

    @objc func sliderDidEndSliding(_ sender: UISlider) {
        if !saveSearch {
            print("Slider released at value: \(sender.value)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.callViewCount()
            }
        }
    }

    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if saveSearch || isFilterProduct == true {
            navigationController?.popViewController(animated: true)
        } else {
            if viewCount != 0 {
                let viewController = storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                viewController.titleStr = "Search Results"
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }

    @IBAction func btnBack_Cliked(_ button: Any) {
        if let delegate = distanceDelegate {
            delegate.selctedDistnce(distnce: String(Int(round(sliderDistanceKm.value))),
                                    Selecte: true,
                                    index: selectedIndex,
                                    hearderTitel: headerTitle)
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func SliderVelueChange(_ slider: UISlider) {
        lblDistanceKm.text = "\(Int(round(sliderDistanceKm.value))) Km"

        setInitDataUserLise(latitude: lat,
                            longitude: log,
                            tital: "Address",
                            radies: Int(sliderDistanceKm.value))

        FilterSingleton.share.filter.distance = "\(Int(round(sliderDistanceKm.value)))"
        FilterSingleton.share.selectedFilter.distance = "\(Int(round(sliderDistanceKm.value))) Km"
    }

    // MARK: - MapKit Equivalent of setInitDataUserLise
    func setInitDataUserLise(latitude: Double, longitude: CLLocationDegrees, tital: String, radies: Int) {
        if latitude != 0.0 || longitude != 0.0 {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

            // Remove old overlay
            if let old = circleOverlay {
                mkMapView.removeOverlay(old)
            }

            // Add new radius circle (meters)
            let circle = MKCircle(center: center, radius: CLLocationDistance(radies * 1000))
            circleOverlay = circle
            mkMapView.addOverlay(circle)

            // Add/Update a pin at center (optional but helps visually)
            if centerAnnotation == nil {
                let pin = MKPointAnnotation()
                centerAnnotation = pin
                mkMapView.addAnnotation(pin)
            }
            centerAnnotation?.coordinate = center
            centerAnnotation?.title = tital

            // Set region to show the circle comfortably
            let region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: CLLocationDistance(radies * 2 * 1000),
                                            longitudinalMeters: CLLocationDistance(radies * 2 * 1000))
            mkMapView.setRegion(region, animated: true)
        }
    }

    // MARK: - MKMapViewDelegate (Circle style)
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let renderer = MKCircleRenderer(circle: circle)
            let stroke = UIColor(named: "BlueColor") ?? UIColor.systemBlue
            renderer.strokeColor = stroke
            renderer.fillColor = stroke.withAlphaComponent(0.2)
            renderer.lineWidth = 6
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    // Keep your method name/flow, even though it’s not used the same way in MapKit
    func getLocationBound(radies: Int) -> MKCoordinateRegion {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: log)
        return MKCoordinateRegion(center: center,
                                  latitudinalMeters: CLLocationDistance(radies * 2 * 1000),
                                  longitudinalMeters: CLLocationDistance(radies * 2 * 1000))
    }

    // MARK: - Reverse Geocode (kept same)
    func getAddressFromLatLon(latitude: Double, longitude: Double) {
        var center = CLLocationCoordinate2D()
        let ceo = CLGeocoder()

        center.latitude = latitude
        center.longitude = longitude

        let loc = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) { placemarks, error in
            if let error = error {
                print("reverse geodcode fail: \(error.localizedDescription)")
                return
            }

            guard let placemarks = placemarks, !placemarks.isEmpty else { return }
            let pm = placemarks[0]

            var addressString = ""
            if let subLocality = pm.subLocality { addressString += subLocality + ", " }
            if let thoroughfare = pm.thoroughfare { addressString += thoroughfare + ", " }
            if let locality = pm.locality { addressString += locality + ", " }
            if let country = pm.country { addressString += country + ", " }
            if let postalCode = pm.postalCode { addressString += postalCode + " " }

            print(addressString)

            let json: [String: Any] = [
                "address": addressString,
                "latitude": String(self.lat),
                "longitude": String(self.log),
                "location_ids": "0",
                "city": pm.locality ?? "",
                "postal_code": self.txtSearchBar.text ?? "",
                "area": pm.subLocality ?? "",
                "id": appDelegate.userDetails?.id ?? 0
            ]

            if let objet = Locations(JSON: json) {
                if (appDelegate.userDetails?.locations?.count ?? 0) > 0 {
                    appDelegate.userDetails?.locations?[0] = objet
                } else {
                    appDelegate.userDetails?.locations?.append(objet)
                }
            }
        }
    }

    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            FilterSingleton.share.filter.is_only_count = "1"

            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")

            // IMPORTANT: Use currently selected lat/log (not appDelegate.userLocation)
            dict["latitude"] = String(self.lat)
            dict["longitude"] = String(self.log)

            APIManager().apiCallWithMultipart(of: ViewCountModel.self,
                                              isShowHud: true,
                                              URL: BASE_URL,
                                              apiName: APINAME.FILTER_POST.rawValue,
                                              parameters: dict) { response, error in
                if error == nil {
                    if let response = response, let data = response.dictData {
                        self.viewCount = data.total_posts ?? 0
                        if self.saveSearch {
                            self.btnViewItems.setTitle("Add to saved Search", for: .normal)
                        } else {
                            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                        }
                    }
                } else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        } else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}
