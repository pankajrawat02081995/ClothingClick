//
//  StoreProfileVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 04/09/24.
//


import UIKit
import MapKit

class StoreProfileVC: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var isSellling : Bool? = true
    var viewModel = StoreProfileViewModel()
    let customTransitioningDelegate = CustomTransitioningDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.viewModel.view = self
        self.viewModel.callGetOtherUserDetails(userId: self.viewModel.userID ?? "")
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never

        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "ProfilePageTbCell", bundle: nil), forCellReuseIdentifier: "ProfilePageTbCell")
        self.tableView.register(UINib(nibName: "HeaderTbCell", bundle: nil), forCellReuseIdentifier: "HeaderTbCell")
        self.tableView.register(UINib(nibName: "ItemTbCell", bundle: nil), forCellReuseIdentifier: "ItemTbCell")
    }
    
    @IBAction func btnMoreOnPress(_ sender: UIButton) {
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @objc func sellingOnPress(sender:UIButton){
        self.isSellling = true
        self.viewModel.tabId = "1"
        self.viewModel.callGetOtherUserpost(userId: self.viewModel.userID ?? "", tabId: "1")
    }
    
    @objc func soldOnPress(sender:UIButton){
        self.isSellling = false
        self.viewModel.tabId = "2"
        self.viewModel.callGetOtherUserpost(userId: self.viewModel.userID ?? "", tabId: "2")
//        callGetOtherUserDetails(userId: self.viewModel.userID ?? "")
    }
    
    @objc func websiteOnPress(sender:UIButton){
        self.openUrl(urlString: "\(sender.titleLabel?.text ?? "")")
    }
    
    @objc func shareOnPress(sender:UIButton){
        self.share(userName: self.viewModel.otherUserDetailsData?.username ?? "")
    }
    
    @objc func contactOnPress(sender:UIButton){
        let vc = StoreContactVC.instantiate(fromStoryboard: .Store)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.otherUserDetailsData = self.viewModel.otherUserDetailsData
        self.present(vc, animated: true)
    }
    
    @objc func storeOpenOnPress(sender:UIButton){
        let vc = StoreOpenVC.instantiate(fromStoryboard: .Store)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        self.present(vc, animated: true)
    }
    
    @objc func directionOnPress(sender:UIButton){
        self.showDirectionOptions(toLatitude: Double(self.viewModel.otherUserDetailsData?.locations?.first?.latitude ?? "") ?? 0.0, toLongitude: Double(self.viewModel.otherUserDetailsData?.locations?.first?.longitude ?? "") ?? 0.0, viewController: self)
    }
    
    @objc func btnFollow_Clicked(_ button: UIButton) {
        let object = self.viewModel.otherUserDetailsData
        if object?.is_following == 0 && object?.is_requested == 0  {
            self.viewModel.callFollow(userId: String(object?.id ?? 0))
        }
        else if object?.is_following == 0 && object?.is_requested == 1 {
            self.viewModel.callUnFollow(userId: String(object?.id ?? 0))
        }
        else{
            self.viewModel.callUnFollow(userId: String(object?.id ?? 0))
        }
    }
    
    @objc func filterOnPress(sender:UIButton){
        let vc = FilterProductVC.instantiate(fromStoryboard: .Dashboard)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.callBack = {
            self.viewModel.callGetOtherUserpost(userId: self.viewModel.userID ?? "", tabId: self.isSellling == true ? "1" : "2")

        }
        vc.isJustFilter = true
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
    }
    
    func showDirectionOptions(toLatitude latitude: Double, toLongitude longitude: Double, viewController: UIViewController) {
        let appleMapScheme = "http://maps.apple.com/"
        let googleMapScheme = "comgooglemaps://"
        
        var availableMapApps: [(name: String, url: URL)] = []
        
        // Check for Apple Maps (always available on iOS)
        if let appleURL = URL(string: "\(appleMapScheme)?daddr=\(latitude),\(longitude)&dirflg=d") {
            availableMapApps.append(("Apple Maps", appleURL))
        }
        
        // Check if Google Maps is installed
        if let googleURL = URL(string: "\(googleMapScheme)?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(googleURL) {
            availableMapApps.append(("Google Maps", googleURL))
        }
        
        // Present an action sheet if more than one option is available
        if !availableMapApps.isEmpty {
            let alert = UIAlertController(title: "Choose Map", message: "Select an app to show directions", preferredStyle: .actionSheet)
            
            for mapApp in availableMapApps {
                alert.addAction(UIAlertAction(title: mapApp.name, style: .default, handler: { _ in
                    UIApplication.shared.open(mapApp.url, options: [:], completionHandler: nil)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Present the alert on the provided view controller
            viewController.present(alert, animated: true, completion: nil)
        } else {
            // Handle the case when no map apps are available
            let noAppsAlert = UIAlertController(title: "No Map Apps Found", message: "No available map applications to show directions.", preferredStyle: .alert)
            noAppsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(noAppsAlert, animated: true, completion: nil)
        }
    }
    
}

extension StoreProfileVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01 // Minimize footer height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePageTbCell", for: indexPath) as! ProfilePageTbCell
            if let data = self.viewModel.otherUserDetailsData{
                cell.setData(otherUserDetailsData: data)
            }
            cell.btnOpenTime.addTarget(self, action: #selector(self.storeOpenOnPress(sender:)), for: .touchUpInside)

            cell.btnShare.addTarget(self, action: #selector(self.shareOnPress(sender:)), for: .touchUpInside)
            cell.btnFollow.addTarget(self, action: #selector(self.btnFollow_Clicked(_:)), for: .touchUpInside)
            cell.lblWebsite.addTarget(self, action: #selector(self.websiteOnPress(sender:)), for: .touchUpInside)
            cell.btnContact.addTarget(self, action: #selector(self.contactOnPress(sender:)), for: .touchUpInside)
            cell.btnDirection.addTarget(self, action: #selector(self.directionOnPress(sender:)), for: .touchUpInside)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTbCell", for: indexPath) as! ItemTbCell
            cell.view = self
            cell.btnFilter.addTarget(self, action: #selector(self.filterOnPress(sender:)), for: .touchUpInside)
            cell.setPostData(post: self.viewModel.posts)
            cell.likeOnPress = { sender in
                debugPrint(sender.tag)
                if self.viewModel.posts[sender.tag].is_favourite ?? false == true{
//                    self.viewModel.posts[sender.tag].is_favourite = false
                    self.viewModel.callPostFavourite(action_type: "0", postId:  "\(self.viewModel.posts[sender.tag].id ?? 0)", index: sender.tag)
                }else{
                    self.viewModel.callPostFavourite(action_type: "1", postId:  "\(self.viewModel.posts[sender.tag].id ?? 0)", index: sender.tag)
                }
//                self.tableView.reloadData()
            }
            cell.layoutIfNeeded()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.cellForRow(at: indexPath) as? ItemTbCell else {
            return UITableView.automaticDimension // Default height
        }
        
        // Calculate the collection view's content height
        return cell.calculateCollectionViewHeight() + 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "HeaderTbCell") as! HeaderTbCell
        
        view.btnSelling.addTarget(self, action: #selector(self.sellingOnPress(sender:)), for: .touchUpInside)
        view.btnSold.addTarget(self, action: #selector(self.soldOnPress(sender:)), for: .touchUpInside)
        
        if self.isSellling == true{
            view.sellingBottomLine.backgroundColor = .customBlack
            view.lblSelling.text = self.viewModel.otherUserDetailsData?.tabs?.first?.name ?? ""
            view.lblSelling.font = .RobotoFont(.robotoBold, size: 14)
            
            view.lblSold.font = .RobotoFont(.robotoRegular, size: 14)
            view.lblSold.text = self.viewModel.otherUserDetailsData?.tabs?.last?.name ?? ""
            view.soldBottomLine.backgroundColor = UIColor.customBorderColor
        }else{
            view.soldBottomLine.backgroundColor = .customBlack
            view.lblSold.text = self.viewModel.otherUserDetailsData?.tabs?.last?.name ?? ""
            view.lblSold.font = .RobotoFont(.robotoBold, size: 14)
            
            view.lblSelling.font = .RobotoFont(.robotoRegular, size: 14)
            view.lblSelling.text = self.viewModel.otherUserDetailsData?.tabs?.first?.name ?? ""
            view.sellingBottomLine.backgroundColor = UIColor.customBorderColor
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return .leastNonzeroMagnitude
        }else{
            return 50
        }
    }
}
