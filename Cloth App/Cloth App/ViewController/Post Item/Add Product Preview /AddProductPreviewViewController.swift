//
//  AddProductPreviewViewController.swift
//  ClothApp
//
//  Created by Apple on 16/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import AVKit

class AddProductPreviewViewController: BaseViewController {
    
    @IBOutlet weak var CVimages: UICollectionView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductType: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductPriceType: UILabel!
    @IBOutlet weak var constTopForlblProductPriceType: NSLayoutConstraint!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var txtViewDiscripction: UITextView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblProductGender: UILabel!
    @IBOutlet weak var lblProductCategory: UILabel!
    @IBOutlet weak var lblProductColor: UILabel!
    @IBOutlet weak var lblProductWitchStore: UILabel!
    @IBOutlet weak var imgColor: CustomImageView!
    @IBOutlet weak var pageControlView: UIPageControl!
    
    @IBOutlet weak var lblProductSizeTitle: UILabel!
    @IBOutlet weak var lblProductConditionTitle: UILabel!
    
    var savegenderId : CategoryModel?
    var selectCategorySubCategory = [Categorie]()
    var selectCategory : Categorie?
    var selectSubcategory : ChildCategories?
    var priceList = [Price_types?]()
    var addresslist = [Locations?]()
    var addressIdLIst = [String]()
    var brandSearchList : BrandeSearchModel?
    var selectSize : Size?
    var selectCondiction : Conditions?
    var selectColor = [Colors?]()
    var productImage = [UIImage]()
    var productImageUrl = [[String:Any]]()
    var postImageVideo = [URL]()
    var productModelItem = ""
    var price = ""
    var priceType = ""
    var discripction = ""
    var edit = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setData()
        
    }
    
    func setData () {
        var sizeArre = [String]()
        var categoryArre = [String]()
        if let brandeName = self.brandSearchList?.name{
            self.lblBrandName.text =  brandeName
        }
        self.lblProductType.text = self.productModelItem
        if let condiction = self.selectCondiction?.name {
            self.lblProductCondition.text = condiction
        }
        if self.priceType == "Price"{
            self.lblProductPriceType.isHidden = false
            self.constTopForlblProductPriceType.constant = 4.5
            self.lblProductPrice.text = "$ \(self.price.formatPrice())"
            //self.lblProductPriceType.text = self.priceType
        }else{
            self.lblProductPriceType.isHidden = false
            self.constTopForlblProductPriceType.constant = 4.5
            self.lblProductPrice.text = self.priceType.formatPrice()
        }
        
//        self.lblProductPriceType.text = self.priceType
        self.txtViewDiscripction.text = self.discripction
        if let size = self.selectSize?.name {
            self.lblProductSize.text = size
            self.lblSize.text = size
        }
        if let seller = appDelegate.userDetails?.role_id {
            if seller == 1 {
               
                self.btnLocation.isHidden = false
            }
            else if seller == 2{
                
                self.btnLocation.isHidden = false
            }
            else {
              
                self.btnLocation.isHidden = true
              
            }
        }
        if appDelegate.userDetails?.role_id == 1 {
            if self.addresslist.count != 0 {
              if let city = self.addresslist[0]?.city{
                        if city == ""{
                            if let area = self.addresslist[0]?.area{
                                if area == ""{
                                self.btnLocation.setTitle(area, for: .normal)
                                }else{
                                    self.btnLocation.setTitle(area, for: .normal)
                                }
                            }
                        }
                  else{
                        self.btnLocation.setTitle(city, for: .normal)
                    }
                }
            }
        }else if appDelegate.userDetails?.role_id == 2{
            if self.addresslist.count == 1 {
              if let city = self.addresslist[0]?.city{
                        if city == ""{
                            if let area = self.addresslist[0]?.area{
                                if area == ""{
                                self.btnLocation.setTitle(area, for: .normal)
                                }else{
                                    self.btnLocation.setTitle(area, for: .normal)
                                }
                            }
                        }
                  else{
                        self.btnLocation.setTitle(city, for: .normal)
                    }
                }
            }else{
            self.btnLocation.setTitle("\(self.addresslist.count) select location", for: .normal)
            }
        }
        if self.edit {
            for i in 0..<(self.selectCategorySubCategory.count ) {
                if let category = self.selectCategorySubCategory[i].name {
                    categoryArre.append(category)
                }
            }
            self.lblProductCategory.text = categoryArre.joined(separator: ",")
            self.lblProductType.text = categoryArre.joined(separator: ",")
        }
        else {
            if let category = self.selectCategory?.name{
                if let subcategory = self.selectSubcategory?.name {
                    self.lblProductCategory.text =  "\(subcategory),\(category)"
                }
                else {
                    self.lblProductCategory.text =  "\(category)"
                }
            }
        }
        
        if let gender = self.savegenderId?.name {
            self.lblProductGender.text = gender
        }
        //        `if let color = self.selectColor[0]?.name{
        //            self.lblProductColor.text = color
        //        `}
        self.imgColor.isHidden = true
        var colorName = [String]()
        for i in 0..<self.selectColor.count {
            if let name = self.selectColor[i]?.name{
                colorName.append(name)
            }
            
        }
        self.lblProductColor.text = colorName.joined(separator: ",")
        
        if let colorcode = self.selectColor[0]?.colorcode {
            let newColorCode = colorcode.replace("#", replacement: "")
            self.imgColor.backgroundColor = UIColor.init(hex: String(newColorCode ))
        }
        if self.postImageVideo.count == 0 {
            self.pageControlView.numberOfPages = self.productImage.count
        }
        else {
            self.pageControlView.numberOfPages = self.productImage.count + 1
        }
       
        if let seller = appDelegate.userDetails?.role_id {
            if seller == 1 {
                self.lblProductWitchStore.text = "User"
            }
            else if seller == 2{
                self.lblProductWitchStore.text = "Store"
            }
            else {
                self.lblProductWitchStore.text = "Brand"
                self.lblProductConditionTitle.isHidden = true
                self.lblProductSizeTitle.isHidden = true
                self.lblProductCondition.isHidden = true
                self.lblProductSize.isHidden = true
            }
        }
        self.pageControlView.currentPage = 0
        self.pageControlView.hidesForSinglePage = true
        self.CVimages.reloadData()
    }
    @IBAction func btnFindLocation_Clicked(_ button: UIButton) {
        let lat = self.addresslist[0]?.latitude
        let log = self.addresslist[0]?.longitude
       // let address = self.postDetails?.locations?[0].address
       // let postal_code = self.postDetails?.locations?[0].postal_code
        let viewController = self.storyboard?.instantiateViewController(identifier: "FindLocation") as! FindLocation
        viewController.addresslist = self.addresslist
        viewController.lat = (lat! as NSString).doubleValue
        viewController.log = (log! as NSString).doubleValue
        viewController.usertype = appDelegate.userDetails?.role_id ?? 0
       // viewController.adddressArea =  "\(address ?? "") \(postal_code ?? "")"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AddProductPreviewViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.postImageVideo.count == 0 {
            return self.productImageUrl.count
        }
        else {
            return self.productImageUrl.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCell", for: indexPath) as! ImagesCell
        cell.imgPlay.isHidden = true
        if self.productImageUrl.count == indexPath.item {
            self.getThumbnailImageFromVideoUrl(url: self.postImageVideo[0]) { (thumbImage) in
                cell.imgProductImages.image = thumbImage
                cell.imgPlay.isHidden = false
            }
        }
        else {
            if let url = self.productImageUrl[indexPath.item]["image_url"] as? String {
                cell.imgProductImages.setImageFast(with: url)
            }
            if let image = self.productImageUrl[indexPath.item]["image_url"] as? UIImage {
                cell.imgProductImages.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.productImageUrl.count == indexPath.item {
            let videoURL = postImageVideo[0]
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
        else {
            var postImageVideo = [ImagesVideoModel]()
            for i in 0..<self.productImageUrl.count{
                let image = self.productImageUrl[i]["image_url"] as? UIImage
                if image != nil {
                let dict = ["type": "Image",
                            "image1": image as Any] as [String : Any]
                let imageData = ImagesVideoModel.init(JSON: dict)
                postImageVideo.append(imageData!)
                }
                else{
                    let dict = ["type": "Image",
                                "image": self.productImageUrl[i]["image_url"] as Any] as [String : Any]
                    let imageData = ImagesVideoModel.init(JSON: dict)
                    postImageVideo.append(imageData!)
                }
            }
            for i in 0..<self.postImageVideo.count{
                let dict = ["type": "video",
                            "video":  self.postImageVideo[i].absoluteString] as [String : Any]
                let videoData = ImagesVideoModel.init(JSON: dict)
                postImageVideo.append(videoData!)
            }
            

            let viewController = self.storyboard?.instantiateViewController(identifier: "PhotosViewController") as! PhotosViewController
            //                viewController.imageUrl = imageUrl
            viewController.imagesList = postImageVideo
            viewController.visibleIndex = indexPath.item
            self.navigationController?.present(viewController, animated: true, completion: nil)
           
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControlView.currentPage = indexPath.item
    }
    
}

extension AddProductPreviewViewController: UICollectionViewDelegateFlowLayout {
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

extension AddProductPreviewViewController: UIScrollViewDelegate{
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
