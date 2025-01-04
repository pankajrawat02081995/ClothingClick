//
//  FaqViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/06/24.
//

import Foundation

class FaqViewModel{
    
    var view : FaqVC?
    var model = [FaqModelData]()
    
    func getAllFaq(){
        if appDelegate.reachable.connection != .unavailable {
            APIManager().apiCall(of: FaqModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAQ.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let dict = response.dictData {
                            debugPrint(dict)
                            self.model = dict.faq ?? []
                            self.view?.tableView.setBackGroundLabel(count: self.model.count)
                            self.view?.tableView.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error!.domain)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self.view ??  UIViewController())
        }
    }
}
