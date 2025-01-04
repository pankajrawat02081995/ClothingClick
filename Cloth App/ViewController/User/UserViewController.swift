//
//  UserViewController.swift
//  ClothApp
//
//  Created by Apple on 07/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import ObjectMapper
import IBAnimatable

class UserViewController: BaseViewController {

    @IBOutlet weak var fbView: AnimatableView!
    @IBOutlet weak var instaView: AnimatableView!
    @IBOutlet weak var lblDataTitle: UILabel!
    @IBOutlet weak var lblrate: UILabel!
    @IBOutlet weak var lblNameLatter: UILabel!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var lblCurrencyCount: UILabel!
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var btnByCoin: UIButton!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblPostsCount: UILabel!
    @IBOutlet weak var lblFollowerCount: UILabel!
    @IBOutlet weak var btnFollowear: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var btnFollowing: UIButton!
    @IBOutlet weak var btnEditProfile: CustomButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAtJoindYear: UILabel!
    @IBOutlet weak var txtUsrDetails: UITextView!
    @IBOutlet weak var txtUserDetailsHeight: NSLayoutConstraint!
    @IBOutlet weak var viewStoreBrand: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var btnlocationDetails: UIButton!
    @IBOutlet weak var hightConstraintView: NSLayoutConstraint!
    @IBOutlet weak var btnStoreAndBrand: CustomButton!
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var btnFloatReting: UIButton!
    @IBOutlet weak var viewFloatRating: FloatRatingView!
    @IBOutlet weak var lblFloatRatingCount: UILabel!
    @IBOutlet weak var CVCategory: UICollectionView!
    @IBOutlet weak var CVCProduct: UICollectionView!
    @IBOutlet weak var constHeightForCVCProduct: NSLayoutConstraint!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var heightView : NSLayoutConstraint!
    @IBOutlet weak var Headerview: UIView!
    var selIndexForCVCategory = 0
    var userData : UserDetailsModel?
    var followingsList : FollowingsFollowearsModel?
    var categoryList = ["men","Women"]
    var tabs = [Tabs]()
    var posts = [Posts]()
    var loginType = ""
    var currentPage = 1
    var hasMorePages = false
    var sort_by = "date"
    var sort_value = "desc"
    var lastContentOffset: CGFloat = 0
    var  loading = false
    var headerViewMaxHeight : CGFloat = 293
    let headerViewMinHeight : CGFloat = 50
    let customTransitioningDelegate = CustomTransitioningDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        FilterSingleton.share.filter = Filters()
        
        self.lblNoData.isHidden = true
        self.scrollView.setContentOffset(.zero, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh(_:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isHidden = true
        self.getUserDetails()
    }
    
    func setupCollectionView(){
        self.CVCProduct.delegate = self
        self.CVCProduct.dataSource = self
        self.CVCProduct.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        self.CVCProduct.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    @IBAction func fbOntap(_ sender: UIButton) {
        openFacebookProfile(facebookID: userData?.facebook_id ?? "")
    }
    
    @IBAction func instaOntap(_ sender: UIButton) {
        openInstagramProfile(username: userData?.instagram_id ?? "")
    }
    
    @IBAction func btnWebsite_Clicked(sender: AnyObject) {
        if let website = userData?.website {
            self.openSafariViewController(strUrl: website)
        }
    }
    
    @IBAction func btnFloatReting_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "RatingListViewController") as! RatingListViewController
        viewController.userId = String(self.userData?.id ?? 0)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnByCoin_Clicked(_ sender: Any) {
        let ViewController = storyboard?.instantiateViewController(identifier: "ClickCoinsViewController") as! ClickCoinsViewController
        ViewController.userCoin = "\(self.userData?.coins ?? 0)"
        ViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    func setdata () {
        if let followerCoubt = self.followingsList?.totalFollowers{
            self.lblFollowerCount.text = String(followerCoubt)
        }
        if let followingCount = self.followingsList?.totalFollowings {
            self.lblFollowingCount.text = String(followingCount)
        }
    }
    @IBAction func btnlocationDetails_Clicked(_ sender: AnyObject) {
        let ViewController = storyboard?.instantiateViewController(identifier: "UserLocationSetDefaultViewController") as! UserLocationSetDefaultViewController
        ViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVCProduct)
        if let indexPath = self.CVCProduct.indexPathForItem(at: poston) {
            let cell = self.CVCProduct.cellForItem(at: indexPath) as! HomePageBrowserXIB
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
    func setUserDetails () {
        if appDelegate.userDetails?.role_id == 2{
            self.tabs = (userData?.tabs)!
            self.hightConstraintView.constant = 86
            self.btnStoreAndBrand.isHidden = false
            self.btnStoreAndBrand.setTitle("Store", for: .normal)
            self.btnWebsite.isHidden = false
            if let website = userData?.website {
                self.btnWebsite.setTitle(website, for: .normal)
            }
            if let username = userData?.username {
                self.lblUserName.text = "@\(username)"
            }
            self.lblLocation.isHidden = false
            if let name = userData?.name {
                self.lblName.text = "\(name.capitalized)"
            }
            self.btnlocationDetails.isHidden = false
            self.viewFloatRating.isHidden = true
            self.lblFloatRatingCount.isHidden = true
            self.lblAtJoindYear.isHidden = true
            self.btnFloatReting.isHidden = true
        }
        else if appDelegate.userDetails?.role_id == 1{//user
            self.tabs = (userData?.tabs)!
            self.hightConstraintView.constant = 31
            self.lblAtJoindYear.isHidden = false
            let getdata = self.convertStringToDate(format: dateFormateForGet, strDate: String((userData?.created_at)!))
            self.lblAtJoindYear.text = "Joined in \(self.convertDateToString(format: "yyyy", date: getdata))"
            self.lblLocation.isHidden = false
            self.btnlocationDetails.isHidden = false
//            if let location = userData?.locations?[0].city {
//                self.lblLocation.text = location
//            }
            self.btnFloatReting.isHidden = false
            self.viewFloatRating.isHidden = false
            self.lblFloatRatingCount.isHidden = false
            self.lblFloatRatingCount.bringSubviewToFront(view)
            print("\(self.lblFloatRatingCount.frame.height)")
            print("\(self.viewFloatRating.frame.height)")
            
            self.viewFloatRating.contentMode = UIView.ContentMode.scaleAspectFit
            self.viewFloatRating.type = .halfRatings
            self.btnStoreAndBrand.isHidden = true
            self.btnWebsite.isHidden = true
            
            self.lblrate.text = "\(self.userData?.avg_rating ?? 0.0) (\(self.userData?.total_reviews ?? 0) Reviews)"
            
            if let total_reviews = self.userData?.total_reviews{
                
                self.lblFloatRatingCount.text = "\(total_reviews)"
            }
            else {
                self.lblFloatRatingCount.text = "\(0)"
            }
            if let ratingCount = self.userData?.avg_rating{
                self.viewFloatRating.rating = Double(ratingCount)
            
            }
            else {
                self.viewFloatRating.rating = Double(0)
              
            }
            if let username = userData?.username {
                self.lblUserName.text = "@\(username)"
            }
            if let name = userData?.name {
                self.lblName.text = "\(name.capitalized)"
            }
            
            if userData?.facebook_id?.isEmpty == true || userData?.facebook_id == nil{
                self.fbView.isHidden = true
            }else{
                self.fbView.isHidden = false
            }
            
            if userData?.instagram_id?.isEmpty == true || userData?.instagram_id == nil{
                self.instaView.isHidden = true
            }else{
                self.instaView.isHidden = false
            }
            
            if let url = userData?.photo {
                self.lblNameLatter.isHidden = false
                if let image = URL.init(string: url){
                    self.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
                }else{
                    self.imgUser.backgroundColor = .black
                    self.lblNameLatter.text = userData?.name?.first?.description.capitalized ?? ""
                }
            }else{
                self.imgUser.backgroundColor = .black
                self.lblNameLatter.isHidden = false
                self.lblNameLatter.text = userData?.name?.first?.description.capitalized ?? ""
            }
        }
        else  {
            self.tabs = (userData?.tabs)!
            self.btnFloatReting.isHidden = true
            self.hightConstraintView.constant = 86
            self.btnStoreAndBrand.isHidden = false
            self.btnStoreAndBrand.setTitle("Brand", for: .normal)
            self.btnWebsite.isHidden = false
            if let website = userData?.website {
                self.btnWebsite.setTitle(website, for: .normal)
            }
            self.lblLocation.isHidden = false
            self.viewFloatRating.isHidden = true
            self.lblFloatRatingCount.isHidden = true
            self.lblAtJoindYear.isHidden = true
            if let username = userData?.username {
                self.lblUserName.text = "@\(username)"
            }
            if let name = userData?.name {
                self.lblName.text = "\(name.capitalized)"
            }
        }
        if let url = userData?.photo {
            if let image = URL.init(string: url){
                self.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
            }else{
                self.imgUser.backgroundColor = .black
                self.lblNameLatter.text = userData?.name?.first?.description.capitalized ?? ""
            }
        }
        if let coins = userData?.coins {
            self.lblCurrencyCount.text = String(coins)
        }
        
        if let name = userData?.username {
            self.lblUserName.text = "@\(name)"
        }
        if let dic = userData?.bio {
            self.txtUsrDetails.text = dic
            txtUserDetailsHeight.priority = dic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? UILayoutPriority(1000) : UILayoutPriority(250)
        }else{
            self.txtUsrDetails.text = ""
            txtUserDetailsHeight.priority = UILayoutPriority(1000)
        }
        if let post = userData?.totalPosts {
            self.lblPostsCount.text = String(post)
        }
        if let follower = userData?.totalFollowers {
            self.lblFollowerCount.text = String(follower)
        }
        if let following = userData?.totalFollowings {
            self.lblFollowingCount.text = String(following)
        }
//        if let location = userData?.locations {
//            if location.count != 1 {
//                self.lblLocation.text = "Edmonton"
//            }
//            else {
//                self.lblLocation.text = location[0].city
//            }
//            
//        }
//        self.heightView.constant = self.Headerview.bounds.height
        self.callFollowingstDatails()
        self.currentPage = 1
        self.callGetUserpost(userId: String(userData?.id ?? 0), tabId: String(self.tabs[self.selIndexForCVCategory].type ?? 0),sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
    }
    
    @objc func refresh(_ notification: NSNotification) {
        self.userData = appDelegate.userDetails
        
            if appDelegate.userDetails?.role_id == 2{
                self.tabs = (userData?.tabs)!
                self.hightConstraintView.constant = 86
                self.btnStoreAndBrand.isHidden = false
                self.btnStoreAndBrand.setTitle("Store", for: .normal)
                self.btnWebsite.isHidden = false
                if let website = userData?.website {
                    self.btnWebsite.setTitle(website, for: .normal)
                }
                if let username = userData?.username {
                    self.lblUserName.text = "@\(username)"
                }
                self.lblLocation.isHidden = false
                if let name = userData?.name {
                    self.lblName.text = "\(name.capitalized)"
                }
                self.btnlocationDetails.isHidden = false
                self.viewFloatRating.isHidden = true
                self.lblFloatRatingCount.isHidden = true
                self.lblAtJoindYear.isHidden = true
                self.btnFloatReting.isHidden = true
            }
            else if appDelegate.userDetails?.role_id == 1{//user
                self.tabs = (userData?.tabs)!
                self.hightConstraintView.constant = 31
                self.lblAtJoindYear.isHidden = false
                let getdata = self.convertStringToDate(format: dateFormateForGet, strDate: String((userData?.created_at)!))
                self.lblAtJoindYear.text = "Joined in \(self.convertDateToString(format: "yyyy", date: getdata))"
                self.lblLocation.isHidden = false
                self.btnlocationDetails.isHidden = false
    //            if let location = userData?.locations?[0].city {
    //                self.lblLocation.text = location
    //            }
                self.btnFloatReting.isHidden = false
                self.viewFloatRating.isHidden = false
                self.lblFloatRatingCount.isHidden = false
                self.lblFloatRatingCount.bringSubviewToFront(view)
                print("\(self.lblFloatRatingCount.frame.height)")
                print("\(self.viewFloatRating.frame.height)")
                
                self.viewFloatRating.contentMode = UIView.ContentMode.scaleAspectFit
                self.viewFloatRating.type = .halfRatings
                self.btnStoreAndBrand.isHidden = true
                self.btnWebsite.isHidden = true
                if let total_reviews = self.userData?.total_reviews{
                    
                    self.lblFloatRatingCount.text = "\(total_reviews)"
                }
                else {
                    self.lblFloatRatingCount.text = "\(0)"
                }
                if let ratingCount = self.userData?.avg_rating{
                    self.viewFloatRating.rating = Double(ratingCount)
                
                }
                else {
                    self.viewFloatRating.rating = Double(0)
                  
                }
                if let username = userData?.username {
                    self.lblUserName.text = "@\(username)"
                }
                if let name = userData?.name {
                    self.lblName.text = "\(name.capitalized)"
                }
            }
            else  {
                self.tabs = (userData?.tabs)!
                self.btnFloatReting.isHidden = true
                self.hightConstraintView.constant = 86
                self.btnStoreAndBrand.isHidden = false
                self.btnStoreAndBrand.setTitle("Brand", for: .normal)
                self.btnWebsite.isHidden = false
                if let website = userData?.website {
                    self.btnWebsite.setTitle(website, for: .normal)
                }
                self.lblLocation.isHidden = false
                self.viewFloatRating.isHidden = true
                self.lblFloatRatingCount.isHidden = true
                self.lblAtJoindYear.isHidden = true
                if let username = userData?.username {
                    self.lblUserName.text = "@\(username)"
                }
                if let name = userData?.name {
                    self.lblName.text = "\(name.capitalized)"
                }
            }
            if let url = userData?.photo {
                if let image = URL.init(string: url){
                    self.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
                }else{
                    self.imgUser.backgroundColor = .black
                    self.lblNameLatter.text = userData?.name?.first?.description.capitalized ?? ""
                }
            }
            if let coins = userData?.coins {
                self.lblCurrencyCount.text = String(coins)
            }
            
            if let name = userData?.username {
                self.lblUserName.text = "@\(name)"
            }
        if let dic = userData?.bio {
            self.txtUsrDetails.text = dic
            txtUserDetailsHeight.priority = dic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true ? UILayoutPriority(1000) : UILayoutPriority(250)
        }else{
            self.txtUsrDetails.text = ""
            txtUserDetailsHeight.priority = UILayoutPriority(1000)
        }
        
            if let post = userData?.totalPosts {
                self.lblPostsCount.text = String(post)
            }
            if let follower = userData?.totalFollowers {
                self.lblFollowerCount.text = String(follower)
            }
            if let following = userData?.totalFollowings {
                self.lblFollowingCount.text = String(following)
            }
//            self.heightView.constant = self.Headerview.bounds.height
    }
    @IBAction func btnUser_Clicked(_ button: UIButton) {
            if defaults.value(forKey: kLoginUserList) != nil {
                if let arr = defaults.value(forKey: kLoginUserList) as? [[String:Any]], arr.count > 0 {
                    print("USERS = \(arr)")
                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "", preferredStyle: .actionSheet)
                    alert.setAlertButtonColor()
                   
                    for i in 0..<arr.count {
                        let dict = arr[i]
                        
                        let nameAction: UIAlertAction = UIAlertAction.init(title: dict["username"] as? String, style: .default, handler: { (action) in
                            print(dict["username"] as! String)
                            self.saveUserDetails(userDetails: Mapper<UserDetailsModel>().map(JSON: arr[i])!)
                            self.navigateToHomeScreen()
                        })
                        alert.addAction(nameAction)
                    }
                    let cancelAction: UIAlertAction = UIAlertAction.init(title: kCancel, style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    
    @IBAction func btnSetting_Clicked(_ button: UIButton) {
//        let viewController = self.storyboard?.instantiateViewController(identifier: "SettingViewController") as! SettingViewController
//        viewController.loginType = self.loginType
//        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = SettingVC.instantiate(fromStoryboard: .Setting)
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    @IBAction func btnFollowing_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "FollowFollwingViewController") as! FollowFollwingViewController
        viewController.selectedTab = "Following"
        viewController.followingCount = self.lblFollowingCount.text!
        viewController.followesrCount = self.lblFollowerCount.text!
        viewController.userId = "\(appDelegate.userDetails?.id ?? 0)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func reviewOnTap(_ sender: UIButton) {
        let viewController = RatingListViewController.instantiate(fromStoryboard: .Main)
        viewController.userId = "\(appDelegate.userDetails?.id ?? 0)"
        viewController.userName = "\(appDelegate.userDetails?.username ?? "")"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnFollowear_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "FollowFollwingViewController") as! FollowFollwingViewController
        viewController.selectedTab = "Followear"
        viewController.userId = "\(appDelegate.userDetails?.id ?? 0)"
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnShort_Clicked(_ button: UIButton) {

        let vc = FilterProductVC.instantiate(fromStoryboard: .Dashboard)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.callBack = {
            self.callGetUserpost(userId: String(appDelegate.userDetails?.id ?? 0), tabId: String(self.selIndexForCVCategory + 1),sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
        }
        vc.isJustFilter = true
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
    }
    
    @IBAction func btnEditProfile_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController
        viewController.loginType = self.loginType
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
extension UserViewController: UIScrollViewDelegate{
    
    //func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {   print("scrollViewDidEndDecelerating")
        
        var visibleRect = CGRect()
        visibleRect.origin = self.scrollView.contentOffset
        visibleRect.size = self.CVCProduct.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = self.CVCProduct.indexPathForItem(at: visiblePoint) else { return }
        print(indexPath)
        if indexPath.item == self.posts.count - 1 && hasMorePages == true && self.loading == false {
            self.scrollView.isScrollEnabled = false
            currentPage = self.currentPage + 1
            loading = true
            
            self.callGetUserpost(userId: String(appDelegate.userDetails?.id ?? 0), tabId: String(self.tabs[self.selIndexForCVCategory].type ?? 0),sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
        }
    }
}
extension UserViewController : UICollectionViewDelegate,UICollectionViewDataSource {
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
                cell.viewLine.backgroundColor = .customBlack
                cell.lblcategory.text = objet.name
                cell.lblcategory.font = .RobotoFont(.robotoBold, size: 14)
            }
            else{
                cell.lblcategory.font = .RobotoFont(.robotoRegular, size: 14)
                cell.lblcategory.text = objet.name
                cell.viewLine.backgroundColor = UIColor.customBorderColor
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
//            cell.imgPromteTopPick.isHidden = objet.isPromotShow()
//            //            if objet.isLblSaleHidden(){
//            cell.imgPromteTopPick.image = UIImage.init(named: objet.isPromotImage())
//            //            }
//            
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
//            else{
//                cell.lblBrand.text = ""
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
//                    if let price = objet.price {
//                        if !(objet.isLblSaleHidden()) {
//                            if let salePrice = objet.sale_price {
//                                cell.lblPrice.text = "$ \(salePrice)"
//                            }
//                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price)")
//                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                            cell.lblSelePrice.attributedText = attributeString
//                            cell.constLeadingForlblPrice.constant = 2
//                            //                    cell.lblPrice.text = "$ \(price)"
//                        }
//                        else {
//                            cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
//                            cell.lblPrice.text = "$ \(price)"
//                        }
//                    }
//                }
//                else{
//                    if let producttype = objet.price_type_name{
//                        cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
//                        cell.lblPrice.text = "\(producttype)"
//                    }
//                }
//            }
//            cell.btnWatch.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.CVCategory {
            if indexPath.item == 0{
                self.lblDataTitle.text = "All Selling"
            }else{
                self.lblDataTitle.text = "All Sold"
            }
            self.selIndexForCVCategory = indexPath.item
            self.currentPage = 1
            self.callGetUserpost(userId: String(appDelegate.userDetails?.id ?? 0), tabId: String(self.tabs[indexPath.item].type ?? 0),sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
        }
        else {
            if let postUserId = self.posts[indexPath.item].user_id {
                if postUserId == appDelegate.userDetails?.id {
                    let viewController = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
                    viewController.postId = String(self.posts[indexPath.item].id ?? 0)
                    viewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else{
                    let viewController = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
                    viewController.postId = String(self.posts[indexPath.item].id ?? 0)
                    viewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.item == self.posts.count - 3 && hasMorePages == true {
//                currentPage = self.currentPage + 1
//                loading = true
//                self.scrollView.isScrollEnabled = false
//                self.callGetUserpost(userId: String(appDelegate.userDetails?.id ?? 0), tabId: String(self.tabs[self.selIndexForCVCategory].type ?? 0),sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
//            }
    }
}

class CategoryCell : UICollectionViewCell {
    @IBOutlet weak var lblcategory: UILabel!
    @IBOutlet weak var lblcategoryCount: UILabel!
    @IBOutlet weak var viewLine: UIView!
}

extension UserViewController: UICollectionViewDelegateFlowLayout {
//    fileprivate var sectionInsets: UIEdgeInsets {
//          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//      }
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
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return interitemSpace
//    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return interitemSpace
//    }
}

extension UserViewController{
    
    func getUserDetails() {
       if appDelegate.reachable.connection != .none {
           APIManager().apiCall(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.AUTOLOGIN.rawValue, method: .get, parameters: [:]) { (response, error) in
               if error == nil {
                   if let response = response {
                       if let userDetails = response.dictData {
                           self.saveUserDetails(userDetails: userDetails)
                        self.userData = userDetails
                        self.setUserDetails()
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
    
    func callFollowingstDatails() {
       if appDelegate.reachable.connection != .none {

           APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOWINGS.rawValue, method: .post, parameters: [:]) { (response, error) in
               if error == nil {
                   if let response = response {
                       if let data = response.dictData {
                        self.followingsList = data
                        self.setdata()
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
    
    func callGetUserpost(userId : String,tabId : String,sort_by:String , sort_value : String ,isShowHud:Bool) {
       if appDelegate.reachable.connection != .none {
        
//        let param = ["user_id":  userId,
//                     "tab" : tabId,
//                     "sort_by" : sort_by,
//                     "sort_value" : sort_value,
//                     "page" : "\(self.currentPage)"
//                    ]
           
           var param = FilterSingleton.share.filter.toDictionary()
           param?.removeValue(forKey: "is_only_count")
           param?.removeValue(forKey: "page")
//           param?.removeValue(forKey: "sort_by")
//           param?.removeValue(forKey: "sort_value")
           param?.removeValue(forKey: "notification_item_counter")
           param?["page"] = "\(self.currentPage)"
           param?["user_id"] = userId
           param?["tab"] = tabId
           param?.removeValue(forKey: "slectedCategories")
           APIManager().apiCall(of:HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.USER_POSTS.rawValue, method: .post, parameters: param) { (response, error) in
               if error == nil {
                   if let response = response {
                    if response.dictData != nil {
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
                        }
                        self.CVCategory.reloadData()
                        
                        if self.posts.count == 0 {
                            self.lblNoData.isHidden = true
                            if sort_by != "size"  {
                                self.btnSort.isHidden = false
                            }
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                            self.btnSort.isHidden = false
                            
                        }
                        
                        self.CVCProduct.reloadData()
                      //  if self.currentPage == 1 {
                            self.CVCProduct.layoutIfNeeded()
                            self.constHeightForCVCProduct.constant = self.CVCProduct.contentSize.height
                       // }
                        self.scrollView.isScrollEnabled = true
                        self.loading = false
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
    
    func callPostFavourite(action_type : String,postId : String,index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
                        ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.posts[index].is_favourite = true
                    }
                    else {
                        self.posts[index].is_favourite = false
                    }
                    self.CVCProduct.reloadData()
//                    if self.currentPage == 1 {
  //                      self.CVCProduct.layoutIfNeeded()
//                        self.constHeightForCVCProduct.constant = self.constHeightForCVCProduct.constant + 290
                    self.CVCProduct.setBackGroundLabel(count: self.posts.count)
//                    }
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
extension UserViewController : ShortByDelegate{
    
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        self.currentPage = 1
        self.callGetUserpost(userId: String(appDelegate.userDetails?.id ?? 0), tabId: String(self.selIndexForCVCategory + 1),sort_by: self.sort_by,sort_value: self.sort_value, isShowHud: true)
    }
}
