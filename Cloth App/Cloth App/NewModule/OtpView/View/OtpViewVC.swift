//
//  OtpViewVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 28/05/24.
//

import UIKit
import OTPFieldView

class OtpViewVC: BaseViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var txtOtpCode: OTPFieldView!
    
    var viewModel = OtpViewModel()
    var finalOtp = String()
    var isProfileUpdate : Bool?
    var mobileNumberUpdated : ((Bool) -> Void)?
    var phone : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.view = self
        self.setupOtpView()
    }
    
    func setupOtpView(){
        self.btnNext.setAlpha(isSet: true)
        self.txtOtpCode.fieldsCount = 6
        self.txtOtpCode.fieldBorderWidth = 1
        self.txtOtpCode.defaultBackgroundColor = .init(named: "Light_Bg_Color") ?? .lightGray
        self.txtOtpCode.defaultBorderColor = UIColor.clear
        self.txtOtpCode.filledBorderColor = UIColor.black
        self.txtOtpCode.cursorColor = UIColor.black
        self.txtOtpCode.displayType = .roundedCorner
        self.txtOtpCode.fieldSize = 44
        self.txtOtpCode.separatorSpace = 8
        self.txtOtpCode.shouldAllowIntermediateEditing = false
        self.txtOtpCode.delegate = self
       
        self.txtOtpCode.initializeUI()
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func resendOnPress(_ sender: UIButton) {
        self.viewModel.callResenfOTP()
    }
    
    @IBAction func nextOnPress(_ sender: UIButton) {
        if self.finalOtp.count < 6{
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter one time password ")
        }else{
            self.viewModel.userVerifyOTP()
        }
    }
    
}

extension OtpViewVC: OTPFieldViewDelegate {
    
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
