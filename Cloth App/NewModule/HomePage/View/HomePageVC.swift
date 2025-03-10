//
//  HomePageVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 19/05/24.
//

import UIKit
import IBAnimatable
import CoreLocation

class HomePageVC: BaseViewController {
    
    @IBOutlet weak var badgeView: AnimatableView!
    @IBOutlet weak var btnUserLocations: UIButton!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var viewModel = HomePageViewModel()
    var sort_by = "date"
    var sort_value = "desc"
    
    var catSelectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deepLinkNavigate(_:)), name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
        
        
        self.viewModel.view = self
        self.setupCollectionView()
        self.viewModel.callCategoryList()
    }
    
    @objc func deepLinkNavigate(_ notification: NSNotification) {
        DeepLinknaviget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.checkAndFetchLocation { city,status in
            if status{
                if appDelegate.userDetails?.locations?.isEmpty == true{
                    self.btnUserLocations.setTitle(city, for: .normal)
                }
            }
            self.viewModel.page = 1
            self.viewModel.getAllProduct(isShowHud: true,cat_id: self.catSelectedIndex != nil ? "\(self.viewModel.categoriesList[self.catSelectedIndex ?? 0].id ?? 0)" : "")
            self.productCollectionView.reloadData()
            if self.viewModel.posts.count > 0 {
                self.productCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        
        
        if let locations = appDelegate.userDetails?.locations{
            self.btnUserLocations.setTitle(locations.first?.city ?? "", for: .normal)
        }
    }
    
    private func getCityOrState(from latitude: Double, longitude: Double, completion: @escaping (Result<String, Error>) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first else {
                completion(.failure(NSError(domain: "LocationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "No location data found."])))
                return
            }
            
            if let city = placemark.locality {
                completion(.success(city))
            } else if let state = placemark.administrativeArea {
                completion(.success(state))
            } else {
                completion(.failure(NSError(domain: "LocationError", code: 404, userInfo: [NSLocalizedDescriptionKey: "City and state not found."])))
            }
        }
    }
    private func checkAndFetchLocation(complition:@escaping((String,Bool) -> Void?)) {
        let locationManager = LocationManager.shared
        
        if locationManager.isLocationServicesEnabled() {
            locationManager.getCurrentLocation { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let location):
                        print("Location fetched: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                        //                        complition(true)
                        self.getCityOrState(from: location.coordinate.latitude, longitude: location.coordinate.longitude) { result in
                            switch result {
                            case .success(let location):
                                print("Location: \(location)")
                                complition(location,true)
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                            }
                        }
                    case .failure(let error):
                        print("Error fetching location: \(error.localizedDescription)")
                        if LocationManager.shared.isLocationSetNotNow == true{
                            complition("",false)
                        }else{
                            let vc = DeletePostVC.instantiate(fromStoryboard: .Sell)
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            vc.isCancelHide = false
                            vc.deleteTitle = "Allow Access"
                            vc.cancelTitle = "Not Now"
                            vc.deleteBgColor = .black
                            vc.titleMain = "Turn on Location"
                            vc.subTitle = " Location services are required to provide the best experience on Clothing Click. Please enable them in your device settings"
                            vc.imgMain = UIImage(named: "ic_location_big")
                            vc.deleteOnTap = {
                                LocationManager.shared.openSettings()
                            }
                            vc.cancelOnTap = {
                                LocationManager.shared.isLocationSetNotNow = true
                                complition("",false)
                            }
                            self.present(vc, animated: true)
                        }
                        
                    }
                }
            }
        } else {
            print("Location services are disabled")
            showLocationErrorAlert(error: LocationManager.LocationError.servicesDisabled)
        }
    }
    
    private func showLocationErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Location Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            LocationManager.shared.openSettings()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func setupCollectionView(){
        self.catCollectionView.delegate = self
        self.catCollectionView.dataSource = self
        self.catCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.catCollectionView.registerCell(nib: UINib(nibName: "CatXIB", bundle: nil), identifier: "CatXIB")
        self.catCollectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        self.productCollectionView.delegate = self
        self.productCollectionView.dataSource = self
        self.productCollectionView.contentInset = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        
        self.productCollectionView.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        //        let viewController = ShortByViewController.instantiate(fromStoryboard: .Main)
        //        viewController.sort_by = self.sort_by
        //        viewController.sort_value = self.sort_value
        //        viewController.shortByDeleget = self
        //        viewController.modalPresentationStyle = .custom
        //        viewController.transitioningDelegate = customTransitioningDelegate
        //        self.present(viewController, animated: true, completion: nil)
        //        let vc = SearchEngineViewController.instantiate(fromStoryboard: .Main)
        //        vc.hidesBottomBarWhenPushed = true
        //        self.pushViewController(vc: vc)
        //        let vc = PaymentViewController.instantiate(fromStoryboard: .Sell)
        //        self.present(vc, animated: true)
    }
    
    @IBAction func locationOnPress(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        self.checkAndFetchLocation { city,status in
            if status{
                if appDelegate.userDetails?.locations?.isEmpty == true{
                    self.btnUserLocations.setTitle(city, for: .normal)
                }
            }
            let vc = MapLocationVC.instantiate(fromStoryboard: .Dashboard)
            vc.hidesBottomBarWhenPushed = true
            vc.newLocation = { [weak self] location in
                self?.btnUserLocations.setTitle(location?.city ?? "", for: .normal)
            }
            vc.isFromDashboard = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func notificationOnPress(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let vc = NotificationsViewController.instantiate(fromStoryboard: .Main)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let poston = sender.convert(CGPoint.zero, to: self.productCollectionView)
        if let indexPath = self.productCollectionView.indexPathForItem(at: poston) {
            let cell = self.productCollectionView.cellForItem(at: indexPath) as! HomePageBrowserXIB
            if cell.btnLike.isSelected {
                if  let postId = self.viewModel.posts[indexPath.item].id {
                    self.viewModel.callPostFavourite(action_type: "0", postId: String(postId) , index: indexPath.item)
                }
            }
            else {
                if  let postId = self.viewModel.posts[indexPath.item].id {
                    self.viewModel.callPostFavourite(action_type: "1", postId: String(postId) , index: indexPath.item)
                }
            }
        }
    }
}


extension HomePageVC:CollectionViewDelegateAndDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catCollectionView{
            return self.viewModel.categoriesList.count
        }else{
            return self.viewModel.posts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.catCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatXIB", for: indexPath) as! CatXIB
            let indexData = self.viewModel.categoriesList[indexPath.item]
            cell.lblCat.text = indexData.name ?? ""
            if indexPath.item == self.catSelectedIndex{
                cell.lblCat.textColor = .white
                cell.bgView.backgroundColor = .black
            }else{
                cell.lblCat.textColor = .black
                cell.bgView.backgroundColor = .white
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
            let objet = self.viewModel.posts[indexPath.item]
            
            cell.imgProduct.setImageFast(with: objet.image?.first?.image ?? "")
            
            cell.btnLike.tag = indexPath.row
            cell.btnLike.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
            if let is_favourite = objet.is_favourite {
                cell.btnLike.isSelected = is_favourite
            }
            if let title = objet.title {
                cell.lblProductName.text = title
            }
            
            if let producttype = objet.price_type{
                if producttype == "1"{
                    if let price = objet.price {
                        if !(objet.isLblSaleHidden()) {
                            if let salePrice = objet.sale_price {
                                cell.lblPrice.text = "$ \(salePrice)"
                            }
                        }else {
                            cell.lblPrice.text = "$ \(price.formatPrice())"
                        }
                    }
                }
                else{
                    if let producttype = objet.price_type_name{
                        cell.lblPrice.text = "\(producttype.formatPrice())"
                    }
                }
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.productCollectionView{
            return CGSize(width: (self.productCollectionView.frame.size.width / 2) - 20, height: 230)
        }else{
            let indexData = self.viewModel.categoriesList[indexPath.item]
            let text = indexData.name ?? ""
            let font = UIFont.systemFont(ofSize: 16)
            let textWidth = text.width(withFont: font)
            return CGSize(width: textWidth + 40, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView{
            let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            vc.postId = "\(self.viewModel.posts[indexPath.item].id ?? 0)"
            vc.hidesBottomBarWhenPushed =  self.viewModel.posts[indexPath.item].user_id ?? 0 == appDelegate.userDetails?.id
            self.pushViewController(vc: vc)
        }else{
            self.checkAndFetchLocation { city,status in
                if status{
                    if appDelegate.userDetails?.locations?.isEmpty == true{
                        self.btnUserLocations.setTitle(city, for: .normal)
                    }
                }
                self.viewModel.page = 1
                if indexPath.item == self.catSelectedIndex{
                    self.catSelectedIndex = nil
                    self.viewModel.getAllProduct(isShowHud: true,cat_id: "")
                }else{
                    self.viewModel.getAllProduct(isShowHud: true,cat_id: "\(self.viewModel.categoriesList[indexPath.item].id ?? 0)")
                    self.catSelectedIndex = indexPath.item
                }
                self.catCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.productCollectionView{
            if indexPath.row == self.viewModel.posts.count - 4 && self.viewModel.isLoading == true {
                self.viewModel.page += 1
                self.viewModel.isLoading = false
                self.viewModel.getAllProduct(isShowHud: false,cat_id: self.catSelectedIndex != nil  ? "\(self.viewModel.categoriesList[self.catSelectedIndex ?? 0].id ?? 0)" :"")
            }
        }
    }
}

extension HomePageVC : ShortByDelegate{
    
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        self.viewModel.getAllProduct(isShowHud: true,cat_id: self.catSelectedIndex != nil  ? "\(self.viewModel.categoriesList[self.catSelectedIndex ?? 0].id ?? 0)" :"",sort_by: self.sort_by,sort_value: self.sort_value)
    }
}
