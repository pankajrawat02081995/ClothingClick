//
//  FollowFollwingViewController.swift
//  ClothApp
//
//  Created by Apple on 12/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class OtherFollowFollwingViewController: BaseViewController {
    
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
    @IBOutlet weak var txtSearchEngine: UITextField!
    @IBOutlet weak var btnSearchEngine: UIButton!
    @IBOutlet weak var tblFollowFollowing: UITableView!
    
    @IBOutlet weak var constHeightForTblFollowFollowing: NSLayoutConstraint!
    @IBOutlet weak var constHeightForviewLinebtnFollowear: NSLayoutConstraint!
    @IBOutlet weak var constHeightForviewLinebtnFollowing: NSLayoutConstraint!
    
    var followingList = [FollowingsFollowearModel]()
    var selectedTab = ""
    var followingCount = ""
    var followesrCount = ""
    var userId = ""
    var userName = ""
    var currentPage = "1"
    var searchString = ""
    var followData : FollowingsFollowearsModel?
    var hasMorePages = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if appDelegate.userDetails?.role_id == 1 && appDelegate.userDetails?.isPrivate() ?? false{
//            self.viewFollowRequset.isHidden = false
//            self.constHeightForviewFollowRequset.constant = 50
//            self.constHeightForviewLine.constant = 1
//            self.constHeightForviewLine2.constant = 1
//        }
//        else {
            self.viewFollowRequset.isHidden = true
            self.constHeightForviewFollowRequset.constant = 0
            self.constHeightForviewLine.constant = 0
            self.constHeightForviewLine2.constant = 0
     //   }
        self.lblTitle.text = self.userName
        
        self.imgRequesetIndicater.isHidden = true
        self.btnFollowing.setTitle("\(self.followingCount) Following", for: .normal)
        self.btnFollowere.setTitle("\(self.followesrCount) Followers", for: .normal)
        
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
    
    @IBAction func btnFollowing_Clicked(_ button: Any) {
        self.btnFollowing.setTitleColor(.black, for: .normal)
        self.btnFollowere.setTitleColor(UIColor.init(named: "DarkGrayColor"), for: .normal)
        self.constHeightForviewLinebtnFollowing.constant = 1
        self.constHeightForviewLinebtnFollowear.constant = 2
        viewLinebtnFollowear.backgroundColor = UIColor.init(named: "DarkGrayColor")
        viewLinebtnFollowing.backgroundColor = .black
        self.currentPage = "1"
        self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
    }
    
    @IBAction func btnFollowere_Clicked(_ button: Any) {
        self.btnFollowing.setTitleColor(UIColor.init(named: "DarkGrayColor"), for: .normal)
        self.btnFollowere.setTitleColor(.black, for: .normal)
        self.constHeightForviewLinebtnFollowing.constant = 2
        self.constHeightForviewLinebtnFollowear.constant = 1
        viewLinebtnFollowear.backgroundColor = .black
        viewLinebtnFollowing.backgroundColor = UIColor.init(named: "DarkGrayColor")
        self.currentPage = "1"
        self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: self.currentPage,userid: self.userId)
    }
    
    @IBAction func btnFollowRequset_Clicked(_ button: Any) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "FollowRequestsViewController") as! FollowRequestsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblFollowFollowing.reloadData()
        self.tblFollowFollowing.layoutIfNeeded()
        self.constHeightForTblFollowFollowing.constant = self.tblFollowFollowing.contentSize.height
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

extension OtherFollowFollwingViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingFollowearCell", for: indexPath) as! FollowingFollowearCell
        let objet = self.followingList[indexPath.row]
        cell.lblUserName.text = objet.name
        
        if let url = objet.photo {
            let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if let imgUrl = URL.init(string: urlString!) {
                cell.imgUser.kf.setImage(with: imgUrl, placeholder: ProfileHolderImage)
            }
            else{
                cell.imgUser.setImage(ProfileHolderImage!)
            }
        }
        else{
            cell.imgUser.setImage(ProfileHolderImage!)
        }
        if objet.user_id == appDelegate.userDetails?.id {
            cell.btnFollowFollowing.isHidden = true
        }else{
            cell.btnFollowFollowing.isHidden = false
        }
        cell.btnFollowFollowing.tag = indexPath.row
        if objet.is_requested == 1 {
            cell.btnFollowFollowing.setTitleColor(.black, for: .normal)
            cell.btnFollowFollowing.setTitle("Requested", for: .normal)
            cell.btnFollowFollowing.borderWidth = 1
            cell.btnFollowFollowing.borderColor = .black
            cell.btnFollowFollowing.backgroundColor = .white
            
        }
        else {
            if objet.is_following == 1 {
                cell.btnFollowFollowing.setTitleColor(.black, for: .normal)
                cell.btnFollowFollowing.setTitle("Following", for: .normal)
                cell.btnFollowFollowing.borderWidth = 1
                cell.btnFollowFollowing.borderColor = .black
                cell.btnFollowFollowing.backgroundColor = .white
                
                cell.btnFollowFollowing.addTarget(self, action: #selector(btnFollowingUser_clicked(_:)), for: .touchUpInside)
                
            }
            else{
                cell.btnFollowFollowing.setTitleColor(.white, for: .normal)
                cell.btnFollowFollowing.setTitle("Follow", for: .normal)
                cell.btnFollowFollowing.borderWidth = 0
                cell.btnFollowFollowing.backgroundColor = UIColor.init(named: "BlueColor")
                
                cell.btnFollowFollowing.addTarget(self, action: #selector(btnFollowingUser_clicked(_:)), for: .touchUpInside)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.followingList[indexPath.row]
        if appDelegate.userDetails?.id == object.user_id {
            self.navigateToHomeScreen(selIndex: 4)
        }
        else {
            if let seller = object.role_id {
                if seller == 1 {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                    viewController.userId = "\(object.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else if seller == 2 {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
                    viewController.userId = "\(object.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
                    viewController.userId = "\(object.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.selectedTab == "Following" {
            if indexPath.item == self.followingList.count - 1 && hasMorePages == true {
                currentPage = String(Int(currentPage) ?? 0 + 1)
                self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
            }
        }
        else {
            if indexPath.item == self.followingList.count - 1 && hasMorePages == true {
                currentPage = String(Int(currentPage) ?? 0 + 1)
                self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
            }
        }
    }
}

extension  OtherFollowFollwingViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtSearchEngine {
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            self.searchString = (newString) as String
            if self.selectedTab == "Following" {
                self.callSearchFollowings(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
            }
            else {
                self.callSearchFollowears(isShowHud: true, Search: self.searchString, Page: currentPage,userid: self.userId)
            }
            return true
        }
        else {
            return true
        }
    }
}

extension OtherFollowFollwingViewController {
    
    func callFollow(userId : String, index : Int) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.followingList[index].is_following = 1
                    self.tblFollowFollowing.reloadData()
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
                    self.followingList[index].is_following = 0
                    self.tblFollowFollowing.reloadData()
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
    
    func callFollowRequest() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.UNFOLLOW_USER.rawValue, method: .post, parameters: [:]) { (response, error) in
                if error == nil {
                    
                    self.tblFollowFollowing.reloadData()
                    
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
                            }
                            if let hasMorePages = data.hasMorePages {
                                self.hasMorePages = hasMorePages
                            }
                            if let post = data.followings {
                                for temp in post {
                                    self.followingList.append(temp)
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
                        self.lblNoData.isHidden = false
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.tblFollowFollowing.reloadData()
                        self.tblFollowFollowing.layoutIfNeeded()
                        self.constHeightForTblFollowFollowing.constant = self.tblFollowFollowing.contentSize.height
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
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.USER_FOLLOWERS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            if self.currentPage == "1" {
                                self.followingList.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages {
                                self.hasMorePages = hasMorePages
                            }
                            if let post = data.followears {
                                for temp in post {
                                    self.followingList.append(temp)
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
                        self.lblNoData.isHidden = false
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.tblFollowFollowing.reloadData()
                        self.tblFollowFollowing.layoutIfNeeded()
                        self.constHeightForTblFollowFollowing.constant = self.tblFollowFollowing.contentSize.height
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
