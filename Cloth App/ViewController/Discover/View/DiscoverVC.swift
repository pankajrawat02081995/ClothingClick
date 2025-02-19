//
//  DiscoverVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 20/06/24.
//

import UIKit
import IBAnimatable
class DiscoverVC: BaseViewController {
    
    @IBOutlet weak var badgeView: AnimatableView!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var homeListData = [HomeModel?]()
    var userData : UserDetailsModel?
    
    var displayIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableview()
        //        self.callHomeList()
    }
    
    
    func setupTableview(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: "RecommendedTableXIB", bundle: nil), forCellReuseIdentifier: "RecommendedTableXIB")
        self.tableView.register(UINib(nibName: "DiscoveTableCellXIB", bundle: nil), forCellReuseIdentifier: "DiscoveTableCellXIB")
        self.tableView.register(UINib(nibName: "DiscoveHeaderCellXIB", bundle: nil), forCellReuseIdentifier: "DiscoveHeaderCellXIB")
        self.tableView.register(UINib(nibName: "SaveSearchXIB", bundle: nil), forCellReuseIdentifier: "SaveSearchXIB")
        self.tableView.register(UINib(nibName: "PopuplerBrandTblXIB", bundle: nil), forCellReuseIdentifier: "PopuplerBrandTblXIB")
        NotificationCenter.default.addObserver(self, selector: #selector(self.deepLinkNavigate(_:)), name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.checkAndFetchLocation { status in
            self.callHomeList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.checkAndFetchLocation { status in
            self.callHomeList()
        }
        if let locations = appDelegate.userDetails?.locations{
            let Location = locations
            print(Location)
            if Location.count>0{
                let data = Location.first
                self.btnLocation.setTitle(data?.city, for: .normal)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.layoutIfNeeded()
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let vc = SearchEngineViewController.instantiate(fromStoryboard: .Main)
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    @IBAction func locationOnPress(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let viewController = MapLocationVC.instantiate(fromStoryboard: .Dashboard)
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: viewController)
    }
    
    @IBAction func searchOnPress(_ sender: UIButton) {
//        if appDelegate.userDetails == nil {
//            self.showLogIn()
//            return
//        }
        let vc = SearchItemAndMembersViewController.instantiate(fromStoryboard: .Main)
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    @IBAction func notificationOnTap(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let vc = NotificationsViewController.instantiate(fromStoryboard: .Main)
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    @objc func seeAllOnPress(sender:UIButton){
        let indexData = self.homeListData[sender.tag]
        if indexData?.type == "brands" || indexData?.type == "stores"{
            let vc = PopulerBrandVC.instantiate(fromStoryboard: .Dashboard)
            vc.titleStr = self.homeListData[sender.tag]?.name ?? ""
            vc.typeId = String(self.homeListData[sender.tag]?.type_id ?? 0)
            vc.isShowFilter = false
            self.pushViewController(vc: vc)
        }else{
            let vc = AllProductViewController.instantiate(fromStoryboard: .Main)
            vc.titleStr = self.homeListData[sender.tag]?.name ?? ""
            vc.typeId = String(self.homeListData[sender.tag]?.type_id ?? 0)
            vc.isFirstTimeScroll = true
            vc.selectedPostID = self.displayIndex
            vc.isShowFilter = true
            self.pushViewController(vc: vc)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    private func checkAndFetchLocation(complition:@escaping((Bool) -> Void?)) {
        let locationManager = LocationManager.shared
        
        if locationManager.isLocationServicesEnabled() {
            locationManager.getCurrentLocation { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let location):
                        print("Location fetched: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                        complition(true)
                    case .failure(let error):
                        print("Error fetching location: \(error.localizedDescription)")
                        if LocationManager.shared.isLocationSetNotNow == true{
                            complition(false)
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
                                complition(false)
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
    
    @objc func createNewSaveSearch(sender:UIButton){
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let vc = SaveSearchViewController.instantiate(fromStoryboard: .Main)
        vc.saveSearch = false
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
        
    }
    
    @objc func viewSaveSearch(sender:UIButton){
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let vc = ExistingSavedSearchsViewController.instantiate(fromStoryboard: .Main)
        self.pushViewController(vc: vc)
    }
    
}


extension DiscoverVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.homeListData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexData = self.homeListData[indexPath.section]
        
        if indexData?.type == "saved_search" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaveSearchXIB", for: indexPath) as! SaveSearchXIB
            cell.btnViewSaveSearch.addTarget(self, action: #selector(self.viewSaveSearch(sender:)), for: .touchUpInside)
            cell.btnCreateSaveSearch.addTarget(self, action: #selector(self.createNewSaveSearch(sender:)), for: .touchUpInside)
            return cell
        } else {
            switch indexData?.type ?? "" {
            case "posts":
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecommendedTableXIB", for: indexPath) as! RecommendedTableXIB
                cell.setupData(posts: indexData?.list ?? [], view: self)
                cell.likeProduct = { sender in
                    debugPrint(indexData?.list?[sender.tag].id ?? 0)
                    if indexData?.list?[sender.tag].is_favourite ?? false == true{
                        self.favPost(postId: "\(indexData?.list?[sender.tag].id ?? 0)" , action_type: "0") { _ in
                            self.homeListData[indexPath.section]?.list?[sender.tag].is_favourite = false
                            self.tableView.reloadData()
                        }
                    }else{
                        self.favPost(postId: "\(indexData?.list?[sender.tag].id ?? 0)" , action_type: "1"){ _ in
                            self.homeListData[indexPath.section]?.list?[sender.tag].is_favourite = true
                            self.tableView.reloadData()
                        }
                    }
                }
                return cell
                
            case "categories":
                let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveTableCellXIB", for: indexPath) as! DiscoveTableCellXIB
                
                let isMensware = self.homeListData[indexPath.section]?.name ?? ""
                
                cell.typeID = "\(indexData?.type_id ?? 0)"
                cell.collectionView.reloadData()
                cell.collectionView.layoutIfNeeded()
                cell.setData(list: indexData?.list ?? [], type: indexData?.type ?? "", view: self,isMensware: isMensware == "Shop Menswear" ? true : false)
                
                cell.scrollIndex = { index in
                    self.displayIndex = index
                }
                cell.likeProduct = { sender in
                    debugPrint(indexData?.list?[sender.tag].id ?? 0)
                    if indexData?.list?[sender.tag].is_favourite ?? false == true{
                        self.favPost(postId: "\(indexData?.list?[sender.tag].id ?? 0)" , action_type: "0") { _ in
                            self.homeListData[indexPath.section]?.list?[sender.tag].is_favourite = false
                            self.tableView.reloadData()
                        }
                    }else{
                        self.favPost(postId: "\(indexData?.list?[sender.tag].id ?? 0)" , action_type: "1"){ _ in
                            self.homeListData[indexPath.section]?.list?[sender.tag].is_favourite = true
                            self.tableView.reloadData()
                        }
                    }
                }
                return cell
            case "brands","stores":
                let cell = tableView.dequeueReusableCell(withIdentifier: "PopuplerBrandTblXIB", for: indexPath) as! PopuplerBrandTblXIB
                cell.setData(list: indexData?.list ?? [], type: indexData?.type ?? "", view: self)
                cell.typeID = "\(indexData?.type_id ?? 0)"
                
                return cell
            default:
                return UITableViewCell() // Return an empty cell for unknown types
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.homeListData[section]?.type == "saved_search"{
            return nil
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoveHeaderCellXIB") as! DiscoveHeaderCellXIB
            let indexData = self.homeListData[section]?.name ?? ""
            cell.lblTitle.text = indexData
            cell.btnSeeMore.tag = section
            if self.homeListData[section]?.type == "categories"{
                cell.btnSeeMore.isHidden = true
            }else{
                cell.btnSeeMore.isHidden = false
            }
            cell.btnSeeMore.addTarget(self, action: #selector(self.seeAllOnPress(sender:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let indexData = self.homeListData[section]
        if self.homeListData[section]?.type == "saved_search"{
            return .leastNonzeroMagnitude
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let indexData = self.homeListData[indexPath.section]
        if indexData?.type == "categories" {
            let tableViewWidth = tableView.frame.size.width
            let collectionViewWidth = tableViewWidth - 28 // Account for left + right insets (14 each)
            
            if self.homeListData[indexPath.section]?.name == "Shop Menswear" {
                return ((collectionViewWidth / 3) * 2) + 48
            } else {
                return ((collectionViewWidth / 3) * 3) + 72
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    
}


extension DiscoverVC{
    
    @objc func deepLinkNavigate(_ notification: NSNotification) {
        DeepLinknaviget()
    }
    
    func favPost(postId:String,action_type:String,complete:@escaping (Bool)->Void){
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ] as [String : Any]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    complete(true)
                } else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
    func callPostFavourite(action_type : String,postId : String,tableindex: Int,collectionindet:Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    //                    self.callHomeList()
                    self.homeListData[tableindex]?.list?[collectionindet].is_favourite  = action_type == "0" ? false : true
                    
                    let indexSet = IndexSet(integer: tableindex)
                    self.tableView.reloadSections(indexSet, with: .automatic)
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
    
    func callHomeList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: HomeModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.HOME_PAGE.rawValue, method: .post, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.homeListData = data
                            
                            if data.first?.unread_notification == nil || data.first?.unread_notification ?? 0 == 0{
                                self.badgeView.isHidden = true
                            }else{
                                self.badgeView.isHidden = false
                            }
                            
                            if self.homeListData.count  > 0  {
                                var popup = true
                                for i in 0..<self.homeListData.count{
                                    
                                    if  self.homeListData[i]?.list?.count ?? 0  > 0{
                                        if self.homeListData[i]?.name == "Banners"{
                                        }
                                        else if self.homeListData[i]?.name == "Saved Searches"{
                                            
                                        }
                                        else{
                                            popup = false
                                            break;
                                        }
                                    }else{
                                        
                                    }
                                }
                                if popup ==  false{
                                    self.tableView.isHidden = false
                                    self.tableView.reloadData()
                                    self.tableView.layoutIfNeeded()
                                }else{
                                    self.tableView.isHidden = true
                                    self.showApoligizeAlert()
                                }
                            }else{
                                self.tableView.isHidden = true
                                self.showApoligizeAlert()
                            }
                        }
                        self.getUserDetails()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func showApoligizeAlert() {
        let vc = DeletePostVC.instantiate(fromStoryboard: .Sell)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.isCancelHide = false
        vc.deleteTitle = "Share"
        vc.cancelTitle = "Ok"
        vc.deleteBgColor = .black
        vc.titleMain = ""
        vc.subTitle = " We apologize that there is no clothes available in your location currently. We are working to get more users in your area. Help us bring more clothes to your area by telling your friends and family about the app."
        vc.imgMain = UIImage(named: "ic_app_name")
        vc.deleteOnTap = {
            let text = "I'm on Clothing Click as \(appDelegate.userDetails?.username ?? ""). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607"
            let url = URL.init(string: APP_SHARE_ITUNES_URL)!
            //let img = UIImage(named: "wel_logo")
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [text, url], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
            self.present(activityViewController, animated: true, completion: nil)
        }
        vc.cancelOnTap = {
            
        }
        self.present(vc, animated: true)
    }
    
    func getUserDetails() {
        if appDelegate.userDetails == nil{
            return
        }
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.AUTOLOGIN.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.userData = userDetails
                            self.DeepLinknaviget()
                            if let UnreadnotificationCount = self.userData?.total_unread_notifications{
                                if UnreadnotificationCount == 0 {
                                    self.btnNotification.setTitle("", for: .normal)
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                }
                                else {
                                    if UnreadnotificationCount > 99 {
                                        self.btnNotification.setTitle("99+", for: .normal)
                                        UIApplication.shared.applicationIconBadgeNumber = UnreadnotificationCount
                                    }
                                    else {
                                        self.btnNotification.setTitle("\(UnreadnotificationCount)", for: .normal)
                                        UIApplication.shared.applicationIconBadgeNumber = UnreadnotificationCount
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
                }
            }
        }
        else {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
        }
    }
}
