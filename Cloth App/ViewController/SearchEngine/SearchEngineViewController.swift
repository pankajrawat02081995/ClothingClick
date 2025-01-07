//
//  SearchEngineViewController.swift
//  ClothApp
//
//  Created by Apple on 01/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class SearchEngineViewController: BaseViewController {
    
    @IBOutlet weak var searchViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var searchViewContainer: UIView!
    @IBOutlet weak var btnViewItems: CustomButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSearchEngine: UIButton!
    @IBOutlet weak var btnColse: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnMySize: UIButton!
    @IBOutlet weak var tblsearchlist: UITableView!
    @IBOutlet weak var btnSearchItemMembers: UIButton!
//    @IBOutlet weak var imgSearch: UIImageView!
    
    var selectSubcategory = [ChildCategories?]()
    var select = false
    var category = ""
    var saveSearch = false
    var priceTypename = ""
    var selectCategory = [String]()
    var categoryList = [ "Department","Category" ,"Size","Style","Brand Name","Color","Condition","Seller","Price","Distance","Sort"]
    var categoryListData = ""
    var viewCount = 0
    var isOnlyFilter : Bool?
    var selectGenderId : String?
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let imageSearch = UIImage(named: "search_ic")?.imageWithColor(color1: UIColor.init(hex: "606060"))
////        self.imgSearch.image = imageSearch
//       
//        if self.saveSearch {
//            self.btnViewItems.setTitle("Add to saved Search", for: .normal)
//        }
//        else {
//            self.callViewCount()
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilterSingleton.share.filter = Filters()
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        self.tblsearchlist.reloadData()
        
        self.lblTitle.text = self.isOnlyFilter ?? false ? "Filter" : "Filter Search"
        self.searchViewContainer.isHidden = self.isOnlyFilter ?? false
        self.searchViewContainerHeight.constant = self.isOnlyFilter ?? false ? 0 : 90
        if appDelegate.mySize == true{
            self.btnMySize.isSelected = false
            self.btnMySize_Clicked(self)
        }else{
            self.btnMySize.isSelected = true
            self.btnMySize_Clicked(self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FilterSingleton.share.filter.is_only_count = "1"
        FilterSingleton.share.getFilterData { model in
            self.btnViewItems.setTitle("View \(model?.total_posts ?? 0) Items", for: .normal)
            self.tblsearchlist.reloadData()
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        FilterSingleton.share.filter = Filters()
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        self.popViewController()
    }
    
    @IBAction func btnSearchItemMembers_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "SearchItemAndMembersViewController") as! SearchItemAndMembersViewController
        viewController.FromSearchEngine = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.viewCount != 0 {
            let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
            viewController.titleStr = "Search Results"
//            viewController.isMySize = appDelegate.isMySize
//            viewController.selectSubCategoryId = appDelegate.selectSubCategoryId
//            viewController.selectSizeId = appDelegate.selectSizeId
//            viewController.selectColorId = appDelegate.selectColorId
//            viewController.selectConditionId = appDelegate.selectConditionId
//            viewController.selectPriceId = appDelegate.selectPriceId
//            viewController.priceFrom = appDelegate.priceFrom
//            viewController.priceTo = appDelegate.priceTo
//            viewController.selectDistnce = appDelegate.selectDistnce
//            viewController.selectSellerId = appDelegate.selectSellerId
//            viewController.selectBrandId = appDelegate.selectBrandId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnClear_Clicked(_ button: Any) {
        appDelegate.mySize = false
//        self.btnMySize.isSelected = false
//        self.tblsearchlist.reloadData()
//        self.categoryListData = ""
//        self.select = false
//        appDelegate.isMySize = "0"
//        appDelegate.selectBrandId = ""
//        appDelegate.selectGenderId = ""
//        appDelegate.selectSubCategoryId.removeAll()
//        appDelegate.selectPriceId = ""
//        appDelegate.priceFrom = ""
//        appDelegate.priceTo = ""
//        appDelegate.selectDistnce = ""
//        appDelegate.selectSizeId = ""
//        appDelegate.selectConditionId = ""
//        appDelegate.selectSellerId = ""
//        appDelegate.selectColorId = ""
//        
        FilterSingleton.share.filter = Filters()
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        self.tblsearchlist.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.callViewCount()
        })
        
    }
    
    @IBAction func btnMySize_Clicked(_ sender: Any) {
        self.btnMySize.isSelected = !self.btnMySize.isSelected
        if self.btnMySize.isSelected {
            appDelegate.mySize = true
            appDelegate.isMySize = "1"
            FilterSingleton.share.filter.is_mysize = "0"
            FilterSingleton.share.filter.sizes = appDelegate.userDetails?.user_size?.map { String($0) }.joined(separator: ",")
            FilterSingleton.share.selectedFilter.sizes = appDelegate.userDetails?.user_sizes_details?.joined(separator: ",")
            FilterSingleton.share.selectedFilter.gender_id = appDelegate.userDetails?.gender_name ?? ""
            FilterSingleton.share.filter.gender_id = "\(appDelegate.userDetails?.user_selected_gender ?? 0)"
            //            self.categoryList = self.categoryList.filter { $0 != "Size"}
        }
        else {
            appDelegate.mySize = false
            appDelegate.isMySize = "0"
            FilterSingleton.share.filter.is_mysize = "0"
            FilterSingleton.share.selectedFilter.sizes = ""
            FilterSingleton.share.filter.sizes = ""
            
            FilterSingleton.share.selectedFilter.gender_id = ""
            FilterSingleton.share.filter.gender_id = ""
            
//            if !self.categoryList.contains("Size"){
//                self.categoryList.insert("Size", at: 2)
//            }
            appDelegate.selectGenderId = ""
        }
        self.categoryList = self.categoryList.removeDuplicates()
        self.tblsearchlist.reloadData()
        self.callViewCount()
    }
}

extension SearchEngineViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchingListCell", for: indexPath) as! SearchingListCell
        let indexData = self.categoryList[indexPath.row]
        cell.lblCategoryList.text = indexData

        switch indexData{
        case "Department" :
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.gender_id ?? ""
        case "Category" :
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.categories ?? ""
        case "Size":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.sizes ?? ""
        case "Brand Name":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.brand_id ?? ""
        case "Color":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.colors ?? ""
        case "Condition":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.condition_id ?? ""
        case "Seller":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.seller ?? ""
        case "Price":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.price_to?.isEmpty == false ? "Under $\(FilterSingleton.share.selectedFilter.price_to ?? "")" : ""
        case "Distance":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.distance?.isEmpty == false ? "\(FilterSingleton.share.selectedFilter.distance ?? "")" : ""
        case "Sort":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.sort_by ?? ""

        case "Style":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.style ?? ""

        default:
            cell.lblSelectCategory.text = ""
            break
        }
            
//        })
        
//        if appDelegate.mySize {
//            if self.categoryList[indexPath.row] == "Brands"{
//                cell.imgSearch.isHidden = false
//                //                cell.comstraintLeding.constant = 3
//                let imageSearch = UIImage(named: "search_ic")?.imageWithColor(color1: UIColor.black)
//                cell.lblSelectCategory.isHidden = false
//                cell.lblCategoryList.text = self.categoryList[indexPath.row]
//                cell.imgSearch.image = imageSearch
//                if self.select {
//                    if self.category == self.categoryList[indexPath.row] {
//                        cell.lblSelectCategory.text = self.categoryListData
//                    }
//                    //                    else {
//                    //                        cell.lblSelectCategory.text = ""
//                    //                    }
//                }
//                else {
//                    cell.lblSelectCategory.text = ""
//                }
//            }
//            else {
//                cell.imgSearch.isHidden = true
//                //                cell.comstraintLeding.constant = -20
//                cell.lblSelectCategory.isHidden = false
//                cell.lblCategoryList.text = self.categoryList[indexPath.row]
//                if self.selectCategory.count == 0 {
//                    cell.lblSelectCategory.text = ""
//                }
//                else {
//                    if self.select {
//                        if self.category == self.categoryList[indexPath.row] {
//                            cell.lblSelectCategory.text = self.categoryListData
//                        }
//                        else {
//                            cell.lblSelectCategory.text = ""
//                        }
//                    }
//                    else {
//                        cell.lblSelectCategory.text = ""
//                    }
//                }
//            }
//        }
//        else {
//            if self.categoryList[indexPath.row] == "Brands"{
//                cell.imgSearch.isHidden = false
//                //                cell.comstraintLeding.constant = 3
//                let imageSearch = UIImage(named: "search_ic")?.imageWithColor(color1: UIColor.black)
//                cell.imgSearch.image = imageSearch
//                cell.lblCategoryList.text = self.categoryList[indexPath.row]
//                if self.select {
//                    if self.category == self.categoryList[indexPath.row] {
//                        cell.lblSelectCategory.text = self.categoryListData
//                    }
//                    else {
//                        cell.lblSelectCategory.text = ""
//                    }
//                }
//                else {
//                    cell.lblSelectCategory.text = ""
//                }
//            }
//            else if Int(self.categoryList[indexPath.row]) == 0 {
//                
//            }
//            else {
//                cell.imgSearch.isHidden = true
//                //                cell.comstraintLeding.constant = -20
//                cell.lblCategoryList.text = self.categoryList[indexPath.row]
//                if self.select {
//                    if self.category == self.categoryList[indexPath.row] {
//                        cell.lblSelectCategory.text = self.categoryListData
//                    }
//                    else {
//                        cell.lblSelectCategory.text = ""
//                    }
//                }
//                else {
//                    cell.lblSelectCategory.text = ""
//                }
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.categoryList[indexPath.row] == "Department" {
            
            let vc = DepartmentVC.instantiate(fromStoryboard: .Dashboard)
            vc.genderDelegate = self
            vc.isFromSearch = false
            vc.genderId = Int(self.selectGenderId ?? "") ?? -1
            vc.isEdit = self.selectGenderId?.isEmpty == false
            self.pushViewController(vc: vc)
        }else if self.categoryList[indexPath.row] == "Sort" {
            let vc = SortVC.instantiate(fromStoryboard: .Sell)
            self.pushViewController(vc: vc)
        }else if self.categoryList[indexPath.row] == "Style" {
            let vc = StyleVC.instantiate(fromStoryboard: .Sell)
            vc.isFromFilterSection = true
            self.pushViewController(vc: vc)
        }
        else if self.categoryList[indexPath.row] == "Category" {
            
            let vc = NewCategoryVC.instantiate(fromStoryboard: .Sell)
            self.pushViewController(vc: vc)
        }
        else if self.categoryList[indexPath.row] == "Brand Name" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandsSearchViewController") as! BrandsSearchViewController
            //            viewController.BrandSearchDeleget = self
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            //            viewController.viewCount = self.viewCount
            //            viewController.isMySize = appDelegate.isMySize
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Color" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
            //            viewController.conditionColorSizeDelegate = self
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            //            viewController.viewCount = self.viewCount
            //            viewController.isMySize = appDelegate.isMySize
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Condition" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
            //            viewController.conditionColorSizeDelegate = self
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            //            viewController.viewCount = self.viewCount
            //            viewController.isMySize = appDelegate.isMySize
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Seller" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
            //            viewController.conditionColorSizeDelegate = self
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            var sellerList = [
                Seller(id: 1,name: "Individual Sellers",isSelect: false),
                Seller(id: 2,name: "Store",isSelect: false),
                //                Seller(id: 3,name: "Brand",isSelect: false)
            ]
            //            if let i = sellerList.firstIndex(where: { $0.id == Int(appDelegate.selectSellerId) }) {
            //                sellerList[i].isSelect = true
            //            }
            viewController.list = sellerList
            //            viewController.viewCount = self.viewCount
            //            viewController.isMySize = appDelegate.isMySize
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Price" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "PiseSearchViewController") as! PiseSearchViewController
            //            viewController.priceDelegate = self
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            //            viewController.viewCount = self.viewCount
            //            if appDelegate.selectPriceId == "1"{
            //                viewController.selected = appDelegate.priceTo
            //                viewController.priceId = Int(appDelegate.selectPriceId) ?? 0
            //            }else{
            //                viewController.selected = self.priceTypename
            //            }
            //viewController.selected = appDelegate.priceTo
            //            viewController.isMySize = appDelegate.isMySize
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Distance" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "DistanceViewController") as! DistanceViewController
            //            viewController.distanceDelegate = self
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            //            viewController.isMySize = appDelegate.isMySize
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Size" {
            
            let viewController = self.storyboard?.instantiateViewController(identifier: "SizeViewController") as! SizeViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
          //  viewController.saveSearch = true
            viewController.saveSearch = false
            self.navigationController?.pushViewController(viewController, animated: true)
            //            }
        }
    }
}

class SearchingListCell : UITableViewCell{
    @IBOutlet weak var lblCategoryList: UILabel!
    @IBOutlet weak var lblSelectCategory: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var comstraintLeding: NSLayoutConstraint!
}

extension SearchEngineViewController : GenderDelegate {
    func selectGendr(gender: MySizeModel?) {
        self.selectGenderId = String(gender?.gender_id ?? 0 )
        self.selectCategory.removeAll()
        
        self.categoryListData = gender?.gender_name ?? ""
        self.select = true
        self.category = self.categoryList[0]
        //        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.tblsearchlist.reloadData()
        
    }
}
extension SearchEngineViewController : CategorySUbCategoryselectionDelegate {
    func categoryAndSUbCategoryList(categoryLise: [ChildCategories?], Selecte: Bool, index: Int, categoryIds: [String], categoryName: [String], category: String, selectCategorys: [String]) {
        self.selectCategory.removeAll()
        self.categoryListData = ""
        for i in 0..<selectCategorys.count{
            self.selectCategory.append(selectCategorys[i])
        }
        for i in 0..<categoryLise.count {
            self.selectCategory.append(categoryLise[i]?.name ?? "")
        }
        self.category = category
        self.select = Selecte
       // self.categoryListData = self.selectCategory.joined(separator: ",")
        self.categoryListData = appDelegate.selectSubCategoryName.joined(separator: ",")
        //self.saveSearchData.append(self.selectCategory.joined(separator: ","))
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }

}
extension SearchEngineViewController : DistnceDelegate , PriceDelegate {
   
    func selctedPrice(price: String, Selecte: Bool, index: Int, hearderTitel: String, priceId: Int, priceFrom: String, priceTO: String) {
        self.select = Selecte
        self.category = hearderTitel
        if priceId == 1 {
            appDelegate.selectPriceId = String(priceId)
            appDelegate.priceTo = priceTO
            appDelegate.priceFrom = priceFrom
            self.selectCategory.removeAll()
            self.selectCategory.append("Under $ \(priceTO) ")
            //            self.saveSearchData.append("Under $ \(priceTO) ")
        }
        else {
            appDelegate.selectPriceId = String(priceId)
            appDelegate.priceTo = ""
            appDelegate.priceFrom = ""
            self.selectCategory.removeAll()
            self.selectCategory.append(price)
            self.priceTypename = price
            //            self.saveSearchData.append(price)
        }
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func selctedDistnce(distnce: String, Selecte: Bool, index: Int, hearderTitel: String) {
        self.selectCategory.removeAll()
        self.selectCategory.append("\(distnce) km")
        appDelegate.selectDistnce = distnce
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
}

extension SearchEngineViewController : ConditionColorSizeDelegate,BrandSearchDelegate,SizeDelegate {

    func selctedSeller(seller: [Seller?], Selecte: Bool, index: Int, hearderTitel: String) {
        var id  = [String]()
        self.selectCategory.removeAll()
        for i in 0..<seller.count {
            self.selectCategory.append(seller[i]?.name ?? "")
            id.append(String(seller[i]?.id ?? 0))
        }
        appDelegate.selectSellerId = id.joined(separator:",")
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func selctedBrandeName(name: BrandeSearchModel?, Selecte: Bool, index: Int, hearderTitel: String) {
        self.selectCategory.removeAll()
        self.selectCategory.append(name?.name ?? "")
        appDelegate.selectBrandId = String(name?.brand_id ?? 0 )
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func selctedCondeition(Condition: [Conditions?], Selecte: Bool, index: Int, hearderTitel : String) {
        print(Condition)
        print(hearderTitel)
        self.selectCategory.removeAll()
        for i in 0..<Condition.count{
            self.selectCategory.append(Condition[i]?.name ?? "")
            appDelegate.selectConditionId = String(Condition[i]?.id ?? 0)
        }
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
        
    }
    
    func selctedSize(Size: [Sizes?], Selecte: Bool, index: Int, hearderTitel : String) {
        var id  = [String]()
        self.selectCategory.removeAll()
        for i in 0..<Size.count{
            self.selectCategory.append(Size[i]?.name ?? "")
            id.append(String(Size[i]?.id ?? 0))
        }
        self.select = Selecte
        self.category = hearderTitel
        appDelegate.selectSizeId = id.joined(separator: ",")
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
        
    }
    
    func selctedColor(color: [Colors?], Selecte: Bool, index: Int, hearderTitel : String) {
        var id = [String]()
        self.selectCategory.removeAll()
        for i in 0..<color.count{
            self.selectCategory.append(color[i]?.name ?? "")
            id.append(String(color[i]?.id ?? 0))
        }
        self.select = Selecte
        self.category = hearderTitel
        appDelegate.selectColorId = id.joined(separator: ",")
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
}

extension SearchEngineViewController {
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
//            let param = ["is_mysize":  appDelegate.isMySize ,
//                         "gender_id" : appDelegate.selectGenderId,
//                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
//                         "sizes" : appDelegate.selectSizeId,
//                         "colors" : appDelegate.selectColorId ,
//                         "condition_id" : appDelegate.selectConditionId ,
//                         "distance" : appDelegate.selectDistnce ,
//                         "seller" : appDelegate.selectSellerId ,
//                         "brand_id" : appDelegate.selectBrandId ,
//                         "notification_item_counter" : "",
//                         "name" :  "",
//                         "price_type" : appDelegate.selectPriceId ,
//                         "price_from" : appDelegate.priceFrom ,
//                         "price_to" : appDelegate.priceTo,
//                         "is_only_count" : "1" ,
//                         "page" : "0"
//            ]
            FilterSingleton.share.filter.is_only_count = "1"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: dict) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.viewCount = data.total_posts ?? 0
                            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
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
