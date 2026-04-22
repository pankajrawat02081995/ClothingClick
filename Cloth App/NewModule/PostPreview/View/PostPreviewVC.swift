//
//  PostPreviewVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 06/06/24.
//

import UIKit
import IBAnimatable
import Kingfisher

class PostPreviewVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var otherProductCollection: UICollectionView!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var lblUserNameAndPostCOunt: UILabel!
    @IBOutlet weak var imgUser: AnimatableImageView!
    @IBOutlet weak var lblNameUser: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblCondtion: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var pageControle: UIPageControl!
    @IBOutlet weak var productCollection: UICollectionView!
    
    
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
    //    var productImage = [UIImage]()
    var productImageUrl = [[String:Any]]()
    var postImageVideo = [URL]()
    var productModelItem = ""
    var price = ""
    var priceType = ""
    var discripction = ""
    var edit = false
    var mediaItems = [MediaItem]()
    var imagesList = [ImagesVideoModel]()
    
    var posts = [Posts]()
    var userData : UserDetailsModel?
    var productImage = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userData = appDelegate.userDetails
        self.setupPostCollection()
        self.setupData()
        self.callGetUserpost(userId: String(userData?.id ?? 0), tabId: "1",sort_by: "",sort_value: "", isShowHud: true)
        
    }
    
    func setupData(){
        self.lblSize.text = "\(self.savegenderId?.name ?? "") \(self.selectSize?.name ?? "")"
        self.lblCondtion.text = self.selectCondiction?.name ?? ""
        self.lblTitle.text = self.productModelItem
        self.lblPrice.text = "$\(self.price)"
        self.lblDescription.text = self.discripction
        self.lblProductName.text = self.productModelItem
        self.lblUserName.text = self.addresslist.first??.city ?? ""
        
        self.lblNameUser.text = appDelegate.userDetails?.name ?? ""
        self.lblUserNameAndPostCOunt.text = "@\(appDelegate.userDetails?.username ?? "") . \(appDelegate.userDetails?.totalPosts ?? 0) posts"
        self.lblReview.text = "\(appDelegate.userDetails?.avg_rating ?? 0) (\(appDelegate.userDetails?.total_reviews ?? 0) Reviews)"
//        if appDelegate.userDetails?.photo.isEmpty == true{
//            
//        }else{
//            self.imgUser.setImageFast(with: appDelegate.userDetails?.photo ?? "")
//        }
        self.imgUser.setProfileImage(from: appDelegate.userDetails?.photo ?? "", placeholderName: appDelegate.userDetails?.name ?? "")

        
        for index in self.productImage{
            
            if index["isLocal"] as? Bool == true{
                let dict = ["type": "Image",
                            "image1": index["image_url"] as? UIImage as Any] as [String : Any]
                if let imageData = ImagesVideoModel(JSON: dict) {
                    imagesList.append(imageData)
                }
            }else{
                let dict = ["type": "Image",
                            "image1": index["image_url"] as? String ?? ""] as [String : Any]
                if let imageData = ImagesVideoModel(JSON: dict) {
                    imagesList.append(imageData)
                }
            }

            
        }
    }
    
    func setupPostCollection(){
        self.pageControle.numberOfPages = self.productImage.count
        self.pageControle.currentPage = 0
        self.productCollection.delegate = self
        self.productCollection.dataSource = self
        
        self.otherProductCollection.delegate = self
        self.otherProductCollection.dataSource = self
        
        self.productCollection.register(UINib(nibName: "PostImageXIB", bundle: nil), forCellWithReuseIdentifier: "PostImageXIB")
        self.otherProductCollection.register(UINib(nibName: "HomePageBrowserXIB", bundle: nil), forCellWithReuseIdentifier: "HomePageBrowserXIB")
    }
    
    @IBAction func mapOnTap(_ sender: UIButton) {
        let lat = self.addresslist.first??.latitude ?? ""
        
        let log = self.addresslist.first??.longitude ?? ""
        // let address = self.postDetails?.locations?[0].address
        // let postal_code = self.postDetails?.locations?[0].postal_code
        let viewController = FindLocation.instantiate(fromStoryboard: .Main)
        viewController.addresslist = self.addresslist
        viewController.lat = (lat as NSString).doubleValue
        viewController.log = (log as NSString).doubleValue
        viewController.usertype = appDelegate.userDetails?.role_id ?? 0
        // viewController.adddressArea =  "\(address ?? "") \(postal_code ?? "")"
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: viewController)
    }
    
    @IBAction func shareOnPress(_ sender: UIButton) {
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
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
            param?["page"] = "1"
            param?["user_id"] = userId
            param?["tab"] = tabId
//            param?.removeValue(forKey: "slectedCategories")
            APIManager().apiCall(of:HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.USER_POSTS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if response.dictData != nil {
                            if let data = response.dictData {
                                
                                if let post = data.posts {
                                    for temp in post {
                                        self.posts.append(temp)
                                    }
                                }
                            }
                            self.otherProductCollection.reloadData()
                            
                            if self.posts.count == 0 {
                                //                            self.lblNoData.isHidden = true
                                if sort_by != "size"  {
                                    //                                self.btnSort.isHidden = false
                                }
                            }
                            else
                            {
                                //                            self.lblNoData.isHidden = true
                                //                            self.btnSort.isHidden = false
                                
                            }
                            
                            self.otherProductCollection.reloadData()
                            //  if self.currentPage == 1 {
                            self.otherProductCollection.layoutIfNeeded()
                            //                            self.constHeightForCVCProduct.constant = self.CVCProduct.contentSize.height
                            // }
                            //                        self.scrollView.isScrollEnabled = true
                            //                        self.loading = false
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
}


extension PostPreviewVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.otherProductCollection{
            return self.posts.count
        }else{
            return self.productImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.otherProductCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
            let objet = self.posts[indexPath.item]
            cell.imgProduct.setImageFast(with: objet.image?.first?.image ?? "")
//            cell.imgProduct.contentMode = .scaleToFill
            
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
                        cell.lblPrice.text = "\(producttype)"
                    }
                }
            }
            return cell
        }else{
            let item = self.productImage[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageXIB", for: indexPath) as! PostImageXIB
            
            if item["isLocal"] as? Bool == true{
                cell.imgPost.image = item["image_url"] as? UIImage
            }else{
                cell.imgPost.setImageFast(with: item["image_url"] as? String ?? "")
            }
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView  == self.productCollection{
            let viewController = PhotosViewController.instantiate(fromStoryboard: .Main)
            viewController.imagesList = self.imagesList
            viewController.visibleIndex = indexPath.item
            self.navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView  == self.productCollection{
            self.pageControle.currentPage = indexPath.item
        }
    }
    
}

extension PostPreviewVC: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        if (self.otherProductCollection != nil){
            return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 1
    }
    
    fileprivate var interitemSpace: CGFloat {
        if (self.otherProductCollection != nil){
            return 10.0
        }else{
            return 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                        indexPath: IndexPath) -> CGSize {
    
        if collectionView == self.productCollection {
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
        else {
            //            return CGSize(width: 160, height: 233)
            return CGSize(width: (self.otherProductCollection.frame.size.width / 2) - 20, height: 230)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.productCollection{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.productCollection{
            return 0.0
        }
        return interitemSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.productCollection{
            return 0.0
        }
        return interitemSpace
    }
}

extension PostPreviewVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.width
        let horizontalCenter = width / 2
        pageControle.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    func PostPreviewVC(_ scrollView: UIScrollView) {
        self.pageControle.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
