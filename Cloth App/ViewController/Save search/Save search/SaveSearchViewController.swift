//
//  SaveSearchViewController.swift
//  ClothApp
//
//  Created by Apple on 05/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class SaveSearchViewController: BaseViewController {
    
    @IBOutlet weak var searchTitleViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var searchTitleView: UIView!
    @IBOutlet weak var notifyViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var searchContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var btnMySize: UIButton!
    @IBOutlet weak var tblsearchlist: UITableView!
    @IBOutlet weak var txtItemCount: CustomTextField!
    @IBOutlet weak var txtItemAddName: CustomTextField!
    @IBOutlet weak var viewCancelSave: UIView!
    @IBOutlet weak var viewCancelSaveEdit: UIView!
    @IBOutlet weak var btnCancel: CustomButton!
    @IBOutlet weak var btnSave: CustomButton!
    @IBOutlet weak var btnCancelEdit: CustomButton!
    @IBOutlet weak var btnSaveEdit: CustomButton!
    @IBOutlet weak var btnDelet: UIButton!
    @IBOutlet weak var btnClearAll: UIButton!
    @IBOutlet weak var constHeightForTblView: NSLayoutConstraint!
    
    var saveSearch = false
    var edit = false
    var select = false
    var category = ""
    var categoryListData = ""
    var selectCategory = [String]()
    var saveSearchData = [String]()
    var selectSubCategoryId = [String]()
    var selectSubCategoryName = [String]()
    var selectGenderId = ""
    var selectDistnce = ""
    var selectSellerId = ""
    var selectBrandId = ""
    var selectConditionId = ""
    var selectSizeId = ""
    var selectColorId = ""
    var selectPriceId = ""
    var priceFrom = ""
    var priceTypename = ""
    var priceTo = ""
    var isMySize = "0"
    var categoryList = [ "Department","Category","Size","Style","Brand Name","Color","Condition","Seller","Price","Distance"]
    var mySize = false
    var saveSearchId = ""
    var saveSearchDetailsData : SaveSearchDetailsModel?
    var viewCount = 0
    @IBOutlet weak var lblTitle: UILabel!
    var isOnlySearch : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.saveSearch == false{
            FilterSingleton.share.filter = Filters()
            FilterSingleton.share.selectedFilter = FiltersSelectedData()
            self.tblsearchlist.reloadData()
        }
        
        if self.isOnlySearch ?? false == true{
            self.lblTitle.text = "Filter"
            self.searchContainerView.isHidden = false
            self.searchContainerHeight.constant = 90
            self.searchTitleView.isHidden = true
            self.searchTitleViewHeigh.constant = 0
            self.notifyView.isHidden = true
            self.btnCancel.isHidden = true
            self.notifyViewHeigh.constant = 0
            self.btnSave.setTitle("View Results", for: .normal)
        }else{
            self.btnCancel.isHidden = false
            self.lblTitle.text = "Saved Search"
            self.searchContainerView.isHidden = true
            self.searchContainerHeight.constant = 0
            self.searchTitleView.isHidden = false
            self.searchTitleViewHeigh.constant = 96
            self.notifyView.isHidden = false
            self.notifyViewHeigh.constant = 62
        }
        if self.edit {
            self.viewCancelSave.isHidden = true
            self.viewCancelSaveEdit.isHidden = false
            self.callSaveSearchDetails()
        }else{
            self.viewCancelSave.isHidden = false
            self.viewCancelSaveEdit.isHidden = true
        }
        self.tblsearchlist.reloadData()
        self.tblsearchlist.layoutIfNeeded()
        self.constHeightForTblView.constant = self.tblsearchlist.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblsearchlist.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
    }
    
    @IBAction func btnCancelEdit_Clicked(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDelet_Clicked(_ button: UIButton) {
        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.setAlertButtonColor()
        let yesAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: .default, handler: { (action) in
            self.callDeleteSaveSearch(saveSearchId: self.saveSearchId)
        })
        let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
        })
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnClearAll_Clicked(_ button: UIButton) {
        //        self.saveSearchData.removeAll()
        //        self.txtItemAddName.text = ""
        //        self.txtItemCount.text = ""
        //        self.tblsearchlist.reloadData()
        //        self.select = false
        //        appDelegate.category = ""
        //        appDelegate.selectSubCategoryId = [String]()
        //        appDelegate.selectSubCategoryName = [String]()
        //        appDelegate.selectGenderId = ""
        //        appDelegate.selectDistnce = ""
        //        appDelegate.selectSellerId = ""
        //        appDelegate.selectBrandId = ""
        //        appDelegate.selectConditionId = ""
        //        appDelegate.selectSizeId = ""
        //        appDelegate.selectColorId = ""
        //        appDelegate.selectPriceId = ""
        //        appDelegate.priceFrom = ""
        //        appDelegate.priceTo = ""
        //        appDelegate.isMySize = "0"
        //        appDelegate.mySize = false
        //
        //        self.selectSubCategoryId = [String]()
        //        self.selectSubCategoryName = [String]()
        //        self.selectGenderId = ""
        //        self.selectDistnce = ""
        //        self.selectSellerId = ""
        //        self.selectBrandId = ""
        //        self.selectConditionId = ""
        //        self.selectSizeId = ""
        //        self.selectColorId = ""
        //        self.selectPriceId = ""
        //        self.priceFrom = ""
        //        self.priceTypename = ""
        //        self.priceTo = ""
        //        self.isMySize = "0"
        self.txtItemAddName.text = ""
        self.txtItemCount.text = ""
        FilterSingleton.share.filter = Filters()
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        self.tblsearchlist.reloadData()
        //        self.popViewController()
    }
    
    @IBAction func btnSave_Clicked(_ button: UIButton) {
        
        print( "Mysize: \(self.isMySize)")
        print("Gender: \(self.selectGenderId)")
        print("Category: \(self.selectSubCategoryId.joined(separator: ","))")
        print("Size: \(self.selectSizeId)")
        print("Color: \(self.selectColorId)")
        print("Condition: \(self.selectConditionId)")
        print("km: \(self.selectDistnce)")
        print("Seller: \(self.selectSellerId)")
        print("Brand: \(self.selectBrandId)")
        print("NotifiactionCount: \(self.txtItemCount.text ?? "")")
        print("Save name: \(self.txtItemAddName.text ?? "")")
        print("Price: \(self.selectPriceId)")
        print("pTo: \(self.priceTo)")
        print("pFrom: \(self.priceFrom)")
        
//        if self.selectGenderId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select gender")
//        }
//        else if self.selectSubCategoryId.count == 0 {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select category")
//        }
//        else if self.selectSizeId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select size")
//        }
//        else if self.selectBrandId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select brand")
//        }
//        else if self.selectColorId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select color")
//        }
//        else if self.selectConditionId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select condition")
//        }
//        else if self.selectSellerId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select seller")
//        }
//        else if self.selectPriceId == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select price")
//        }
//        else if self.selectDistnce == "" {
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select distnce")
//        }
        if self.txtItemCount.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter notify count")
        }
        else if self.txtItemAddName.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter title of save search")
        }
//        else if self.selectGenderId == "" && self.isMySize == "0"{
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select gender")
//        }
//        else if self.selectSizeId == "" && self.isMySize == "0"{
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select size")
//        }
        else {
            if self.edit {
//                if self.isMySize == "1"{
//                    self.selectGenderId = ""
//                }
                self.callEditSaveSearch()
            }
            else {
//                if self.isMySize == "1"{
//                    self.selectGenderId = ""
//                }
                self.callSaveSearch()
            }
        }
    }
    
    @IBAction func btnMySize_Clicked(_ button: Any) {
//        self.btnMySize.isSelected = !self.btnMySize.isSelected
//        if self.btnMySize.isSelected {
//            self.mySize = true
//            self.isMySize = "1"
//            FilterSingleton.share.filter.is_mysize = "1"
//            self.selectGenderId = "\( appDelegate.userDetails?.user_selected_gender ?? 0)"
//            self.categoryList = self.categoryList.filter { $0 != "Department"}
//            self.categoryList = self.categoryList.filter { $0 != "Size"}
//        }
//        else {
//            self.mySize = false
//            self.isMySize = "0"
//            FilterSingleton.share.filter.is_mysize = "0"
//            if !self.categoryList.contains("Department"){
//            self.categoryList.insert("Department", at: 0)
//            }
//            if !self.categoryList.contains("Size"){
//            self.categoryList.insert("Size", at: 2)
//            }
//            self.selectGenderId = ""
//        }
        if self.btnMySize.isSelected {
            self.btnMySize.isSelected = false
            appDelegate.mySize = true
            appDelegate.isMySize = "1"
            
            //            self.categoryList = self.categoryList.filter { $0 != "Size"}
            FilterSingleton.share.filter.is_mysize = "0"
            FilterSingleton.share.selectedFilter.sizes = ""
            FilterSingleton.share.filter.sizes = ""
            
            FilterSingleton.share.selectedFilter.gender_id = ""
            FilterSingleton.share.filter.gender_id = ""
        }
        else {
            self.btnMySize.isSelected = true
            appDelegate.mySize = false
            appDelegate.isMySize = "0"
            
            FilterSingleton.share.filter.is_mysize = "1"
            FilterSingleton.share.filter.sizes = appDelegate.userDetails?.user_size?.map { String($0) }.joined(separator: ",")
            FilterSingleton.share.selectedFilter.sizes = appDelegate.userDetails?.user_sizes_details?.joined(separator: ",")
            FilterSingleton.share.selectedFilter.gender_id = appDelegate.userDetails?.gender_name ?? ""
            FilterSingleton.share.filter.gender_id = "\(appDelegate.userDetails?.user_selected_gender ?? 0)"
            
//            if !self.categoryList.contains("Size"){
//                self.categoryList.insert("Size", at: 2)
//            }
            appDelegate.selectGenderId = ""
        }
        
        self.categoryList = self.categoryList.removeDuplicates()
        self.tblsearchlist.reloadData()
        self.tblsearchlist.layoutIfNeeded()
        self.constHeightForTblView.constant = self.tblsearchlist.contentSize.height
    }
    
    func setDate () {
        if let mysize = self.saveSearchDetailsData?.is_mysize {
            FilterSingleton.share.filter.is_mysize = String(mysize)
            if FilterSingleton.share.filter.is_mysize == "1" {
                self.mySize = true
                self.btnMySize.isSelected = false
                self.btnMySize_Clicked(self)
                
            }
            else {
                self.mySize = false
                self.btnMySize.isSelected = true
                self.btnMySize_Clicked(self)
            }
        }
        if let gender = self.saveSearchDetailsData?.gender_name {
            FilterSingleton.share.selectedFilter.gender_id = gender
        }
        else{
            
        }
        if let genderId = saveSearchDetailsData?.gender_id {
            FilterSingleton.share.filter.gender_id = "\(genderId)"
        }
        
        
        FilterSingleton.share.selectedFilter.categories = self.saveSearchDetailsData?.categories?.map{$0.name ?? ""}.joined(separator: ",")
        FilterSingleton.share.filter.categories = self.saveSearchDetailsData?.categories?.map{"\($0.id ?? 0)"}.joined(separator: ",")

        
        if let category = self.saveSearchDetailsData?.categories {
            var name = [""]
            
            for i in 0..<category.count {
                name.append(category[i].name ?? "")
                self.selectSubCategoryId.append(String(category[i].id ?? 0))
                self.selectSubCategoryName.append(category[i].name ?? "")
            }
            name.removeFirst()
            self.saveSearchData.append(name.joined(separator: ","))
        }
        else{
            self.saveSearchData.append("")
        }

        FilterSingleton.share.selectedFilter.sizes = self.saveSearchDetailsData?.sizes?.map{$0.name ?? ""}.joined(separator: ",")
        FilterSingleton.share.filter.sizes = self.saveSearchDetailsData?.sizes?.map{"\($0.id ?? 0)"}.joined(separator: ",")

        FilterSingleton.share.filter.style = "\(self.saveSearchDetailsData?.style ?? "")"
        FilterSingleton.share.selectedFilter.style = self.saveSearchDetailsData?.style_name ?? ""

        if let brandname = self.saveSearchDetailsData?.brand_name {
            FilterSingleton.share.filter.brand_id = "\(self.saveSearchDetailsData?.brand_id ?? 0)"
            FilterSingleton.share.selectedFilter.brand_id = self.saveSearchDetailsData?.brand_name
        }

        FilterSingleton.share.selectedFilter.colors = self.saveSearchDetailsData?.colors?.map{$0.name ?? ""}.joined(separator: ",")
        FilterSingleton.share.filter.colors = self.saveSearchDetailsData?.colors?.map{"\($0.id ?? 0)"}.joined(separator: ",")

        FilterSingleton.share.selectedFilter.condition_id = self.saveSearchDetailsData?.condition_name ?? ""
        FilterSingleton.share.filter.condition_id = self.saveSearchDetailsData?.condition_id ?? 0 == 0 ? "" : "\(self.saveSearchDetailsData?.condition_id ?? 0)"

        FilterSingleton.share.selectedFilter.seller = self.saveSearchDetailsData?.seller_name ?? ""
        FilterSingleton.share.filter.seller = "\(self.saveSearchDetailsData?.seller ?? "")"

        FilterSingleton.share.selectedFilter.price_from = self.saveSearchDetailsData?.price_from ?? "" == "0" || self.saveSearchDetailsData?.price_from ?? "" == "" ? "" : self.saveSearchDetailsData?.price_from ?? ""
        FilterSingleton.share.filter.price_from = self.saveSearchDetailsData?.price_from ?? "" == "0" || self.saveSearchDetailsData?.price_from ?? "" == "" ? "" : "\(self.saveSearchDetailsData?.price_from ?? "")"
        
        FilterSingleton.share.selectedFilter.price_to = self.saveSearchDetailsData?.price_to ?? "" == "0" || self.saveSearchDetailsData?.price_to ?? "" == "" ? "" : self.saveSearchDetailsData?.price_to ?? ""
        FilterSingleton.share.filter.price_to = self.saveSearchDetailsData?.price_to ?? "" == "0" || self.saveSearchDetailsData?.price_to ?? "" == "" ? "" : "\(self.saveSearchDetailsData?.price_to ?? "")"

        FilterSingleton.share.selectedFilter.distance = self.saveSearchDetailsData?.distance == nil ? "" : "\(self.saveSearchDetailsData?.distance ?? "") Km"
        FilterSingleton.share.filter.distance = "\(self.saveSearchDetailsData?.distance ?? "")"

        
        if let notifictionCount = self.saveSearchDetailsData?.notification_item_counter {
            self.txtItemCount.text = String(notifictionCount)
        }
        
        if let saveName = self.saveSearchDetailsData?.name {
            self.txtItemAddName.text = saveName
        }
        
        self.tblsearchlist.reloadData()
        self.tblsearchlist.layoutIfNeeded()
        self.constHeightForTblView.constant = self.tblsearchlist.contentSize.height
    }
}

extension SaveSearchViewController : UITableViewDelegate,UITableViewDataSource {

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
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.price_to?.isEmpty == false && FilterSingleton.share.selectedFilter.price_to != "0" ? "Under $\(FilterSingleton.share.selectedFilter.price_to ?? "")" : ""
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
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.categoryList[indexPath.row] == "Department" {
////            let viewController = self.storyboard?.instantiateViewController(identifier: "SizeViewController") as! SizeViewController
////            viewController.isFromGender = true
////            viewController.genderDelegate = self
////            viewController.saveSearch = true
////            
////            viewController.selectGenderId = Int(self.selectGenderId) ?? -1
////            self.navigationController?.pushViewController(viewController, animated: true)
//            let vc = DepartmentVC.instantiate(fromStoryboard: .Dashboard)
//            vc.genderDelegate = self
//            vc.genderId = Int(self.selectGenderId) ?? -1
//            vc.isEdit = self.selectGenderId.isEmpty == false
//            self.pushViewController(vc: vc)
//        }
//        else if self.categoryList[indexPath.row] == "Category" {
//            if self.selectGenderId == "" || self.selectGenderId == "-1"{
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Select a gender before you select a category")
//            }else{
//                let viewController = self.storyboard?.instantiateViewController(identifier: "CategoryListViewController") as! CategoryListViewController
//                viewController.categoryDelegate = self
//                viewController.selectIndex = Int(indexPath.row)
//                viewController.selectGenderId = Int(self.selectGenderId) ?? -1
//                viewController.headerTitel = self.categoryList[indexPath.row]
//                viewController.saveSearch = true
//                viewController.selectSubCategoryId = self.selectSubCategoryId
//                viewController.selectSubCategoryName = self.selectSubCategoryName
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
//        }
//        else if self.categoryList[indexPath.row] == "Brand Name" {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandsSearchViewController") as! BrandsSearchViewController
//            viewController.BrandSearchDeleget = self
//            viewController.selectedIndex = indexPath.row
//            viewController.headerTitle = self.categoryList[indexPath.row]
//            viewController.saveSearch = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        else if self.categoryList[indexPath.row] == "Color" {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
//            viewController.conditionColorSizeDelegate = self
//            viewController.selectedIndex = indexPath.row
//            viewController.headerTitle = self.categoryList[indexPath.row]
//            viewController.selectColorId = self.selectColorId
//            viewController.saveSearch = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }else if self.categoryList[indexPath.row] == "Style" {
//            let vc = StyleVC.instantiate(fromStoryboard: .Sell)
//            vc.delegate = self
//            self.pushViewController(vc: vc)
//        }else if self.categoryList[indexPath.row] == "Condition" {
//                let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
//                viewController.conditionColorSizeDelegate = self
//                viewController.selectedIndex = indexPath.row
//                viewController.headerTitle = self.categoryList[indexPath.row]
//                viewController.selectConditionId = self.selectConditionId
//                viewController.saveSearch = true
//                //viewController.categoryList = ["Red","Black","Whit","Green"]
//                self.navigationController?.pushViewController(viewController, animated: true)
////            }
//        }
//        else if self.categoryList[indexPath.row] == "Seller" {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
//            viewController.conditionColorSizeDelegate = self
//            viewController.selectedIndex = indexPath.row
//            viewController.headerTitle = self.categoryList[indexPath.row]
//            var sellerList = [
//                Seller(id: 1,name: "Individual Sellers",isSelect: false),
//                Seller(id: 2,name: "Store",isSelect: false),
////                Seller(id: 3,name: "Brand",isSelect: false)
//            ]
//            
//            if let i = sellerList.firstIndex(where: { $0.id == Int(self.selectSellerId) }) {
//                sellerList[i].isSelect = true
//            }
//            viewController.list = sellerList
//            viewController.saveSearch = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        else if self.categoryList[indexPath.row] == "Price" {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "PiseSearchViewController") as! PiseSearchViewController
//            viewController.priceDelegate = self
//            viewController.selectedIndex = indexPath.row
//            viewController.headerTitle = self.categoryList[indexPath.row]
//            if self.selectPriceId == "1"{
//                viewController.selected = self.priceTo
//            }else{
//                viewController.selected = self.priceTypename
//            }
//            viewController.priceId = Int(self.selectPriceId) ?? 0
//            viewController.saveSearch = true
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        else if self.categoryList[indexPath.row] == "Distance" {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "DistanceViewController") as! DistanceViewController
//            viewController.distanceDelegate = self
//            viewController.selectedIndex = indexPath.row
//            viewController.headerTitle = self.categoryList[indexPath.row]
//            viewController.saveSearch = true
//            viewController.selecteddistance = self.selectDistnce
//            self.navigationController?.pushViewController(viewController, animated: true)
//        }
//        else if self.categoryList[indexPath.row] == "Size" {
//            if self.saveSearch == true{
//                let viewController = self.storyboard?.instantiateViewController(identifier: "SizeViewController") as! SizeViewController
//                viewController.sizeDelegate = self
//                viewController.filterSize = true
//                viewController.selectedIndex = indexPath.row
//                viewController.headerTitle = self.categoryList[indexPath.row]
//                viewController.viewCount = self.viewCount
//                viewController.saveSearch = self.saveSearch
//                viewController.selectSizeId = self.selectSizeId
//                viewController.selectSubCategoryId = self.selectSubCategoryId
//                viewController.selectGenderId = Int(self.selectGenderId) ?? -1
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }else{
//            if appDelegate.selectGenderId == "" {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select gender")
//            }else if appDelegate.selectSubCategoryId.count == 0 {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select category")
//
//            }else{
//                let viewController = self.storyboard?.instantiateViewController(identifier: "SizeViewController") as! SizeViewController
//                viewController.sizeDelegate = self
//                viewController.filterSize = true
//                viewController.selectedIndex = indexPath.row
//                viewController.headerTitle = self.categoryList[indexPath.row]
//                viewController.viewCount = self.viewCount
//                viewController.isMySize = appDelegate.isMySize
//                viewController.selectSubCategoryId = appDelegate.selectSubCategoryId
//                viewController.saveSearch = self.saveSearch
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.categoryList[indexPath.row] == "Department" {
            let vc = DepartmentVC.instantiate(fromStoryboard: .Dashboard)
            vc.genderDelegate = self
            vc.isFromSearch = true
            vc.isSaveSearch = true
            vc.genderId = Int(self.selectGenderId) ?? -1
            vc.isEdit = self.selectGenderId.isEmpty == false
            self.pushViewController(vc: vc)
        }else if self.categoryList[indexPath.row] == "Sort" {
            let vc = SortVC.instantiate(fromStoryboard: .Sell)
            vc.isSaveSearch = true
            self.pushViewController(vc: vc)
        }else if self.categoryList[indexPath.row] == "Style" {
            let vc = StyleVC.instantiate(fromStoryboard: .Sell)
            vc.isFromFilterSection = false
            self.pushViewController(vc: vc)
        }
        else if self.categoryList[indexPath.row] == "Category" {
            let vc = NewCategoryVC.instantiate(fromStoryboard: .Sell)
            vc.isSaveSearch = true
            self.pushViewController(vc: vc)
        }
        else if self.categoryList[indexPath.row] == "Brand Name" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandsSearchViewController") as! BrandsSearchViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.saveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Color" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.saveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Condition" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.saveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Seller" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "ConditionAndSellerViewController") as! ConditionAndSellerViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            var sellerList = [
                Seller(id: 1,name: "Individual Sellers",isSelect: false),
                Seller(id: 2,name: "Store",isSelect: false),
            ]
            viewController.list = sellerList
            viewController.saveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Price" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "PiseSearchViewController") as! PiseSearchViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.saveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Distance" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "DistanceViewController") as! DistanceViewController
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.saveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Size" {
            let viewController = self.storyboard?.instantiateViewController(identifier: "SizeViewController") as! SizeViewController
            viewController.selectedIndex = indexPath.row
            viewController.saveSearch = true
            viewController.headerTitle = self.categoryList[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SaveSearchViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtItemCount {
            let maxLength = 3
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else {
            return true
        }
    }
}

extension SaveSearchViewController : GenderDelegate {
    func selectGendr(gender: MySizeModel?) {
        self.selectGenderId = String(gender?.gender_id ?? -1 )
        self.selectCategory.append("\(gender?.gender_name ?? "")")
        self.categoryListData = gender?.gender_name ?? ""
        self.select = true
        self.category = self.categoryList[0]
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
        self.tblsearchlist.layoutIfNeeded()
        self.constHeightForTblView.constant = self.tblsearchlist.contentSize.height
        
    }
}
extension SaveSearchViewController : CategorySUbCategoryselectionDelegate {
    
    func categoryAndSUbCategoryList(categoryLise: [ChildCategories?], Selecte: Bool, index: Int, categoryIds: [String],categoryName: [String], category: String,selectCategorys: [String]) {
        self.selectCategory.removeAll()
        self.categoryListData = ""
        for i in 0..<categoryLise.count {
            self.selectCategory.append(categoryLise[i]?.name ?? "")
            self.selectSubCategoryName.append(categoryLise[i]?.name ?? "")
        }
        for i in 0..<selectCategorys.count{
            self.selectCategory.append(selectCategorys[i])
        }
        self.category = category
        self.selectSubCategoryId.removeAll()
        for i in 0..<categoryIds.count {
            self.selectSubCategoryId.append(String(categoryIds[i]))
        }
        self.select = Selecte
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.saveSearchData.append(self.selectCategory.joined(separator: ","))
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
}
extension SaveSearchViewController : DistnceDelegate , PriceDelegate {
   
    func selctedPrice(price: String, Selecte: Bool, index: Int, hearderTitel: String, priceId: Int, priceFrom: String, priceTO: String) {
        self.select = Selecte
        self.category = hearderTitel
        if priceId == 1 {
            self.selectPriceId = String(priceId)
            self.priceTo = priceTO
            self.priceFrom = priceFrom
            self.selectCategory.removeAll()
            self.selectCategory.append("Under $ \(priceTO) ")
        }
        else {
            self.selectPriceId = String(priceId)
            self.priceTo = ""
            self.priceFrom = ""
            self.selectCategory.removeAll()
            self.selectCategory.append(price)
            self.priceTypename = price
        }
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func selctedDistnce(distnce: String, Selecte: Bool, index: Int, hearderTitel: String) {
        self.selectCategory.removeAll()
        self.selectCategory.append("\(distnce) km")
        self.selectDistnce = distnce
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
}

extension SaveSearchViewController : ConditionColorSizeDelegate,BrandSearchDelegate ,SizeDelegate,SelectedStyle{
    
    func selectedStyle(ids: [Int], styleName: [String]) {
        
    }
    
    func selctedSeller(seller: [Seller?], Selecte: Bool, index: Int, hearderTitel: String) {
        var id  = [String]()
        self.selectCategory.removeAll()
        for i in 0..<seller.count {
            self.selectCategory.append(seller[i]?.name ?? "")
            id.append(String(seller[i]?.id ?? 0))
        }
        self.selectSellerId = id.joined(separator:",")
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
        
    func selctedBrandeName(name: BrandeSearchModel?, Selecte: Bool, index: Int, hearderTitel: String) {
        self.selectCategory.removeAll()
        self.selectCategory.append(name?.name ?? "")
        self.selectBrandId = String(name?.brand_id ?? 0)
        self.select = Selecte
        self.category = hearderTitel
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
    
    func selctedCondeition(Condition: [Conditions?], Selecte: Bool, index: Int, hearderTitel : String) {
        self.selectCategory.removeAll()
        for i in 0..<Condition.count{
            self.selectCategory.append(Condition[i]?.name ?? "")
            self.selectConditionId = String(Condition[i]?.id ?? 0)
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
        self.selectSizeId = id.joined(separator: ",")
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
        self.selectColorId = id.joined(separator: ",")
        self.categoryListData = self.selectCategory.joined(separator: ",")
        self.tblsearchlist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
}

extension SaveSearchViewController {
    func callSaveSearch() {
        if appDelegate.reachable.connection != .none {
            
//            let param = ["is_mysize":  self.isMySize ,
//                         "gender_id" : self.selectGenderId ,
//                         "categories" : self.selectSubCategoryId.joined(separator: ","),
//                         "sizes" : self.selectSizeId ,
//                         "colors" : self.selectColorId ,
//                         "condition_id" : self.selectConditionId ,
//                         "distance" : self.selectDistnce ,
//                         "seller" : self.selectSellerId ,
//                         "brand_id" : self.selectBrandId ,
//                         "notification_item_counter" : self.txtItemCount.text ?? "",
//                         "name" : self.txtItemAddName.text ?? "",
//                         "price_type" : self.selectPriceId ,
//                         "price_from" : self.priceFrom ,
//                         "price_to" : self.priceTo
//                        ]
            var param = FilterSingleton.share.filter.toDictionary()
            param?.removeValue(forKey: "is_only_count")
            param?.removeValue(forKey: "page")
            param?.removeValue(forKey: "sort_by")
            param?.removeValue(forKey: "sort_value")
            param?["notification_item_counter"] = self.txtItemCount.text ?? ""
            param?["name"] = self.txtItemAddName.text ?? ""
//            param?.removeValue(forKey: "slectedCategories")
            
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SEARCH_CREATE.rawValue, parameters: param ?? [:]) { (response, error) in
                if error == nil {
                    if response != nil {
                        FilterSingleton.share.filter = Filters()
                        FilterSingleton.share.selectedFilter = FiltersSelectedData()
                        self.popViewController()
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
    
    func callSaveSearchDetails() {
        if appDelegate.reachable.connection != .none {
            let param = ["save_search_id": self.saveSearchId ]
            APIManager().apiCallWithMultipart(of: SaveSearchDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SEARCH_DETAILS.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.saveSearchDetailsData = data
                            self.setDate()
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
    
    func callEditSaveSearch() {
        if appDelegate.reachable.connection != .none {
            
//            let param = ["is_mysize":  self.isMySize ,
//                         "gender_id" : self.selectGenderId ,
//                         "categories" : self.selectSubCategoryId.joined(separator: ","),
//                         "sizes" : self.selectSizeId ,
//                         "colors" : self.selectColorId ,
//                         "condition_id" : self.selectConditionId ,
//                         "distance" : self.selectDistnce ,
//                         "seller" : self.selectSellerId ,
//                         "brand_id" : self.selectBrandId ,
//                         "notification_item_counter" : self.txtItemCount.text ?? "",
//                         "name" : self.txtItemAddName.text ?? "",
//                         "price_type" : self.selectPriceId ,
//                         "price_from" : self.priceFrom ,
//                         "price_to" : self.priceTo,
//                         "save_search_id" : self.saveSearchId
//                        ]
            
            var param = FilterSingleton.share.filter.toDictionary()
            param?.removeValue(forKey: "is_only_count")
            param?.removeValue(forKey: "page")
            param?.removeValue(forKey: "sort_by")
            param?.removeValue(forKey: "sort_value")
            param?["notification_item_counter"] = self.txtItemCount.text ?? ""
            param?["name"] = self.txtItemAddName.text ?? ""
            param?["save_search_id"] = self.saveSearchId
//            param?.removeValue(forKey: "slectedCategories")
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SEARCH_UPDATE.rawValue, parameters: param ?? [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let messge = response.message {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: messge)
                        }
                        FilterSingleton.share.filter = Filters()
                        FilterSingleton.share.selectedFilter = FiltersSelectedData()
                        self.popViewController()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callDeleteSaveSearch(saveSearchId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["save_search_id": self.saveSearchId ]
            APIManager().apiCallWithMultipart(of: SaveSearchDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SERCH_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
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
    
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            let param = ["is_mysize":  appDelegate.isMySize ,
                         "gender_id" : appDelegate.selectGenderId,
                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
                         "sizes" : appDelegate.selectSizeId,
                         "colors" : appDelegate.selectColorId ,
                         "condition_id" : appDelegate.selectConditionId ,
                         "distance" : appDelegate.selectDistnce ,
                         "seller" : appDelegate.selectSellerId ,
                         "brand_id" : appDelegate.selectBrandId ,
                         "notification_item_counter" : "",
                         "latitude" : appDelegate.userLocation?.latitude ?? "",
                         "longitude" : appDelegate.userLocation?.longitude ?? "",
                         "name" :  "",
                         "price_type" : appDelegate.selectPriceId ,
                         "price_from" : appDelegate.priceFrom ,
                         "price_to" : appDelegate.priceTo,
                         "is_only_count" : "1" ,
                         "page" : "0"
            ]
            
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.viewCount = data.total_posts ?? 0
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
