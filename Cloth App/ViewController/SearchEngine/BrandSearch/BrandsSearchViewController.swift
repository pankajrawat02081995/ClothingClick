//
//  BrandsSearchViewController.swift
//  ClothApp
//
//  Created by Apple on 02/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol BrandSearchDelegate {
//    func BrandSearchAddd(name: BrandeSearchModel )
    func selctedBrandeName (name: BrandeSearchModel?, Selecte:Bool,index : Int,hearderTitel: String)
}

class BrandsSearchViewController: BaseViewController {

    @IBOutlet weak var searchBarBrand: CustomTextField!
    
    @IBOutlet weak var viewItemsCount: CustomView!
    @IBOutlet weak var lblItemsCount: UILabel!
    @IBOutlet weak var tblBrand: UITableView!
    @IBOutlet weak var btnViewItems: CustomButton!
    
    var selectedIndex = 0
    var headerTitle = ""
    var  brandSearchList = [BrandeSearchModel?]()
    var BrandSearchDeleget : BrandSearchDelegate!
    var saveSearch = false
    var viewCount = 0
    
    var isMySize = ""
    var selectSubCategoryId = [String]()
    
    var selectColorId = ""
    
    var selectBrandId = ""
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.searchBarBrand.delegate = self
        self.searchBarBrand.returnKeyType = .search
        self.searchBarBrand.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingDidEnd)

        if self.isFilterProduct == true{
            self.btnViewItems.setTitle("Add", for: .normal)
        }else{
            if self.saveSearch {
                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
            }
            else {
                self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
            }
        }

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        debugPrint(textField.text ?? "")
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        if trimmedText != "" && trimmedText.count >= 2 {
            self.callBrandSearchList(searchtext: (trimmedText) as String)
        }else {
            self.brandSearchList.removeAll()
            self.tblBrand.reloadData()
        }
    }
    
    func setupTableView(){
        self.tblBrand.delegate = self
        self.tblBrand.dataSource = self
        self.tblBrand.tableFooterView = UIView()
        self.tblBrand.register(UINib(nibName: "UserProfileListXIB", bundle: nil), forCellReuseIdentifier: "UserProfileListXIB")
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnClear_Clicked(_ button: Any) {
//        if self.saveSearch {
////            self.BrandSearchDeleget.selctedBrandeName(name: nil, Selecte: false, index: self.selectedIndex, hearderTitel: self.headerTitle)
//            self.navigationController?.popViewController(animated: true)
//        }else{
//            
//        }
        FilterSingleton.share.filter.brand_id = ""
        FilterSingleton.share.selectedFilter.brand_id = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.saveSearch  || self.isFilterProduct == true{
//            if self.selectedIndex == 0 {
//                if self.BrandSearchDeleget != nil {
//
//                }
                self.navigationController?.popViewController(animated: true)
//            }
//            else
//            {
//                if self.BrandSearchDeleget != nil {
//                    self.BrandSearchDeleget.selctedBrandeName(name: bsrnds!, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
//                }
//                self.navigationController?.popViewController(animated: true)
//            }
        }
        else {
            if self.viewCount != 0 {

                let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                viewController.titleStr = "Search Results"
                viewController.isMySize = self.isMySize
                viewController.selectSubCategoryId = self.selectSubCategoryId
                viewController.selectSizeId = appDelegate.selectSizeId
                viewController.selectColorId = self.selectColorId
                viewController.selectConditionId = appDelegate.selectConditionId
                viewController.selectPriceId = appDelegate.selectPriceId
                viewController.priceFrom = appDelegate.priceFrom
                viewController.priceTo = appDelegate.priceTo
                viewController.selectDistnce = appDelegate.selectDistnce
                viewController.selectSellerId = appDelegate.selectSellerId
                viewController.selectBrandId = self.selectBrandId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
    }
}

extension BrandsSearchViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brandSearchList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objet = self.brandSearchList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileListXIB", for: indexPath) as! UserProfileListXIB
        cell.lblName.text = objet?.name
        cell.imgUser.contentMode = .scaleAspectFit
        cell.lblFollowerCount.text = "\(objet?.photo ?? "") Listings"
        if let image = URL.init(string: objet?.image ?? ""){
            cell.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
        }else{
            cell.imgUser.image = PlaceHolderImage
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bsrnds = self.brandSearchList[indexPath.row]
        FilterSingleton.share.filter.brand_id = "\(bsrnds?.brand_id ?? 0)"
        FilterSingleton.share.selectedFilter.brand_id = "\(bsrnds?.name ?? "")"
        self.navigationController?.popViewController(animated: true)
//        if self.selectedIndex == 0 {
//            if self.BrandSearchDeleget != nil {
//            
//            }
//            self.navigationController?.popViewController(animated: true)
//        }
//        else
//        {
//            if self.BrandSearchDeleget != nil {
//                self.BrandSearchDeleget.selctedBrandeName(name: bsrnds!, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
//            }
//            self.navigationController?.popViewController(animated: true)
//        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

class BrandsCell : UITableViewCell {
    @IBOutlet weak var lblBrandName: UILabel!
}

extension BrandsSearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString: NSString = (self.searchBarBrand.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        if newString != "" && newString.length >= 2 {
            self.callBrandSearchList(searchtext: (newString) as String)
        }
        else {
            self.brandSearchList.removeAll()
            self.tblBrand.reloadData()
        }
        return true
    }
}

extension BrandsSearchViewController {
    
    func callBrandSearchList(searchtext : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["name": searchtext]
            APIManager().apiCall(of: BrandeSearchModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.BRAND_SEARCH.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.brandSearchList = data
                            self.tblBrand.reloadData()
                            self.callViewCount()
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
    
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
           
//            let param = ["is_mysize":  "0" ,
//                         "gender_id" : appDelegate.selectGenderId,
//                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
//                         "sizes" : appDelegate.selectSizeId,
//                         "colors" : appDelegate.selectColorId,
//                         "condition_id" :appDelegate.selectConditionId ,
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
            
            FilterSingleton.share.filter.is_only_count = "0"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
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
//                            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)

                        }
                        
//                        self.navigateToHomeScreen()
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

extension BrandsSearchViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debugPrint(textField.text ?? "")
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        if trimmedText != "" && trimmedText.count >= 2 {
            self.callBrandSearchList(searchtext: (trimmedText) as String)
        }else {
            self.brandSearchList.removeAll()
            self.tblBrand.reloadData()
        }
        return true
    }
}
