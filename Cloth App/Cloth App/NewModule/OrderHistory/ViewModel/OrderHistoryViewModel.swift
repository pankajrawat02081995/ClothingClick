//
//  OrderHistoryViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 02/09/24.
//

import Foundation
import UIKit

class OrderHistoryViewModel{
    
    var view : OrderHistoryVC?
    var modelData = [OrderHistoryModel]()
    
    func callGetOrderList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: OrderHistoryModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LIST_ORDER.rawValue, method: .post, parameters: [:]) { (response, error) in
                if error == nil {
                    debugPrint(response?.arrayData?.first?.product?.title ?? "")
                    self.modelData = response?.arrayData ?? []
                    self.view?.tableView.reloadData()
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callGetOrderDetails(order_id:Int,complition:@escaping((OrderDetailsModel)->Void?)) {
        if appDelegate.reachable.connection != .none {
            let param = ["order_id":order_id]
            APIManager().apiCall(of: OrderDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.ORDER_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    debugPrint(response?.arrayData?.first?.product?.title ?? "")
                    if let response = response?.arrayData?.first{
                        complition(response)
                    }else{
                        
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}
