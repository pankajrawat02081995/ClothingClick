//
//  MobileNumberViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 29/05/24.
//

import Foundation
import UIKit

class MobileNumberViewModel{
    var view : MobileNumberVC?
    
    func userVerifyMobileNumber() {
        if appDelegate.reachable.connection != .none {
            var  param = [String:Any]()
#if DEBUG
            param = ["email": appDelegate.userDetails?.email ?? ""]
//                     ,
//                     "country_prefix" : "+91" ,
//                     "country_code" : "IN",
//                     "is_test" : "1"
//            ]
#else
            
            param = ["email": appDelegate.userDetails?.email ?? ""]
//                     ,
//                     "country_prefix" : "+1" ,
//                     "country_code" : "CA",
//                     "is_test" : "1"
//            ]
#endif
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
//                            self.view?.saveUserDetails(userDetails: userDetails)
                            let vc = OtpViewVC.instantiate(fromStoryboard: .Auth)
                            vc.isProfileUpdate = true
                            vc.mobileNumberUpdated = { [weak self] status in
                                self?.view?.navigationController?.popToRootViewController(animated: true)
                            }
                            vc.phone = "\(self.view?.txtPhoneNumber.text ?? "")"
                            self.view?.pushViewController(vc: vc)
                        }
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
