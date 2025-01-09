//
//  PiseSearchViewController.swift
//  ClothApp
//
//  Created by Apple on 02/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol PriceDelegate {
    func selctedPrice (price: String, Selecte:Bool,index : Int,hearderTitel: String, priceId : Int,priceFrom: String,priceTO: String)
}
class PiseSearchViewController: BaseViewController {

    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var tblPriseList: UITableView!
    @IBOutlet weak var txtMinPrise: UITextField!
    @IBOutlet weak var txtMexPrise: UITextField!
    @IBOutlet weak var btnViewItems: CustomButton!

    var saveSearch = false
    var list = ["25","50","75","100","200","500","1000"]//,"Best offer","Free","Trade/swap "]
    var headerTitle = ""
    var selected = ""
    var Prise = 0
    var selectedIndex = 0
    var priceId  = 0
    var priceString = ""
    var priceDelegate : PriceDelegate!
    var viewCount = 0
    var isMySize = ""
    var selectSubCategoryId = [String]()
    var priceTo = ""
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isFilterProduct == true{
            self.btnViewItems.setTitle("Add", for: .normal)
        }else{
            if self.saveSearch {
                self.txtMexPrise.text = self.selected
                self.priceString = self.selected
                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
            }
            else {
                self.txtMexPrise.text = self.selected
                self.priceString = self.selected
                self.callViewCount()
            }
        }
    }
    
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.saveSearch || self.isFilterProduct == true{
//            if self.priceDelegate != nil {
//                self.priceDelegate.selctedPrice(price: self.priceString, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle, priceId: self.priceId, priceFrom: self.txtMinPrise.text ?? "", priceTO: self.txtMexPrise.text ?? "")
//            }
            self.navigationController?.popViewController(animated: true)
        }
        else {
            if self.viewCount != 0 {
                let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                viewController.titleStr = "Search Results"
//                viewController.isMySize = self.isMySize
//                viewController.selectSubCategoryId = self.selectSubCategoryId
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
    
    @IBAction func btnBack_Clicked(_ button: UIButton) {
        if self.priceDelegate != nil {
            self.priceDelegate.selctedPrice(price: self.priceString, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle, priceId: self.priceId, priceFrom: self.txtMinPrise.text ?? "", priceTO: self.txtMexPrise.text ?? "")
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnClear_Clicked(_ button: UIButton) {
        self.selected = ""
        self.txtMinPrise.text = ""
        self.txtMexPrise.text = ""
//        self.txtMexPrise.placeholder = "max"
        FilterSingleton.share.filter.price_to = ""
        FilterSingleton.share.filter.price_from = ""
        FilterSingleton.share.selectedFilter.price_to = ""
        FilterSingleton.share.selectedFilter.price_from = ""
        self.tblPriseList.reloadData()
       // if !self.saveSearch && self.isFilterProduct == false{
            self.callViewCount()
        //}
//        self.priceId = 0
//        self.priceString = ""
//        appDelegate.priceFrom = ""
//        appDelegate.priceTo = ""
//        appDelegate.selectPriceId = ""
    }
    
    func setPriseData(prise : String) {
        self.txtMinPrise.text = "0"
        self.txtMexPrise.text = prise
    }
}

extension PiseSearchViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PriseListCell", for: indexPath) as! PriseListCell
        if indexPath.row <= 6{
            cell.lblTitle.text = "Under $\(self.list[indexPath.row])"
        }
        else {
            cell.lblTitle.text = self.list[indexPath.row]
//            self.txtMexPrise.placeholder = "max"
        }
        //cell.lblTitle.text = "Under $\(self.list[indexPath.row])"//self.list[indexPath.row]
        if FilterSingleton.share.filter.price_to == self.list[indexPath.row] {
            cell.imgSelect.image = UIImage.init(named: "ic_circle_check")
        }
        else{
            cell.imgSelect.image = UIImage.init(named: "ic_circle_uncheck")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = self.list[indexPath.row]
        //        if indexPath.row <= 6{
        //            self.setPriseData(prise: self.list[indexPath.row])
        //            if !self.saveSearch {
        //            appDelegate.priceFrom = "0"
        //            appDelegate.priceTo = self.list[indexPath.row]
        //            appDelegate.selectPriceId = "1"
        //                self.priceId = 1
        //                self.priceString = self.list[indexPath.row]
        //            }else{
        //            self.priceId = 1
        //            self.priceString = self.list[indexPath.row]
        //                }
        //        }
        //        else if self.list[indexPath.row] == "Best offer" {
        //            self.txtMexPrise.text = ""
        ////            self.txtMexPrise.placeholder = "max"
        //            if !self.saveSearch {
        //            appDelegate.priceFrom = "0"
        //            appDelegate.selectPriceId = "2"
        //          //  appDelegate.priceTo = self.list[indexPath.row]
        //                self.priceId = 2
        //                self.priceString = self.list[indexPath.row]
        //            }else{
        //            self.priceId = 2
        //            self.priceString = self.list[indexPath.row]
        //            }
        //        }
        //        else if self.list[indexPath.row] == "Free" {
        //            self.txtMexPrise.text = ""
        ////            self.txtMexPrise.placeholder = "max"
        //            if !self.saveSearch {
        //            appDelegate.priceFrom = "0"
        //         //  appDelegate.priceTo = self.list[indexPath.row]
        //            appDelegate.selectPriceId = "3"
        //                self.priceId = 3
        //                self.priceString = self.list[indexPath.row]
        //            }else{
        //            self.priceId = 3
        //            self.priceString = self.list[indexPath.row]
        //            }
        //        }
        //        else if self.list[indexPath.row] == "Trade/swap "{
        //            self.txtMexPrise.text = ""
        ////            self.txtMexPrise.placeholder = "max"
        //            if !self.saveSearch {
        //            appDelegate.selectPriceId = "4"
        //            appDelegate.priceFrom = "0"
        //          //  appDelegate.priceTo = self.list[indexPath.row]
        //                self.priceId = 4
        //                self.priceString = self.list[indexPath.row]
        //            }else{
        //            self.priceId = 4
        //            self.priceString = self.list[indexPath.row]
        //            }
        //        }
        self.txtMexPrise.text = self.list[indexPath.row]
        FilterSingleton.share.filter.price_from = "0"
        FilterSingleton.share.filter.price_to = self.list[indexPath.row]
        FilterSingleton.share.selectedFilter.price_from = "0"
        FilterSingleton.share.selectedFilter.price_to = self.list[indexPath.row]
        self.tblPriseList.reloadData()
      //  if !self.saveSearch && self.isFilterProduct == false {
            self.callViewCount()
        //}
        self.tblPriseList.reloadData()
    }
    
}

class PriseListCell : UITableViewCell {
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
}

extension PiseSearchViewController : UITextFieldDelegate {
    private func textFieldDidChangeSelection(_ textField: UITextView) {
        if txtMexPrise.text == "" {
//            self.txtMexPrise.placeholder = "max"
        }
        else {
            self.selected = ""
            self.tblPriseList.reloadData()
        }
        
    }
}

extension PiseSearchViewController {
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
           
//            let param = ["is_mysize":  "0" ,
//                         "gender_id" : appDelegate.selectGenderId,
//                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
//                         "sizes" : appDelegate.selectSizeId ,
//                         "colors" : appDelegate.selectColorId ,
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
