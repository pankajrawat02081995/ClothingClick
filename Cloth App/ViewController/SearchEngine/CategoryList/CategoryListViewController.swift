//
//  CategoryListViewController.swift
//  ClothApp
//
//  Created by Apple on 01/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol CategorySUbCategoryselectionDelegate {
    func categoryAndSUbCategoryList(categoryLise: [ChildCategories?], Selecte:Bool,index : Int,categoryIds: [String],categoryName: [String],category: String,selectCategorys : [String])
}


class CategoryListViewController: BaseViewController {
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblCategorylist: UITableView!
    @IBOutlet weak var btnViewItems: CustomButton!
    
    var headerTitel = ""
    var categoryDelegate : CategorySUbCategoryselectionDelegate!
    var selectIndex = 0
    var genderList = [CategoryModel?]()
    var subCategoryList = [ChildCategories?]()
    var categoryList = [Categorie?]()
    var selectSubcategory = [ChildCategories?]()
    var selectGenderId = -1
    var saveSearch = false
    var categoryname = ""
    var selectSubCategoryId = [String]()
    var selectSubCategoryName = [String]()
    var categoryselectData = [String]()
    var viewCount = 0
    var selectCategorys = [String]()
    var select = false
    var isMySize = ""
    
    override func viewDidAppear(_ animated: Bool) {
        self.callViewCount()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callCategoryList()
        if self.saveSearch {
            self.btnViewItems.setTitle("Add to saved Search", for: .normal)
        }
        else {
            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
        }
    }
    
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.saveSearch {
            for i in 0..<self.categoryList.count {
                if self.categoryList[i]?.isSelect == true{
                    self.selectCategorys.append(self.categoryList[i]?.name ?? "")
                }
            }
            if self.categoryDelegate != nil {
                self.categoryDelegate.categoryAndSUbCategoryList(categoryLise: self.selectSubcategory, Selecte: true, index: self.selectIndex, categoryIds: self.selectSubCategoryId, categoryName: self.selectSubCategoryName, category: self.headerTitel, selectCategorys: self.selectCategorys)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            if self.viewCount != 0 {
                let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                viewController.titleStr = "Search Results"
                viewController.isMySize = self.isMySize
                viewController.selectSubCategoryId = appDelegate.selectSubCategoryId
                viewController.selectSizeId = appDelegate.selectSizeId
                viewController.selectColorId = appDelegate.selectColorId
                viewController.selectConditionId = appDelegate.selectConditionId
                viewController.selectPriceId = appDelegate.selectPriceId
                viewController.priceFrom = appDelegate.priceFrom
                viewController.priceTo = appDelegate.priceTo
                viewController.selectDistnce = appDelegate.selectDistnce
                viewController.selectSellerId = appDelegate.selectSellerId
                viewController.selectBrandId = appDelegate.selectBrandId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    //    @IBAction func btnBack_Clicked(_ button: UIBarButtonItem) {
    //        for i in 0..<self.categoryList.count {
    //            if self.categoryList[i]?.isSelect == true{
    //                self.selectCategorys.append(self.categoryList[i]?.name ?? "")
    //            }
    //        }
    //        if self.categoryDelegate != nil {
    //
    //            self.categoryDelegate.categoryAndSUbCategoryList(categoryLise: self.selectSubcategory,
    //                                                             Selecte: true,
    //                                                             index: self.selectIndex,
    //                                                             categoryIds: self.selectSubcategory.count == 0 ? [] : self.selectSubCategoryId,
    //                                                             categoryName: self.selectSubcategory.count == 0 ? [] : self.selectSubCategoryName,
    //                                                             category: self.selectSubcategory.count == 0 ? "" : self.headerTitel,
    //                                                             selectCategorys: self.selectSubcategory.count == 0 ? [] : self.selectCategorys)
    //        }
    //        self.navigationController?.popViewController(animated: true)
    //    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        for i in 0..<self.categoryList.count {
            if self.categoryList[i]?.isSelect == true{
                self.selectCategorys.append(self.categoryList[i]?.name ?? "")
            }
        }
        if self.categoryDelegate != nil {
            
            self.categoryDelegate.categoryAndSUbCategoryList(categoryLise: self.selectSubcategory,
                                                             Selecte: true,
                                                             index: self.selectIndex,
                                                             categoryIds: self.selectSubcategory.count == 0 ? [] : self.selectSubCategoryId,
                                                             categoryName: self.selectSubcategory.count == 0 ? [] : self.selectSubCategoryName,
                                                             category: self.selectSubcategory.count == 0 ? "" : self.headerTitel,
                                                             selectCategorys: self.selectSubcategory.count == 0 ? [] : self.selectCategorys)
        }
        self.popViewController()
    }
    
    @IBAction func btnClear_Clicked(_ button: UIButton) {
        self.select = false
        
        for i in 0..<self.categoryList.count {
            if self.categoryList[i] != nil {
                self.categoryList[i]!.isSelect = false
            }
        }
        
        //        self.categoryList = self.categoryList.map {
        //            (item: Categorie?) -> Categorie? in
        //            var item1 = item
        //            item1?.isSelect = false
        //            return item1
        //        }
        appDelegate.selectSubCategoryName.removeAll()
        appDelegate.selectSubCategoryId.removeAll()
        self.selectSubCategoryName.removeAll()
        self.selectSubCategoryId.removeAll()
        self.selectSubcategory.removeAll()
        self.categoryselectData.removeAll()
        self.tblCategorylist.reloadData()
        
        self.callViewCount()
        if self.categoryDelegate != nil {
            self.categoryDelegate.categoryAndSUbCategoryList(categoryLise: self.selectSubcategory, Selecte: true, index: self.selectIndex, categoryIds: self.selectSubCategoryId, categoryName: self.selectSubCategoryName, category: self.headerTitel, selectCategorys: self.selectCategorys)
        }
    }
}

extension CategoryListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryLisetCell", for: indexPath) as! CategoryLisetCell
        let objet = self.categoryList[indexPath.row]
        
        if select {
            if !self.saveSearch {
                if appDelegate.selectSubCategoryName.contains(objet?.name ?? "") && objet?.childCategories?.count == 0 {
                    cell.lblCategoryName.text = objet?.name
                    cell.lblSelectCategory.isHidden = true
                    cell.btnDown.isHidden = true
                    if (objet?.isSelect ?? false) {
                        cell.imgSelected.image = UIImage.init(named: "ic_circle_check")
                    }
                    else{
                        cell.imgSelected.image = UIImage.init(named: "ic_circle_uncheck")
                    }
                }
                else {
                    cell.lblCategoryName.text = objet?.name
                    if appDelegate.selectSubCategoryId.count != 0 && objet?.childCategories?.count != 0{
                        cell.lblSelectCategory.isHidden = false
                        var name = ""
                        if appDelegate.selectSubCategoryName.contains(objet?.name ?? ""){
                            if name == ""{
                                name = objet?.name ?? ""
                            }else
                            {
                                name = name + "," + (objet?.name ?? "")
                            }
                            
                        }
                        for i in 0..<(objet?.childCategories?.count ?? 0){
                            if  let innername = objet?.childCategories?[i].name {
                                if appDelegate.selectSubCategoryName.contains(innername){
                                    name = name + "," + (innername)
                                }
                            }
                        }
                        cell.lblSelectCategory.text = name
                        //" cell.lblSelectCategory.text = self.categoryselectData.joined(separator: ",")
                    }else{
                        var name = ""
                        if appDelegate.selectSubCategoryName.contains(objet?.name ?? ""){
                            if name == ""{
                                name = objet?.name ?? ""
                            }else
                            {
                                name = name + "," + (objet?.name ?? "")
                            }
                            cell.lblSelectCategory.text = name
                        }
                    }
                    if objet?.childCategories?.count == 0 {
                        cell.btnDown.isHidden = true
                        if (objet?.isSelect ?? false) {
                            cell.imgSelected.image = UIImage.init(named: "ic_circle_check")
                        }
                        else{
                            cell.imgSelected.image = UIImage.init(named: "ic_circle_uncheck")
                        }
                    }
                    else {
                        cell.btnDown.isHidden = false
                        cell.imgSelected.isHidden = true
                    }
                }
            }else{
                if self.selectSubCategoryName.contains(objet?.name ?? "") && objet?.childCategories?.count == 0 {
                    cell.lblCategoryName.text = objet?.name
                    cell.lblSelectCategory.isHidden = true
                    cell.btnDown.isHidden = true
                    if (objet?.isSelect ?? false) {
                        cell.imgSelected.image = UIImage.init(named: "ic_circle_check")
                    }
                    else{
                        cell.imgSelected.image = UIImage.init(named: "ic_circle_uncheck")
                    }
                }
                else {
                    cell.lblCategoryName.text = objet?.name
                    if self.selectSubCategoryId.count != 0 && objet?.childCategories?.count != 0{
                        cell.lblSelectCategory.isHidden = false
                        var name = ""
                        if self.selectSubCategoryName.contains(objet?.name ?? ""){
                            if name == ""{
                                name = objet?.name ?? ""
                            }else
                            {
                                name = name + "," + (objet?.name ?? "")
                            }
                            
                        }
                        for i in 0..<(objet?.childCategories?.count ?? 0){
                            if  let innername = objet?.childCategories?[i].name {
                                if self.selectSubCategoryName.contains(innername){
                                    name = name + "," + (innername)
                                }
                            }
                        }
                        cell.lblSelectCategory.text = name
                        //" cell.lblSelectCategory.text = self.categoryselectData.joined(separator: ",")
                    }else{
                        var name = ""
                        if self.selectSubCategoryName.contains(objet?.name ?? ""){
                            if name == ""{
                                name = objet?.name ?? ""
                            }else
                            {
                                name = name + "," + (objet?.name ?? "")
                            }
                            cell.lblSelectCategory.text = name
                        }
                    }
                    if objet?.childCategories?.count == 0 {
                        cell.btnDown.isHidden = true
                        if (objet?.isSelect ?? false) {
                            cell.imgSelected.image = UIImage.init(named: "ic_circle_check")
                        }
                        else{
                            cell.imgSelected.image = UIImage.init(named: "ic_circle_uncheck")
                        }
                    }
                    else {
                        cell.btnDown.isHidden = false
                        cell.imgSelected.isHidden = true
                    }
                }
            }
        }
        else{
            if objet?.childCategories?.count == 0 {
                
                cell.btnDown.isHidden = true
                if (objet?.isSelect ?? false) {
                    cell.imgSelected.alpha = 1
                    cell.imgSelected.image = UIImage.init(named: "ic_black_check")
                }
                else{
                    cell.imgSelected.alpha = 0.5
                    cell.imgSelected.image = UIImage.init(named: "ic_next_arrow")
                }
            }
            else {
                cell.btnDown.isHidden = false
                cell.imgSelected.isHidden = true
            }
            cell.lblCategoryName.text = objet?.name
            
            cell.lblSelectCategory.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.categoryList[indexPath.row]?.childCategories?.count == 0 {
            if self.categoryList[indexPath.row]?.isSelect == true{
                
                self.categoryList[indexPath.row]?.isSelect = false
                if !saveSearch{
                    //   appDelegate.selectSubCategoryId = appDelegate.selectSubCategoryId.filter { $0 != "\(self.categoryList[indexPath.row]?.category_id ?? 0)"}
                    appDelegate.selectSubCategoryName = appDelegate.selectSubCategoryName.filter { $0 != "\(self.categoryList[indexPath.row]?.name ?? "")"}
                }else{
                    //     self.selectSubCategoryId = appDelegate.selectSubCategoryId.filter { $0 != "\(self.categoryList[indexPath.row]?.category_id ?? 0)"}
                    self.selectSubCategoryName = appDelegate.selectSubCategoryName.filter { $0 != "\(self.categoryList[indexPath.row]?.name ?? "")"}
                }
            }
            else {
                if let id = self.categoryList[indexPath.row]?.category_id {
                    if !saveSearch{
                        appDelegate.selectSubCategoryId.append("\(id)")
                    }
                    else{
                        self.selectSubCategoryId.append("\(id)")
                    }
                }
                if let name = self.categoryList[indexPath.row]?.name {
                    if !saveSearch{
                        appDelegate.selectSubCategoryName.append(name)
                    }
                    else{
                        self.selectSubCategoryName.append(name)
                    }
                }
                self.categoryList[indexPath.row]?.isSelect = true
            }
            self.tblCategorylist.reloadRows(at: [indexPath], with: .automatic)
            self.callViewCount()
            //            self.tblCategorylist.reloadData()
        }
        else {
            if !saveSearch{
                if let id = self.categoryList[indexPath.row]?.category_id {
                    appDelegate.selectSubCategoryId.append("\(id)")
                }
                if let name = self.categoryList[indexPath.row]?.name {
                    appDelegate.selectSubCategoryName.append(name)
                }
            }else{
                if let id = self.categoryList[indexPath.row]?.category_id {
                    self.selectSubCategoryId.append("\(id)")
                }
                if let name = self.categoryList[indexPath.row]?.name {
                    self.selectSubCategoryName.append(name)
                }
            }
            self.categoryList[indexPath.row]?.isSelect = true
            appDelegate.selectSubCategoryId = appDelegate.selectSubCategoryId.removeDuplicates()
            appDelegate.selectSubCategoryName = appDelegate.selectSubCategoryName.removeDuplicates()
            self.selectSubCategoryId = self.selectSubCategoryId.removeDuplicates()
            self.selectSubCategoryName = self.selectSubCategoryName.removeDuplicates()
            let viewController = self.storyboard?.instantiateViewController(identifier: "CategoryDetailsViewController") as! CategoryDetailsViewController
            viewController.headertitle = self.categoryList[indexPath.row]?.name ?? ""
            viewController.subCategoryList = self.categoryList[indexPath.row]?.childCategories as [ChildCategories?]
            viewController.delegate = self
            viewController.selectIndex = Int(indexPath.row)
            viewController.isMySize = self.isMySize
            viewController.saveSearch = self.saveSearch
            viewController.selectSubCategoryId = self.selectSubCategoryId
            viewController.selectSubCategoryName = self.selectSubCategoryName
            viewController.selectSubcategory = self.selectSubcategory
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
}

class CategoryLisetCell : UITableViewCell {
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblSelectCategory: UILabel!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var imgSelected: UIImageView!
}

extension CategoryListViewController : CategoryselectionDelegate {
    func categoryLise(categoryLise: [ChildCategories?], Selecte: Bool, index: Int, category: String) {
        self.selectSubcategory.removeAll()
        self.selectSubcategory.append(contentsOf: categoryLise)
        self.categoryselectData.removeAll()
        //        self.selectSubCategoryId.removeAll()
        for i in 0..<self.selectSubcategory.count {
            self.categoryselectData.append(self.selectSubcategory[i]?.name ?? "")
            self.selectSubCategoryId.append(String(self.selectSubcategory[i]?.id ?? 0))
            self.selectSubCategoryName.append(self.selectSubcategory[i]?.name ?? "")
        }
        self.selectSubCategoryId = self.selectSubCategoryId.removeDuplicates()
        self.selectSubCategoryName = self.selectSubCategoryName.removeDuplicates()
        print(appDelegate.selectSubCategoryId)
        self.select = Selecte
        self.categoryname = category
        self.tblCategorylist.reloadRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
    }
}

extension CategoryListViewController {
    func callCategoryList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: CategoryModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.genderList = data
                            
                            for i in 0..<self.genderList.count {
                                if !self.saveSearch {
                                    if String(self.genderList[i]?.gender_id ?? 0) == FilterSingleton.share.filter.gender_id ?? "" {
                                        self.categoryList = self.genderList[i]?.categories! as! [Categorie]
                                        for j in 0..<self.categoryList.count{
                                            
                                            if let id = self.categoryList[j]?.category_id{
                                                if appDelegate.selectSubCategoryId.contains("\(id)") {
                                                    for suubcategory in 0..<(self.categoryList[j]?.childCategories?.count ?? 0){
                                                        if let ids = self.self.categoryList[j]?.childCategories?[suubcategory].id{
                                                            if appDelegate.selectSubCategoryId.contains("\(ids)") {
                                                                print(appDelegate.selectSubCategoryId.contains("\(ids)"))
                                                                self.categoryList[j]?.childCategories?[suubcategory].isSelect = true
                                                                self.categoryList[j]?.isSelect = true
                                                                self.select = true
                                                            }
                                                        }
                                                    }
                                                    print(appDelegate.selectSubCategoryId.contains("\(id)"))
                                                    self.categoryList[j]?.isSelect = true
                                                    
                                                    //                                                    self.select = true
                                                }
                                            }
                                        }
                                        self.subCategoryList = self.categoryList[i]?.childCategories as! [ChildCategories?]
                                        //                                        r
                                    }else{
                                        
                                    }
                                }else{
                                    if self.selectGenderId == -1{
                                        if String(self.genderList[i]?.gender_id ?? 0) == appDelegate.selectGenderId {
                                            self.categoryList = self.genderList[i]?.categories! as! [Categorie]
                                            for j in 0..<self.categoryList.count{
                                                
                                                if let id = self.categoryList[j]?.category_id{
                                                    if self.selectSubCategoryId.contains("\(id)") {
                                                        for suubcategory in 0..<(self.categoryList[j]?.childCategories?.count ?? 0){
                                                            if let ids = self.self.categoryList[j]?.childCategories?[suubcategory].id{
                                                                if self.selectSubCategoryId.contains("\(ids)") {
                                                                    
                                                                    self.categoryList[j]?.childCategories?[suubcategory].isSelect = true
                                                                    self.categoryList[j]?.isSelect = true
                                                                    self.select = true
                                                                }
                                                            }
                                                        }
                                                        print(self.selectSubCategoryId.contains("\(id)"))
                                                        self.categoryList[j]?.isSelect = true
                                                        
                                                        //                                                    self.select = true
                                                    }
                                                }
                                            }
                                            self.subCategoryList = self.categoryList[i]?.childCategories as [ChildCategories?]
                                            //                                        r
                                        }
                                    }
                                    else{
                                        if self.genderList[i]?.gender_id ?? 0 == self.selectGenderId {
                                            self.categoryList = self.genderList[i]?.categories! as! [Categorie]
                                            for j in 0..<self.categoryList.count{
                                                if let id = self.categoryList[j]?.category_id{
                                                    if self.selectSubCategoryId.contains("\(id)") {
                                                        for suubcategory in 0..<(self.categoryList[j]?.childCategories?.count ?? 0){
                                                            if let ids = self.self.categoryList[j]?.childCategories?[suubcategory].id{
                                                                if self.selectSubCategoryId.contains("\(ids)") {
                                                                    
                                                                    self.categoryList[j]?.childCategories?[suubcategory].isSelect = true
                                                                    self.categoryList[j]?.isSelect = true
                                                                    self.select = true
                                                                }
                                                            }
                                                        }
                                                        print(self.selectSubCategoryId.contains("\(id)"))
                                                        self.categoryList[j]?.isSelect = true
                                                        
                                                    }
                                                }
                                            }
                                            self.subCategoryList = self.categoryList[i]?.childCategories as [ChildCategories?]
                                            //                                        r
                                        }
                                    }
                                }
                            }
                            
                            self.callViewCount()
                            
                            self.tblCategorylist.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            
//            let param = ["is_mysize":  "0" ,
//                         "gender_id" : appDelegate.selectGenderId,
//                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
//                         "sizes" : appDelegate.selectSizeId,
//                         "colors" : appDelegate.selectColorId,
//                         "condition_id" : appDelegate.selectConditionId ,
//                         "distance" : appDelegate.selectDistnce,
//                         "seller" : appDelegate.selectSellerId,
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
            dict["latitude"] = appDelegate.userLocation?.latitude ?? ""
            dict["longitude"] = appDelegate.userLocation?.longitude ?? ""
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: dict) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.viewCount = data.total_posts ?? 0
                            if self.saveSearch {
                                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
                            }
                            else {
                                self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                            }
                            //                            self.btnViewItems.setTitle("View \(self.viewCount) Results", for: .normal)
                            
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
