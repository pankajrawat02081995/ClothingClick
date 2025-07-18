//
//  SignupAccesscodeViewController.swift
//  Cloth App
//
//  Created by Rishi Vekariya on 15/08/2022.
//

import UIKit

class SignupAccesscodeViewController: BaseViewController {
    
    
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var btnNext: CustomButton!
    
    var isOTPEntered = false
    var otpNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarToTransparant(navigationBar: self.navBar)
        self.setOTPView()
       
    }
    @IBAction func btnwebsite_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.openUrl(urlString: "www.clothingclick.online")
    }
    

    // MARK: - Methods -
    func setOTPView() {
        otpView.otpFieldSize = 40
        otpView.otpFieldsCount = 4
        otpView.otpFieldInputType = .alphaNumeric
        otpView.otpFieldSeparatorSpace = 8
        otpView.otpFieldDisplayType = .underlinedBottom
        otpView.cursorColor = UIColor.black
        otpView.otpFieldDefaultBackgroundColor = UIColor.white
        otpView.otpFieldEnteredBackgroundColor = UIColor.white
        otpView.otpFieldFont = UIFont(name: "ProximaNova-Medium", size: 20)!
        otpView.delegate = self
        
        // Create the UI
        otpView.initalizeUI()
    }
    @IBAction func btnDone_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        if !self.isOTPEntered {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Access code")
        }
        else
        {
            self.userVerifyOTP()
        }
    }
    
}

extension SignupAccesscodeViewController: VPMOTPViewDelegate {
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func hasEnteredAllOTP(hasEntered: Bool) {
        self.isOTPEntered = hasEntered
    }
    
    func enteredOTP(otpString: String) {
        print("OTPString: \(otpString)")
        otpNumber = otpString
    }
}

extension SignupAccesscodeViewController {
    
    func userVerifyOTP() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["access_code": self.otpNumber
                        ]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CHECK_ACCESS_CODE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    let viewController = self.storyBoard.instantiateViewController(withIdentifier: "SignupSocialViewController") as! SignupSocialViewController
                    viewController.accesscode = self.otpNumber
                    self.navigationController?.pushViewController(viewController, animated: true)
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
