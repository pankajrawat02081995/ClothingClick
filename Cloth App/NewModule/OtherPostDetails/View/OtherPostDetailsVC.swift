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
    
    @IBOutlet weak var lblMoreFromSeller: UILabel!
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
    
    @IBOutlet weak var storeSizeView: UIView!
    @IBOutlet weak var storeColorView: UIView!
    @IBOutlet weak var storeSizeCollection: UICollectionView!
    @IBOutlet weak var storeColorCollection: UICollectionView!
    @IBOutlet weak var storeColorCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var storeSizeCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomLineDese: UIView!
    @IBOutlet weak var bottomLineTop: NSLayoutConstraint!
    
    let globalSizeOrder = ["XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL"]
    
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
    
    var sizeSelectionIndex : Int? = 0
    var colorSelectionIndex : Int? = 0
    var colorCount : Int? = 0
    var sizeStore : [String]? = []
    var colorStore : [String]? = []
    var veriantImages : [VariantsImages]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.deeplinkClear()
        self.callPostDetails(postId: self.postId)
    }
    
    // ✅ 1. Get colors for a specific size
    func colors(for size: String?, in variants: [Variants]) -> [String] {
        
        return Array(
            Set(
                variants.filter {
                    if let size = size {
                        return $0.size == size
                    } else {
                        return $0.size == nil || $0.size?.isEmpty == true
                    }
                }
                    .compactMap { $0.color }
            )
        ).sorted()
    }
    
    
    // ✅ 2. Get all unique sizes
    func allSizes(in variants: [Variants]) -> [String] {
        return Array(
            Set(
                variants
                    .compactMap { $0.size }
                    .filter { !$0.isEmpty }
            )
        ).sorted()
    }
    
    
    
    //    func updateCollections(for variants: [Variants]) {
    //
    //        let sizes = allSizes(in: variants)
    //        sizeStore = sizes
    //        let hasSize = !sizes.isEmpty
    //
    //        let colors = colors(
    //            for: hasSize ? sizes.first : nil,
    //            in: variants
    //        )
    //
    //        // UI visibility
    //        storeSizeView.isHidden = !hasSize
    //        storeColorView.isHidden = colors.isEmpty
    //
    //        storeSizeCollection.reloadData()
    //        storeColorCollection.reloadData()
    //    }
    func updateCollections(for variants: [Variants]) {
        
        // sizes
        let sizes = getAllSizes(from: variants)
        sizeStore = sizes
        
        let hasSize = !sizes.isEmpty
        storeSizeView.isHidden = !hasSize
        
        if hasSize {
            sizeSelectionIndex = min(sizeSelectionIndex ?? 0, sizes.count - 1)
        } else {
            sizeSelectionIndex = nil
        }
        
        // selected size
        let selectedSize = hasSize ? sizes[safe: sizeSelectionIndex ?? 0] : nil
        
        // colors
        let colors = getColors(from: variants, selectedSize: selectedSize)
        colorStore = colors
        
        let hasColor = !colors.isEmpty
        storeColorView.isHidden = !hasColor
        
        if hasColor {
            colorSelectionIndex = min(colorSelectionIndex ?? 0, colors.count - 1)
        } else {
            colorSelectionIndex = nil
        }
        
        storeSizeCollection.reloadData()
        storeColorCollection.reloadData()
        
        updateVariantImages()
    }
    
    
    
    //    func images(
    //        for size: String?,
    //        color: String?,
    //        in variants: [Variants]
    //    ) -> [VariantsImages] {
    //
    //        let sizeValue = size?.isEmpty == true ? nil : size
    //        let colorValue = color?.isEmpty == true ? nil : color
    //
    //        return variants
    //            .filter { v in
    //                let matchSize = sizeValue == nil || v.size == sizeValue
    //                let matchColor = colorValue == nil || v.color == colorValue
    //                return matchSize && matchColor
    //            }
    //            .compactMap { $0.image }
    //            .flatMap { $0 }
    //            .filter { ($0.image?.isEmpty == false) }
    //    }
    
    
    
    // MARK: - Variants Helper
    func getSizesWithColors(from variants: [Variants]) -> [String: [String]] {
        
        let grouped = Dictionary(grouping: variants) {
            ($0.size?.isEmpty == true || $0.size == nil) ? "NO_SIZE" : $0.size!
        }
        
        return grouped.mapValues {
            Array(Set($0.compactMap { $0.color })).sorted()
        }
    }
    
    
    func getPrice(for size: String?, color: String?, in variants: [Variants]) -> String? {
        
        let variant = variants.first {
            let sizeMatch =
            size == nil
            ? ($0.size == nil || $0.size?.isEmpty == true)
            : $0.size == size
            
            let colorMatch =
            color == nil ? true : $0.color == color
            
            return sizeMatch && colorMatch
        }
        
        return variant?.price
    }
    
    
    
    
    func updateHeight(for collectionView: UICollectionView, constraint: NSLayoutConstraint) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let itemsPerRow: CGFloat = 6
        let rows = ceil(CGFloat(itemCount) / itemsPerRow)
        
        let spacing = layout.minimumLineSpacing
        let itemWidth = (collectionView.bounds.width - (itemsPerRow - 1) * layout.minimumInteritemSpacing) / itemsPerRow
        let totalHeight = rows * itemWidth + (rows - 1) * spacing
        
        constraint.constant = totalHeight
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeight(for: storeSizeCollection, constraint: storeSizeCollectionHeight)
        updateHeight(for: storeColorCollection, constraint: storeColorCollectionHeight)
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
        
        self.storeSizeCollection.delegate = self
        self.storeSizeCollection.dataSource = self
        self.storeSizeCollection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        self.storeSizeCollection.registerCell(nib: UINib(nibName: "SizeXIB", bundle: nil), identifier: "SizeXIB")
        
        self.storeColorCollection.delegate = self
        self.storeColorCollection.dataSource = self
        self.storeColorCollection.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        self.storeColorCollection.registerCell(nib: UINib(nibName: "SizeXIB", bundle: nil), identifier: "SizeXIB")
        
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
        
        guard let url = URL(string: "\(BASE)post/\(self.postId)") else {
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
        if postDetails?.type?.lowercased() == "store" {
            
            let variants = postDetails?.variants ?? []
            
            let sizeArray = sizeStore ?? []
            let colorArray = colorStore ?? []
            
            let hasSize = !sizeArray.isEmpty
            let hasColor = !colorArray.isEmpty
            
            let viewController = BuyNowVC.instantiate(fromStoryboard: .Store)
            viewController.postDetails = postDetails
            viewController.hidesBottomBarWhenPushed = true
            
            if postDetails?.locations?.isEmpty ?? true {
                viewController.isOnlyShip = true
            }
            
            // ✅ Selected size (optional)
            let selectedSize: String? = {
                guard hasSize,
                      let index = sizeSelectionIndex,
                      index < sizeArray.count else { return nil }
                return sizeArray[index]
            }()
            
            // ✅ Selected color (optional)
            let selectedColor: String? = {
                guard hasColor,
                      let index = colorSelectionIndex,
                      index < colorArray.count else { return nil }
                return colorArray[index]
            }()
            
            viewController.size = selectedSize
            viewController.color = selectedColor
            
            // ✅ Price
            viewController.price = getPrice(
                for: selectedSize,
                color: selectedColor,
                in: variants
            )
            
            // ✅ Variant ID (SAFE for all cases)
            if let variant = variants.first(where: { variant in
                
                let sizeMatch: Bool = {
                    guard let selectedSize = selectedSize else {
                        return variant.size == nil || variant.size?.isEmpty == true
                    }
                    return variant.size == selectedSize
                }()
                
                let colorMatch: Bool = {
                    guard let selectedColor = selectedColor else { return true }
                    return variant.color == selectedColor
                }()
                
                return sizeMatch && colorMatch
            }) {
                viewController.varientID = "\(variant.shopify_variant_id ?? 0)"
            }
            
            // ✅ Validation before proceed
            if hasColor && selectedColor == nil {
                UIAlertController().alertViewWithTitleAndMessage(
                    self,
                    message: "Please select a color to purchase."
                )
                return
            }
            
            if hasSize && selectedSize == nil {
                UIAlertController().alertViewWithTitleAndMessage(
                    self,
                    message: "Please select a size to purchase."
                )
                return
            }
            
            // 🛒 Proceed
            pushViewController(vc: viewController)
        }else{
            let isComplete =  appDelegate.userDetails?.isEmailVerifid().trim().isEmpty ?? true
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
        if appDelegate.reachable.connection != .unavailable {
            
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
        self.sizeSelectionIndex = 0
        self.colorSelectionIndex = 0
        
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
            self.lblDese.text = dice.htmlToPlainText
            bottomLineTop.constant = 10
            bottomLineDese.isHidden = false
        }else{
            bottomLineTop.constant = 0
            bottomLineDese.isHidden = true
        }
        if let condiction = self.postDetails?.condition_name {
            self.lblCondition.text = condiction
        }
        
        if let gender = self.postDetails?.gender_name,let size  = self.postDetails?.sizes?.first?.name {
            self.lblSize.text = "\(gender == "Menswear" ? "Men" : "Women")'s \(size)"
            if postDetails?.categories?.first?.name?.lowercased() == "accessories"{
                self.sizeViewContainer.isHidden = true
            }else{
                self.sizeViewContainer.isHidden = false
            }
        }else{
            self.sizeViewContainer.isHidden = true
        }
        
        if let userPost = self.postDetails?.total_posts ,let username = self.postDetails?.user_username {
            self.lblUserName.text = "@\(username.capitalized) . \(userPost) posts"
        }
        
        self.lblFirstLatter.isHidden = true
        self.imgSellerProfile.setProfileImage(from: self.postDetails?.user_profile_picture ?? "", placeholderName: self.postDetails?.user_name ?? "")
        self.imgSellerProfile.contentMode = .scaleAspectFill
        var categoryList = [String]()
        for i in 0..<(self.postDetails?.categories?.count ?? 0) {
            if let category = self.postDetails?.categories?[i].name {
                categoryList.append(category)
            }
        }
        if let name = self.postDetails?.user_name {
            self.lblSallerName.text = name.capitalized
        }
        
        if let locations = self.postDetails?.locations{
            
            self.lblAddress.text = locations.first?.city
            self.lblAddress.isUserInteractionEnabled = true
            
            // Create the tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            
            // Add the gesture recognizer to the label
            self.lblAddress.addGestureRecognizer(tapGesture)
        }
        
        if self.postDetails?.type?.lowercased() != "store"{
            if let review = self.postDetails?.total_reviews,let rate = self.postDetails?.user_avg_review {
                self.lblRate.text = "\(rate) (\(review) Reviews)"
            }
        }else{
            imgStart.isHidden = true
            self.lblRate.text = ""
            self.lblMoreFromSeller.text = "More from this store"
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
        
        if self.postDetails?.type?.lowercased() == "store"{
            //            sizeViewContainer.isHidden = true
            storeSizeView.isHidden = false
            storeColorView.isHidden = false
            
            viewDidLayoutSubviews()
            // Make sure variants exist
            
            storeColorCollection.reloadData()
            storeSizeCollection.reloadData()
        }else{
            //            sizeViewContainer.isHidden = false
            storeSizeView.isHidden = true
            storeColorView.isHidden = true
        }
        
        updateCollections(for: self.postDetails?.variants ?? [])
        setPrice()
        
    }
    
    func setPrice(isColorTap: Bool = false) {

        let variants = postDetails?.variants ?? []

        let selectedSize = sizeStore?[safe: sizeSelectionIndex ?? 0]
        let selectedColor = colorStore?[safe: colorSelectionIndex ?? 0]

        lblPrice.text = getPrice(
            for: selectedSize,
            color: selectedColor,
            in: variants
        ).map { "$ \($0)" } ?? ""
    }
    
    
    
    func updateVariantImages() {
        
        let variants = postDetails?.variants ?? []
        
        let selectedSize = sizeStore?[safe: sizeSelectionIndex ?? 0]
        let selectedColor = colorStore?[safe: colorSelectionIndex ?? 0]
        
        let images = getImages(
            from: variants,
            selectedSize: selectedSize,
            selectedColor: selectedColor
        )
        
        veriantImages = images
        
        pageControlle.numberOfPages = images.count
        pageControlle.currentPage = 0
        pageControlle.hidesForSinglePage = true
        
        collectionView.reloadData()
        
        debugPrint("Size:", selectedSize ?? "nil")
        debugPrint("Color:", selectedColor ?? "nil")
        debugPrint("Images:", images.count)
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
                            debugPrint(data)
                            self.colorStore = []
                            self.sizeStore = []
                            self.veriantImages = []
                            self.collectionView.reloadData()
                            self.storeSizeCollection.reloadData()
                            self.storeColorCollection.reloadData()
                            
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
                                
                                if self.postDetails?.address_visible == 1{
                                    self.btnFindLocation.isHidden = false
                                }else{
                                    self.btnFindLocation.isHidden = true
                                }
                            }
                            
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
                                self.imgStart.isHidden = true
                                if self.postDetails?.is_sold ?? 0 == 1{
                                    self.btnChetAndByNow.isHidden = true
                                }else{
                                    self.btnChetAndByNow.isHidden = false
                                    self.btnChetAndByNow.setTitle("Buy Now", for: .normal)
                                }
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
                            
                            self.lblStyle.text = "\(self.postDetails?.categories?.last?.name ?? "")"
                            if self.postDetails?.type?.lowercased() != "store"{
                                self.pageControlle.numberOfPages = self.postImageVideo.count
                                self.pageControlle.currentPage = 0
                                self.pageControlle.hidesForSinglePage = true
                            }
                            self.collectionView.reloadData()
                            self.moreSallerCollection.reloadData()
                            self.recentViewCollection.reloadData()

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
                    //                    viewController.sizeSelectionIndex = self.sizeSelectionIndex
                    //                    viewController.colorSelectionIndex = self.colorSelectionIndex
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
            if self.postDetails?.type?.lowercased() == "store"{
                return self.veriantImages?.count ?? 0
            }else{
                return self.postImageVideo.count
            }
        }
        else if collectionView == self.moreSallerCollection{
            return self.userPost.count
        }
        else if collectionView == storeSizeCollection {
            return sizeStore?.count ?? 0
        }
        else if collectionView == storeColorCollection {
            return colorStore?.count ?? 0
        }
//            else if collectionView == storeSizeCollection || collectionView == storeColorCollection {
//
//            let variants = postDetails?.variants ?? []
//            
//            // Get valid sizes (non-empty)
//            let sizes = allSizes(in: variants)
//            let hasSize = !sizes.isEmpty
//            sizeStore = sizes
//            // SIZE COLLECTION
//            if collectionView == storeSizeCollection {
//                
//                storeSizeView.isHidden = !hasSize
//                return hasSize ? (sizeStore?.count ?? 0) : 0
//            }
//            
//            // COLOR COLLECTION
//            else {
//                
//                let colorsArray: [String]
//                
//                if hasSize {
//                    // Size + Color product
//                    guard let selectedIndex = sizeSelectionIndex,
//                          selectedIndex < sizes.count else {
//                        debugPrint("⚠️ Invalid sizeSelectionIndex")
//                        storeColorView.isHidden = true
//                        return 0
//                    }
//                    
//                    let selectedSize = sizes[selectedIndex]
//                    colorsArray = colors(for: selectedSize, in: variants)
//                    
//                } else {
//                    // 🔥 Color-only product
//                    colorsArray = Array(Set(variants.compactMap { $0.color })).sorted()
//                }
//                
//                storeColorView.isHidden = colorsArray.isEmpty
//                colorCount = colorsArray.count
//                return colorStore?.count  == 0 ? colorsArray.count : colorStore?.count ?? 0
//            }
//        }
        else  {
            return self.relatedPost.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            
            let objet = self.postImageVideo[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageXIB", for: indexPath) as! PostImageXIB
            if self.postDetails?.type?.lowercased() == "store"{
                let data = self.veriantImages?[indexPath.row]
                cell.imgPost.setImageFast(with: data?.image ?? "")
            }else{
                //            cell.imgPlay.isHidden = true
                if objet.type == "image"{
                    cell.imgPost.setImageFast(with: objet.image ?? "")
                }
                else {
                    if let url = objet.video {
                        if let videourl = URL.init(string: url){
                            self.getThumbnailImageFromVideoUrl(url:videourl) { (thumbImage) in
                                cell.imgPost.image = thumbImage
                                // cell.imgPost.contentMode = .scaleToFill
                                // cell.imgPlay.isHidden = false
                            }
                        }
                    }
                }
            }
            return cell
        }else if collectionView == storeSizeCollection || collectionView == storeColorCollection {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "SizeXIB",
                for: indexPath
            ) as! SizeXIB
            
            cell.lblTitle.layer.cornerRadius = 4
            cell.lblTitle.clipsToBounds = true
            
            let isSizeCollection = (collectionView == storeSizeCollection)
            
            // Data source
            let text: String?
            let isSelected: Bool
            
            if isSizeCollection {
                guard let sizeStore = sizeStore,
                      indexPath.item < sizeStore.count else {
                    cell.lblTitle.text = ""
                    return cell
                }
                
                text = sizeStore[indexPath.item]
                isSelected = (indexPath.item == sizeSelectionIndex)
                
            } else {
                guard let colorStore = colorStore,
                      indexPath.item < colorStore.count else {
                    cell.lblTitle.text = ""
                    return cell
                }
                
                text = colorStore[indexPath.item]
                isSelected = (indexPath.item == colorSelectionIndex)
            }
            
            // UI
            cell.lblTitle.text = text
            cell.lblTitle.backgroundColor = isSelected ? .blackTheme : .white
            cell.lblTitle.textColor = isSelected ? .appWhite : .blackTheme
            
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
                if self.postDetails?.type?.lowercased() == "store"{
                    var veriantData = [ImagesVideoModel]()
                    for index in self.veriantImages ?? []{
                        let data = ["image":index.image ?? ""]
                        if let images = ImagesVideoModel(JSON: data){
                            veriantData.append(images)
                        }
                    }
                    viewController.imagesList = veriantData
                }else{
                    var imag = [String]()
                    for i in 0..<self.postImageVideo.count{
                        imag.append(postImageVideo[i].image ?? "")
                    }
                    viewController.imagesList = self.postImageVideo
                }
                viewController.visibleIndex = indexPath.item
                self.navigationController?.present(viewController, animated: true, completion: nil)
            }
        }else if collectionView == storeColorCollection{
            if indexPath.row == colorSelectionIndex{
                return
            }
            colorSelectionIndex = indexPath.row
            
            storeColorCollection.reloadData()
            
            setPrice(isColorTap: true)
            
            updateVariantImages()
        }else if collectionView == storeSizeCollection{
            if indexPath.row == sizeSelectionIndex{
                return
            }
            sizeSelectionIndex = indexPath.row

            let selectedSize = sizeStore?[indexPath.row]

            colorStore = getColors(
                from: postDetails?.variants ?? [],
                selectedSize: selectedSize
            )

            colorSelectionIndex = 0

            storeSizeCollection.reloadData()
            storeColorCollection.reloadData()

            setPrice()
            updateVariantImages()
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
        }else if collectionView == self.storeSizeCollection || collectionView == self.storeColorCollection{
            let itemsPerRow: CGFloat = 5
            let spacing: CGFloat = 8 // adjust based on your layout’s minimumInteritemSpacing
            let totalSpacing = (itemsPerRow - 1) * spacing
            
            // subtract total spacing from collection width, then divide by items per row
            let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
            return CGSize(width: width, height: 33)
        } else {
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
        }else if collectionView == self.storeSizeCollection || collectionView == self.storeColorCollection {
            return  8
        }else{
            return 10
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.collectionView{
            return interitemSpace
        }else if collectionView == self.storeSizeCollection || collectionView == self.storeColorCollection {
            return  8
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

extension OtherPostDetailsVC{
    
    func getImages(
        from variants: [Variants],
        selectedSize: String?,
        selectedColor: String?
    ) -> [VariantsImages] {
        
        let filtered = variants.filter { v in
            let matchSize = (selectedSize?.isEmpty != false) || v.size == selectedSize
            let matchColor = (selectedColor?.isEmpty != false) || v.color == selectedColor
            return matchSize && matchColor
        }
        
        let allImages = filtered.flatMap { $0.image ?? [] }
        
        return uniqueImages(allImages)
    }
    
    func uniqueImages(_ items: [VariantsImages]) -> [VariantsImages] {
        var seen: Set<Int> = []
        var result: [VariantsImages] = []
        
        for item in items {
            if let id = item.id, !seen.contains(id) {
                seen.insert(id)
                result.append(item)
            }
        }
        return result
    }
    
    func getColors(from variants: [Variants], selectedSize: String?) -> [String] {
        let filtered = variants.filter { variant in
            guard let size = selectedSize, !size.isEmpty else {
                return true
            }
            return variant.size == size
        }
        
        return filtered
            .compactMap { $0.color }
            .filter { !$0.isEmpty }
            .uniquePreservingOrder()
    }
    
    func getAllSizes(from variants: [Variants]) -> [String] {
        let sizes = variants.compactMap { $0.size }.uniquePreservingOrder()
        
        return sizes.sorted {
            (globalSizeOrder.firstIndex(of: $0) ?? 999) <
                (globalSizeOrder.firstIndex(of: $1) ?? 999)
        }
    }
    
}

extension Array where Element: Hashable {
    func uniquePreservingOrder() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
