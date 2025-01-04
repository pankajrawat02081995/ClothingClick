//
//  ViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 17/06/24.
//

import Foundation

class NewPasswordViewModel{
    var view : NewPasswordVC?
    
    
    func isValid() -> Bool{
        if self.view?.txtNewPassowrd?.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: "Please enter new password")
            return false
        }
        else if self.view?.txtConfirmPassword.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: "Please enter comfirm password")
            return false
        }
        else if self.view?.txtNewPassowrd.text != self.view?.txtConfirmPassword.text {
            UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: "New password and Confirm password does not match")
            return false
        }else{
            return true
        }
    }
    
    func callChangePassword() {
        if self.isValid(){
            if appDelegate.reachable.connection != .none {
                
                let param = [
                    "new_password" : self.view?.txtNewPassowrd.text ?? ""
                ]
                APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CHANGE_PASSWORD.rawValue, method: .post, parameters: param) { (response, error) in
                    if error == nil {
                        if let response = response {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                self.view?.popToViewController(ofType: SettingVC.self, animated: true)
                            })
                            alert.addAction(hideAction)
                            self.view?.present(alert, animated: true, completion: nil)
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
    
}
