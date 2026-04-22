//
//  NotificationsViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit


enum NotificationType: String {
    case customNotification = "CUSTOM_NOTIFICATION"
    case watchlistPriceDrop = "WATCHLIST_PRICE_DROP"
    case newFollower = "NEW_FOLLOWER"
    case messageSend = "MESSAGE_SEND"
    case savedSearchAlert = "SAVED_SEARCH_ALERT"
    case acceptFollowRequest = "ACCEPT_FOLLOW_REQUEST"
    case followRequest = "FOLLOW_REQUEST"
    case rateSeller = "RATE_SELLER"
}

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
        self.tblNotification.register(
            
            
            UINib(nibName: "FollowRequestXIB", bundle: nil), forCellReuseIdentifier: "FollowRequestXIB")
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

        let object = notificationList[indexPath.row]
        let type = NotificationType(rawValue: object.type ?? "")

        // MARK: - CUSTOM NOTIFICATION
        if type == .customNotification {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "CustomeNotificationCell",
                for: indexPath
            ) as! CustomeNotificationCell

            cell.lblTitle.text = object.title
            cell.lblSubTitle.text = object.message

            configureTime(cell.lblTime, object.created_at)

            if let photo = object.user_photo,
               let encoded = photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               URL(string: encoded) != nil {
                cell.imgUser.isHidden = false
                cell.constleadingtxttitle.constant = 5
                cell.imgUser.setImageFast(with: encoded)
                cell.imgUser.contentMode = .scaleAspectFill
            } else {
                cell.imgUser.isHidden = true
                cell.constleadingtxttitle.constant = -55
            }

            return cell
        }

        // MARK: - WATCHLIST PRICE DROP
        if type == .watchlistPriceDrop {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "BookMarkLikeCell",
                for: indexPath
            ) as! BookMarkLikeCell

            cell.lblTitle.text = object.title
            cell.lblSubTitle.text = "$\(object.post_price ?? "")"
            cell.lblSubTitle.textColor = .red
//            cell.lblCurrnceCount.isHidden = false
//            cell.lblCurrnceCount.text = object.post_price.map { "$\($0)" }
//
//            if let size = object.post_size?.first?.name,
//               let title = object.post_title {
//                cell.lblDescription.text = "(\(size)) \(title)"
//            }

            if let image = object.post_image?.first?.image {
                cell.imgUser.setImageFast(with: image)
                cell.imgUser.contentMode = .scaleAspectFill
            }

            cell.imgBookmark.image = UIImage(named: "like-ic")
            cell.imgBookmark.isHidden = true
            configureTime(cell.lblTime, object.created_at)
            cell.imgUser.cornerRadius = 0
            cell.imgUser.clipsToBounds = true
            return cell
        }

        // MARK: - FOLLOWER / MESSAGE / SAVED SEARCH
        if type == .newFollower || type == .messageSend || type == .savedSearchAlert {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FavoritesUserCell",
                for: indexPath
            ) as! FavoritesUserCell

            cell.viewCoine.isHidden = true
            cell.imgBookmark.isHidden = true
            cell.lblCC.isHidden = true
            cell.imgUser.image = nil
            
            
            switch type {

            case .savedSearchAlert:
                if let image = object.post_image?.first?.image,
                   URL(string: image) != nil {
                    cell.imgUser.setImageFast(with: image)
                    
                } else {
                    cell.lblCC.isHidden = false
                }
                cell.imgUser.cornerRadius = 0
                cell.imgUser.contentMode = .scaleAspectFill
                cell.imgUser.clipsToBounds = true
                cell.lblTitle.text = object.title
                cell.lblSubTitle.text = "A new listing matches your saved search."

            case .newFollower:
                cell.lblTitle.text = object.name?.capitalized
                cell.lblSubTitle.text = object.title
                cell.imgUser.cornerRadius = cell.imgUser.frame.height/2
                cell.imgUser.setProfileImage(
                    from: object.user_photo ?? "",
                    placeholderName: object.name ?? ""
                )
                cell.imgUser.contentMode = .scaleAspectFill

            case .messageSend:
                cell.lblTitle.text = object.name?.capitalized
                cell.lblSubTitle.text = object.message
                cell.imgUser.cornerRadius = cell.imgUser.frame.height/2
                cell.imgUser.setProfileImage(
                    from: object.user_photo ?? "",
                    placeholderName: object.name ?? ""
                )
                cell.imgUser.contentMode = .scaleAspectFill

            default:
                break
            }

            configureTime(cell.lblTime, object.created_at)
            return cell
        }

        // MARK: - ACCEPT FOLLOW REQUEST
        if type == .acceptFollowRequest {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FavoritesUserCell",
                for: indexPath
            ) as! FavoritesUserCell

            cell.viewCoine.isHidden = true
            cell.imgBookmark.image = UIImage(named: "unlock-ic")
            cell.imgBookmark.isHidden = true

            cell.lblTitle.text = object.name
            cell.lblSubTitle.text = object.title

            if let photo = object.user_photo {
                cell.imgUser.setImageFast(with: photo)
                cell.imgUser.contentMode = .scaleAspectFill
            }

            configureTime(cell.lblTime, object.created_at)
            return cell
        }

        // MARK: - FOLLOW REQUEST
        if type == .followRequest {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FollowRequestXIB",
                for: indexPath
            ) as! FollowRequestXIB

            cell.lblTitle.text = object.title
            cell.lblSubTitle.text = object.message

            if let photo = object.user_photo {
                cell.imgUser.setImageFast(with: photo)
                cell.imgUser.contentMode = .scaleAspectFill
            }

            configureTime(cell.lblTime, object.created_at)

            cell.btnConfirm.addTarget(self, action: #selector(btnAccepted_Clicked), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(btnRejected_Clicked), for: .touchUpInside)

            return cell
        }

        // MARK: - RATE SELLER
        if type == .rateSeller {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "FavoritesUserCell",
                for: indexPath
            ) as! FavoritesUserCell

            cell.viewCoine.isHidden = true
            cell.imgBookmark.isHidden = true
            cell.imgBookmark.image = UIImage(named: "stars-ic")

            cell.lblTitle.text = object.title?.capitalized
            cell.lblSubTitle.text = object.name?.capitalized

            if let photo = object.user_photo {
                cell.imgUser.setImageFast(with: photo)
                cell.imgUser.contentMode = .scaleAspectFill
            }

            configureTime(cell.lblTime, object.created_at)
            return cell
        }

        // MARK: - DEFAULT (COIN / OTHER)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "FavoritesUserCell",
            for: indexPath
        ) as! FavoritesUserCell

        cell.viewCoine.isHidden = false
        cell.imgUser.image = UIImage(named: "Vector-Coin-ic")
        cell.lblTitle.text = object.title?.capitalized
        cell.imgUser.contentMode = .scaleAspectFill
        cell.lblCoinmessage.text = object.message
        cell.lblCoinCount.text = object.earned_coin.map { "+ \($0)" }
        cell.lblSubTitle.isHidden = true
        cell.imgBookmark.isHidden = true

        configureTime(cell.lblTime, object.created_at)
        return cell
    }

    private func configureTime(_ label: UILabel, _ dateString: String?) {
        guard let strDate = dateString else { return }
        let date = convertWebStringToDate(strDate: strDate).toLocalTime()
        label.text = Date().offset(from: date)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.notificationList[indexPath.row]
        if object.type == "SAVED_SEARCH_ALERT"{
//            let viewController = self.storyboard?.instantiateViewController(identifier: "PopularBrandsViewController") as! PopularBrandsViewController
//            viewController.headerTitel = "Search Results"
//            viewController.isSaveSearch = true
//            viewController.saveSearchID = String(object.save_search_id ?? 0)
//            self.navigationController?.pushViewController(viewController, animated: true)
            
//            let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
//            viewController.titleStr = "Search Results"
//            viewController.isSaveList = true
//            viewController.saveSearchId =  object.save_search_id ?? 0
//            self.pushViewController(vc: viewController)
            let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            vc.postId = "\(object.post_id ?? 0)"
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc: vc)
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
