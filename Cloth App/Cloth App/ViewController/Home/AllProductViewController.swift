//
//  AllProductViewController.swift
//  ClothApp
//
//  Created by Apple on 27/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import Foundation

class AllProductViewController: BaseViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnShort: UIButton!
    @IBOutlet weak var alertViewForBookMark: UIView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CVProducts: UICollectionView!
    @IBOutlet weak var btnBookMark: UIButton!
    
    var hasAppeared = false
    var isMySize = ""
    var titleStr = ""
    var typeId = ""
    var currentPage = 1
    var hasMorePages = false
    var postList = [Posts?]()
    var selectGenderId = ""
    var sort_by = "date"
    var sort_value = "desc"
    
    var selectSubCategoryId = [String]()
    var selectSizeId = ""
    var selectColorId = ""
    var selectConditionId = ""
    var selectPriceId = ""
    var priceFrom = ""
    var priceTo = ""
    var selectDistnce = ""
    var selectSellerId = ""
    var selectBrandId = ""
    var BarndName = ""
    var isDistance = false
    var sort = false
    var cat_id = ""
    var selectedPostID : Int?
    var isFirstTimeScroll : Bool?
    var isSaveList : Bool?
    var saveSearchId : Int?
    var isShowFilter : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isShowFilter == true{
            FilterSingleton.share.filter = Filters()
            FilterSingleton.share.selectedFilter = FiltersSelectedData()
        }
        
        self.lblTitle.text = self.titleStr
        self.lblNoData.isHidden = true
        self.setupCollectionView()
//        self.titleStr == "Recommended" ||
//        self.titleStr == "Following" ||
        if   self.titleStr == "Top Picks"{
            self.btnShort.isHidden = true
        }

        self.lblHeaderTitle.text = "\(self.titleStr) Listings"
    }
    
    
    func findIndexPath(forUserId postId: Int) -> IndexPath? {
        for (index, item) in postList.enumerated() {
            if (item?.id ?? 0) == postId {
                return IndexPath(item: index%2 == 0 ? index - 1 : index, section: 0)
            }
        }
        return nil
    }

    func scrollToPost(withId postId: Int) {
        if let indexPath = findIndexPath(forUserId: postId) {
            self.scrollToIndexPathConsideringTwoColumns(indexPath: indexPath)
        } else {
            debugPrint("Post with ID \(postId) not found.")
        }
    }

    func scrollToIndexPathConsideringTwoColumns(indexPath: IndexPath) {
        guard let layout = CVProducts.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let itemsPerRow = Int(CVProducts.bounds.width / layout.itemSize.width)
        let rowIndex = indexPath.item / itemsPerRow
        let adjustedIndexPath = IndexPath(item: rowIndex * itemsPerRow, section: indexPath.section)
        self.CVProducts.scrollToItem(at: adjustedIndexPath, at: .top, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.btnShort.isHidden = self.isShowFilter == false  ? true : false
        if self.titleStr == "Search Results" {
            self.btnBookMark.isHidden = self.isSaveList == true
            self.btnShort.isHidden = self.isSaveList == true
            self.callViewCount(isShowHud: true, page: "\(self.currentPage)")
        }
        else if self.titleStr == self.BarndName{
            self.lblTitle.text = self.BarndName
            self.callPopularBrandPost(isShowHud: true, page: "\(self.currentPage)")
        }
        else {
            self.callHomeListDetails(isShowHud: true, listType: typeId, page: "\(self.currentPage)", sort_by: self.sort_by, sort_value: self.sort_value)
        }
        
        if self.titleStr == "Search Results"{
            let bool = defaults.value(forKey: KBookMarkPopup) as? Bool ?? false
            if bool == false{
                self.alertViewForBookMark.isHidden = false
                defaults.set(true, forKey: KBookMarkPopup)
            }else{
                self.alertViewForBookMark.isHidden = true
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.hasAppeared = true
    }
    
    func setupCollectionView(){
        self.CVProducts.delegate = self
        self.CVProducts.dataSource = self
        self.CVProducts.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    @IBAction func gotItOnTap(_ sender: UIButton) {
        defaults.set(true, forKey: KBookMarkPopup)
        self.alertViewForBookMark.isHidden = true
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVProducts)
        if let indexPath = self.CVProducts.indexPathForItem(at: poston) {
            let cell = self.CVProducts.cellForItem(at: indexPath) as! HomePageBrowserXIB
            if (self.postList[indexPath.item]?.isItemSold() ?? false){
                UIAlertController().alertViewWithTitleAndMessage(self, message: "This item is sold")
            }
            else {
                if cell.btnLike.isSelected {
                    if  let postId = self.postList[indexPath.item]?.id {
                        self.callPostFavourite(action_type: "0", postId: String(postId) , index: indexPath.item)
                    }
                }
                else {
                    if  let postId = self.postList[indexPath.item]?.id {
                        self.callPostFavourite(action_type: "1", postId: String(postId) , index: indexPath.item)
                    }
                }
            }
            
        }
    }
    @IBAction func btnShort_Clicked(_ button: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
//        let viewController = self.storyboard?.instantiateViewController(identifier: "ShortByViewController") as! ShortByViewController
//        viewController.sort_by = self.sort_by
//        viewController.sort_value = self.sort_value
//        viewController.shortByDeleget = self
//        viewController.modalPresentationStyle = .custom
//        viewController.transitioningDelegate = customTransitioningDelegate
//        self.present(viewController, animated: true, completion: nil)
        let vc = FilterProductVC.instantiate(fromStoryboard: .Dashboard)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.callBack = {
            if self.titleStr == "Search Results"   {
                self.btnBookMark.isHidden = self.isSaveList == true
                self.btnShort.isHidden = self.isSaveList == true
                self.callViewCount(isShowHud: true, page: "\(self.currentPage)")
            }
            else if self.titleStr == self.BarndName{
                self.lblTitle.text = self.BarndName
                self.callPopularBrandPost(isShowHud: true, page: "\(self.currentPage)")
            }
            else {
                self.callHomeListDetails(isShowHud: true, listType: self.typeId, page: "\(self.currentPage)", sort_by: self.sort_by, sort_value: self.sort_value)
            }
        }
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
    }
    @IBAction func btnBookMark_Clicked(_ button: UIButton) {
//        let viewController = self.storyboard?.instantiateViewController(identifier: "SaveSearchViewController") as! SaveSearchViewController
//        viewController.saveSearch = true
//        self.navigationController?.pushViewController(viewController, animated: true)
        
        let vc = SaveSearchViewController.instantiate(fromStoryboard: .Main)
        vc.edit = false
        vc.saveSearchId = "\(self.saveSearchId ?? 0)"
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
}

extension AllProductViewController : ShortByDelegate{
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        
        self.sort = true
//        if self.titleStr == "Search Results"  || self.titleStr == self.BarndName{
//            self.callViewCount(isShowHud: true, page: "\(self.currentPage)")
//        }
//        else {
//            self.callHomeListDetails(isShowHud: true, listType: typeId, page: "\(self.currentPage)", sort_by: self.sort_by, sort_value: self.sort_value)
//        }
        if self.titleStr == "Search Results"   {
            self.currentPage = 1
            self.callViewCount(isShowHud: true, page: "\(self.currentPage)")
        }
        else if self.titleStr == self.BarndName{
            self.callPopularBrandPost(isShowHud: true, page: "\(self.currentPage)")
        }
        else {
            self.currentPage = 1
            self.callHomeListDetails(isShowHud: true, listType: typeId, page: "\(self.currentPage)", sort_by: self.sort_by, sort_value: self.sort_value)
        }
    }
}

extension AllProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
        let objet = self.postList[indexPath.item]
        
        cell.imgProduct.setImageFast(with: objet?.image?.first?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
        if let is_favourite = objet?.is_favourite {
            cell.btnLike.isSelected = is_favourite
        }
        if let title = objet?.title {
            cell.lblProductName.text = title
        }
        
        if let producttype = objet?.price_type{
            if producttype == "1"{
                if let price = objet?.price {
                    if (objet?.isLblSaleHidden()) == nil {
                        if let salePrice = objet?.sale_price {
                            cell.lblPrice.text = "$ \(salePrice)"
                        }
                    }else {
                        cell.lblPrice.text = "$ \(price.formatPrice())"
                    }
                }
            }
            else{
                if let producttype = objet?.price_type_name{
                    cell.lblPrice.text = "\(producttype.formatPrice())"
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        viewController.postId = String(self.postList[indexPath.item]?.id ?? 0)
//        viewController.indexpath = indexPath
//        viewController.likeDeleget = self
//        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.postId = "\(self.postList[indexPath.item]?.id ?? 0)"
        vc.hidesBottomBarWhenPushed =  self.postList[indexPath.item]?.user_id ?? 0 == appDelegate.userDetails?.id
        self.pushViewController(vc: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.titleStr == "Search Results" {
            if indexPath.item == self.postList.count - 1 && hasMorePages == true {
                currentPage = self.currentPage + 1
                self.callViewCount(isShowHud: false, page: "\(self.currentPage)")
            }
        }
      
        else {
            if indexPath.item == self.postList.count - 1 && hasMorePages == true {
                currentPage = self.currentPage + 1
                if self.titleStr == self.BarndName{
                    self.callPopularBrandPost(isShowHud: true, page: "\(self.currentPage)")
                }else{
                    self.callHomeListDetails(isShowHud: false, listType: self.typeId, page: "\(self.currentPage)", sort_by: self.sort_by, sort_value: self.sort_value)
                }
            }
        }
    }
    
}

extension AllProductViewController: LikeDelegate{
    func Like(like: Bool, indexpath: IndexPath) {
        self.postList[indexpath.item]?.is_favourite = like
        self.CVProducts.reloadItems(at: [indexpath])
    }
}

extension AllProductViewController: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
      
    fileprivate var itemsPerRow: CGFloat {
        return 2.0
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
//        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
//        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
//        let widthPerItem = availableWidth / itemsPerRow
//        return CGSize(width: widthPerItem, height: 222)
        return CGSize(width: (self.CVProducts.frame.size.width / 2) - 20, height: 228)

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

extension AllProductViewController {
    func callHomeListDetails(isShowHud : Bool,listType :String, page: String,sort_by :String, sort_value: String) {
//        var param = ["list_type":  listType,
//                     "page": page,
//                     "sort_by":  sort_by,
//                     "sort_value": sort_value
//                    ]
//        if self.cat_id.isEmpty == false{
//            param["cat_id"] = self.cat_id
//        }
//        
        var param = FilterSingleton.share.filter.toDictionary()
        param?.removeValue(forKey: "is_only_count")
        param?.removeValue(forKey: "notification_item_counter")
        param?["page"] = "\(self.currentPage)"
        param?["cat_id"] = self.cat_id
        param?["list_type"] = listType
        param?.removeValue(forKey: "slectedCategories")
        param?.removeValue(forKey: "categories")

        param?["latitude"] = appDelegate.userLocation?.latitude ?? ""
        param?["longitude"] = appDelegate.userLocation?.longitude ?? ""
        
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.HOME_LIST_POSTLIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.postList.removeAll()
                            }
                            
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            
                            if let post = data.posts {
                                for temp in post {
                                    self.postList.append(temp)
                                }
                            }
                        }
                        
                        if self.postList.count == 0 {
                            self.lblNoData.isHidden = false
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                        }
                        self.CVProducts.reloadData()
                        if self.sort ==  true{
                            self.sort = false
                            if self.postList.count > 0{
                                self.CVProducts.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
                            }
                        }
                    }
                    
                    if self.isFirstTimeScroll == true{
                        self.isFirstTimeScroll = false
                        DispatchQueue.main.async {
                            self.scrollToPost(withId: self.selectedPostID ?? 0)
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callViewCount(isShowHud : Bool , page : String) {
        if appDelegate.reachable.connection != .none {
           
//            var param = [String:Any]()
//            param = ["is_mysize":  self.isMySize ,
//                     "gender_id" : appDelegate.selectGenderId,
//                     "categories" : self.selectSubCategoryId.joined(separator: ","),
//                     "sizes" : self.selectSizeId ,
//                     "colors" : self.selectColorId ,
//                     "condition_id" : self.selectConditionId ,
//                     "distance" : self.selectDistnce ,
//                     "seller" : self.selectSellerId ,
//                     "brand_id" : self.selectBrandId ,
//                     "notification_item_counter" : "",
//                     "name" :  "",
//                     "price_type" : self.selectPriceId ,
//                     "price_from" : self.priceFrom ,
//                     "price_to" : self.priceTo,
//                     "is_only_count" : "0" ,
//                     "sort_by" : self.sort_by,
//                     "sort_value" : self.sort_value,
//                     "page" : "\(self.currentPage)"]
            FilterSingleton.share.filter.is_only_count = "0"
            FilterSingleton.share.filter.page = page
            var param = FilterSingleton.share.filter.toDictionary() ?? [:]
            let searchID = ["save_search_id": "\( self.saveSearchId ?? 0)","page" : "\(page)"]
//            param.removeValue(forKey: "slectedCategories")
            param["latitude"] = appDelegate.userLocation?.latitude ?? ""
            param["longitude"] = appDelegate.userLocation?.longitude ?? ""
            APIManager().apiCallWithMultipart(of: HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: self.isSaveList == true ? APINAME.SAVE_SEARCH_POSTS.rawValue : APINAME.FILTER_POST.rawValue, parameters: self.isSaveList == true ? searchID : param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                if !self.hasAppeared {
                                    self.postList.removeAll()
                                }
                            }
                            
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            
                            if let post = data.posts {
                                for temp in post {
                                    if !self.hasAppeared {
                                        self.postList.append(temp)
                                    }
                                }
                            }
                        }
                        if self.postList.count > 0 {
                            self.lblNoData.isHidden = true
                        }
                        else
                        {
                            self.lblNoData.isHidden = false
                        }
                        self.CVProducts.reloadData()
                        if self.sort ==  true{
                            self.sort = false
                            if self.postList.count > 0{
                            self.CVProducts.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
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
    
    func callPopularBrandPost(isShowHud : Bool , page : String) {
        if appDelegate.reachable.connection != .none {
            var param = [String:Any]()
            param = [
                     "brand_id" : self.selectBrandId ,
                     "sort_by" : self.sort_by,
                     "sort_value" : self.sort_value,
                     "page" : "\(self.currentPage)",
                     "latitude" : appDelegate.userLocation?.latitude ?? "",
                     "longitude" : appDelegate.userLocation?.longitude ?? ""]
            APIManager().apiCallWithMultipart(of: HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.BRAND_POST.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.postList.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            if let post = data.posts {
                                for temp in post {
                                    self.postList.append(temp)
                                }
                            }
                        }
                        if self.postList.count == 0 {
                            self.lblNoData.isHidden = false
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                        }
                        self.CVProducts.reloadData()
                        
                        if self.sort ==  true{
                            self.sort = false
                            if self.postList.count > 0{
                            self.CVProducts.scrollToItem(at: IndexPath.init(item: 0, section: 0), at: UICollectionView.ScrollPosition.top, animated: true)
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
                        self.postList[index]?.is_favourite = true
                        self.CVProducts.reloadItems(at: [IndexPath.init(row: index, section: 0)])
                    }
                    else {
                        self.postList[index]?.is_favourite = false
                        self.CVProducts.reloadItems(at: [IndexPath.init(row: index, section: 0)])
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
