//
//  OtherPostDetailsVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 04/07/24.
//

import UIKit
import IBAnimatable
import AVFoundation
import AVKit
class OtherPostDetailsVC: BaseViewController {
    
    @IBOutlet weak var sizeViewContainer: UIView!
    @IBOutlet weak var lblStyle: UILabel!
    @IBOutlet weak var lblDealPopupSubtile: UILabel!
    @IBOutlet weak var lblDealPopupTitle: UILabel!
    @IBOutlet weak var dealPopup: UIView!
    @IBOutlet weak var lblFirstLatter: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var lblSallerType: UILabel!
    @IBOutlet weak var btnEdit: AnimatableButton!
    @IBOutlet weak var soldPostView: UIView!
    @IBOutlet weak var deletePostView: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var soldAlertContainerView: UIView!
    @IBOutlet weak var btnMarkSold: AnimatableButton!
    @IBOutlet weak var moreFromSellerCollectionContainer: UIView!
    @IBOutlet weak var recentViewCollectionContainer: UIView!
    @IBOutlet weak var btnFindLocation: AnimatableButton!
    @IBOutlet weak var btnChetAndByNow: AnimatableButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var recentViewCollection: UICollectionView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var moreSallerCollection: UICollectionView!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSallerName: UILabel!
    @IBOutlet weak var imgSellerProfile: AnimatableImageView!
    @IBOutlet weak var lblDese: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var pageControlle: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var postId = ""
    var chatAndBuyNow = ""
    var postDetails : PostDetailsModel?
    var postImageVideo = [ImagesVideoModel]()
    var userPost = [User_posts]()
    var relatedPost = [User_posts]()
    var typeOfLogin :[String] = ["Store","User","Brand"]
    var likeDeleget : LikeDelegate!
    var indexpath : IndexPath!
    var FavritIndx = 0
    var fromPushNotification:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.deeplinkClear()
        self.callPostDetails(postId: self.postId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerCell(nib: UINib(nibName: "PostImageXIB", bundle: nil), identifier: "PostImageXIB")
        
        self.moreSallerCollection.delegate = self
        self.moreSallerCollection.dataSource = self
        self.moreSallerCollection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        self.moreSallerCollection.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
        
        self.recentViewCollection.delegate = self
        self.recentViewCollection.dataSource = self
        self.recentViewCollection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        self.recentViewCollection.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
        
    }
    
    @IBAction func editOnPress(_ sender: UIButton) {
        let viewController = PostItemViewController.instantiate(fromStoryboard: .Main)
        viewController.postDetails = self.postDetails
        viewController.edit = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func likeOnPress(_ sender: UIButton) {
        if (postDetails?.isItemSold() ?? false){
            UIAlertController().alertViewWithTitleAndMessage(self, message: "This item is sold")
        }
        else {
            if self.postDetails?.isFavourite() ?? false {
                if let id = self.postDetails?.id {
                    self.callPostFavourite(action_type: "0", postId:"\(id)" )
                }
            }
            else {
                if let id = self.postDetails?.id {
                    self.callPostFavourite(action_type: "1", postId:"\(id)" )
                }
            }
        }
    }
    
    @IBAction func deletePostOnPress(_ sender: UIButton) {
        if let postId = self.postDetails?.id {
            self.callPostDelete(postId: "\(postId)")
        }
    }
    
    @IBAction func deleteOnPress(_ sender: UIButton) {
        self.soldAlertContainerView.isHidden = false
        self.soldPostView.isHidden = true
        self.deletePostView.isHidden = false
    }
    
    @IBAction func sellerProfileOnTap(_ sender: UIButton) {
        
        if self.postDetails?.type?.lowercased() == "store"{
            let vc = StoreProfileVC.instantiate(fromStoryboard: .Store)
            vc.viewModel.userID = "\(self.postDetails?.user_id ?? 0)"
            self.pushViewController(vc: vc)
        }else{
            if self.postDetails?.user_id == appDelegate.userDetails?.id {
                self.tabBarController?.selectedIndex = 4
            }else{
                let viewController = OtherUserProfileViewController.instantiate(fromStoryboard: .Main)
                viewController.userId = "\(self.postDetails?.user_id ?? 0)"
                self.pushViewController(vc: viewController)
            }
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        if fromPushNotification == false{
            self.view.endEditing(true)
            if likeDeleget != nil {
                if let like = postDetails?.is_favourite {
                    self.likeDeleget.Like(like: like, indexpath: indexpath)
                }
            }
            self.popViewController()
        }else{
            self.navigateToHomeScreen()
        }
    }
    
    @IBAction func gotItOnPress(_ sender: UIButton) {
        self.dealPopup.isHidden = true
    }
    
    @IBAction func cancelOnPress(_ sender: UIButton) {
        self.soldAlertContainerView.isHidden = true
        self.deletePostView.isHidden = true
        self.soldPostView.isHidden = true
    }
    
    @IBAction func acceptOnPress(_ sender: UIButton) {
        self.callItemSold(postId: self.postId)
    }
    
    @IBAction func shareOnPress(_ sender: UIButton) {
        //        guard let userDetails = appDelegate.userDetails else {
        //            self.showLogIn()
        //            return
        //        }
        
        let text = "I found this on Clothing Click"
        
        guard let url = URL(string: "\(SERVER_URL)share/post/\(self.postId)") else {
            print("Invalid URL")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [text, url], applicationActivities: nil)
        
        // Excluding unwanted activity types but allowing copy to pasteboard
        activityViewController.excludedActivityTypes = [
            .print,
            .postToWeibo,
            .addToReadingList,
            .postToVimeo
        ]
        
        // Handling completion to confirm copy action
        activityViewController.completionWithItemsHandler = { activity, success, items, error in
            if let error = error {
                print("Error during sharing: \(error.localizedDescription)")
            } else if success, activity == .copyToPasteboard {
                print("Content copied to clipboard")
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func soldOnPress(_ sender: UIButton) {
        self.soldAlertContainerView.isHidden = false
        self.soldPostView.isHidden = false
        self.deletePostView.isHidden = true
    }
    
    @IBAction func chatOnPress(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        if self.postDetails?.type?.lowercased() == "store"{
            let viewController = BuyNowVC.instantiate(fromStoryboard: .Store)
            viewController.postDetails = self.postDetails
            viewController.hidesBottomBarWhenPushed = true
            self.pushViewController(vc: viewController)
        }else{
            let isComplete =  appDelegate.userDetails?.phone?.trim().isEmpty ?? true
            if isComplete == true{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please complete your profile to chat with other users.") { [weak self] in
                    guard self != nil else {return}
                    let viewController = MobileNumberVC.instantiate(fromStoryboard: .Auth)
                    viewController.hidesBottomBarWhenPushed = true
                    self?.pushViewController(vc: viewController)
                }
            }else{
                let viewController = MessagesViewController.instantiate(fromStoryboard: .Main)
                viewController.receiverId = String(postDetails?.receiver_id ?? 0)
                viewController.postId = String (postDetails?.id ?? 0)
                viewController.hidesBottomBarWhenPushed = true
                self.pushViewController(vc: viewController)
            }
        }
    }
    
    @IBAction func mapOnPress(_ sender: UIButton) {
        guard let userDetails = appDelegate.userDetails else {
            self.showLogIn()
            return
        }
        
        guard
            let locations = postDetails?.locations,
            let firstLocation = locations.first,
            let latStr = firstLocation.latitude,
            let logStr = firstLocation.longitude,
            let lat = Double(latStr),
            let log = Double(logStr)
        else {
            // Optionally, show an alert or silently return if location info is missing
            return
        }

        let viewController = FindLocation.instantiate(fromStoryboard: .Main)
        viewController.addresslist = locations
        viewController.lat = lat
        viewController.log = log
        viewController.usertype = postDetails?.user_type ?? 0
        viewController.hidesBottomBarWhenPushed = true
        
        self.pushViewController(vc: viewController)
    }

}


extension OtherPostDetailsVC {
    
    func callPostDelete(postId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    //                    self.getUserDetele()
                    self.popViewController()
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
    
    func setUserType () {
        self.setData()
    }
    
    func setData () {
        
        self.lblViewCount.text = (self.postDetails?.post_views ?? 0) == 0 ? "" : "\(String(self.postDetails?.post_views ?? 0))"
        
        if let productType = self.postDetails?.title {
            self.lblProductName.text = productType
            self.lblTitle.text = productType
        }
        
        if let pricetype = self.postDetails?.price_type {
            if pricetype == "1"{
                if let saletype = self.postDetails?.is_sale {
                    if saletype == 1 {
                        if let price = self.postDetails?.sale_price {
                            self.lblPrice.text = "$ \(price)"
                        }
                    }else{
                        if let price = self.postDetails?.price {
                            self.lblPrice.text = "$ \(price.formatPrice())"
                        }
                    }
                }
            }else{
                if let price = self.postDetails?.price_type_name {
                    self.lblPrice.text = "\(price)"
                }
            }
        }
        if let dice = self.postDetails?.description {
            self.lblDese.text = dice
        }
        if let condiction = self.postDetails?.condition_name {
            self.lblCondition.text = condiction
        }
        //        if let size  = self.postDetails?.sizes {
        //            if size.count != 0 {
        //                self.lblProductSizeTitel.isHidden = false
        //                self.lblProductSize2.isHidden = false
        //                self.lblProductSize.text = size[0].name
        //                self.lblProductSize2.text = size[0].name
        //            }
        //            else {
        //                self.ConstTopForlblProductSizeTitel.constant = -self.lblProductSizeTitel.frame.height
        //                self.lblProductSizeTitel.isHidden = true
        //                self.lblProductSize2.isHidden = true
        //                self.Constlblproductsizetwoheight.constant = 0
        //            }
        //        }
        if let gender = self.postDetails?.gender_name,let size  = self.postDetails?.sizes?.first?.name {
            self.lblSize.text = "\(gender == "Menswear" ? "Men" : "Women")'s \(size)"
            self.sizeViewContainer.isHidden = false
        }else{
            self.sizeViewContainer.isHidden = true
        }
        //        if let color = self.postDetails?.colors {
        //            self.imgProductColor.isHidden = true
        //            var colorName = [String]()
        //            for i in 0..<color.count {
        //                if let name = color[i].name{
        //                    colorName.append(name)
        //                }
        //            }
        ////            self.lblProductColor.text = colorName.joined(separator: ",")
        //        }
        //        if let category = self.postDetails?.categories?[0].name {
        //            self.lblProductCategory.text = category
        //        }
        
        if let userPost = self.postDetails?.user_posts?.count ,let username = self.postDetails?.user_username {
            self.lblUserName.text = "@\(username.capitalized) . \(userPost) posts"
        }
        //        if let username = self.postDetails?.user_username {
        //            self.lblUserName.text = username
        //        }
        if let url = self.postDetails?.user_profile_picture {
            self.imgSellerProfile.setImageFast(with: url)
        }else{
            self.lblFirstLatter.text = self.postDetails?.user_name?.first?.description.capitalized ?? ""
            self.lblFirstLatter.isHidden = false
            
        }
        var categoryList = [String]()
        for i in 0..<(self.postDetails?.categories?.count ?? 0) {
            if let category = self.postDetails?.categories?[i].name {
                categoryList.append(category)
            }
        }
        //        self.lblProductCategory.text = categoryList.joined(separator: ",")
        
        if let name = self.postDetails?.user_name {
            self.lblSallerName.text = name.capitalized
        }
        //        if let postCount = self.postDetails?.total_posts {
        //            self.lblUserPostCount.text = "\(postCount)"
        //        }
        
        if let locations = self.postDetails?.locations{
            //            if locations.count > 0 {
            //                if let city = locations[0].city{
            //                    if city == ""{
            //                        if let area = locations[0].area{
            //                            if area == ""{
            //                                self.btnLocation.setTitle(area, for: .normal)
            //                            }else{
            //                                self.btnLocation.setTitle(area, for: .normal)
            //                            }
            //                        }
            //                    }else{
            //                        self.btnLocation.setTitle(city, for: .normal)
            //                    }
            //                }
            //            }
            self.lblAddress.text = locations.first?.city
            self.lblAddress.isUserInteractionEnabled = true
            
            // Create the tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            
            // Add the gesture recognizer to the label
            self.lblAddress.addGestureRecognizer(tapGesture)
        }
        
        if let review = self.postDetails?.total_reviews,let rate = self.postDetails?.total_reviews {
            self.lblRate.text = "\(review)"
        }
        
        if let is_favourite = self.postDetails?.is_favourite {
            if is_favourite == true {
                self.btnLike.setImage(UIImage.init(named: "ic_red_heart"), for: .normal)
            }
            else {
                self.btnLike.setImage(UIImage.init(named: "ic_unfill_heart"), for: .normal)
            }
        }
        if let strDate = self.postDetails?.created_at{
            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
            self.lblTime.text = Date().offset(from: date)
        }
    }
    
    @objc func labelTapped() {
        guard
            let locations = postDetails?.locations,
            let firstLocation = locations.first,
            let latStr = firstLocation.latitude,
            let logStr = firstLocation.longitude,
            let lat = Double(latStr),
            let log = Double(logStr)
        else {
            // Optionally, show an alert or silently return if location info is missing
            return
        }
        
        let viewController = FindLocation.instantiate(fromStoryboard: .Main)
        viewController.addresslist = locations
        viewController.lat = lat
        viewController.log = log
        viewController.usertype = postDetails?.user_type ?? 0
        viewController.hidesBottomBarWhenPushed = true
        
        self.pushViewController(vc: viewController)    }
    
    func callPostDetails(postId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["post_id":  postId
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_DETAILS.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.postDetails = data
                            
                            if self.postDetails?.user_id == appDelegate.userDetails?.id {
                                if self.postDetails?.is_sold == 1{
                                    self.btnMarkSold.isUserInteractionEnabled = false
                                    self.btnEdit.isHidden = true
                                    self.btnMarkSold.setTitle("Item Sold", for: .normal)
                                }else{
                                    self.btnEdit.isHidden = false
                                    self.btnMarkSold.setTitle("Mark as Sold", for: .normal)
                                }
                                self.btnMarkSold.isHidden = false
                                self.btnChetAndByNow.isHidden = true
                                self.btnFindLocation.isHidden = true
                                self.lblLikeCount.isHidden = false
                                self.btnEye.isHidden = false
                                self.lblViewCount.isHidden = false
                                self.btnDelete.isHidden = true
                            }else{
                                self.btnEdit.isHidden = true
                                self.lblLikeCount.isHidden = true
                                self.btnEye.isHidden = true
                                self.lblViewCount.isHidden = true
                                self.btnMarkSold.isHidden = true
                                self.btnDelete.isHidden = true
                                self.btnChetAndByNow.isHidden = false
                                self.btnFindLocation.isHidden = false
                            }
                            //                                let viewController = AdPlacementViewController.instantiate(fromStoryboard: .Main)
                            //                                if let id = self.postDetails?.id{
                            //                                    viewController.postId = String(id)
                            //                                }
                            //                                self.navigationController?.pushViewController(viewController, animated: true)
                            //                            }
                            //                            else {
                            self.setUserType()
                            self.postImageVideo.removeAll()
                            if let image = self.postDetails?.images {
                                for i in 0..<image.count {
                                    var model = image[i]
                                    model.type = "image"
                                    self.postImageVideo.append(model)
                                }
                            }
                            if let videos = self.postDetails?.videos {
                                for i in 0..<videos.count {
                                    var model = videos[i]
                                    model.type = "video"
                                    self.postImageVideo.append(model)
                                }
                            }
                            if let userPost = self.postDetails?.user_posts {
                                self.userPost = userPost
                            }
                            self.userPost = self.userPost.filter({$0.id != Int(self.postId)})
                            if self.userPost.count == 0 {
                                self.moreFromSellerCollectionContainer.isHidden = true
                                //                                    self.constTopForlblReletedProduct.constant = -243
                            }
                            else
                            {
                                self.moreFromSellerCollectionContainer.isHidden = false
                                //                                    self.constTopForlblReletedProduct.constant = 20
                            }
                            if let reletedPost = self.postDetails?.recently_viewed {
                                self.relatedPost = reletedPost
                            }
                            self.relatedPost = self.relatedPost.filter({$0.id != Int(self.postId)})
                            if self.relatedPost.count == 0 {
                                self.recentViewCollectionContainer.isHidden = true
                                //                                    self.lblReletedProduct.isHidden = true
                            }
                            else
                            {
                                //                                    self.lblReletedProduct.isHidden = false
                                self.recentViewCollectionContainer.isHidden = false
                            }
                            
                            self.lblSallerType.text = self.postDetails?.type?.capitalized ?? ""
                            if self.postDetails?.type?.lowercased() == "store"{
                                self.lblRate.isHidden = false
                                self.imgStart.isHidden = false
                                self.btnChetAndByNow.setTitle("Buy Now", for: .normal)
                                self.btnChetAndByNow.setImage(UIImage(named: "ic_cart"), for: .normal)
                                
                                let isDeal = UserDefaults.standard.value(forKey: "isStoreDeal") as? Bool ?? false
                                
                                if isDeal == true{
                                    self.dealPopup.isHidden = true
                                }else{
                                    self.lblDealPopupTitle.text = "Buy now from local stores"
                                    self.lblDealPopupSubtile.text = "Purchase items directly within the app. Choose delivery to your doorstep or pickup at the store."
                                    UserDefaults.standard.set(true, forKey: "isStoreDeal")
                                    self.dealPopup.isHidden = false
                                }
                                
                            }else{
                                self.imgStart.isHidden = false
                                self.lblRate.isHidden = false
                                self.btnChetAndByNow.setTitle("Chat", for: .normal)
                                self.btnChetAndByNow.setImage(UIImage(named: "ic_white_chat"), for: .normal)
                                let isDeal = UserDefaults.standard.value(forKey: "isDeal") as? Bool ?? false
                                
                                if isDeal == true || self.postDetails?.user_id == appDelegate.userDetails?.id {
                                    self.dealPopup.isHidden = true
                                }else{
                                    self.lblDealPopupTitle.text = "Ready to make a deal?"
                                    self.lblDealPopupSubtile.text = "Tap here for any product questions and to arrange a meet up with the seller"
                                    UserDefaults.standard.set(true, forKey: "isDeal")
                                    self.dealPopup.isHidden = false
                                }
                            }
                            
                            self.lblStyle.text = "\(self.postDetails?.style_name ?? "")"
                            self.pageControlle.numberOfPages = self.postImageVideo.count
                            self.pageControlle.currentPage = 0
                            self.pageControlle.hidesForSinglePage = true
                            self.collectionView.reloadData()
                            self.moreSallerCollection.reloadData()
                            self.recentViewCollection.reloadData()
                            //                            }
                        }
                        
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                        
                    }
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
    
    func callPostFavourite(action_type : String,postId : String) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.postDetails?.is_favourite = true
                        self.btnLike.setImage(UIImage.init(named: "ic_red_heart"), for: .normal)
                        if self.likeDeleget != nil{
                            self.likeDeleget.Like(like: true, indexpath: self.indexpath)
                        }
                    }
                    else {
                        self.postDetails?.is_favourite = false
                        self.btnLike.setImage(UIImage.init(named: "ic_unfill_heart"), for: .normal)
                        if self.likeDeleget != nil{
                            self.likeDeleget.Like(like: false, indexpath: self.indexpath)
                        }
                    }
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
    
    func callItemSold(postId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId
                         
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_SOLD.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    let viewController = ItemSoldCongratulationsVC.instantiate(fromStoryboard: .Sell)
                    viewController.postId = String(self.postDetails?.id ?? 0)
                    self.pushViewController(vc: viewController)
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

extension OtherPostDetailsVC : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return self.postImageVideo.count
        }
        else if collectionView == self.moreSallerCollection{
            return self.userPost.count
        }
        else  {
            return self.relatedPost.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let objet = self.postImageVideo[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageXIB", for: indexPath) as! PostImageXIB
            //            cell.imgPlay.isHidden = true
            if objet.type == "image"{
                cell.imgPost.setImageFast(with: objet.image ?? "")
                cell.imgPost.contentMode = .scaleAspectFill
            }
            else {
                if let url = objet.video {
                    if let videourl = URL.init(string: url){
                        self.getThumbnailImageFromVideoUrl(url:videourl) { (thumbImage) in
                            cell.imgPost.image = thumbImage
                            cell.imgPost.contentMode = .scaleAspectFill
                            //                            cell.imgPlay.isHidden = false
                        }
                    }
                }
            }
            return cell
        }
        else if collectionView == self.moreSallerCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
            let objet = userPost[indexPath.item]
            cell.imgProduct.setImageFast(with: objet.image?.first?.image ?? "")
            
            cell.btnLike.tag = indexPath.row
            //            cell.btnLike.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
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
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
            let objet  = self.relatedPost[indexPath.item]
            cell.imgProduct.setImageFast(with: objet.image?.first?.image ?? "")
            
            cell.btnLike.tag = indexPath.row
            //            cell.btnLike.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let objet = self.postImageVideo[indexPath.item]
            if objet.type == "video"{
                if let videoUrl = objet.video {
                    let videoURL = URL(string: videoUrl)
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
            else {
                let viewController = PhotosViewController.instantiate(fromStoryboard: .Main)
                var imag = [String]()
                for i in 0..<self.postImageVideo.count{
                    imag.append(postImageVideo[i].image ?? "")
                }
                viewController.imagesList = self.postImageVideo
                viewController.visibleIndex = indexPath.item
                self.navigationController?.present(viewController, animated: true, completion: nil)
            }
        }
        else if collectionView == self.moreSallerCollection {
            let postId = self.userPost[indexPath.item].id ?? 0
            self.postId = String(postId)
            self.callPostDetails(postId: String(postId))
        }
        else {
            let postId = self.relatedPost[indexPath.item].id ?? 0
            self.callPostDetails(postId: String(postId))
            self.postId = String(postId)
        }
    }
}

extension OtherPostDetailsVC: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 1
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth
            return CGSize(width: widthPerItem, height: 300)
        }else {
            return CGSize(width: self.recentViewCollection.frame.width / 2.3, height: 230)
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
        if collectionView == self.collectionView{
            return interitemSpace
        }else{
            return 10
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView{
            return interitemSpace
        }else{
            return 10
        }
    }
}

extension OtherPostDetailsVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControlle.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControlle.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
