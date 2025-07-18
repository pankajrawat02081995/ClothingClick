//
//  MobileNumberVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 29/05/24.
//

import UIKit
import IBAnimatable

class MobileNumberVC: BaseViewController {
    
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var txtPhoneNumber: AnimatableTextField!
    
    var viewModel = MobileNumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.view = self
        self.txtPhoneNumber.delegate = self
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func nextOnPress(_ sender: UIButton) {
        if self.txtPhoneNumber.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter mobile number ")
        }else{
            self.viewModel.userVerifyMobileNumber()
        }
    }
}

extension MobileNumberVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtPhoneNumber {
            let maxLength = 16
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else {
            return true
        }
    }
}
