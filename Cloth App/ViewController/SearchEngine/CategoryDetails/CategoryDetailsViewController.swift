//
//  CategoryDetailsViewController.swift
//  ClothApp
//
//  Created by Apple on 02/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol CategoryselectionDelegate {
    func categoryLise(categoryLise: [ChildCategories?], Selecte:Bool,index : Int,category: String)
}

class CategoryDetailsViewController: BaseViewController {

    @IBOutlet weak var lblTitel: UILabel!
    @IBOutlet weak var tblCategoryDetail: UITableView!
    @IBOutlet weak var btnViewItems: CustomButton!
    
    var selectIndex = 0
    var delegate : CategoryselectionDelegate!
    var categoryList : [String] = []
    var subCategoryList = [ChildCategories?]()
    var selectSubcategory = [ChildCategories?]()
    var categoryData = [String]()
    var headertitle = ""
    var selected = ""
    var selectSubCategoryId = [String]()
    var selectSubCategoryName = [String]()
    var viewCount = 0
    var saveSearch = false
    
    var isMySize = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitel.text = self.headertitle
//        if self.selectSubcategory.count != 0 {
//            for i in 0..<self.subCategoryList.count{
//                for j in 0..<self.selectSubcategory.count{
//                    if self.subCategoryList[i]?.id == self.selectSubcategory[j]?.id{
//                        if appDelegate.selectSubCategoryId.contains("\(self.subCategoryList[i]?.id)"){
//                            self.subCategoryList[i]?.isSelect = true
//                        }
////                        self.subCategoryList[i]?.isSelect = true
//                    }
////                    if let id = self.selectSubcategory[j]?.id{
////                        if appDelegate.selectSubCategoryId.contains("\(id)"){
////                            self.subCategoryList[i]?.isSelect = true
////                        }
////                    }
//                    
//                }
//            }
//        }
        
        if self.saveSearch {
            self.btnViewItems.setTitle("Add to saved Search", for: .normal)
        }
        else {
            self.callViewCount()
            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.saveSearch {
            self.selectSubcategory.removeAll()
            for i in 0..<self.subCategoryList.count {
                if self.subCategoryList[i]?.isSelect == true {
                    self.selectSubcategory.append(self.subCategoryList[i])
                    self.categoryData.append(subCategoryList[i]?.name ?? "")
                    appDelegate.selectSubCategoryId.append("\(subCategoryList[i]?.category_id ?? 0)")
                }
            }
            if self.delegate != nil {
                self.delegate.categoryLise(categoryLise: self.selectSubcategory, Selecte: true, index: self.selectIndex, category: self.headertitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            if self.viewCount != 0 {
                let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
                viewController.titleStr = "Search Results"
//                viewController.isMySize = self.isMySize
//                viewController.selectSubCategoryId = appDelegate.selectSubCategoryId
//                viewController.selectSizeId = appDelegate.selectSizeId
//                viewController.selectColorId = appDelegate.selectColorId
//                viewController.selectConditionId = appDelegate.selectConditionId
//                viewController.selectPriceId = appDelegate.selectPriceId
//                viewController.priceFrom = appDelegate.priceFrom
//                viewController.priceTo = appDelegate.priceTo
//                viewController.selectDistnce = appDelegate.selectDistnce
//                viewController.selectSellerId = appDelegate.selectSellerId
//                viewController.selectBrandId = appDelegate.selectBrandId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnBack_Clicked(_ button: UIBarButtonItem) {
        self.selectSubcategory.removeAll()
        
        for i in 0..<self.subCategoryList.count {
            if self.subCategoryList[i]?.isSelect == true {
                self.selectSubcategory.append(self.subCategoryList[i])
                self.categoryData.append(subCategoryList[i]?.name ?? "")
            }
        }
        
        if self.delegate != nil {
            self.delegate.categoryLise(categoryLise: self.selectSubcategory,
                                       Selecte: self.selectSubcategory.count == 0 ? false : true,
                                       index: self.selectIndex,
                                       category: self.selectSubcategory.count == 0 ? "": self.headertitle)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension CategoryDetailsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryDetailsCell", for: indexPath) as!CategoryDetailsCell
        let objet = self.subCategoryList[indexPath.row]
        cell.lblcategoryName.text = objet?.name
        if (objet?.isSelect ?? false) {
            cell.imgSelect.image = UIImage.init(named: "ic_circle_check")
        }
        else{
            cell.imgSelect.image = UIImage.init(named: "ic_circle_uncheck")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        if self.subCategoryList[indexPath.item]?.isSelect == true {
//            self.subCategoryList[indexPath.item]?.isSelect = false
//            if !saveSearch{
//            appDelegate.selectSubCategoryId = appDelegate.selectSubCategoryId.filter { $0 != "\(subCategoryList[indexPath.item]?.id ?? 0)"}
//            appDelegate.selectSubCategoryName = appDelegate.selectSubCategoryName.filter { $0 != "\(subCategoryList[indexPath.item]?.name ?? "")"}
//            }else{
//                
//            }
//        }
//        else {
//            self.subCategoryList[indexPath.item]?.isSelect = true
//            appDelegate.selectSubCategoryId.append("\(subCategoryList[indexPath.item]?.id ?? 0)")
//            appDelegate.selectSubCategoryName.append("\(subCategoryList[indexPath.item]?.name ?? "")")
//        }
        if appDelegate.selectSubCategoryId.contains("\(subCategoryList[indexPath.item]?.category_id ?? 0)"){
            let index = appDelegate.selectSubCategoryId.firstIndex(of: "\(subCategoryList[indexPath.item]?.category_id ?? 0)") ?? 0
            appDelegate.selectSubCategoryId.remove(at: index)
        }else{
            appDelegate.selectSubCategoryId.append("\(subCategoryList[indexPath.item]?.category_id ?? 0)")

        }
        
        if appDelegate.selectSubCategoryName.contains("\(subCategoryList[indexPath.item]?.name ?? "")"){
            let index = appDelegate.selectSubCategoryId.firstIndex(of: "\(subCategoryList[indexPath.item]?.name ?? "")") ?? 0
            appDelegate.selectSubCategoryName.remove(at: index)
        }else{
            appDelegate.selectSubCategoryName.append("\(subCategoryList[indexPath.item]?.name ?? "")")
        }
        
        if self.subCategoryList[indexPath.item]?.isSelect == true {
             self.subCategoryList[indexPath.item]?.isSelect = false
        }else{
            self.subCategoryList[indexPath.item]?.isSelect = true

        }
        
        self.callViewCount()
        self.tblCategoryDetail.reloadData()
    }
}

class CategoryDetailsCell : UITableViewCell {
    @IBOutlet weak var lblcategoryName: UILabel!
    @IBOutlet weak var imgSelect: UIImageView!
}

extension CategoryDetailsViewController {
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
//                        ]
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
