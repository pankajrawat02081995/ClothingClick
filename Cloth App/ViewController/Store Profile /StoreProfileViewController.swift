//
//  StoreProfileViewController.swift
//  ClothApp
//
//  Created by Apple on 12/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class StoreProfileViewController: BaseViewController {
    
    @IBOutlet weak var viewAcceptedRejected: UIView!
    @IBOutlet weak var viewUserDeatils: UIView!
    @IBOutlet weak var lblRequesetUserName: UILabel!
    @IBOutlet weak var btnAccepted: UIButton!
    @IBOutlet weak var btnRejected: UIButton!
    @IBOutlet weak var constHeightForviewAcceptedRejected: NSLayoutConstraint!
    @IBOutlet weak var constTopForviewAcceptedRejected: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblNoDeta: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblPostsCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var btnFollow: CustomButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnMessges: CustomButton!
    @IBOutlet weak var btnContact: CustomButton!
    @IBOutlet weak var txtUsrDetails: UITextView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnFollowear: UIButton!
    @IBOutlet weak var btnFollowing: UIButton!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnStore: CustomButton!
    @IBOutlet weak var btnWebsite: UIButton!
    
    @IBOutlet weak var CVCategory: UICollectionView!
    @IBOutlet weak var CVCProduct: UICollectionView!
    @IBOutlet weak var ConstTopForeCVProduct: NSLayoutConstraint!
    @IBOutlet weak var constHeightForCVCProduct: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var btnSort: UIButton!
    
    var selIndexForCVCategory = 0
    var categoryList = ["men","Women"]
    var gender = ["single gender","gender"]
    var loginType = ""
    var haderTitle = ""
    var userId = ""
    var otherUserDetailsData : UserDetailsModel?
    var tabs = [Tabs?]()
    var tabId = ""
    var posts = [Posts]()
    var sort_by = "date"
    var sort_value = "desc"
    var currentPage = 1
    var hasMorePages = false
    var isFollow = false
    var requesetUserName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewAcceptedRejected.isHidden = true
        self.btnAccepted.isHidden = true
        self.btnRejected.isHidden = true
        self.constTopForviewAcceptedRejected.constant = -self.viewAcceptedRejected.frame.height
        self.btnMessges.isHidden = true
        self.lblNoDeta.isHidden = true
        self.lblTitle.text = "\(self.haderTitle) Name"
        self.callGetOtherUserDetails(userId: self.userId)
        
        
    }
    
    func setFollowUserButtonRequested() {
        if self.otherUserDetailsData?.is_sent_follow_request ?? false {
            
            self.viewAcceptedRejected.isHidden = false
            self.btnAccepted.isHidden = false
            self.btnRejected.isHidden = false
            //            self.constHeightForviewAcceptedRejected.constant = 50
            self.constTopForviewAcceptedRejected.constant = self.viewAcceptedRejected.frame.height
            self.lblRequesetUserName.text = "\(self.requesetUserName) wants to follow tou"
        }
        else {
            self.viewAcceptedRejected.isHidden = true
            self.btnAccepted.isHidden = true
            self.btnRejected.isHidden = true
            self.constTopForviewAcceptedRejected.constant = -self.viewAcceptedRejected.frame.height
        }
        if let isrequested = self.otherUserDetailsData?.is_requested {
            if isrequested == 1 {
                self.btnFollow.setTitleColor(.black, for: .normal)
                self.btnFollow.setTitle("Requested", for: .normal)
                self.btnFollow.borderWidth = 1
                self.btnFollow.borderColor = .black
                self.btnFollow.backgroundColor = .white
            }
            else {
                if let isfollowing = self.otherUserDetailsData?.is_following {
                    if isfollowing == 0 {
                        self.btnFollow.setTitleColor(.white, for: .normal)
                        self.btnFollow.setTitle("Follow", for: .normal)
                        self.btnFollow.borderWidth = 0
                        self.btnFollow.backgroundColor = UIColor.init(named: "BlueColor")
                    }
                    else{
                        self.btnFollow.setTitleColor(.black, for: .normal)
                        self.btnFollow.setTitle("Following", for: .normal)
                        self.btnFollow.borderWidth = 1
                        self.btnFollow.borderColor = .black
                        self.btnFollow.backgroundColor = .white
                    }
                }
            }
        }
    }
    
    @IBAction func btnWebsite_Clicked(sender: AnyObject) {
        if let websit = self.otherUserDetailsData?.website {
            self.openSafariViewController(strUrl: websit)
        }
    }
    
    @IBAction func btnAccepted_Clicked(sender: AnyObject) {
        self.callFollowRequstAcceptOrReject(followRequestId: String(userId), status: "1")
        
    }
    @IBAction func btnRejected_Clicked(sender: AnyObject) {
        self.callFollowRequstAcceptOrReject(followRequestId: String(userId), status: "0")
        
    }
    
    @IBAction func btnMenu_Clicked(_ button: UIButton) {
        guard let popVC = self.storyBoard.instantiateViewController(withIdentifier: "CustomMenuViewController") as? CustomMenuViewController else { return }
        popVC.delegate = self
        popVC.modalPresentationStyle = .popover
        popVC.userId = String(self.otherUserDetailsData?.id ?? 0)
        popVC.menuList = [FEED_MORE_MENU.BLOCK.rawValue,FEED_MORE_MENU.REPORT.rawValue]
        popVC.popoverPresentationController?.dimmingView?.backgroundColor = UIColor(hex: "ECE8E5").withAlphaComponent(0.27)
        popVC.preferredContentSize = CGSize(width: Int(VERTICALMENU_SIZE.WIDTH.rawValue), height: Int(VERTICALMENU_SIZE.HEIGHT.rawValue) * popVC.menuList.count)
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = button
        popOverVC?.sourceRect = button.bounds
        popOverVC?.permittedArrowDirections = .up
        self.present(popVC, animated: true)
        
    }
    
    @IBAction func btnFollowing_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "OtherFollowFollwingViewController") as! OtherFollowFollwingViewController
        viewController.selectedTab = "Following"
        viewController.userId = self.userId
        viewController.userName = self.otherUserDetailsData?.username ?? ""
        viewController.followingCount =  self.lblFollowingCount.text!
        viewController.followesrCount = self.lblFollowerCount.text!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnFollowear_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "OtherFollowFollwingViewController") as! OtherFollowFollwingViewController
        viewController.selectedTab = "Followear"
        viewController.userId = self.userId
        viewController.userName = self.otherUserDetailsData?.username ?? ""
        viewController.followingCount =  self.lblFollowingCount.text!
        viewController.followesrCount = self.lblFollowerCount.text!
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnContact_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "ContactDisplayViewController") as! ContactDisplayViewController
        viewController.phoneNo = String((self.otherUserDetailsData?.phone) ?? "")
        viewController.email = String(self.otherUserDetailsData?.email ?? "")
        viewController.isEmailShow = self.otherUserDetailsData?.isEmailShow() ?? false
        viewController.isPhoneShow = self.otherUserDetailsData?.isPhoneShow() ?? false
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnShort_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "ShortByViewController") as! ShortByViewController
        viewController.sort_by = self.sort_by
        viewController.sort_value = self.sort_value
        viewController.shortByDeleget = self
     //   viewController.isUser = true
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnFollow_Clicked(_ button: UIButton) {
        let object = self.otherUserDetailsData
        if object?.is_following == 0 {
            //            self.btnFollow.setTitleColor(.white, for: .normal)
            //            self.btnFollow.setTitle("Follow", for: .normal)
            //            self.btnFollow.borderWidth = 0
            //            self.btnFollow.backgroundColor = UIColor.init(named: "BlueColor")
            self.callFollow(userId: String(object?.id ?? 0))
        }
        else{
            //            self.btnFollow.setTitleColor(.black, for: .normal)
            //            self.btnFollow.setTitle("Following", for: .normal)
            //            self.btnFollow.borderWidth = 1
            //            self.btnFollow.borderColor = .black
            //            self.btnFollow.backgroundColor = .white
            self.callUnFollow(userId: String(object?.id ?? 0))
        }
    }
    
    func setData() {
        if self.otherUserDetailsData?.isEmailShow() ?? false || self.otherUserDetailsData?.isPhoneShow() ?? false{
            self.btnContact.isHidden = false
        }
        else {
            self.btnContact.isHidden = true
        }
        if let title = self.otherUserDetailsData?.username {
            self.lblTitle.text = title
        }
        if let url = self.otherUserDetailsData?.photo {
            self.imgUser.setImageFast(with: url)
        }
        if let postCount = self.otherUserDetailsData?.totalPosts {
            self.lblPostsCount.text = "\(postCount)"
        }
        if let followerCount = self.otherUserDetailsData?.totalFollowers {
            self.lblFollowerCount.text = "\(followerCount)"
        }
        if let followingCount = self.otherUserDetailsData?.totalFollowings {
            self.lblFollowingCount.text = "\(followingCount)"
        }
        if let name = self.otherUserDetailsData?.username {
            self.lblName.text = name
        }
        if let websit = self.otherUserDetailsData?.website {
            self.btnWebsite.setTitle(websit, for: .normal)
        }
        if let usserDetails = self.otherUserDetailsData?.bio {
            self.txtUsrDetails.text = usserDetails
        }
        if let address = self.otherUserDetailsData?.name{
            self.lblLocation.text = address
        }
    }
}

extension StoreProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == CVCategory {
            return self.tabs.count
        }
        else {
            return self.posts.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == CVCategory {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            let objet = self.tabs[indexPath.item]
            if self.selIndexForCVCategory == indexPath.item {
                cell.lblcategory.textColor = UIColor.black
                cell.viewLine.isHidden = false
                cell.lblcategory.text = objet?.name
            }
            else{
                cell.lblcategory.textColor = UIColor.init(named: "DarkGrayColor")
                cell.lblcategory.text = objet?.name
                cell.viewLine.isHidden = true
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
            let objet = self.posts[indexPath.item]
            cell.lblSale.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
            }
            cell.lblSelePrice.isHidden = objet.isLblSaleHidden()
            cell.lblSale.isHidden = objet.isLblSaleHidden()
            cell.viewSale.isHidden = objet.isViewSaleHidden()
          //  cell.imgPromteTopPick.isHidden = objet.isTopPickHidden()
            if let color = objet.getBackgroundColor() {
                self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
                cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
            }
            if let strDate = objet.created_at{
                //                let date = self.convertStringToDate(format: "yyyy-MM-dd HH:mm:ss", strDate: strDate)
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblDayAgo.text = Date().offset(from: date)
            }
            if let url = objet.image?[0].image {
                cell.imgBrand.setImageFast(with: url)
            }
            if let brsnd = objet.brand_name {
                cell.lblBrand.text = brsnd
            }
            if let title = objet.title {
                cell.lblModelItem.text = title
            }
            if let size = objet.size_name {
                cell.lblSize.text = size
            }
            if let is_favourite = objet.is_favourite {
                cell.btnWatch.isSelected = is_favourite
            }
            if let price = objet.price {
                if !(objet.isLblSaleHidden()) {
                    if let salePrice = objet.sale_price {
                        cell.lblPrice.text = "$ \(salePrice)"
                    }
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price.formatPrice())")
                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                    cell.lblSelePrice.attributedText = attributeString
                    cell.constLeadingForlblPrice.constant = 2
                    cell.lblPrice.text = "$ \(price.formatPrice())"
                }
                else {
                    cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                    cell.lblPrice.text = "$ \(price.formatPrice())"
                }
            }
            cell.btnWatch.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVCProduct)
        if let indexPath = self.CVCProduct.indexPathForItem(at: poston) {
            let cell = self.CVCProduct.cellForItem(at: indexPath) as! HomeCVCell
            if (self.posts[indexPath.item].isItemSold() ?? false){
                UIAlertController().alertViewWithTitleAndMessage(self, message: "This item is sold")
            }
            else {
                if cell.btnWatch.isSelected {
                    if  let postId = self.posts[indexPath.item].id {
                        self.callPostFavourite(action_type: "0", postId: String(postId) , index: indexPath.item)
                    }
                }
                else {
                    if  let postId = self.posts[indexPath.item].id {
                        self.callPostFavourite(action_type: "1", postId: String(postId) , index: indexPath.item)
                    }
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.CVCategory {
            self.selIndexForCVCategory = indexPath.item
            self.tabId = String(self.otherUserDetailsData?.tabs?[indexPath.item].type ?? 0)
            self.currentPage = 1
            self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
            self.CVCategory.reloadData()
        }
        else {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//            viewController.postId = String(self.posts[indexPath.item].id ?? 0)
//            viewController.indexpath = indexPath
//            viewController.likeDeleget = self
//            self.navigationController?.pushViewController(viewController, animated: true)
            let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            vc.postId = String(self.posts[indexPath.item].id ?? 0)
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc: vc)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.posts.count - 1 && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: false)
        }
    }
}
extension StoreProfileViewController: LikeDelegate{
    func Like(like: Bool, indexpath: IndexPath) {
        self.posts[indexpath.item].is_favourite = like
        self.CVCProduct.reloadItems(at: [indexpath])
    }
    
    
}
extension StoreProfileViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.CVCategory {
            return CGSize(width: collectionView.bounds.width / 2, height: 50)
        }
        else {
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 300)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
}

extension StoreProfileViewController {
    func callGetOtherUserDetails(userId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["user_id":  userId
            ]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                            if let tabs = self.otherUserDetailsData?.tabs{
                                self.tabs = tabs
                            }
                            self.CVCategory.reloadData()
                            self.setFollowUserButtonRequested()
                            self.currentPage = 1
                            self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
                            self.setData()
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
    
    func callGetOtherUserpost(userId : String,tabId : String,sort_by:String , sort_value : String ,isShowHud:Bool) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["user_id":  userId,
                         "tab" : tabId,
                         "sort_by" : sort_by,
                         "sort_value" : sort_value,
                         "page" : "\(self.currentPage)"
            ]
            APIManager().apiCall(of:HomeListDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_POSTS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.posts.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            if let post = data.posts {
                                for temp in post {
                                    self.posts.append(temp)
                                }
                            }
                            if self.posts.count == 0 {
                                self.lblNoDeta.isHidden = false
                                if sort_by == "size"{
                                    self.btnSort.isHidden = true
                                }
                                self.CVCProduct.reloadData()
                                self.CVCProduct.layoutIfNeeded()
                                self.constHeightForCVCProduct.constant = self.CVCProduct.contentSize.height
                            }
                            else
                            {
                                self.lblNoDeta.isHidden = true
                                self.btnSort.isHidden = false
                                self.CVCProduct.reloadData()
                                self.CVCProduct.layoutIfNeeded()
                                self.constHeightForCVCProduct.constant = self.CVCProduct.contentSize.height
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
    
    func callFollowRequstAcceptOrReject(followRequestId : String,status: String) {
        if appDelegate.reachable.connection != .none {
            let param = ["follow_request_id" : followRequestId,
                         "status":status
            ]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOW_REQUESTS_STATUS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.viewAcceptedRejected.isHidden = true
                    self.btnAccepted.isHidden = true
                    self.btnRejected.isHidden = true
                    self.constHeightForviewAcceptedRejected.constant = 0
                    self.constTopForviewAcceptedRejected.constant = -self.viewAcceptedRejected.frame.height
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
    
    func callFollow(userId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.otherUserDetailsData = userDetails
                        }
                        self.setFollowUserButtonRequested()
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
    
    func callUnFollow(userId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.UNFOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.otherUserDetailsData = userDetails
                        }
                        self.setFollowUserButtonRequested()
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
    func callPostFavourite(action_type : String,postId : String,index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.posts[index].is_favourite = true
                        self.CVCProduct.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                    }
                    else {
                        self.posts[index].is_favourite = false
                        self.CVCProduct.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                    }
                    //                    self.CVCProduct.reloadData()
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
}
extension StoreProfileViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension StoreProfileViewController : ShortByDelegate{
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        self.currentPage = 1
        self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
    }
}
extension StoreProfileViewController: CustomMenuDelegate {
    func dismissCustomMenu() {
//        let viewController = self.storyboard?.instantiateViewController(identifier: "SuggestionReportViewController") as! SuggestionReportViewController
//        viewController.headerTitle = "Report user"
//        viewController.subTitle = "Why are you reporting this user?"
//        viewController.userId = self.userId
//        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = SupportFeedbackVC.instantiate(fromStoryboard: .Setting)
        vc.isReport = true
        vc.userId = self.userId
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
}
