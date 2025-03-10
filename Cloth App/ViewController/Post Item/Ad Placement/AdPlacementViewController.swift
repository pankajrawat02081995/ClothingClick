//
//  AdPlacementViewController.swift
//  ClothApp
//
//  Created by Apple on 19/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import CHIPageControl
import AVKit

class AdPlacementViewController: BaseViewController {
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    // @IBOutlet weak var constCenterForbtnDelete: NSLayoutConstraint!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnItemsold: CustomButton!
    @IBOutlet weak var btnItemView: CustomButton!
    @IBOutlet weak var btnSellItemsFasterWithCoins: UIButton!
    @IBOutlet weak var CVimages: UICollectionView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductType: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var imgFavourite: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var lblProductSizeTitel: UILabel!
    @IBOutlet weak var ConstTopForlblProductSizeTitel: NSLayoutConstraint!
    @IBOutlet weak var lblProductSize2: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblProductGender: UILabel!
    @IBOutlet weak var lblProductCategory: UILabel!
    @IBOutlet weak var imgProductColor: CustomImageView!
    @IBOutlet weak var lblProductColor: UILabel!
    @IBOutlet weak var lblProductWitchStore: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var txtProductDetails: UITextView!
    @IBOutlet weak var lblProductTimAndDate: UILabel!
    @IBOutlet weak var lblPromotTime: UILabel!
    @IBOutlet weak var imgPromot: UIImageView!
    @IBOutlet weak var viewSellItemFaster: CustomView!
    @IBOutlet weak var pageControlView: UIPageControl!
    
    var typeOfLogin :[String] = ["Store","User","Brand"]
    
    var userId = ""
    var postId = ""
    var postDetails : PostDetailsModel?
    var postImageVideo = [ImagesVideoModel]()
    var isEdited = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.userDetails?.role_id == 2 {
            self.btnEdit.isHidden = false
            // self.constCenterForbtnDelete.constant = 70
        }
        else if appDelegate.userDetails?.role_id == 1 {
            self.btnEdit.isHidden = false
            // self.constCenterForbtnDelete.constant = 70
        }
        else if appDelegate.userDetails?.role_id == 3 {
            self.btnEdit.isHidden = false
            //  self.constCenterForbtnDelete.constant = 70
        }
        self.callPostDetails(postId: self.postId)
        
    }
    
    @IBAction func btnLocation_Clicked(_ button: UIButton) {
        if self.postDetails?.locations?.count ?? 0 > 0{
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
    }
    @IBAction func btnLike_Clicked(_ button: UIButton) {
        if (postDetails?.isItemSold() ?? false){
            UIAlertController().alertViewWithTitleAndMessage(self, message: "This item is sold")
        }
        else {
            if self.btnLike.isSelected{
                if let id = self.postDetails?.id {
                    self.callPostFavourite(action_type: "1", postId:"\(id)" )
                }
            }
            else {
                if let id = self.postDetails?.id {
                    self.callPostFavourite(action_type: "0", postId:"\(id)" )
                }
            }
            self.btnLike.isSelected = !self.btnLike.isSelected
        }
    }
    
    @IBAction func btnShare_Clicked(_ button: UIButton) {
        //        let url = URL.init(string: "\(SERVER_URL)share/post/\(self.postId)")!
        //        let objectsToShare = ["Hi,", url] as [Any]
        //        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        ////        activityVC.popoverPresentationController?.sourceView = sender
        //        self.present(activityVC, animated: true, completion: nil)
        let text = "Check out my post on Clothing Click"
        let url = URL.init(string: "\(SERVER_URL)share/post/\(self.postId)")!
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems:  [text, url], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnDelete_Clicked(_ button: UIButton) {
        if let postId = self.postDetails?.id {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to Delete?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: .default, handler: { (action) in
                self.callPostDelete(postId: String(postId))
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnEdit_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "PostItemsizeConditionColorViewController") as! PostItemsizeConditionColorViewController
        viewController.postDetails = self.postDetails
        viewController.edit = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnItemsold_Clicked(_ button: UIButton) {
        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to sell this item?", preferredStyle: .alert)
        alert.setAlertButtonColor()
        let yesAction: UIAlertAction = UIAlertAction.init(title: "YES", style: .default, handler: { (action) in
            self.callItemSold(postId: self.postId)
        })
        let noAction: UIAlertAction = UIAlertAction.init(title: "NO", style: .default, handler: { (action) in
        })
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnItemView_Clicked(_ button: UIButton) {
        //        let viewController = self.storyboard?.instantiateViewController(identifier: "ItemsSoldCongratulationsViewController") as! ItemsSoldCongratulationsViewController
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnSellItemsFasterWithCoins_Clicked(_ button: UIButton) {
        if self.lblPromotTime.text == "Promote Expired" || self.lblPromotTime.text == "" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "PromoteViewController") as! PromoteViewController
            viewController.postDetail = self.postDetails
            //        viewController.isGotoHome = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Please wait for your current promotion to expire.", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                
            })
            
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setData() {
        self.btnItemView.setTitle("\(String(self.postDetails?.post_views ?? 0)) Views", for: .normal)
        if let is_show = postDetails?.isPromotShow() {
            self.imgPromot.isHidden = is_show
            if let imeg = postDetails?.isPromotImage(){
                self.imgPromot.image = UIImage.init(named: imeg)
            }
            
            if let strDate = self.postDetails?.isPromotExpDate(){
                if strDate != ""{
                    self.lblPromotTime.isHidden = false
                    let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                    let dateFormatter = DateFormatter()
                    
                    let today = Date()
                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    let todaydate = dateFormatter.string(from: today)
                    let createdate = dateFormatter.string(from: date)
                    if let d1 = dateFormatter.date(from: todaydate), let d2 = dateFormatter.date(from: createdate) {
                        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: d1, to: d2)
                        
                        if components.day! >= 0{
                            self.lblPromotTime.text = "\(components.day ?? 0) days, \(components.hour ?? 0) hrs"
                        }else{
                            self.lblPromotTime.text = "Promote Expired"
                        }
                    }
                    // self.lblPromotTime.text = Date().offsetFrom(date: date)
                    //Date().offset1(from: date)//offset(from: date)
                }
            }
        }
        else {
            self.imgPromot.isHidden = true
            self.lblPromotTime.isHidden = true
        }
        if self.postDetails?.isItemSold() ?? false{
            self.btnItemsold.alpha = 0.5
            self.btnItemsold.isUserInteractionEnabled = false
            self.viewSellItemFaster.isHidden = true
        }
        
        if let brandName = self.postDetails?.brand_name {
            self.lblBrandName.text = brandName
        }
        if let productType = self.postDetails?.title {
            self.lblProductType.text = productType
        }
        
        if let saletype = self.postDetails?.is_sale {
            if saletype == 1 {
                if let price = self.postDetails?.sale_price {
                    self.lblProductPrice.text = "$ \(price)"
                }
            }else{
                if let pricetypename = self.postDetails?.price_type_name {
                    if pricetypename == "Price"{
                        if let price = self.postDetails?.price {
                            self.lblProductPrice.text = "$ \(price.formatPrice())"
                        }
                    }else{
                        self.lblProductPrice.text = pricetypename.formatPrice()
                    }
                }
            }
        }else{
            if let pricetypename = self.postDetails?.price_type_name {
                self.lblProductPrice.text = "\(pricetypename)"
            }
        }
        
        var categoryList = [String]()
        for i in 0..<(self.postDetails?.categories?.count ?? 0) {
            if let category = self.postDetails?.categories?[i].name {
                categoryList.append(category)
            }
        }
        self.lblProductCategory.text = categoryList.joined(separator: ",")
        if let dice = self.postDetails?.description {
            self.txtProductDetails.text = dice
        }
        if let condiction = self.postDetails?.condition_name {
            self.lblProductCondition.text = condiction
        }
        var sizeList = [String]()
        if let size  = self.postDetails?.sizes {
            if size.count != 0 {
                self.lblProductSizeTitel.isHidden = false
                self.lblProductSize2.isHidden = false
                if let size = size[0].name {
                    self.lblProductSize.text = size
                }
                
                for i in 0..<size.count{
                    
                    if let size = size[i].name{
                        sizeList.append(size)
                    }
                }
                self.lblProductSize2.text = sizeList.joined(separator: ",")
            }
            else {
                self.ConstTopForlblProductSizeTitel.constant = -self.lblProductSizeTitel.frame.height
                self.lblProductSizeTitel.isHidden = true
                self.lblProductSize2.isHidden = true
            }
            
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
                
            }
        }
        if let gender = self.postDetails?.gender_name {
            self.lblProductGender.text = gender
        }
        if let color = self.postDetails?.colors {
            self.imgProductColor.isHidden = true
            //            self.lblProductColor.text = color[0].name
            //            let colorCode = color[0].colorcode
            //            let newColorCode = colorCode?.replace("#", replacement: "")
            //            self.imgProductColor.backgroundColor = UIColor.init(hex: String(newColorCode ?? "" ))
            var colorname = [String]()
            for i in 0..<color.count{
                if let name = color[i].name{
                    colorname.append(name)
                }
            }
            self.lblProductColor.text = colorname.joined(separator: ",")
        }
        if let seller = self.postDetails?.user_type {
            if seller == 1 {
                self.lblProductWitchStore.text = "User"
            }
            else if seller == 2{
                self.lblProductWitchStore.text = "Store"
            }
            else {
                self.lblProductWitchStore.text = "Brand"
            }
        }
        if let strDate = self.postDetails?.created_at{
            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
            self.lblProductTimAndDate.text = Date().offset(from: date)
        }
        
        
    }
}

extension AdPlacementViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postImageVideo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let objet = self.postImageVideo[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        cell.imgPlay.isHidden = true
        if objet.type == "image"{
            let urlString = objet.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            cell.imgProductImages.setImageFast(with: urlString)
        }
        else {
            if let url = objet.video {
                
                if let videourl = URL.init(string: url){
                    cell.imgPlay.isHidden = false
                    self.getThumbnailImageFromVideoUrl(url:videourl) { (thumbImage) in
                        cell.imgProductImages.image = thumbImage
                        
                    }
                }
            }
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        else{
            let viewController = self.storyboard?.instantiateViewController(identifier: "PhotosViewController") as! PhotosViewController
            viewController.imagesList = self.postImageVideo
            viewController.visibleIndex = indexPath.item
            self.navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControlView.currentPage = indexPath.section
    }
    
}

extension AdPlacementViewController: UICollectionViewDelegateFlowLayout {
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

extension AdPlacementViewController: UIScrollViewDelegate{
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

extension AdPlacementViewController {
    func callPostDetails(postId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id":  postId
            ]
            
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_DETAILS.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.postDetails = data
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
                            self.pageControlView.numberOfPages = self.postImageVideo.count
                            self.pageControlView.currentPage = 0
                            self.pageControlView.hidesForSinglePage = true
                            self.CVimages.reloadData()
                            self.setData()
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
                         "action_type":  action_type]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.imgFavourite.image = UIImage.init(named: "like-ic")
                    }
                    else {
                        self.imgFavourite.image = UIImage.init(named: "like_ic")
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
    
    func callPostDelete(postId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    self.getUserDetele()
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
    
    func getUserDetele() {
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.AUTOLOGIN.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            //                           self.startWithAuth(userData: userDetails)
                            self.navigationController?.popViewController(animated: true)
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
    
    func callItemSold(postId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId
                         
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_SOLD.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "ItemsSoldCongratulationsViewController") as! ItemsSoldCongratulationsViewController
                    viewController.postId = String(self.postDetails?.id ?? 0)
                    self.navigationController?.pushViewController(viewController, animated: true)
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
