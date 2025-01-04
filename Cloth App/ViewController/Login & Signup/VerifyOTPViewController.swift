//
//  VerifyOTPViewController.swift
//  ClothApp
//  Created by Apple on 26/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class VerifyOTPViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var otpView: VPMOTPView!
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var btnReSendOTP: UIButton!
    
    var isOTPEntered = false
    var otpNumber = ""
    var mobileNo = ""
    var accesscode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNumber.text = appDelegate.userDetails?.phone
        self.setNavigationBarShadow(navigationBar: self.navBar)
        print(self.otpNumber)
        self.setOTPView()
    }
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.navigateToVerfyPhoneNo()
    }
    
    // MARK: - Methods -
    func setOTPView() {
        otpView.otpFieldSize = 40
        otpView.otpFieldsCount = 7
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
    
    @IBAction func btnNext_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        if !self.isOTPEntered {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter one time password ")
        }
        else
        {
            self.userVerifyOTP()
        }
    }
    
    @IBAction func btnReSendOTP_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.callResenfOTP()
    }
}

extension VerifyOTPViewController: VPMOTPViewDelegate {
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

extension VerifyOTPViewController {
    
    func userVerifyOTP() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["otp": self.otpNumber
                        ]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_VERIFY_USER_PHONE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    self.navigateToHomeScreen()
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
    
    func callResenfOTP() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["phone": appDelegate.userDetails?.phone,
                         "country_prefix" : appDelegate.userDetails?.country_prefix ,
                         "country_code" : appDelegate.userDetails?.country_code,
                         "is_test" : "1"
                        ] 
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param  ) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.startWithAuth(userData: userDetails)
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
