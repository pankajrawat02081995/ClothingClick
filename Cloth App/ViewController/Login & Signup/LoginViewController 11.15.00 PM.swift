//
//  LoginViewController.swift
//  Cloth App
//
//  Created by Apple on 14/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var btnNext: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarToTransparant(navigationBar: self.navBar)
    }
    
    @IBAction func btnNext_clicked(_ sender: Any) {
        if self.txtEmail.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email address")
        }
//        else if !self.isValidEmail(str: self.txtEmail.text!){
//            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter valid email address")
//        }
        else if self.txtPassword.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter password")
        }
        else if !self.isValidPassword(password: self.txtPassword.text!) {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "- At least 8 characters - 1 uppercase - 1 number")
        }
        else {
            self.userLogin()
        }
    }
    
    @IBAction func btnPassword_Clicked(_ button: UIButton) {
        self.btnPassword.isSelected = !self.btnPassword.isSelected
        self.txtPassword.isSecureTextEntry = !self.txtPassword.isSecureTextEntry
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtEmail.isFirstResponder {
            txtPassword.becomeFirstResponder()
        }
        else if txtPassword.isFirstResponder {
            txtPassword.resignFirstResponder()
        }
        return true
    }
    
}

extension LoginViewController {
    func userLogin() {
        if appDelegate.reachable.connection != .none {
            let param = ["username": txtEmail.text!,
                         "password": self.txtPassword.text!,
                         "app_version": APP_VERSION,
                         "devices_name": UIDevice().modelName,
                         "os": UIDevice().getOS(),
                         "devices_id": UIDevice().deviceID,
                         "devices_type": DEVICE_TYPE,
                         "devices_token": appDelegate.deviceToken,
                         "login_type": "1"]
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LOGIN.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.startWithAuth(userData: userDetails)
//                            self.navigateToHomeScreen()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
}
