//
//  TroubleLoginViewController.swift
//  ClothApp
//
//  Created by Apple on 18/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS

class TroubleLoginViewController: BaseViewController {

    @IBOutlet weak var imgLock: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var txtCountryCode: UITextField!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var btnSend: CustomButton!
    @IBOutlet weak var btnBackToLogin: UIButton!
    
    var selCountryName = ""
    var selPhoneCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarShadow(navigationBar: self.navBar)
        
        let selIndex = CountryManager.shared.countries.firstIndex { (($0 as Country).dialingCode == DEFAULT_COUNTRYCODE) && (($0 as Country).countryName == DEFAULT_COUNTRYNAME)}!
        CountryManager.shared.lastCountrySelected = CountryManager.shared.countries[selIndex]
        self.setCountryData(country: CountryManager.shared.lastCountrySelected!)
    }
    
    func setCountryData(country: Country) {
        self.txtCountryCode.text = "\(country.countryCode) \(country.dialingCode!) -"
//        self.setLeftSideImageInTextField(textField: self.txtCountryCode, image: country.flag!)
        self.selCountryName = country.countryName
        self.selPhoneCode = "\(country.dialingCode!)"
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
    
    @IBAction func btnSend_clicked(_ sender: Any) {
        if self.txtPhoneNo.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter mobile number ")
        } else if !isValidPhoneNumber(phoneNumber: "\(selPhoneCode)\(self.txtPhoneNo.text!)", countryCode: self.selCountryName) {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter the correct mobile number")
        } else {
            self.callForgotPassword()
        }
    }
   
    @IBAction func btnBackToLogin_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.navigateToWelconeScreen()
    }
}
extension TroubleLoginViewController {
    func callForgotPassword() {
        if appDelegate.reachable.connection != .none {
           // \(self.selPhoneCode)
            let param = ["phone": "\(self.txtPhoneNo.text!)"]
            
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FORGOT_PASSWORD.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            let vc = MobileNumberVC.instantiate(fromStoryboard: .Auth)
                            self.pushViewController(vc: vc)
                        }else{
                            self.navigateToWelconeScreen()
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
