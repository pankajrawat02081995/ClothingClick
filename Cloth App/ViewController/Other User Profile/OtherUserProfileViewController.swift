//
//  OtherUserProfileViewController.swift
//  ClothApp
//
//  Created by Apple on 12/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import IBAnimatable
class OtherUserProfileViewController: BaseViewController {
    
    @IBOutlet weak var postFollowerStack: UIStackView!
    @IBOutlet weak var fbView: AnimatableView!
    @IBOutlet weak var instaView: AnimatableView!
    @IBOutlet weak var lblSellingitle: UILabel!
    @IBOutlet weak var privateAccountView: AnimatableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNameLater: UILabel!
    @IBOutlet weak var viewAcceptedRejected: UIView!
    @IBOutlet weak var lblRequesetUserName: UILabel!
    @IBOutlet weak var btnAccepted: UIButton!
    @IBOutlet weak var btnRejected: UIButton!
    @IBOutlet weak var constHeightForviewAcceptedRejected: NSLayoutConstraint!
    
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblPostsCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var txtUsrDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var btnFollow: CustomButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtUsrDetails: UITextView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblFloatRatingCount: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var constHeightlbllocation: NSLayoutConstraint!
    //    @IBOutlet weak var btnFollowing: UIButton!
    //    @IBOutlet weak var btnFollowers: UIButton!
    
    @IBOutlet weak var CVCategory: UICollectionView!
    @IBOutlet weak var CVCProduct: UICollectionView!
    @IBOutlet weak var constHeightForCVCProduct: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var btnSort: UIButton!
    
    
    var selIndexForCVCategory = 0
    var categoryList = ["Selling","Sold"]
    var loginType = ""
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
        FilterSingleton.share.filter = Filters()
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        self.CVCProduct.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callGetOtherUserDetails(userId: self.userId)
    }
    
    func followButtonSet() {
        if self.otherUserDetailsData?.is_requested == 1 {
            self.btnFollow.setTitleColor(.customWhite, for: .normal)
            self.btnFollow.setTitle("Requested", for: .normal)
            self.btnFollow.borderWidth = 1
            self.btnFollow.borderColor = .customBlack
            self.btnFollow.backgroundColor = .customBlack
        }else {
            if self.otherUserDetailsData?.is_following == 0 ||  appDelegate.userDetails == nil {
                self.btnFollow.setTitleColor(.customBlack, for: .normal)
                self.btnFollow.setTitle("Follow", for: .normal)
                self.btnFollow.borderWidth = 1
                self.btnFollow.borderColor = .customBlack
                self.btnFollow.backgroundColor = UIColor.customWhite
            }
            else{
                self.btnFollow.setTitleColor(.customWhite, for: .normal)
                self.btnFollow.setTitle("Following", for: .normal)
                self.btnFollow.borderWidth = 1
                self.btnFollow.borderColor = .customBlack
                self.btnFollow.backgroundColor = .customBlack
            }
        }
    }
    
    @IBAction func instaOnTap(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        openInstagramProfile(username: self.otherUserDetailsData?.instagram_id ?? "")
    }
    
    @IBAction func fbOnTap(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        openFacebookProfile(facebookID: self.otherUserDetailsData?.facebook_id ?? "")
    }
    
    @IBAction func btnAccepted_Clicked(sender: AnyObject) {
        self.callFollowRequstAcceptOrReject(followRequestId: String(self.otherUserDetailsData?.follow_request_id ?? 0), status: "1")
    }
    @IBAction func btnRejected_Clicked(sender: AnyObject) {
        self.callFollowRequstAcceptOrReject(followRequestId: String(self.otherUserDetailsData?.follow_request_id ?? 0), status: "0")
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnShort_Clicked(_ button: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let vc = FilterProductVC.instantiate(fromStoryboard: .Dashboard)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.callBack = {
            self.currentPage = 1
            self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
        }
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnMenu_Clicked(_ button: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let popVC = CustomMenuViewController.instantiate(fromStoryboard: .Main)
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
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let viewController = FollowFollwingViewController.instantiate(fromStoryboard: .Main)
        viewController.selectedTab = "Following"
        viewController.userId = self.userId
        viewController.userName = self.otherUserDetailsData?.username ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
        //        let viewController = OtherFollowFollwingViewController.instantiate(fromStoryboard: .Main)
        //        viewController.selectedTab = "Following"
        //        viewController.userId = self.userId
        //        viewController.userName = self.otherUserDetailsData?.username ?? ""
        //        viewController.followingCount =  self.lblFollowingCount.text ?? ""
        //        viewController.followesrCount = self.lblFollowerCount.text ?? ""
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func shareOnPress(_ sender: UIButton) {
//        if appDelegate.userDetails == nil {
//            self.showLogIn()
//            return
//        }
        self.share(userName: self.lblUserName.text ?? "")
    }
    
    @IBAction func btnFollowear_Clicked(_ button: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let viewController = FollowFollwingViewController.instantiate(fromStoryboard: .Main)
        viewController.selectedTab = "Followear"
        viewController.userId = self.userId
        viewController.userName = self.otherUserDetailsData?.username ?? ""
        self.navigationController?.pushViewController(viewController, animated: true)
        //        let viewController = OtherFollowFollwingViewController.instantiate(fromStoryboard: .Main)
        //        viewController.selectedTab = "Follower"
        //        viewController.userId = self.userId
        //        viewController.userName = self.otherUserDetailsData?.username ?? ""
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnFollow_Clicked(_ button: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let object = self.otherUserDetailsData
        if object?.is_following == 0 && object?.is_requested == 0  {
            self.callFollow(userId: String(object?.id ?? 0))
        }
        else if object?.is_following == 0 && object?.is_requested == 1 {
            self.callUnFollow(userId: String(object?.id ?? 0))
        }
        else{
            self.callUnFollow(userId: String(object?.id ?? 0))
        }
    }
    
    @IBAction func btnFloatReting_Clicked(_ button: UIButton) {
        let viewController = RatingListViewController.instantiate(fromStoryboard: .Main)
        viewController.userId = String(self.otherUserDetailsData?.id ?? 0)
        viewController.userName = self.otherUserDetailsData?.username ?? ""
        self.pushViewController(vc: viewController)
    }
    
    func setData() {
        
        if let userName = self.otherUserDetailsData?.username {
            self.lblHeaderTitle.text = userName
        }
        if let isprivate = self.otherUserDetailsData?.is_private, let isFollowing =  self.otherUserDetailsData?.is_following{
            if isprivate == 1 && isFollowing == 0{
                self.postFollowerStack.isUserInteractionEnabled = false
                self.privateAccountView.isHidden = false
                self.privateAccountView.isUserInteractionEnabled = false
                self.scrollView.isUserInteractionEnabled = true
            }else{
                self.postFollowerStack.isUserInteractionEnabled = true
                self.privateAccountView.isHidden = true
                self.privateAccountView.isUserInteractionEnabled = true
                self.scrollView.isUserInteractionEnabled = true
            }
        }
        
        if let url = self.otherUserDetailsData?.photo {
            self.lblNameLater.isHidden = true
            if let image = URL.init(string: url){
                self.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
            }else{
                self.imgUser.backgroundColor = .black
                self.lblNameLater.text = self.otherUserDetailsData?.name?.first?.description ?? ""
            }
        }else{
            self.imgUser.backgroundColor = .black
            self.lblNameLater.isHidden = false
            self.lblNameLater.text = self.otherUserDetailsData?.name?.first?.description ?? ""
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
        if let name = self.otherUserDetailsData?.name {
            self.lblName.text = name
        }
        if let name = self.otherUserDetailsData?.username {
            self.lblUserName.text = "@\(name)"
        }
        if let review = self.otherUserDetailsData?.total_reviews {
            self.lblFloatRatingCount.text = "\(review)"
        }
        //        if let address = self.otherUserDetailsData?.locations?[0].address{
        //            self.lblLocation.text = address
        //        }
        //        if let address = self.otherUserDetailsData?.locations?[0].city{
        //            self.lblLocation.text = address
        //        }
        
        if let usserDetails = self.otherUserDetailsData?.bio {
            self.txtUsrDetails.text = usserDetails
            txtUsrDetailsHeight.priority = usserDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? UILayoutPriority(1000) : UILayoutPriority(250)
            
        }
        if let ratingCount = self.otherUserDetailsData?.avg_rating{
            // self.lblFloatRatingCount.text = "\(ratingCount)"
            self.lblFloatRatingCount.text = "\(Double(ratingCount)) (\(self.otherUserDetailsData?.total_reviews ?? 0) Reviews)"
        }
        
        if self.otherUserDetailsData?.is_sent_follow_request ?? false {
            self.constHeightForviewAcceptedRejected.constant = self.viewAcceptedRejected.frame.height + 10
            self.viewAcceptedRejected.isHidden = true
            self.lblRequesetUserName.text = "\(self.requesetUserName) wants to follow tou"
        }
        else {
            self.viewAcceptedRejected.isHidden = false
            self.constHeightForviewAcceptedRejected.constant = -self.viewAcceptedRejected.frame.height
        }
        if self.otherUserDetailsData?.is_requested == 1 {
            self.btnFollow.setTitleColor(.customWhite, for: .normal)
            self.btnFollow.setTitle("Requested", for: .normal)
            self.btnFollow.borderWidth = 1
            self.btnFollow.borderColor = .customBlack
            self.btnFollow.backgroundColor = .customBlack
        }
        else {
            if self.otherUserDetailsData?.is_following == 0 {
                self.btnFollow.setTitleColor(.customBlack, for: .normal)
                self.btnFollow.setTitle("Follow", for: .normal)
                self.btnFollow.borderWidth = 1
                self.btnFollow.borderColor = .customBlack
                self.btnFollow.backgroundColor = UIColor.customWhite
            }
            else{
                self.btnFollow.setTitleColor(.white, for: .normal)
                self.btnFollow.setTitle("Following", for: .normal)
                self.btnFollow.borderWidth = 1
                self.btnFollow.borderColor = .customBlack
                self.btnFollow.backgroundColor = .customBlack
            }
        }
    }
}


extension OtherUserProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource {
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
                cell.lblcategory.text = objet?.name
                cell.lblcategory.textColor = UIColor.customBlack
                cell.viewLine.isHidden = false
                cell.viewLine.backgroundColor = UIColor.customBlack
                cell.lblcategory.font = .RobotoFont(.robotoBold, size: 14)
            }
            else{
                cell.lblcategory.textColor = UIColor.customBlack
                cell.viewLine.isHidden = false
                cell.viewLine.backgroundColor = UIColor.customBorderColor
                cell.lblcategory.text = objet?.name
                cell.lblcategory.font = .RobotoFont(.robotoRegular, size: 14)
            }
            return cell
        }
        else{
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
            //            let objet = self.posts[indexPath.item]
            //            cell.lblSale.backgroundColor = .red
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            //                cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
            //            }
            //            cell.lblSelePrice.isHidden = objet.isLblSaleHidden()
            //            cell.lblSale.isHidden = objet.isLblSaleHidden()
            //            cell.viewSale.isHidden = objet.isViewSaleHidden()
            //      //      cell.imgPromteTopPick.isHidden = objet.isTopPickHidden()
            //            if let color = objet.getBackgroundColor() {
            //                self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
            //                cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
            //            }
            //            if let strDate = objet.created_at{
            //                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
            //                cell.lblDayAgo.text = Date().offset(from: date)
            //            }
            //            if let url = objet.image?[0].image {
            //                if let image = URL.init(string: url){
            //                    cell.imgBrand.kf.setImage(with: image,placeholder: PlaceHolderImage)
            //                }
            //            }
            //            if let brsnd = objet.brand_name {
            //                cell.lblBrand.text = brsnd
            //            }
            //            if let title = objet.title {
            //                cell.lblModelItem.text = title
            //            }
            //            if let size = objet.size_name {
            //                cell.lblSize.text = size
            //            }
            //            if let is_favourite = objet.is_favourite {
            //                cell.btnWatch.isSelected = is_favourite
            //            }
            //            if let producttype = objet.price_type{
            //                if producttype == "1"{
            //            if let price = objet.price {
            //                if !(objet.isLblSaleHidden()) {
            //
            //                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price)")
            //                    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            //                    cell.lblSelePrice.attributedText = attributeString
            //                    cell.constLeadingForlblPrice.constant = 2
            //                    if let salePrice = objet.sale_price {
            //                        cell.lblPrice.text = "$ \(salePrice)"
            //                    }
            //                }
            //                else {
            //                    cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
            //                    cell.lblPrice.text = "$ \(price)"
            //                }
            //            }
            //                }else{
            //                    cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
            //                    if let producttype = objet.price_type_name{
            //                        cell.lblPrice.text = producttype
            //                    }
            //                }
            //            }
            //            cell.btnWatch.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
            //
            //            return cell
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
            let objet = self.posts[indexPath.item]
            if let url = objet.image?.first?.image {
                if let image = URL.init(string: url){
                    cell.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
                }
            }
            
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
                        cell.lblPrice.text = "\(producttype)"
                    }
                }
            }
            return cell
        }
        
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVCProduct)
        if let indexPath = self.CVCProduct.indexPathForItem(at: poston) {
            let cell = self.CVCProduct.cellForItem(at: indexPath) as! HomePageBrowserXIB
            if (self.posts[indexPath.item].isItemSold() ?? false){
                UIAlertController().alertViewWithTitleAndMessage(self, message: "This item is sold")
            }
            else {
                if cell.btnLike.isSelected {
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
            if indexPath.item == 0{
                self.lblSellingitle.text = "All Selling"
            }else{
                self.lblSellingitle.text = "All Sold"
            }
            self.selIndexForCVCategory = indexPath.item
            self.tabId = String(self.otherUserDetailsData?.tabs?[indexPath.item].type ?? 0)
            self.currentPage = 1
            self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
            //            self.CVCategory.reloadData()
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
            self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
        }
    }
    
}

extension OtherUserProfileViewController: LikeDelegate{
    func Like(like: Bool, indexpath: IndexPath) {
        self.posts[indexpath.item].is_favourite = like
        self.CVCProduct.reloadItems(at: [indexpath])
    }
    
    
}

extension OtherUserProfileViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    //
    //      fileprivate var itemsPerRow: CGFloat {
    //          return 2
    //      }
    //
    //      fileprivate var interitemSpace: CGFloat {
    //            return 0.0
    //      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.CVCategory {
            return CGSize(width: collectionView.bounds.width / 2, height: 50)
        }
        else {
            //            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            //            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            //            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            //            let widthPerItem = availableWidth / itemsPerRow
            //            return CGSize(width: widthPerItem, height: 300)
            return CGSize(width: (self.CVCProduct.frame.size.width / 2) - 20, height: 230)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    //
    //    func collectionView(_ collectionView: UICollectionView,
    //                        layout collectionViewLayout: UICollectionViewLayout,
    //                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return interitemSpace
    //    }
    //
    //    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return interitemSpace
    //    }
}

extension OtherUserProfileViewController : FloatRatingViewDelegate{
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
    }
}
extension OtherUserProfileViewController {
    
    func callGetOtherUserDetails(userId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["user_id":  userId ]
            
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                            if let tabs = self.otherUserDetailsData?.tabs{
                                self.tabs = tabs
                            }
                            self.CVCategory.reloadData()
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
            
//            let param = ["user_id":  userId,
//                         "tab" : tabId,
//                         "sort_by" : sort_by,
//                         "sort_value" : sort_value,
//                         "page" : "\(self.currentPage)" ]
            
            var param = FilterSingleton.share.filter.toDictionary()
            param?.removeValue(forKey: "is_only_count")
            param?.removeValue(forKey: "page")
            param?.removeValue(forKey: "sort_by")
            param?.removeValue(forKey: "sort_value")
            param?.removeValue(forKey: "notification_item_counter")
            param?["page"] = "\(self.currentPage)"
            param?["user_id"] = userId
            param?["tab"] = tabId
            param?.removeValue(forKey: "slectedCategories")
            
            APIManager().apiCall(of:HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.USER_POSTS.rawValue, method: .post, parameters: param) { (response, error) in
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
                                self.lblNoData.isHidden = false
                                
                                if sort_by == "size"{
                                    //                                    self.btnSort.isHidden = true
                                }
                                self.CVCProduct.reloadData()
                                self.CVCProduct.layoutIfNeeded()
                                self.constHeightForCVCProduct.constant = self.CVCProduct.contentSize.height
                            }else{
                                self.lblNoData.isHidden = true
                                //                                self.btnSort.isHidden = false
                                self.CVCProduct.reloadData()
                                self.CVCProduct.layoutIfNeeded()
                                self.constHeightForCVCProduct.constant = self.CVCProduct.contentSize.height
                            }
                            self.CVCategory.reloadData()
                        }
                    }
                }
                else {
                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
                }
            }
        }else {
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
                    self.constHeightForviewAcceptedRejected.constant = 0
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
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                        }
                        self.followButtonSet()
                        
                    }
                } else {
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
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                        }
                        
                        self.followButtonSet()
                        self.callGetOtherUserDetails(userId: self.userId)

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
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
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

extension OtherUserProfileViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
extension OtherUserProfileViewController : ShortByDelegate{
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        self.currentPage = 1
        self.callGetOtherUserpost(userId: self.userId, tabId: self.tabId,sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
    }
}

extension OtherUserProfileViewController: CustomMenuDelegate {
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
