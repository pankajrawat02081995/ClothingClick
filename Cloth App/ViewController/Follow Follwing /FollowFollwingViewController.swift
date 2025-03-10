//
//  FollowFollwingViewController.swift
//  ClothApp
//
//  Created by Apple on 12/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class FollowFollwingViewController: BaseViewController {

    @IBOutlet weak var txtSearch: CustomTextField!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var viewFollowRequset: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewLine2: UIView!
    @IBOutlet weak var constHeightForviewLine: NSLayoutConstraint!
    @IBOutlet weak var constHeightForviewLine2: NSLayoutConstraint!
    @IBOutlet weak var constHeightForviewFollowRequset: NSLayoutConstraint!
    @IBOutlet weak var viewLinebtnFollowing: UIView!
    @IBOutlet weak var btnFollowere: UIButton!
    @IBOutlet weak var viewLinebtnFollowear: UIView!
    @IBOutlet weak var btnFollowRequset: UIButton!
    @IBOutlet weak var lblRequesetCount: UILabel!
    @IBOutlet weak var imgRequesetIndicater: CustomImageView!
    @IBOutlet weak var bgViewSearch: CustomView!
    @IBOutlet weak var imgSearchIcon: UIImageView!
//    @IBOutlet weak var txtSearchEngine: UITextField!
    @IBOutlet weak var btnSearchEngine: UIButton!
    @IBOutlet weak var tblFollowFollowing: UITableView!
    
    @IBOutlet weak var constHeightForTblFollowFollowing: NSLayoutConstraint!
    @IBOutlet weak var constHeightForviewLinebtnFollowear: NSLayoutConstraint!
    @IBOutlet weak var constHeightForviewLinebtnFollowing: NSLayoutConstraint!


//    var FollingFollow  =   ["Follow","Following","Following","Follow","Follow","Following","Following","Following","Follow","Following","Following"]
    
    var userName = ""
    var followingList = [FollowingsFollowearModel]()
    var followingListFilter = [FollowingsFollowearModel]()
    var selectedTab = ""
    var followingCount = ""
    var followesrCount = ""
    var currentPage = "1"
    var searchString = ""
    var userId = ""
    var followData : FollowingsFollowearsModel?
    var hasMorePages = false
    var searchActive : Bool = false
    var filtered = [FollowingsFollowearModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearch.delegate = self
        self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        if appDelegate.userDetails?.role_id == 1 && appDelegate.userDetails?.isPrivate() ?? false{
            self.viewFollowRequset.isHidden = false
            self.constHeightForviewFollowRequset.constant = 50
            self.constHeightForviewLine.constant = 1
            self.constHeightForviewLine2.constant = 1
        }
        else {
            self.viewFollowRequset.isHidden = true
            self.constHeightForviewFollowRequset.constant = 0
            self.constHeightForviewLine.constant = 0
            self.constHeightForviewLine2.constant = 0
        }
        self.lblTitle.text = userName.isEmpty ? appDelegate.userDetails?.username?.capitalized : userName
        
        self.imgRequesetIndicater.isHidden = true
        self.btnFollowing.setTitle(self.followingCount.isEmpty == false ? "Following (\(self.followingCount)) " : "Following", for: .normal)
        self.btnFollowere.setTitle(self.followesrCount.isEmpty == false ? "Followers (\(self.followesrCount))" : "Followers", for: .normal)
        
        if self.selectedTab == "Following" {
            self.btnFollowing_Clicked(self)
        }
        else {
            self.btnFollowere_Clicked(self)
        }
        if let requesetCount = self.followData?.totalFollowRequests {
            if requesetCount == 0 {
                self.lblRequesetCount.text = ""
                self.imgRequesetIndicater.isHidden = true
            }
            else {
                self.lblRequesetCount.text = String(self.followData?.totalFollowRequests ?? 0)
                self.imgRequesetIndicater.isHidden = false
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
           debugPrint(textField.text ?? "")
           let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
           self.followingList.removeAll()
           
           if trimmedText.isEmpty {
               self.followingList = self.followingListFilter
           } else {
               self.followingList = self.followingListFilter.filter { $0.username?.lowercased().contains(trimmedText) == true }
           }

           self.tblFollowFollowing.reloadData()
       }
    
    
    
    @IBAction func backIOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnFollowing_Clicked(_ button: Any) {
        self.selectedTab = "Following"
        self.btnFollowing.titleLabel?.font = UIFont.RobotoFont(.robotoBold, size: 16)
        self.btnFollowere.titleLabel?.font = UIFont.RobotoFont(.robotoRegular, size: 16)
        self.btnFollowing.setTitleColor(.customBlack, for: .normal)
        self.btnFollowere.setTitleColor(.customBlack, for: .normal)
        self.constHeightForviewLinebtnFollowing.constant = 1
        self.constHeightForviewLinebtnFollowear.constant = 2
        viewLinebtnFollowear.backgroundColor = UIColor.init(named: "App_Light_Border_Color")
        viewLinebtnFollowing.backgroundColor = .customBlack
        self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
    }
    
    @IBAction func btnFollowere_Clicked(_ button: Any) {
        self.selectedTab = "Followear"
        self.btnFollowere.titleLabel?.font = UIFont.RobotoFont(.robotoBold, size: 16)
        self.btnFollowing.titleLabel?.font = UIFont.RobotoFont(.robotoRegular, size: 16)
        self.btnFollowing.setTitleColor(.customBlack, for: .normal)
        self.btnFollowere.setTitleColor(.customBlack, for: .normal)
        self.constHeightForviewLinebtnFollowing.constant = 2
        self.constHeightForviewLinebtnFollowear.constant = 1
        viewLinebtnFollowear.backgroundColor = .customBlack
        viewLinebtnFollowing.backgroundColor = UIColor.init(named: "App_Light_Border_Color")
        self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
    }
    
    @IBAction func btnFollowRequset_Clicked(_ button: Any) {
        
        let viewController = self.storyboard?.instantiateViewController(identifier: "FollowRequestsViewController") as! FollowRequestsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func Txt_SearchStart(_ sender: Any) {
       
        if self.txtSearch.text == ""{
            self.searchActive = false
            if self.selectedTab == "Following" {
                self.btnFollowing_Clicked(self)
            }
            else {
                self.btnFollowere_Clicked(self)
            }
            }else{
                self.searchActive = true
                self.filtered = self.followingList.filter({$0.username!.lowercased().range(of: self.txtSearch.text!.lowercased()) != nil})
                self.tblFollowFollowing.reloadData()
            }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblFollowFollowing.reloadData()
        self.tblFollowFollowing.layoutIfNeeded()
       // self.constHeightForTblFollowFollowing.constant = self.tblFollowFollowing.contentSize.height
    }
    
    @objc func btnFollowUser_clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.tblFollowFollowing)
        if let indexPath = self.tblFollowFollowing.indexPathForRow(at: poston) {
            let object = self.followingList[indexPath.row]
            if let userId = object.user_id {
                self.callFollow(userId: String(userId), index: indexPath.row)
            }
        }
    }
    
    @objc func btnFollowingUser_clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.tblFollowFollowing)
        if let indexPath = self.tblFollowFollowing.indexPathForRow(at: poston) {
            let object = self.followingList[indexPath.row]
            if let userId = object.user_id {
                if object.is_following == 1 {
                    self.callUnFollow(userId: String(userId), index: indexPath.row)
                }else{
                    self.callFollow(userId: String(userId), index: indexPath.row)
                }
            }
        }
    }
}

extension FollowFollwingViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if self.searchActive == true{
//            return self.filtered.count
//        }else{
            return self.followingList.count
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingFollowearCell", for: indexPath) as! FollowingFollowearCell
//        if searchActive == true{
//            let objet = self.filtered[indexPath.row]
//            cell.lblFollowerCount.text = objet.followers ?? 0 > 1 ? "\(objet.followers ?? 0) Followers" : "\(objet.followers ?? 0) Follower"
//            cell.btnFollowFollowing.tag = indexPath.row
//            cell.lblUserName.text = objet.username?.capitalized
//            if let url = objet.photo {
//                let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                if let imgUrl = URL.init(string: urlString!) {
//                    cell.imgUser.kf.setImage(with: imgUrl, placeholder: ProfileHolderImage)
//                }
//                else{
//                    cell.imgUser.setImage(ProfileHolderImage!)
//                }
//            }
//            else{
//                cell.imgUser.setImage(ProfileHolderImage!)
//            }
//            if objet.is_requested == 1 {
//                cell.btnFollowFollowing.setTitleColor(.black, for: .normal)
//                cell.btnFollowFollowing.setTitle("Requested", for: .normal)
//                cell.btnFollowFollowing.borderWidth = 1
//                cell.btnFollowFollowing.borderColor = .customBlack
//                cell.btnFollowFollowing.backgroundColor = .customWhite
//               
//            }
//            else {
//                if objet.is_following == 1 {
//                    cell.btnFollowFollowing.setTitleColor(.black, for: .normal)
//                    cell.btnFollowFollowing.setTitle("Following", for: .normal)
//                    cell.btnFollowFollowing.borderWidth = 1
//                    cell.btnFollowFollowing.borderColor = .customBlack
//                    cell.btnFollowFollowing.backgroundColor = .customBlack
//                    cell.lblUserName.text = objet.username?.capitalized
//                    
//                    cell.btnFollowFollowing.addTarget(self, action: #selector(btnFollowingUser_clicked(_:)), for: .touchUpInside)
//                }
//                else{
//                    cell.btnFollowFollowing.setTitleColor(.customWhite, for: .normal)
//                    cell.btnFollowFollowing.setTitle("Follow", for: .normal)
//                    cell.btnFollowFollowing.borderWidth = 0
//                    cell.btnFollowFollowing.backgroundColor = .customBlack
//                    cell.lblUserName.text = objet.username?.capitalized
//                   
//                    cell.btnFollowFollowing.addTarget(self, action: #selector(btnFollowingUser_clicked(_:)), for: .touchUpInside)
//                }
//            }
//        }else{
            let objet = self.followingList[indexPath.row]
            cell.lblUserName.text = objet.username?.capitalized
            cell.lblFollowerCount.text = objet.total_posts ?? 0 > 1 ? "\(objet.total_posts ?? 0) Listings" : "\(objet.followers ?? 0) Listings"

        if let url = objet.photo {
            cell.lblFirstLetter.isHidden = true
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            cell.imgUser.setImageFast(with: urlString)
        } else {
            cell.imgUser.backgroundColor = .black
            cell.lblFirstLetter.isHidden = false
            cell.lblFirstLetter.text = objet.name?.first?.description ?? ""
            cell.imgUser.setImage(ProfileHolderImage!)
        }
        
        cell.btnFollowFollowing.isHidden = objet.user_id == appDelegate.userDetails?.id ?? 0
            cell.btnFollowFollowing.tag = indexPath.row
            if objet.is_requested == 1 {
                cell.btnFollowFollowing.setTitleColor(.black, for: .normal)
                cell.btnFollowFollowing.setTitle("Requested", for: .normal)
                cell.btnFollowFollowing.borderWidth = 1
                cell.btnFollowFollowing.borderColor = .customBlack
                cell.btnFollowFollowing.backgroundColor = .customWhite
                
            }
            else {
                if objet.is_following == 1 {
                    cell.btnFollowFollowing.setTitleColor(.black, for: .normal)
                    cell.btnFollowFollowing.setTitle("Following", for: .normal)
                    cell.btnFollowFollowing.borderWidth = 1
                    cell.btnFollowFollowing.borderColor = .customBlack
                    cell.btnFollowFollowing.backgroundColor = .customWhite
                    cell.btnFollowFollowing.addTarget(self, action: #selector(btnFollowingUser_clicked(_:)), for: .touchUpInside)
                }
                else{
                    cell.btnFollowFollowing.setTitleColor(.customWhite, for: .normal)
                    cell.btnFollowFollowing.setTitle("Follow", for: .normal)
                    cell.btnFollowFollowing.borderWidth = 0
                    cell.btnFollowFollowing.backgroundColor = .customBlack
                    cell.btnFollowFollowing.addTarget(self, action: #selector(btnFollowingUser_clicked(_:)), for: .touchUpInside)
                }
            }
//        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if searchActive == true{
        //            let object = self.filtered[indexPath.row]
        //            if appDelegate.userDetails?.id == object.user_id {
        //                self.navigateToHomeScreen(selIndex: 4)
        //            }
        //            else {
        //                if let seller = object.role_id {
        //                    if seller == 1 {
        //                        let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
        //                        viewController.userId = "\(object.user_id ?? 0)"
        //                        self.navigationController?.pushViewController(viewController, animated: true)
        //                    }
        //                    else if seller == 2 {
        //                        let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
        //                        viewController.userId = "\(object.user_id ?? 0)"
        //                        self.navigationController?.pushViewController(viewController, animated: true)
        //                    }
        //                    else {
        //                        let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
        //                        viewController.userId = "\(object.user_id ?? 0)"
        //                        self.navigationController?.pushViewController(viewController, animated: true)
        //                    }
        //                }
        //            }
        //        }else{
        let object = self.followingList[indexPath.row]
        if appDelegate.userDetails?.id == object.user_id {
            self.navigateToHomeScreen(selIndex: 4)
        }
        else {
            if let seller = object.role_id {
                if seller == 1 {
                    let viewController = OtherUserProfileViewController.instantiate(fromStoryboard: .Main)
                    viewController.userId = "\(object.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else if seller == 2 {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
                    viewController.userId = "\(object.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                    let vc = StoreProfileVC.instantiate(fromStoryboard: .Store)
                    vc.viewModel.userID = "\(object.user_id ?? 0)"
                    self.pushViewController(vc: vc)
                    //                        let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
                    //                        viewController.userId = "\(object.user_id ?? 0)"
                    //                        self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
        //        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if searchActive == true{
//            if self.selectedTab == "Following" {
//                if indexPath.item == self.filtered.count - 1 && hasMorePages == true {
//                    currentPage = String(Int(currentPage) ?? 0 + 1)
//                    self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
//                }
//            }
//            else {
//                if indexPath.item == self.filtered.count - 1 && hasMorePages == true {
//                    currentPage = String(Int(currentPage) ?? 0 + 1)
//                    self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
//                }
//            }
//        }else{
//            if self.selectedTab == "Following" {
//                if indexPath.item == self.followingList.count - 1 && hasMorePages == true {
//                    currentPage = String(Int(currentPage) ?? 0 + 1)
//                    self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
//                }
//            }
//            else {
//                if indexPath.item == self.followingList.count - 1 && hasMorePages == true {
//                    currentPage = String(Int(currentPage) ?? 0 + 1)
//                    self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
//                }
//            }
//        }
    }
}

class FollowingFollowearCell : UITableViewCell {
    @IBOutlet weak var lblFirstLetter: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var btnFollowFollowing: CustomButton!
    @IBOutlet weak var lblUserName: UILabel!
}
extension  FollowFollwingViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        if textField == self.txtSearch {
//            if textField.text == ""{
//                self.searchActive = false
//                self.tblFollowFollowing.reloadData()
//            }else{
//                self.filtered = self.followingList.filter({$0.username!.lowercased().range(of: textField.text!.lowercased()) != nil})
//                self.tblFollowFollowing.reloadData()
//            }
//            let currentString: NSString = (textField.text ?? "") as NSString
//            let newString: NSString =
//            currentString.replacingCharacters(in: range, with: string) as NSString
//            self.searchString = (newString) as String
//            if self.selectedTab == "Following" {
//                self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
//            }
//            else {
//                self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
//            }
            return true
        }
        else {
            return true
        }
    }
}

extension FollowFollwingViewController {
    
    func callFollow(userId : String, index : Int) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if self.selectedTab == "Following" {
                        self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
                        
                    }else{
                        self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
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
    
    func callUnFollow(userId : String, index : Int) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.UNFOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if self.selectedTab == "Following" {
                        self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
                        
                    }else{
                        self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
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

    func callSearchFollowings(isShowHud: Bool,Search : String, Page : String,userid : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["page" : Page ,
                         "Search" : Search,
                         "user_id" : userid
            ]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOWINGS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.followData = data
                            if self.currentPage == "1" {
                                self.followingList.removeAll()
                                self.followingListFilter.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages {
                                self.hasMorePages = hasMorePages
                            }
                            if let post = data.followings {
                                for temp in post {
                                    self.followingList.append(temp)
                                    self.followingListFilter.append(temp)
                                }
                            }
                            self.followingCount = ""
                            if let followingCount = data.totalFollowings, followingCount != 0 {
                                self.followingCount = String(followingCount)
                            }
                            self.followesrCount = ""
                            if let follwearCount = data.totalFollowers, follwearCount  != 0 {
                                self.followesrCount = String(follwearCount)
                            }
                            self.lblRequesetCount.text = ""
                            self.imgRequesetIndicater.isHidden = true
                            if let requesetCount = data.totalFollowRequests, requesetCount != 0 {
                                self.lblRequesetCount.text = String(data.totalFollowRequests ?? 0)
                                self.imgRequesetIndicater.isHidden = false
                            }
                        }
                    }
                    if self.followingList.count == 0 {
                        self.lblNoData.isHidden = true
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    self.tblFollowFollowing.setBackGroundLabel(count: self.followingList.count)
                    self.btnFollowing.setTitle(self.followingCount.isEmpty == false ? "Following (\(self.followingCount)) " : "Following", for: .normal)
                    self.btnFollowere.setTitle(self.followesrCount.isEmpty == false ? "Followers (\(self.followesrCount))" : "Followers", for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.tblFollowFollowing.reloadData()
                        self.tblFollowFollowing.layoutIfNeeded()
       //                 self.constHeightForTblFollowFollowing.constant = self.tblFollowFollowing.contentSize.height
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
    
    func callSearchFollowears(isShowHud: Bool,Search : String, Page : String,userid : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["page" : Page ,
                         "Search" : Search,
                         "user_id" : userid
            ]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOWERS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            if self.currentPage == "1" {
                                self.followingList.removeAll()
                                self.followingListFilter.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages {
                                self.hasMorePages = hasMorePages
                            }
                            if let post = data.followears {
                                for temp in post {
                                    self.followingList.append(temp)
                                    self.followingListFilter.append(temp)
                                }
                            }
                            if let followingCount = data.totalFollowings {
                                if followingCount == 0 {
                                    self.followingCount = ""
                                }
                                else {
                                    self.followingCount = String(followingCount)
                                }
                            }
                            if let follwearCount = data.totalFollowers {
                                if follwearCount == 0 {
                                    self.followesrCount = ""
                                }
                                else {
                                    self.followesrCount = String(follwearCount)
                                }
                            }
                            if let requesetCount = data.totalFollowRequests {
                                if requesetCount == 0 {
                                    self.lblRequesetCount.text = ""
                                    self.imgRequesetIndicater.isHidden = true
                                }
                                else {
                                    self.lblRequesetCount.text = String(data.totalFollowRequests ?? 0)
                                    self.imgRequesetIndicater.isHidden = false
                                }
                            }
                        }
                    }
                    if self.followingList.count == 0 {
                        self.lblNoData.isHidden = true
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    self.tblFollowFollowing.setBackGroundLabel(count: self.followingList.count)
                    self.btnFollowing.setTitle(self.followingCount.isEmpty == false ? "Following (\(self.followingCount)) " : "Following", for: .normal)
                    self.btnFollowere.setTitle(self.followesrCount.isEmpty == false ? "Followers (\(self.followesrCount))" : "Followers", for: .normal)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.tblFollowFollowing.reloadData()
                        self.tblFollowFollowing.layoutIfNeeded()
                        //self.constHeightForTblFollowFollowing.constant = self.tblFollowFollowing.contentSize.height
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
extension FollowFollwingViewController{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtSearch{
            debugPrint(textField.text ?? "")
            let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
            self.followingList.removeAll()
            
            if trimmedText.isEmpty {
                self.followingList = self.followingListFilter
            } else {
                self.followingList = self.followingListFilter.filter { $0.username?.lowercased().contains(trimmedText) == true }
            }

            self.tblFollowFollowing.reloadData()
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if textField == self.txtSearch{
            debugPrint(textField.text ?? "")
            let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
            self.followingList.removeAll()
            
            if trimmedText.isEmpty {
                self.followingList = self.followingListFilter
            } else {
                self.followingList = self.followingListFilter.filter { $0.username?.lowercased().contains(trimmedText) == true }
            }

            self.tblFollowFollowing.reloadData()
            return true
        }
        return true
    }
}
