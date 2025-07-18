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
        setupTextFields()
        
    }
    private func setupTextFields() {
        for (index, textField) in otpView.subviews.enumerated() {
            if let otpTextField = textField as? UITextField {
                otpTextField.delegate = self
                otpTextField.tag = index
                otpTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            }
        }
    }
    
    @IBAction func continewOnPress(_ sender: UIButton) {
        if self.finalOtp.count < 6 {
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

extension NewChangePasswordVC: OTPFieldViewDelegate, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // If user pastes the entire OTP
            if let pastedText = UIPasteboard.general.string, pastedText.count == otpView.fieldsCount, range.length == 0, range.location == 0 {
                distributeOTP(pastedText)
                return false
            }
            
            // Restrict to one character per text field
            if string.count > 1 { return false }
            
            return true
        }
        
        @objc private func textFieldDidChange(_ textField: UITextField) {
            let text = textField.text ?? ""
            
            // Automatically move to the next field if filled
            if text.count == 1 {
                if let nextField = view.viewWithTag(textField.tag + 1) as? UITextField {
                    nextField.becomeFirstResponder()
                } else {
                    textField.resignFirstResponder() // Close keyboard if it's the last field
                }
            }
        }
        
        private func distributeOTP(_ otp: String) {
            for (index, char) in otp.enumerated() {
                if index < otpView.fieldsCount {
                    if let otpTextField = otpView.subviews[index] as? UITextField {
                        otpTextField.text = String(char)
                    }
                }
            }
            
            // Move focus to the last field
            otpView.subviews.last?.becomeFirstResponder()
        }
    
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
