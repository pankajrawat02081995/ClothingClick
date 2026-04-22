//
//  AddCreditCardViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddCreditCardViewController: BaseViewController {
    // MARK: - IBOutlets -
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblHeaderName: UILabel!
    @IBOutlet weak var lblNameOnCard: UILabel!
    @IBOutlet weak var txtNameOnCard: CustomTextField!
    @IBOutlet weak var lblAddCardNumber: UILabel!
    @IBOutlet weak var txtAddCardNumber: CustomTextField!
    @IBOutlet weak var lblExpiryDate: UILabel!
    @IBOutlet weak var lblAddCVV: UILabel!
    @IBOutlet weak var txtExpiryMonth: CustomTextField!
    @IBOutlet weak var txtExpiryYear: CustomTextField!
    @IBOutlet weak var txtAddCVV: CustomTextField!
    @IBOutlet weak var txtLocation: CustomTextField!
    @IBOutlet weak var txtAddress: CustomTextField!
    @IBOutlet weak var txtPostalcode: CustomTextField!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnAdd: CustomButton!
    
    // MARK: - Variables -
    var monthList = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var yearList = [String]()
    var addressFull = ""
    var city = ""
    var country = ""
    var state = ""
    var postalCode = ""
    // MARK: - ViewController LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.txtAddCardNumber.keyboardType = .numberPad
        self.txtAddCVV.keyboardType = .numberPad
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let currentYear = dateFormatter.string(from: Date())
        
        let intCurrentYear = Int(currentYear)!
        
        for i in 0..<10 {
            let year = "\(intCurrentYear + i)"
            yearList.append(year)
        }
        
        self.txtAddCardNumber.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)

    }
    
    
    // MARK: - IBActions -
    @IBAction func btnAdd(_ sender: Any) {
      
        if txtAddCardNumber.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Enter card number")
        }
        else if txtAddCardNumber.text!.count < 16 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Enater card number must be 16 digit")
        }
        else if txtExpiryMonth.text?.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Select expirymonth")
        }
        else if txtExpiryYear.text?.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Select expiryyear"))
        }
        else  if txtAddCVV.text?.trim().count == 0{
            UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Enter CVV number"))
        }
        else  if txtPostalcode.text?.trim().count == 0{
            UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Enter postalcode"))
        }
        else  if txtLocation.text?.trim().count == 0{
            UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Select city"))
        }
        else  if txtAddress.text?.trim().count == 0{
            UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Enter address"))
        }
        else{
            self.addCardAPI(isShowHud: true)
        }
    }
    @IBAction func btnSelectMonthClicked(_ sender : UIButton) {
        self.view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
            RPicker.selectOption(title: "Expiry Month", cancelText: kCancel, doneText: kOk, dataArray: self.monthList, selectedIndex: 0) { (month, index) in
                self.txtExpiryMonth.text = month
            }
        })
        
//            RPicker.shared.showPicker(title: self.getLocalizeTextForKey(keyName: "Title_Expiry_Month"), selected: self.monthList.first, strings: self.monthList) { (value, index, cancel) in
//                if !cancel {
//                    self.txtExpiryMonth.text = value
//                }
//            }
//        })
    }
    
    @IBAction func btnSelectYearClicked(_ sender : UIButton) {
        self.view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01, execute: {
            RPicker.selectOption(title: "Expiry Year", cancelText: kCancel, doneText: kOk, dataArray: self.yearList, selectedIndex: 0) { (year, index) in
                self.txtExpiryYear.text = year
            }
//            DPPickerManager.shared.showPicker(title: self.getLocalizeTextForKey(keyName: "Title_Expiry_Year"), selected: self.yearList.first, strings: self.yearList) { (value, index, cancel) in
//                if !cancel {
//                    self.txtExpiryYear.text = value
//                }
//            }
        })
    }
    
    @objc func didChangeText(textField:UITextField) {
        textField.text = self.modifyCreditCardString(creditCardString: textField.text!)
    }

    // MARK: - Methods -
    func modifyCreditCardString(creditCardString : String) -> String {
        let trimmedString = creditCardString.components(separatedBy: .whitespaces).joined()
        
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
}

extension AddCreditCardViewController: UITextFieldDelegate {
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txtNameOnCard.isFirstResponder {
            _ = txtAddCardNumber.becomeFirstResponder()
        }
        else if txtAddCardNumber.isFirstResponder {
            _ = txtExpiryMonth.becomeFirstResponder()
        }
        else if txtExpiryMonth.isFirstResponder {
            _ = txtExpiryYear.becomeFirstResponder()
        }
        else if txtExpiryYear.isFirstResponder {
            _ = txtAddCVV.becomeFirstResponder()
        }
        else if txtAddCVV.isFirstResponder {
            _ = txtAddCVV.resignFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if(textField == txtAddCardNumber) {
            return newLength <= 19
        }
        else if(textField == txtAddCVV) {
            return newLength <= 3
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtLocation {
            let viewController = GMSAutocompleteViewController()
            viewController.delegate = self
            viewController.setFilter()
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
}

extension AddCreditCardViewController: GMSAutocompleteViewControllerDelegate  {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        
        print("Place name: ", place.name ?? "")
        print("Place address: ", place.formattedAddress ?? "")
        print("Place attributions: ", place.attributions ?? "")
        
        if let data = place.attributions {
            
            print(data.accessibilityLabel)
          //  self.state = data[0].
            //  self.country = data[2]
        }
//        self.txtAddress.text = place.formattedAddress!
        self.addressFull = place.formattedAddress!
        
        
        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
        self.postalCode = component.postalCode ?? ""
           //   self.area = component.area ?? ""
        self.txtLocation.text = component.city ?? ""
        self.state = component.state ?? ""
        self.country = component.country ?? ""
//        if place.addressComponents != nil {
//            for addressComponent in (place.addressComponents)! {
//                for type in (addressComponent.types){
//
//                    switch(type){
//                    case "sublocality_level_2":
//                        print(addressComponent.name)
//                    case "sublocality_level_1":
//                        print (addressComponent.name) //ariya
////                        self.area = addressComponent.name
//                    case "administrative_area_level_2":
//                        print(addressComponent.name)
//                        self.city = addressComponent.name // city
//                        self.txtLocation.text = self.city
//                    case "administrative_area_level_1":
//                        print(addressComponent.name)    // state
//                        self.state = addressComponent.name
//                    case "country":
//                        print(addressComponent.shortName)
//                        self.country = addressComponent.shortName ?? ""
//                    case "postal_code":
//                        print(addressComponent.name)
//                        self.postalCode = addressComponent.name
//                        self.txtPostalcode.text = self.postalCode
//                    default:
//                        break
//                    }
//                }
//            }
//        }

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
extension AddCreditCardViewController {
    func addCardAPI(isShowHud: Bool) {
        if appDelegate.reachable.connection != .none {

            let creditCardNumber = txtAddCardNumber.text!.replace(" ", replacement: "")

            let param = ["card_number": creditCardNumber,
                         "exp_month": txtExpiryMonth.text ?? "",
                         "exp_year": txtExpiryYear.text ?? "",
                         "cvv": txtAddCVV.text ?? "",
                         "card_name" : self.txtNameOnCard.text ?? "",
                         "address" : self.txtAddress.text ?? "",
                         "postal_code" : self.txtPostalcode.text ?? "",
                         "city" : self.txtLocation.text ?? "",
                         "state" : self.state,
                         "country" : self.country] as [String : Any]

                APIManager().apiCall(of:OtherUserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.PAYMENT_METHOD_ADD.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {

//                    let responseData = response as! [String : Any]
                    self.navigationController?.popViewController(animated: true)
                    //dictionary
//                    if let data = responseData[kData] as? [String : Any] {
//
//                        if appDelegate.userDetails["login_type"] as? String == "Guest" {
//                            var dict = [String:Any]()
//                            dict["customer_id"] = data["customer_id"]
//                            dict["card_id"] = data["card_id"]
//                            // post a notification
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passGuestCreditCardData"), object: nil, userInfo: dict)
//                        }
//
//                    }

                    //array
//                    if let data = responseData[kData] as? [[String : Any]] {
//
//                        if appDelegate.userDetails["login_type"] as? String != "Guest" {
//                            var dict = [String:Any]()
//                            dict["arrCards"] = data
//                            // post a notification
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "passCreditCardList"), object: nil, userInfo: dict)
//                        }
//                        self.navigationController?.popViewController(animated: true)
//                    }

                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }

}


