//
//  ProductDetailsViewController.swift
//  ClothApp
//
//  Created by Apple on 05/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import CHIPageControl
import AVKit
import SafariServices
protocol LikeDelegate {
    func Like(like: Bool,indexpath : IndexPath)
}

class ProductDetailsViewController: BaseViewController {
    
    @IBOutlet weak var lblUserPostCount: UILabel!
    @IBOutlet weak var lblProductTimAndDate: UILabel!
    @IBOutlet weak var CVimages: UICollectionView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductType: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblProductConditionTitle: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var lblProductSizeTitel: UILabel!
    @IBOutlet weak var ConstTopForlblProductSizeTitel: NSLayoutConstraint!
    @IBOutlet weak var Constlblproductsizetwoheight: NSLayoutConstraint!
    @IBOutlet weak var ConstTopForlblProductConditionTitle: NSLayoutConstraint!
    @IBOutlet weak var lblProductSize2: UILabel!
    @IBOutlet weak var lblProductGender: UILabel!
    @IBOutlet weak var lblProductCategory: UILabel!
    @IBOutlet weak var lblSold: UILabel!
    @IBOutlet weak var lblProductColor: UILabel!
    @IBOutlet weak var lblProductWitchStore: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var imgProductColor: CustomImageView!
    @IBOutlet weak var imgFavourite: UIImageView!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnBrand: CustomButton!
    @IBOutlet weak var btnUserDeteils: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var viewFloatRating: FloatRatingView!
    @IBOutlet weak var lblFloatRatingCount: UILabel!
    
    @IBOutlet weak var stackViewBottom: UIStackView!
    @IBOutlet weak var constTopForStackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var btnByNow: CustomButton!
    @IBOutlet weak var btnChetAndByNow: CustomButton!
    @IBOutlet weak var btnFindLocation: CustomButton!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var CVProdict: UICollectionView!
    @IBOutlet weak var lblReletedProduct: UILabel!
    @IBOutlet weak var constTopForlblReletedProduct: NSLayoutConstraint!
    @IBOutlet weak var CVReletedProduct: UICollectionView!
    
    @IBOutlet weak var pageControlView: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        self.btnLocation.isHidden = false
        
        self.deeplinkClear()
        self.callPostDetails(postId: self.postId)
        self.stackViewBottom.isHidden = true
        self.constTopForStackViewBottom.constant = -self.stackViewBottom.frame.height
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.hidesBottomBarWhenPushed = false
    }
    
    @IBAction func btnLike_Clicked(_ button: UIButton) {
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
    
    @IBAction func btnUserDeteils_Clicked(_ button: UIButton) {
        if appDelegate.userDetails?.id == self.postDetails?.user_id {
            self.navigateToHomeScreen(selIndex: 4)
        }
        else {
            if let seller = self.postDetails?.user_type {
                if seller == 1 {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                    viewController.userId = "\(self.postDetails?.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else if seller == 2{
                    let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
                    viewController.userId = "\(self.postDetails?.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
                    viewController.userId = "\(self.postDetails?.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    @IBAction func btnChetAndByNow_Clicked(_ button: UIButton) {
        let isComplete =  appDelegate.userDetails?.phone?.trim().isEmpty ?? true
        if isComplete == true{
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please complete your profile to chat with other users.") { [weak self] in
                guard self != nil else {return}
                let viewController = MobileNumberVC.instantiate(fromStoryboard: .Auth)
                viewController.hidesBottomBarWhenPushed = true
                self?.pushViewController(vc: viewController)
            }
        }else{
            let viewController = self.storyboard?.instantiateViewController(identifier: "MessagesViewController") as! MessagesViewController
            viewController.receiverId = String(postDetails?.receiver_id ?? 0)
            viewController.postId = String (postDetails?.id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnFindLocation_Clicked(_ button: UIButton) {
        let lat = self.postDetails?.locations?[0].latitude
        let log = self.postDetails?.locations?[0].longitude
       // let address = self.postDetails?.locations?[0].address
       // let postal_code = self.postDetails?.locations?[0].postal_code
        let viewController = self.storyboard?.instantiateViewController(identifier: "FindLocation") as! FindLocation
        viewController.addresslist = self.postDetails!.locations!
        viewController.lat = (lat! as NSString).doubleValue
        viewController.log = (log! as NSString).doubleValue
        viewController.usertype = self.postDetails?.user_type ?? 0
       // viewController.adddressArea =  "\(address ?? "") \(postal_code ?? "")"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnByNow_Clicked(_ button: UIButton) {
//        let viewController = self.storyboard?.instantiateViewController(identifier: "CheckoutViewController") as! CheckoutViewController
//        viewController.postDetails = postDetails
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        if let urls = self.postDetails?.product_url{
            if let url = URL(string: urls) {
                if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
            }
        }
    }
    
    @IBAction func btnShare_Clicked(_ button: UIButton) {
        let text = "I found this on Clothing Click"
        let url = URL.init(string: "\(SERVER_URL)share/post/\(self.postId)")!
        //let img = UIImage(named: "wel_logo")
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [text, url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onBtnBack_Clicked(_ sender: Any) {
        if fromPushNotification == false{
            self.view.endEditing(true)
            if likeDeleget != nil {
                if let like = postDetails?.is_favourite {
                    self.likeDeleget.Like(like: like, indexpath: indexpath)
                }
            }
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigateToHomeScreen()
        }
    }
    func setUserType () {
        if self.postDetails?.user_type == 2{
            self.btnBrand.isHidden = false
            self.btnBrand.setTitle("Store", for: .normal)
            self.viewFloatRating.isHidden = true
            self.lblFloatRatingCount.isHidden = true
            self.setData()
        }
        else if self.postDetails?.user_type == 1{
            self.btnBrand.isHidden = true
            self.viewFloatRating.isHidden = true
            self.viewFloatRating.backgroundColor = UIColor.clear
            self.viewFloatRating.delegate = self
            self.viewFloatRating.contentMode = UIView.ContentMode.scaleAspectFit
            self.viewFloatRating.type = .halfRatings
            self.lblFloatRatingCount.isHidden = false
            self.setData()
        }
        else if self.postDetails?.user_type == 3 {
            self.btnBrand.isHidden = false
            self.btnBrand.setTitle("Brand", for: .normal)
            self.viewFloatRating.isHidden = true
            self.lblFloatRatingCount.isHidden = true
            self.ConstTopForlblProductConditionTitle.constant = -self.lblProductConditionTitle.frame.height
            self.lblProductConditionTitle.isHidden = true
            self.lblProductCondition.isHidden = true
            self.setData()
        }
    }
    func setData () {
        if let brandName = self.postDetails?.brand_name {
            self.lblBrandName.text = brandName
        }
        if let productType = self.postDetails?.title {
            self.lblProductType.text = productType
        }
        if let pricetype = self.postDetails?.price_type {
            if pricetype == "1"{
                if let saletype = self.postDetails?.is_sale {
                    if saletype == 1 {
                        if let price = self.postDetails?.sale_price {
                            self.lblProductPrice.text = "$ \(price)"
                        }
                    }else{
                        if let price = self.postDetails?.price {
                            self.lblProductPrice.text = "$ \(price.formatPrice())"
                        }
                    }
                }
            }else{
                if let price = self.postDetails?.price_type_name {
                    self.lblProductPrice.text = "\(price)".formatPrice()
                }
            }
        }
        if let dice = self.postDetails?.description {
            self.txtDescription.text = dice
        }
        if let condiction = self.postDetails?.condition_name {
            self.lblProductCondition.text = condiction
        }
        if let size  = self.postDetails?.sizes {
            if size.count != 0 {
                self.lblProductSizeTitel.isHidden = false
                self.lblProductSize2.isHidden = false
                self.lblProductSize.text = size[0].name
                self.lblProductSize2.text = size[0].name
            }
            else {
                self.ConstTopForlblProductSizeTitel.constant = -self.lblProductSizeTitel.frame.height
                self.lblProductSizeTitel.isHidden = true
                self.lblProductSize2.isHidden = true
                self.Constlblproductsizetwoheight.constant = 0
            }
        }
        if let gender = self.postDetails?.gender_name {
            self.lblProductGender.text = gender
        }
        if let color = self.postDetails?.colors {
            self.imgProductColor.isHidden = true
            var colorName = [String]()
            for i in 0..<color.count {
                if let name = color[i].name{
                    colorName.append(name)
                }
            }
            self.lblProductColor.text = colorName.joined(separator: ",")
        }
        if let category = self.postDetails?.categories?[0].name {
            self.lblProductCategory.text = category
        }
        if let seller = self.postDetails?.user_type {
            if seller == 1 {
                self.lblProductWitchStore.text = "User"
                self.btnLocation.isHidden = false
            }
            else if seller == 2{
                self.lblProductWitchStore.text = "Store"
                self.btnLocation.isHidden = false
            }
            else {
                self.lblProductWitchStore.text = "Brand"
                self.btnLocation.isHidden = true
                self.btnLocation.layer.frame.size.height = 0
            }
        }
        if let userPost = self.postDetails?.user_posts?.count  {
            self.lblUserPostCount.text = "\(userPost )"
        }
        if let username = self.postDetails?.user_username {
            self.lblUserName.text = username
        }
        if let url = self.postDetails?.user_profile_picture {
            self.imgUserProfile.setImageFast(with: url)
            
        }
        var categoryList = [String]()
        for i in 0..<(self.postDetails?.categories?.count ?? 0) {
            if let category = self.postDetails?.categories?[i].name {
                categoryList.append(category)
            }
        }
        self.lblProductCategory.text = categoryList.joined(separator: ",")
        
        if let name = self.postDetails?.user_name {
            self.lblName.text = name
        }
        if let postCount = self.postDetails?.total_posts {
            self.lblUserPostCount.text = "\(postCount)"
        }
        
        if let locations = self.postDetails?.locations{
            if locations.count > 0 {
            if let city = locations[0].city{
                if city == ""{
                    if let area = locations[0].area{
                        if area == ""{
                        self.btnLocation.setTitle(area, for: .normal)
                        }else{
                            self.btnLocation.setTitle(area, for: .normal)
                        }
                    }
                }else{
                self.btnLocation.setTitle(city, for: .normal)
                }
            }
        }
        }
        if let ratingCount = self.postDetails?.user_avg_review{
            self.viewFloatRating.rating = Double(ratingCount)
        }
        
        if let review = self.postDetails?.total_reviews {
            self.lblFloatRatingCount.text = "\(review)"
        }
        if let is_favourite = self.postDetails?.is_favourite {
            if is_favourite == true {
                self.imgFavourite.image = UIImage.init(named: "like-ic")
            }
            else {
                self.imgFavourite.image = UIImage.init(named: "like_ic")
            }
        }
        if let strDate = self.postDetails?.created_at{
            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
            self.lblProductTimAndDate.text = Date().offset(from: date)
        }
        
        self.btnChetAndByNow.isHidden = !(self.postDetails?.isChatButtonDisplay() ?? false)
        self.btnByNow.isHidden = !(self.postDetails?.isBuyNowButtonDisplay() ?? false)
        self.btnFindLocation.isHidden = !(self.postDetails?.isFiendLocationButtonDisplay() ?? false)
        if self.postDetails?.user_type == 1 {
            self.viewFloatRating.isHidden = false
            self.viewFloatRating.rating = Double(self.postDetails?.user_avg_review ?? 0 )
        }
        else {
            self.viewFloatRating.isHidden = true
        }
        if !(self.postDetails?.isHideStackViewBottom() ?? false)
        {
            self.stackViewBottom.isHidden = true
            self.constTopForStackViewBottom.constant = -self.stackViewBottom.frame.height
        }
        else{
            self.stackViewBottom.isHidden = false
            self.constTopForStackViewBottom.constant = 10
        }
    }
}

extension ProductDetailsViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.CVimages {
            return self.postImageVideo.count
        }
        else if collectionView == self.CVProdict{
            return self.userPost.count
        }
        else  {
            return self.relatedPost.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.CVimages {
            let objet = self.postImageVideo[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
            cell.imgPlay.isHidden = true
            if objet.type == "image"{
                if let url = objet.image {
                    cell.imgProductImages.setImageFast(with: url)
                }
            }
            else {
                if let url = objet.video {
                    if let videourl = URL.init(string: url){
                        self.getThumbnailImageFromVideoUrl(url:videourl) { (thumbImage) in
                            cell.imgProductImages.image = thumbImage
                            cell.imgPlay.isHidden = false
                        }
                    }
                }
            }
            return cell
        }
        else if collectionView == self.CVProdict{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
            let objet = userPost[indexPath.item]
            cell.lblSale.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
            }
            cell.lblSelePrice.isHidden = objet.isLblSaleHidden()
            cell.lblSale.isHidden = objet.isLblSaleHidden()
            cell.viewSale.isHidden = objet.isViewSaleHidden()
            cell.imgPromteTopPick.isHidden = true///objet.isTopPickHidden()
            if let color = objet.getBackgroundColor() {
                self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
                cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
            }
            if let strDate = objet.created_at{
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblDayAgo.text = Date().offset(from: date)
            }
            
            if let url = objet.image?[0].image {
                cell.imgBrand.setImageFast(with: url)
            }
            if let brand = objet.brand_name{
                cell.lblBrand.text = brand
            }
            if let title = objet.title{
                cell.lblModelItem.text = title
            }
            if let producttype = objet.price_type{
                if producttype == "1"{
                    if let price = objet.price {
                        if !(objet.isLblSaleHidden()) {
                            if let salePrice = objet.sale_price {
                                cell.lblPrice.text = "$ \(salePrice)"
                            }
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price.formatPrice())")
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell.lblSelePrice.attributedText = attributeString
                            cell.constLeadingForlblPrice.constant = 2
                           // cell.lblPrice.text = "$ \(price)"
                        }
                        else {
                            cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                            cell.lblPrice.text = "$ \(price.formatPrice())"
                        }
                    }
                }else{
                    cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                    if let producttype = objet.price_type_name{
                        cell.lblPrice.text = "\(producttype)"
                    }
                }
            }
            if let size = objet.size_name {
                cell.lblSize.text = size
            }
            cell.btnWatch.isSelected = objet.isfavourite()
            if let is_favourite = objet.is_favourite {
                cell.btnWatch.isSelected = is_favourite
            }
            return cell
        }
        else  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
            let objet  = self.relatedPost[indexPath.item]
            cell.lblSale.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
            }
            cell.lblSelePrice.isHidden = objet.isLblSaleHidden()
            cell.lblSale.isHidden = objet.isLblSaleHidden()
            cell.viewSale.isHidden = objet.isViewSaleHidden()
            cell.imgPromteTopPick.isHidden = true//objet.isTopPickHidden()
            if let color = objet.getBackgroundColor() {
                self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
                cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
            }
            if let strDate = objet.created_at{
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblDayAgo.text = Date().offset(from: date)
            }
            
            if let url = objet.image?[0].image {
                cell.imgBrand.setImageFast(with: url)
            }
            if let brand = objet.brand_name{
                cell.lblBrand.text = brand
            }
            if let title = objet.title{
                cell.lblModelItem.text = title
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
                   // cell.lblPrice.text = "$ \(price)"
                }
                else {
                    cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                    cell.lblPrice.text = "$ \(price.formatPrice())"
                }
            }
            if let size = objet.size_name {
                cell.lblSize.text = size
            }
            cell.btnWatch.isSelected = objet.isfavourite()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.CVimages {
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
                let viewController = self.storyboard?.instantiateViewController(identifier: "PhotosViewController") as! PhotosViewController
                var imag = [String]()
                for i in 0..<self.postImageVideo.count{
                    imag.append(postImageVideo[i].image ?? "")
                }
                viewController.imagesList = self.postImageVideo
                viewController.visibleIndex = indexPath.item
                self.navigationController?.present(viewController, animated: true, completion: nil)
            }
        }
        else if collectionView == CVProdict {
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

class ImagesCell : UICollectionViewCell {
    @IBOutlet weak var imgProductImages: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
}

extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
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
        if collectionView == self.CVimages {
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth
            return CGSize(width: widthPerItem, height: 300)
        }
        else {
            return CGSize(width: 160, height: 233)
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

extension ProductDetailsViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControlView.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.pageControlView.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension ProductDetailsViewController : FloatRatingViewDelegate{
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
        
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
    }
}
extension ProductDetailsViewController {
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
                                let viewController = self.storyboard?.instantiateViewController(identifier: "AdPlacementViewController") as! AdPlacementViewController
                                if let id = self.postDetails?.id{
                                    viewController.postId = String(id)
                                }
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                            else {
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
                                    self.CVProdict.isHidden = true
                                    self.constTopForlblReletedProduct.constant = -243
                                }
                                else
                                {
                                    self.CVProdict.isHidden = false
                                    self.constTopForlblReletedProduct.constant = 20
                                }
                                if let reletedPost = self.postDetails?.related_posts {
                                    self.relatedPost = reletedPost
                                }
                                self.relatedPost = self.relatedPost.filter({$0.id != Int(self.postId)})
                                if self.relatedPost.count == 0 {
                                    self.CVReletedProduct.isHidden = true
                                    self.lblReletedProduct.isHidden = true
                                }
                                else
                                {
                                    self.lblReletedProduct.isHidden = false
                                    self.CVReletedProduct.isHidden = false
                                }
                                if !(self.postDetails?.isItemSold() ?? false){
                                    self.lblSold.isHidden = true
                                }else{
                                    self.lblSold.isHidden = false
                                }
                                self.scrollView.contentOffset = .zero
                                self.pageControlView.numberOfPages = self.postImageVideo.count
                                self.pageControlView.currentPage = 0
                                self.pageControlView.hidesForSinglePage = true
                                self.CVimages.reloadData()
                                self.CVProdict.reloadData()
                                self.CVReletedProduct.reloadData()
                            }
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
    
    func callPostFavourite(action_type : String,postId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.postDetails?.is_favourite = true
                        self.imgFavourite.image = UIImage.init(named: "like-ic")
                        if self.likeDeleget != nil{
                            self.likeDeleget.Like(like: true, indexpath: self.indexpath)
                        }
                    }
                    else {
                        self.postDetails?.is_favourite = false
                        self.imgFavourite.image = UIImage.init(named: "like_ic")
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
}
