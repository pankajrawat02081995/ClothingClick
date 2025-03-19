//
//  NotificationsViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var lblNoDeta: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblNotification: UITableView!
    
    var notificationList = [Notifications]()
    var currentPage = 1
    var hasMorePages = false
    var fromPushNotification:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.getNottfication(isShowHud: true)
    }
    
    func setupTableView(){
        self.tblNotification.register(UINib(nibName: "FollowRequestXIB", bundle: nil), forCellReuseIdentifier: "FollowRequestXIB")
    }
    @IBAction func onBtnBack_Clicked(_ sender: Any) {
        if fromPushNotification == false{
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigateToHomeScreen()
        }
    }
    
    @objc func btnAccepted_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblNotification)
        if let indexPath = self.tblNotification.indexPathForRow(at: buttonPosition) {
            let object = self.notificationList[indexPath.row]
            self.callFollowRequstAcceptOrReject(followRequestId: "\(object.follow_request_id ?? 0)", status: "1", index: indexPath.row,notificationid: "\(object.id ?? 0)")
        }
    }
    
    @objc func btnRejected_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblNotification)
        if let indexPath = self.tblNotification.indexPathForRow(at: buttonPosition) {
            let object = self.notificationList[indexPath.row]
            self.callFollowRequstAcceptOrReject(followRequestId: "\(object.follow_request_id ?? 0)", status: "0", index: indexPath.row,notificationid: "\(object.id ?? 0)")
        }
    }
}

extension NotificationsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.notificationList[indexPath.row]
//        if object.type == "SAVED_SEARCH_ALERT"{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarkLikeCell", for: indexPath) as! BookMarkLikeCell
//            if let title = object.title{
//                cell.lblTitle.text = title//"Saved search"
//            }
////            if let size = object.post_size , size.count > 0 {
////                if let size = object.post_size?[0].name {
////                    if let postTitle = object.post_title {
////                        cell.lblSubTitle.text = "(\(size)) \(postTitle)"
////                    }
////                    else{
////                        if let postTitle = object.post_title {
////                            cell.lblSubTitle.text = "\(postTitle)"
////                        }
////                    }
////                }else{
////                    if let postTitle = object.post_title {
////                        cell.lblSubTitle.text = "\(postTitle)"
////                    }
////                }
////            }
////            else{
////                if let postTitle = object.post_title {
////                    cell.lblSubTitle.text = "\(postTitle)"
////                }
////            }
////            if let savesearchname = object.save_search_name {
////                cell.lblDescription.text = savesearchname
////            }
//            if let strDate = object.created_at {
//                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
//                cell.lblTime.text = Date().offset(from: date)
//            }
//            //            if let message = object.post_desc {
//            //                cell.lblDescription.text = message//"Description..."
//            //            }
//            
//            cell.lblCurrnceCount.isHidden = true
//            cell.imgBookmark.isHidden = true
//            cell.imgBookmark.image = UIImage.init(named: "bookmark_ic")
//            if let url = object.post_image?[0].image {
//                if let image = URL.init(string: url){
//                    cell.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
//                    cell.imgUser.layer.cornerRadius = cell.imgUser.bounds.height/2
//                }
//            }
//            return cell
//        }
//        else
        if object.type == "CUSTOM_NOTIFICATION" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomeNotificationCell", for: indexPath) as! CustomeNotificationCell
            if let title = object.title{
                cell.lblTitle.text = title//"Saved search"
            }
            
            if let message = object.message {
                cell.lblSubTitle.text = "\(message)"
            }
            
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            if let url = object.user_photo {
                let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if let image = URL.init(string: urlString ?? ""){
                    cell.imgUser.isHidden = false
                    cell.constleadingtxttitle.constant = 5
                    cell.imgUser.setImageFast(with: urlString ?? "")
                    
                }
                else{
                    cell.imgUser.isHidden = true
                    cell.constleadingtxttitle.constant = -55
                }
            }
            else{
                cell.imgUser.isHidden = true
                cell.constleadingtxttitle.constant = -55
                cell.imgUser.setImage(ProfileHolderImage!)
            }
            return cell
        }
        else if object.type == "WATCHLIST_PRICE_DROP" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookMarkLikeCell", for: indexPath) as! BookMarkLikeCell
            if let title = object.title {
                cell.lblTitle.text = title
            }
            if let brandName = object.post_brand {
                cell.lblSubTitle.text = brandName
            }
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            if let postsize = object.post_size{
                let name = postsize[0].name
                if let message = object.post_title {
                    cell.lblDescription.text = "(\(name ?? "")) \(message)"
                }
            }
            cell.lblCurrnceCount.isHidden = false
            if let postPrice = object.post_price {
                cell.lblCurrnceCount.text = "$\(postPrice)"
            }
            cell.imgBookmark.image = UIImage.init(named: "like-ic")
            if let data = object.post_image {
                if  let imageurl = data[0].image{
                    cell.imgUser.setImageFast(with: imageurl)
                }
            }
            return cell
        }
        else if object.type == "NEW_FOLLOWER" || object.type == "MESSAGE_SEND" || object.type == "SAVED_SEARCH_ALERT"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesUserCell", for: indexPath) as! FavoritesUserCell
            cell.viewCoine.isHidden = true
            cell.lblCC.isHidden = true
            if object.type == "SAVED_SEARCH_ALERT"{
                if let url = object.post_image?.first {
                    
                    if let image = URL.init(string: url.image ?? ""){
                        cell.lblCC.isHidden = true
                        cell.imgUser.setImageFast(with: url.image ?? "")
                    }
                    else {
                        cell.lblCC.isHidden = false
                        cell.imgUser.image = nil
                    }
                }
            }else{
                if let url = object.user_photo {
                    if let image = URL.init(string: url){
                        cell.lblCC.isHidden = true
                        cell.imgUser.setImageFast(with: url ?? "")
                    }
                    else {
                        cell.lblCC.isHidden = false
                        cell.imgUser.image = nil
                    }
                }
            }
            
            if let title = object.name{
                cell.lblTitle.text = title.capitalized//"Username"
            }
            
            if object.type == "NEW_FOLLOWER" {
                if let subtitle = object.title {
                    cell.lblSubTitle.text = subtitle//"Started following you"
                }
            }
            else if object.type == "MESSAGE_SEND"{
                if let subtitle = object.message {
                    cell.lblSubTitle.text = subtitle//"Started following you"
                }
            }else{
                if let subtitle = object.title {
                    cell.lblTitle.text = subtitle//"Started following you"
                }
                    cell.lblSubTitle.text = "A new listing matches your saved search."//"Started following you"

            }
            
            
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            cell.imgBookmark.isHidden = true
            return cell
        }
        else  if object.type == "ACCEPT_FOLLOW_REQUEST" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesUserCell", for: indexPath) as! FavoritesUserCell
            cell.viewCoine.isHidden = true
            if let url = object.user_photo {
                cell.imgUser.setImageFast(with: url ?? "")
            }
            cell.lblTitle.text = object.name ?? ""
            cell.lblSubTitle.text = object.title
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            cell.imgBookmark.isHidden = true
            cell.imgBookmark.image = UIImage.init(named: "unlock-ic")
            return cell
        }
        else if object.type == "FOLLOW_REQUEST"{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowRequestXIB", for: indexPath) as! FollowRequestXIB
//            if let username = object.username {
//                cell.lblSubTitle.text = username
//            }
            if let message = object.message {
                cell.lblSubTitle.text = message
            }
            if let titel = object.title {
                cell.lblTitle.text = titel
            }
            if let url = object.user_photo {
                cell.imgUser.setImageFast(with: url ?? "")
            }
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            cell.btnConfirm.addTarget(self, action: #selector(btnAccepted_Clicked(sender:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(btnRejected_Clicked(sender:)), for: .touchUpInside)
            
            return cell
        }
        else if object.type == "RATE_SELLER" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesUserCell", for: indexPath) as! FavoritesUserCell
            if let title = object.title {
                cell.lblTitle.text = title.capitalized
            }
            if let userename = object.name {
                cell.lblSubTitle.text = userename.capitalized
            }
            if let url = object.user_photo {
                cell.imgUser.setImageFast(with: url ?? "")
            }
            cell.imgBookmark.isHidden = true
            cell.viewCoine.isHidden = true
            cell.imgBookmark.image = UIImage.init(named: "stars-ic")
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesUserCell", for: indexPath) as! FavoritesUserCell
            cell.viewCoine.isHidden = false
            //            cell.ConstrainLidingForImgUser.constant = 20
            //            cell.ConstrainTopForImgUser.constant = 10
            //            cell.ConstrainBottumForImgUser.constant = 10
            //            cell.ConstrainHightForImgUser.constant = 50
            //            cell.imgUser.cornerRadius = 25
            cell.imgUser.image = UIImage.init(named: "Vector-Coin-ic")
            //            cell.ConstrainLidingForTitle.constant = 15
            if let tital = object.title {
                cell.lblTitle.text = tital.capitalized
            }
            if let subTitle = object.message {
                cell.lblCoinmessage.text = subTitle
            }
            if let coutn = object.earned_coin {
                cell.lblCoinCount.text = "+ \(coutn)"
            }
            
            if let strDate = object.created_at {
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblTime.text = Date().offset(from: date)
            }
            if object.type == "MESSAGE_SEND"{
            }else{
                cell.lblSubTitle.isHidden = true
            }
            cell.imgBookmark.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.notificationList[indexPath.row]
        if object.type == "SAVED_SEARCH_ALERT"{
//            let viewController = self.storyboard?.instantiateViewController(identifier: "PopularBrandsViewController") as! PopularBrandsViewController
//            viewController.headerTitel = "Search Results"
//            viewController.isSaveSearch = true
//            viewController.saveSearchID = String(object.save_search_id ?? 0)
//            self.navigationController?.pushViewController(viewController, animated: true)
            
            let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
            viewController.titleStr = "Search Results"
            viewController.isSaveList = false
            viewController.saveSearchId =  object.save_search_id ?? 0
            self.pushViewController(vc: viewController)
        }
        
        else if object.type == NOTIFICATIONSTYPE.MESSAGE_SEND.rawValue{
            let viewController = self.storyboard?.instantiateViewController(identifier: "MessagesViewController") as! MessagesViewController
            if let postId = object.post_id{
                viewController.postId = "\(postId)"
            }
            if let sendUserId = object.user_id{
                viewController.senderuserId = "\(sendUserId)"
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if object.type == NOTIFICATIONSTYPE.FOLLOW_REQUEST.rawValue || object.type == NOTIFICATIONSTYPE.ACCEPT_FOLLOW_REQUEST.rawValue || object.type == NOTIFICATIONSTYPE.NEW_FOLLOWER.rawValue{
            if appDelegate.userDetails?.id == object.user_id {
                self.navigateToHomeScreen(selIndex: 4)
            }
            else {
                if let seller = object.role_id {
                    if seller == 1 {
                        let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                        viewController.userId = "\(object.user_id ?? 0)"
                        viewController.isFollow = true
                        viewController.requesetUserName = object.username ?? ""
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    else if seller == 2{
                        let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
                        viewController.userId = "\(object.user_id ?? 0)"
                        viewController.isFollow = true
                        viewController.requesetUserName = object.username ?? ""
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    else {
                        let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
                        viewController.userId = "\(object.seller_id ?? 0)"
                        viewController.isFollow = true
                        viewController.requesetUserName = object.username ?? ""
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
        else if object.type == NOTIFICATIONSTYPE.WATCHLISTPRICEDROP.rawValue{
//            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//            viewController.postId = "\(object.post_id ?? 0)"
//            self.navigationController?.pushViewController(viewController, animated: true)
            let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            vc.postId = "\(object.post_id ?? 0)"
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc: vc)
        }
        else if object.type == NOTIFICATIONSTYPE.RATESELLER.rawValue{
            let viewController = NewRatingViewController.instantiate(fromStoryboard: .Setting)
            viewController.userId = "\(object.seller_id ?? 0)"
            viewController.postId = "\(object.post_id ?? 0)"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if object.type == NOTIFICATIONSTYPE.EARNCLICKCOIN.rawValue{
            let ViewController = storyboard?.instantiateViewController(identifier: "ClickCoinsViewController") as! ClickCoinsViewController
            self.navigationController?.pushViewController(ViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.notificationList.count - 1 && hasMorePages == true {
            self.currentPage = self.currentPage + 1
            self.getNottfication(isShowHud: false)
        }
    }
}
class CustomeNotificationCell : UITableViewCell {
    @IBOutlet weak var lblCC: UILabel!
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var constleadingtxttitle: NSLayoutConstraint!
}
class BookMarkLikeCell : UITableViewCell {
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var imgBookmark: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCurrnceCount: UILabel!
}

class FavoritesUserCell : UITableViewCell {
    @IBOutlet weak var lblCC: UILabel!
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var ConstrainHightForImgUser: NSLayoutConstraint!
    @IBOutlet weak var ConstrainTopForImgUser: NSLayoutConstraint!
    @IBOutlet weak var ConstrainBottumForImgUser: NSLayoutConstraint!
    @IBOutlet weak var ConstrainLidingForImgUser: NSLayoutConstraint!
    @IBOutlet weak var imgBookmark: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ConstrainLidingForTitle: NSLayoutConstraint!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCoinCount: UILabel!
    @IBOutlet weak var lblCoinmessage: UILabel!
    @IBOutlet weak var viewCoine: UIView!
}

class RequestCell : UITableViewCell {
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnAccepted: UIButton!
    @IBOutlet weak var btnRejected: UIButton!
}

extension NotificationsViewController {
    func getNottfication(isShowHud : Bool) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["page":  "\(self.currentPage)"]
            
            APIManager().apiCall(of: NotificationModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.GET_NOTIFICATION.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.notificationList.removeAll()
                            }
                            
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            
                            if let notifications = data.notifications {
                                for temp in notifications {
                                    self.notificationList.append(temp)
                                }
                            }
                            if self.notificationList.count == 0 {
                                self.lblNoDeta.isHidden = false
                            }
                            else {
                                self.lblNoDeta.isHidden = true
                            }
                            self.tblNotification.reloadData()
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
    
    func callFollowRequstAcceptOrReject(followRequestId : String,status: String, index : Int,notificationid: String) {
        if appDelegate.reachable.connection != .none {
            let param = ["follow_request_id" : followRequestId,
                         "status":status,
                         "notification_id": notificationid          ]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOW_REQUESTS_STATUS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.notificationList.remove(at: index)
                    self.tblNotification.reloadData()
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
