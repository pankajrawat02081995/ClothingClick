//
//  ViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 17/06/24.
//

import Foundation
import UIKit

class NewChangePasswordViewModel{
    
    var view : NewChangePasswordVC?
    
    func userVerifyMobileNumber() {
        if appDelegate.reachable.connection != .none {
            var  param = [String:Any]()
//#if DEBUG
            param = ["phone": appDelegate.userDetails?.phone ?? "",
                     "country_prefix" : "+91" ,
                     "country_code" : "IN",
                     "is_test" : "1"
            ]
//#else
//            
//            param = ["phone": appDelegate.userDetails?.phone ?? "",
//                     "country_prefix" : "+1" ,
//                     "country_code" : "CA",
//                     "is_test" : "1"
//            ]
//#endif
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    
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
    
    func userVerifyOTP() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["otp": self.view?.finalOtp
                        ]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_VERIFY_USER_PHONE.rawValue, parameters: param as [String : Any]) { (response, error) in
                if error == nil {
                    if self.view?.isDeleteAccountRequest == true{
                        self.view?.popViewController()
                        self.view?.deleteResquestOtpVerify?(true)
                    }else{
                        let vc = NewPasswordVC.instantiate(fromStoryboard: .Auth)
                        self.view?.pushViewController(vc: vc)
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
