//
//  StyleViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 15/07/24.
//

import Foundation
import UIKit

class StyleViewModel{
    var view : StyleVC?
    var modelData = [StyleModelList]()
    func getStyle() {
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of: StyleModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.STYLES.rawValue, method: .get, parameters: nil) { (response, error) in
                if error == nil {
                    if let response = response {
                        self.modelData = response.dictData?.styles ?? []
                        self.view?.tableView.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self.view ?? UIViewController())
        }
    }
}
