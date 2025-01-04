//
//  NewChangePasswordVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 17/06/24.
//

import UIKit
import OTPFieldView

class NewChangePasswordVC: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var otpView: OTPFieldView!
    
    var viewModel = NewChangePasswordViewModel()
    var finalOtp = ""
    var isDeleteAccountRequest : Bool?
    var deleteResquestOtpVerify : ((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.isDeleteAccountRequest == true{
            self.lblTitle.text = "Delete Account"
        }
        self.viewModel.view = self
        self.setupOtpView()
        self.viewModel.userVerifyMobileNumber()
    }
    
    func setupOtpView(){
        self.btnNext.setAlpha(isSet: true)
        self.otpView.fieldsCount = 6
        self.otpView.fieldBorderWidth = 1
        self.otpView.defaultBackgroundColor = .init(named: "Light_Bg_Color") ?? .lightGray
        self.otpView.defaultBorderColor = UIColor.clear
        self.otpView.filledBorderColor = UIColor.black
        self.otpView.cursorColor = UIColor.black
        self.otpView.displayType = .roundedCorner
        self.otpView.fieldSize = 44
        self.otpView.separatorSpace = 8
        self.otpView.shouldAllowIntermediateEditing = false
        self.otpView.delegate = self
        self.otpView.initializeUI()
    }
    
    @IBAction func continewOnPress(_ sender: UIButton) {
        if self.finalOtp.count < 6{
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter one time password ")
        }else{
            self.viewModel.userVerifyOTP()
        }
    }
    
    @IBAction func resendOnPress(_ sender: UIButton) {
        self.viewModel.userVerifyMobileNumber()
    }
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
}

extension NewChangePasswordVC: OTPFieldViewDelegate {
    
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        self.btnNext.setAlpha(isSet: !hasEntered)
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        print("OTPString: \(otpString)")
        self.finalOtp = otpString
    }
}
