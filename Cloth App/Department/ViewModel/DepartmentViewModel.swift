//
//  DepartmentViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/06/24.
//

import Foundation

class DepartmentViewModel{
    
   weak var view : DepartmentVC?
    var mysizeList = [MySizeModel?]()
    
    func callSizeList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: MySizeModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MY_SIZE_LIST.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.mysizeList = data
                            self.view?.tableView.reloadData()
                            if self.view?.isEdit == true{
                                self.callViewCount(genderId: self.view?.genderId ?? 0)
                            }
                        }
                    }
                    self.view?.tableView.setBackGroundLabel(count: self.mysizeList.count)
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ??  UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self.view ?? UIViewController())
        }
    }
    
    func callViewCount(genderId:Int) {
        if appDelegate.reachable.connection != .none {
           
            appDelegate.selectGenderId = "\(genderId)"
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
            
            FilterSingleton.share.filter.gender_id = "\(genderId)"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: dict) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            if self.view?.isFromSearch == true{
                                self.view?.btnResult.setTitle("View \(data.total_posts ?? 0) Items", for: .normal)
                            }else{
                                self.view?.btnResult.setTitle("Add to saved search", for: .normal)
                            }
                            self.view?.genderId = genderId
                            self.view?.btnResult.isUserInteractionEnabled = true
                            self.view?.btnResult.alpha = 1
                            self.view?.tableView.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
}
