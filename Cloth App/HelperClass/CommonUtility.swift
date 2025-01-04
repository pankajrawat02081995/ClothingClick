//
//  CommonUtility.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 27/05/24.
//

import Foundation

class CommonUtility{
    static let share = CommonUtility()
    
    func callSettingApi(appDelegate:AppDelegate) {
        if appDelegate.reachable.connection != .unavailable {
            APIManager().apiCall(of: GeneralSettingModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.GET_GENERAL_DATA.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let generalSettingDetails = response.dictData {
                            self.saveGeneralSetting(generalSetting: generalSettingDetails)
                        }
                    }
                }
                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                }
            }
        }
        else {
//            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
    func saveGeneralSetting(generalSetting: GeneralSettingModel) {
        appDelegate.generalSettings = generalSetting
        let data = NSKeyedArchiver.archivedData(withRootObject: generalSetting.toJSONString()!)
        defaults.set(data, forKey:kGeneralSettingDetails)
        defaults.synchronize()
    }
}
