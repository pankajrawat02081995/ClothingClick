//
//  ChangePasswordViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class ChangePasswordViewController: BaseViewController {

    @IBOutlet weak var txtCurrentPassword: CustomTextField!
    @IBOutlet weak var btnCurrentPasswordVisibility: UIButton!
    @IBOutlet weak var txtNewPassword: CustomTextField!
    @IBOutlet weak var btnNewPasswordVisibility: UIButton!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    @IBOutlet weak var btnConfirmPasswordVisibility: UIButton!
    @IBOutlet weak var btnSave: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnCurrentPasswordVisibility_Clicked(_ button: UIButton) {
        self.txtCurrentPassword.isSecureTextEntry = !self.txtCurrentPassword.isSecureTextEntry
        self.btnCurrentPasswordVisibility.isSelected = !self.btnCurrentPasswordVisibility.isSelected
    }
    
    @IBAction func btnNewPasswordVisibility_Clicked(_ button: UIButton) {
        self.txtNewPassword.isSecureTextEntry = !self.txtNewPassword.isSecureTextEntry
        self.btnNewPasswordVisibility.isSelected = !self.btnNewPasswordVisibility.isSelected
    }
    
    @IBAction func btnConfirmPasswordVisibility_Clicked(_ button: UIButton) {
        self.txtConfirmPassword.isSecureTextEntry = !self.txtConfirmPassword.isSecureTextEntry
        self.btnConfirmPasswordVisibility.isSelected = !self.btnConfirmPasswordVisibility.isSelected
    }
    
    @IBAction func btnSave_Clicked(_ button: UIButton) {
        if self.txtCurrentPassword.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter current password")
        }
        else if self.txtNewPassword.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter new password")
        }
        else if self.txtConfirmPassword.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter comfirm password")
        }
        else if self.txtNewPassword.text != self.txtConfirmPassword.text {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "New password and Confirm password does not match")
        }
        else if txtCurrentPassword.text == self.txtNewPassword.text {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Old password and New password can not be same")
        }
        else {
            self.callChangePassword()
        }
    }
}
extension ChangePasswordViewController {
    func callChangePassword() {
        
        if appDelegate.reachable.connection != .none {
            
            let param = ["old_password": self.txtCurrentPassword.text ?? "",
                         "new_password" : self.txtNewPassword.text ?? ""
                        ]
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CHANGE_PASSWORD.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        
                        let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                            self.navigationController?.popViewController(animated: true)
                        })
                        alert.addAction(hideAction)
                        self.present(alert, animated: true, completion: nil)
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
