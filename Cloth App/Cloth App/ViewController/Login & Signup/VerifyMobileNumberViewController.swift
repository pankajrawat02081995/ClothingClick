//
//  VerifyMobileNumberViewController.swift
//  ClothApp
//
//  Created by Apple on 26/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class VerifyMobileNumberViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnNext: CustomButton!
    
    var selCountryCode = ""
    var selCountryName = ""
    var selPhoneCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarShadow(navigationBar: self.navBar)
        
        let selIndex = CountryManager.shared.countries.firstIndex { (($0 as Country).dialingCode == DEFAULT_COUNTRYCODE) && (($0 as Country).countryName == DEFAULT_COUNTRYNAME)}!
        CountryManager.shared.lastCountrySelected = CountryManager.shared.countries[selIndex]
        self.setCountryData(country: CountryManager.shared.lastCountrySelected!)
        
    }
    @IBAction func btnBack_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.navigateToWelconeScreen()
    }
    
    func setCountryData(country: Country) {
        self.txtCountryCode.text = "\(country.countryCode) \(country.dialingCode!) -"
        //        self.setLeftSideImageInTextField(textField: self.txtCountryCode, image: country.flag!)
        print(country.countryCode)
        self.selCountryCode = country.countryCode
        self.selCountryName = country.countryName
        self.selPhoneCode = String(country.dialingCode!)
    }
    
    @IBAction func btnCountryCode_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { (country: Country) in
            self.setCountryData(country: country)
        }
        countryController.detailColor = UIColor.black
        countryController.labelColor = UIColor.black
        countryController.isHideFlagImage = false
        countryController.isHideDiallingCode = false
    }
    
    @IBAction func btnNext_clicked(_ sender: Any) {
        if self.txtPhoneNo.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter mobile number ")
        } else {
            self.userVerifyMobileNumber()
        }
    }
}

extension VerifyMobileNumberViewController {
    
    func userVerifyMobileNumber() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["phone": "\(self.txtPhoneNo.text ?? "")",
                         "country_prefix" : self.selPhoneCode ,
                         "country_code" : self.selCountryCode,
                         "is_test" : "1"
            ]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            //                            self.startWithAuth(userData: userDetails)
                            let otp = userDetails.otp
                            print(otp)
                            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "VerifyOTPViewController") as! VerifyOTPViewController
                            viewController.mobileNo = self.txtPhoneNo.text!
                            viewController.otpNumber = "\(otp)"
                            self.navigationController?.pushViewController(viewController, animated: true)
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

extension VerifyMobileNumberViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtPhoneNo {
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
