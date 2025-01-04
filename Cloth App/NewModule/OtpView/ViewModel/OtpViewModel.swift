//
//  OtpViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 29/05/24.
//

import Foundation

class OtpViewModel{
    
    var view : OtpViewVC?
    
    func userVerifyOTP() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["otp": self.view?.finalOtp
                        ]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_VERIFY_USER_PHONE.rawValue, parameters: param as [String : Any]) { (response, error) in
                if error == nil {
                    self.view?.navigateToHomeScreen()
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
    
    func callResenfOTP() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["phone": appDelegate.userDetails?.phone,
                         "country_prefix" : appDelegate.userDetails?.country_prefix ,
                         "country_code" : appDelegate.userDetails?.country_code,
                         "is_test" : "1"
            ]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param as [String : Any]  ) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.view?.saveUserDetails(userDetails: userDetails)
                            self.view?.startWithAuth(userData: userDetails)
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
