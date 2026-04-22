//
//  LoginViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/05/24.
//

import Foundation
import FBSDKLoginKit
import FBSDKCoreKit


class LoginViewModel{
    
    var view : LoginVC?
    
    func fbLogin(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self.view ??  UIViewController()) { result, error in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let result = result, !result.isCancelled else {
                print("User cancelled login.")
                return
            }
            
            // Get the user's token and profile info
            if let token = result.token {
                let tokenString = token.tokenString
                print("Token: \(tokenString)")
                
                // Get user profile info
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"]).start { _, result, error in
                    if let error = error {
                        print("Failed to get user info: \(error.localizedDescription)")
                        return
                    }
                    
                    if let result = result as? [String: Any] {
                        let id = result["id"] as? String
                        let name = result["name"] as? String
                        let email = result["email"] as? String
                        print("User ID: \(id ?? "")")
                        print("User Name: \(name ?? "")")
                        print("User Email: \(email ?? "")")
                    }
                }
            }
        }
    }
}


extension LoginViewModel{
    
    func socialLogin(socialId:String,loginType:String) {
        let param = ["username": socialId,
                     "password": "",
                     "app_version": APP_VERSION,
                     "devices_name": UIDevice().modelName,
                     "os": UIDevice().getOS(),
                     "devices_id": UIDevice().deviceID,
                     "devices_type": DEVICE_TYPE,
                     "devices_token": appDelegate.deviceToken,
                     "login_type": loginType]
        
        if appDelegate.reachable.connection != .unavailable {
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LOGIN.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if response.status == kIsSuccess {
                            if let userDetails = response.dictData {
                                self.view?.saveUserDetails(userDetails: userDetails)
                                self.view?.startWithAuth(userData: userDetails)
                            }
                        }
                        else {
                            UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: response.message ?? "")
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? "")
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self.view ?? UIViewController())
        }
    }
}
