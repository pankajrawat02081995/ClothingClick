//
//  SignupViewController.swift
//  ClothApp
//
//  Created by Apple on 15/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit

class SignupAppleViewController: BaseViewController {

   
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var lblProfileType: UILabel!
    @IBOutlet weak var lblUser: UILabel!
    @IBOutlet weak var lblStore: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var viewCircleUser: CustomView!
    @IBOutlet weak var viewCircleStore: CustomView!
    @IBOutlet weak var viewCircleBrand: CustomView!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnStore: UIButton!
    @IBOutlet weak var btnBrand: UIButton!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtUserName: CustomTextField!
    @IBOutlet weak var txtLocation: CustomTextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnNext: CustomButton!

    // 1 = User ,2 = store ,3 = brand
    var selType = "1"
    var address : AddressListModel!
    var addressList = [Locations?]()
    // Scocial Login
    var socialId = ""
    var firstName = ""
    var lastName = ""
    var emailId = ""
    var loginType = ""
    var profilePicture = ""
    var accesscode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarShadow(navigationBar: self.navBar)
        self.setdata()
        self.setRightSideImageInTextField(textField: self.txtLocation, image: UIImage(named: "location_ic")!)
        
        self.btnUser_clicked(self)
    }
    
    func setdata (){
        self.txtEmail.text = self.emailId
        self.txtName.text = self.firstName
    }
   
    
    @IBAction func btnUser_clicked(_ sender: Any) {
        self.selType = "1"
        self.txtName.placeholder = "Name"
        self.addressList.removeAll()
        self.txtLocation.text = ""
        self.setBorderAndRadius(radius: self.viewCircleUser.bounds.height/2, view: self.viewCircleUser, borderWidth: 1, borderColor: UIColor.clear)
        self.setBorderAndRadius(radius: self.viewCircleStore.bounds.height/2, view: self.viewCircleStore, borderWidth: 1, borderColor: UIColor.black)
        self.setBorderAndRadius(radius: self.viewCircleBrand.bounds.height/2, view: self.viewCircleBrand, borderWidth: 1, borderColor: UIColor.black)
        self.viewCircleUser.backgroundColor = UIColor().blueColor
        self.viewCircleStore.backgroundColor = UIColor.clear
        self.viewCircleBrand.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnStore_clicked(_ sender: Any) {
        self.selType = "2"
        self.txtName.placeholder = "Store Name"
        self.addressList.removeAll()
        self.txtLocation.text = ""
        self.setBorderAndRadius(radius: self.viewCircleUser.bounds.height/2, view: self.viewCircleUser, borderWidth: 1, borderColor: UIColor.black)
        self.setBorderAndRadius(radius: self.viewCircleStore.bounds.height/2, view: self.viewCircleStore, borderWidth: 1, borderColor: UIColor.clear)
        self.setBorderAndRadius(radius: self.viewCircleBrand.bounds.height/2, view: self.viewCircleBrand, borderWidth: 1, borderColor: UIColor.black)
        self.viewCircleUser.backgroundColor = UIColor.clear
        self.viewCircleStore.backgroundColor = UIColor().blueColor
        self.viewCircleBrand.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnBrand_clicked(_ sender: Any) {
        self.selType = "3"
        self.txtName.placeholder = "Brand Name"
        self.addressList.removeAll()
        self.txtLocation.text = ""
        self.setBorderAndRadius(radius: self.viewCircleUser.bounds.height/2, view: self.viewCircleUser, borderWidth: 1, borderColor: UIColor.black)
        self.setBorderAndRadius(radius: self.viewCircleStore.bounds.height/2, view: self.viewCircleStore, borderWidth: 1, borderColor: UIColor.black)
        self.setBorderAndRadius(radius: self.viewCircleBrand.bounds.height/2, view: self.viewCircleBrand, borderWidth: 1, borderColor: UIColor.clear)
        self.viewCircleUser.backgroundColor = UIColor.clear
        self.viewCircleStore.backgroundColor = UIColor.clear
        self.viewCircleBrand.backgroundColor = UIColor().blueColor
    }
    
    @IBAction func btnLocation_clicked(_ sender: Any) {
        if self.selType == "1" {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "UserLocationViewController") as! UserLocationViewController
            viewController.locationdelegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.selType == "2" {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "StoreLocationViewController") as! StoreLocationViewController
            viewController.storelocationdelegate = self
            viewController.addresslist = self.addressList
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.selType == "3" {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "BrandLocationViewController") as! BrandLocationViewController
            viewController.brandlocationdelegate = self
            viewController.addresslist = self.addressList
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnNext_clicked(_ sender: Any) {
        if self.txtEmail.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email address")
//            self.txtEmail.placeholderColor = .red
        }
        else if !self.isValidEmail(str: self.txtEmail.text!) {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter valid email address")
//            self.txtEmail.placeholderColor = .red
        }
        else if self.txtName.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter name")
//            self.txtName.placeholderColor = .red
        }
        else if self.txtUserName.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter User Name (display name)")
//            self.txtUserName.placeholderColor = .red
        }
        else if txtLocation.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Pless select your location")
//            self.txtLocation.placeholderColor = .red
        }
        else {
            self.userSignup()
        }
    }
    
}

extension SignupAppleViewController {
    
    func userSignup() {
        if appDelegate.reachable.connection != .none {
            
            var dictGeneral = [String:Any]()
            dictGeneral["access_code"] = self.accesscode
                dictGeneral["name"] = self.txtName.text ?? ""
                dictGeneral["email"] = self.txtEmail.text  ?? ""
                dictGeneral["username"] = self.txtUserName.text ?? ""
                dictGeneral["role_id"] = self.selType
                dictGeneral["devices_type"] = DEVICE_TYPE
                dictGeneral["devices_token"] = appDelegate.deviceToken
                dictGeneral["devices_name"] = UIDevice().modelName
                dictGeneral["os"] = self.getOSInfo()
                dictGeneral["devices_id"] = UIDevice().deviceID
                dictGeneral["app_version"] = APP_VERSION
            dictGeneral["signup_type"] = self.loginType
            
            if self.loginType == "2" {
                dictGeneral["facebook_id"] = self.socialId
            }
            
            if self.loginType == "4" {
                dictGeneral["google_id"] = self.socialId
            }
            
            if self.loginType == "5" {
                dictGeneral["apple_id"] = self.socialId
            }
            
            
            var address = [[String:Any]]()
            for i in 0..<self.addressList.count {
                var dict = [String:Any]()
                dict["address"] = self.addressList[i]?.address
                dict["postal_code"] = self.addressList[i]?.postal_code
                dict["latitude"] = self.addressList[i]?.latitude
                dict["longitude"] = self.addressList[i]?.longitude
//                dict["location_ids"] = "\(i)"
                dict["city"] = self.addressList[i]?.city
                dict["area"] = self.addressList[i]?.area
                address.append(dict)
            }
            
            dictGeneral["locations"] = self.json(from: address)

            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP.rawValue, parameters: dictGeneral) { (response, error) in
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


extension SignupAppleViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtEmail.isFirstResponder {
            txtName.becomeFirstResponder()
        }
        else if txtName.isFirstResponder {
            txtUserName.becomeFirstResponder()
        }
        else if txtUserName.isFirstResponder {
            txtUserName.becomeFirstResponder()
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUserName {
            let allowedCharacterSet = CharacterSet(charactersIn: kUserNameCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
//        if textField == txtName  {
//            let allowedCharacterSet = CharacterSet(charactersIn: kNameCharacters)
//            let typedCharacterSet = CharacterSet(charactersIn: string)
//            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
//            return alphabet
//        }
        return true
    }
}

extension SignupAppleViewController: UserLocationDelegate {
    
    func LocationFormAdddLocation(address: [Locations?]) {
        self.addressList.removeAll()
        self.addressList.append(contentsOf: address)
        let objet = self.addressList[0]!
//        self.txtLocation.text = "\(objet.city ?? ""), \(objet.postal_code ?? "")"
        self.txtLocation.text = "\(objet.address ?? "")"
    }
}

extension SignupAppleViewController: StoreLocationDelegate {
    func LocationFormStoreLocationAdd(addressLists: [Locations?]) {
        self.addressList.removeAll()
        for temp in addressLists {
            self.addressList.append(temp)
        }
        if addressList.count == 1 {
            if let address = self.addressList[0]?.address {
                if let  postlcode = addressList[0]?.postal_code  {
                    self.txtLocation.text = "\(address) , \(postlcode)"
                }
            }
        }
        else
        {
            let count  = self.addressList.count
            self.txtLocation.text = "\(count) Add location"
        }
    }
}
extension SignupAppleViewController: BrandLocationDelegate {
    func LocationFormBrandLocationAdd(addressLists: [Locations?]) {
        self.addressList.removeAll()
        for temp in addressLists {
            self.addressList.append(temp)
        }
        if addressList.count == 1 {
            if let address = self.addressList[0]?.city {
                self.txtLocation.text = "\(address)"
            }
        }
        else
        {
            let count  = self.addressList.count
            self.txtLocation.text = "\(count) Add location"
        }
    }
}
