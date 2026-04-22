//
//  UserLocationSetDefaultViewController.swift
//  Cloth App
//
//  Created by Apple on 30/06/21.
//

import UIKit
import GoogleMaps
import Contacts
import GooglePlaces

class UserLocationSetDefaultViewController: BaseViewController {
    
    @IBOutlet weak var txtPostalcode: CustomTextField!
    @IBOutlet weak var txtLocatio: CustomTextField!
    @IBOutlet weak var lblRecentLocation: UILabel!
    @IBOutlet weak var constTopFortxtLblRecentLocation: NSLayoutConstraint!

    @IBOutlet weak var tblAddressList: UITableView!
    
    var addressList = [Locations?]()
    var userData : UserDetailsModel?
    var lat = 0.0
    var log = 0.0
    var city = ""
    var address = ""
    var adddressArea = ""
    var deletedLocationIds = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if appDelegate.userDetails?.role_id == 1 {
//            self.txtPostalcode.isHidden = false
//            self.constTopFortxtLblRecentLocation.constant = 20
//        }
//        else if appDelegate.userDetails?.role_id == 2 {
//            self.txtPostalcode.isHidden = true
//            self.constTopFortxtLblRecentLocation.constant = -50
//        }
//        else {
//            self.txtPostalcode.isHidden = true
//            self.constTopFortxtLblRecentLocation.constant = -50
//        }
//        self.getUserDetails()
    }
    
    func setDefaultLocation () {
        for i in 0..<self.addressList.count {
            if self.addressList[i]?.is_default == 1 {
                self.txtLocatio.text = self.addressList[i]?.city
                self.txtPostalcode.text = self.addressList[i]?.postal_code
            }
        }
    }
}

extension UserLocationSetDefaultViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = self.addressList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetDefaultLocationCell", for: indexPath) as! SetDefaultLocationCell
        cell.lblExpDate.isHidden = true
//        if appDelegate.userDetails?.role_id == 3 {
//            cell.lblPostalCoud.isHidden = true
//            cell.lblAddress.isHidden = true
//        }
        if object?.isPayAddress() ?? false {
            if object?.isSelectedAddress() ?? false{
                cell.btnSetDefault.isHidden = true//!(object?.isSelectedAddress() ?? false)
                cell.btnPay.isHidden = true
                cell.btnDelete.isHidden = true
                cell.constTopForbtnPay.constant = -30
            }
            else {
                cell.btnDelete.isHidden = true
                cell.constTopForbtnPay.constant = -30
                cell.btnSetDefault.isHidden = false
                cell.btnPay.isHidden = true
            }
            if let strDate = object?.expire_at {
                let date = convertStringToDate(format: dateFormateForGet, strDate: strDate)
                let convDate = self.convertDateToString(format: dateFormateForDisplayForPremun, date: date)
                cell.lblExpDate.textColor = .red
                cell.lblExpDate.text = "Expire on:- \(convDate)"
                cell.lblExpDate.isHidden = false
            }
          }
        else {
            if object?.isSelectedAddress() ?? false {
                cell.btnPay.isHidden = true
                cell.btnSetDefault.isHidden = true
                cell.btnDelete.isHidden = true
                cell.constTopForbtnPay.constant = -30
            }
            else {
                if object?.isPaidPrise() != 0 {
                    if let prise = object?.price {
                        cell.btnPay.isHidden = false
                        cell.btnPay.setTitle("Pay $ \(prise)", for: .normal)
                        cell.btnSetDefault.isHidden = true//(object?.isSelectedAddress() ?? false)
                    }
                }
                else {
                    cell.btnPay.isHidden = true
                    cell.btnSetDefault.isHidden = !(object?.isSelectedAddress() ?? false)
                }
            }
            
        }
        cell.lblAddressCount.text = "Location \(indexPath.row + 1)"
        cell.lblCity.text = object?.city
        cell.lblPostalCoud.text = object?.postal_code
        cell.lblAddress.text = object?.address
        cell.btnSetDefault.addTarget(self, action: #selector(btnSetDefault_Clicked(sender:)), for: .touchUpInside)
        cell.btnPay.addTarget(self, action: #selector(btnPay_Clicked(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    @objc func btnSetDefault_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblAddressList)
        if let indexPath = self.tblAddressList.indexPathForRow(at: buttonPosition) {
            self.callSetDefaultLocation(locationId: String(self.addressList[indexPath.row]?.id ?? 0))
        }
    }
    @objc func btnDelete_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblAddressList)
        if let indexPath = self.tblAddressList.indexPathForRow(at: buttonPosition) {
            self.callDeleteLocation(locationId: String(self.addressList[indexPath.row]?.id ?? 0), index: indexPath.row)
        }
    }
    @objc func btnPay_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblAddressList)
        if let indexPath = self.tblAddressList.indexPathForRow(at: buttonPosition) {
            //            self.callSetDefaultLocation(locationId: String(self.addressList[indexPath.row]?.id ?? 0))
            let ViewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
            ViewController.locationId = "\(self.addressList[indexPath.row]?.id ?? 0)"
            self.navigationController?.pushViewController(ViewController, animated: true)
        }
    }
}

extension UserLocationSetDefaultViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtLocatio {
            if appDelegate.userDetails?.role_id == 2 {
                let viewController = self.storyboard?.instantiateViewController(identifier: "EditeStoreLocationViewController") as! EditeStoreLocationViewController
                viewController.editStoreLocationDelegate = self
                viewController.addresslist = appDelegate.userDetails?.locations! as! [Locations?]
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if appDelegate.userDetails?.role_id == 1{
                let viewController = self.storyboard?.instantiateViewController(identifier: "UserLocationViewController") as! UserLocationViewController
                viewController.edit = true
                if let address = appDelegate.userDetails?.locations {
                    viewController.addresslist = address
                }
                
                viewController.locationdelegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else{
                let viewController = self.storyboard?.instantiateViewController(identifier: "BrandLocationViewController") as! BrandLocationViewController
                viewController.edit = true
                viewController.editeBrandlocationdelegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            return false
        }
        if textField == txtPostalcode {
            if appDelegate.userDetails?.role_id == 2 {
                let viewController = self.storyboard?.instantiateViewController(identifier: "EditeStoreLocationViewController") as! EditeStoreLocationViewController
                viewController.editStoreLocationDelegate = self
                viewController.addresslist = appDelegate.userDetails?.locations! as! [Locations?]
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if appDelegate.userDetails?.role_id == 1{
                let viewController = self.storyboard?.instantiateViewController(identifier: "UserLocationViewController") as! UserLocationViewController
                viewController.edit = true
                viewController.locationdelegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else{
                let viewController = self.storyboard?.instantiateViewController(identifier: "BrandLocationViewController") as! BrandLocationViewController
                viewController.edit = true
                viewController.editeBrandlocationdelegate = self
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            return false
        }
        return true
    }
}

class SetDefaultLocationCell : UITableViewCell
{
    @IBOutlet weak var lblAddressCount: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPostalCoud: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblExpDate: UILabel!
    @IBOutlet weak var btnPay: CustomButton!
    @IBOutlet weak var constTopForbtnPay: NSLayoutConstraint!

    @IBOutlet weak var btnSetDefault: CustomButton!
    @IBOutlet weak var btnDelete: UIButton!
}
extension UserLocationSetDefaultViewController {
    func callSetDefaultLocation(locationId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["location_id" : locationId ]
            
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.SET_DEFAULT_LOCATION.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let userDetails = response?.dictData {
                        self.addressList.removeAll()
                        for i in 0..<userDetails.locations!.count {
                            self.addressList.append(userDetails.locations?[i])
                        }
                        self.saveUserDetails(userDetails: userDetails)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.setDefaultLocation()
                        self.tblAddressList.reloadData()
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
    
    func callDeleteLocation(locationId : String ,index : Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["location_id" : locationId ]
            
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.LOCATION_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    
                    if let userDetails = response?.dictData {
                        self.saveUserDetails(userDetails: userDetails)
                        if let locations = userDetails.locations {
                            self.addressList = locations
                        }
                    }
                    self.tblAddressList.reloadData()
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
    
    func getUserDetails() {
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.AUTOLOGIN.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.userData = userDetails
                        }
                        self.addressList = self.userData?.locations as! [Locations?]//appDelegate.userDetails?.locations as! [Locations?]
//                        self.setDefaultLocation()
                        self.tblAddressList.reloadData()
                    }
                }
                else {
                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
                }
            }
        }
        else {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
        }
    }
    func callUpdetUserProfile() {
        if appDelegate.reachable.connection != .none {
            
            var dictGeneral = [String:Any]()
            
            var address = [[String:Any]]()
            
            dictGeneral["name"] = appDelegate.userDetails?.name//self.txtBrandName.text ?? ""
            dictGeneral["email"] = appDelegate.userDetails?.email ?? ""
            dictGeneral["username"] = appDelegate.userDetails?.username ?? ""
            if appDelegate.userDetails?.role_id == 1 {
                dictGeneral["phone"] = appDelegate.userDetails?.phone
                dictGeneral["country_code"] = appDelegate.userDetails?.country_code
                dictGeneral["country_prefix"] = appDelegate.userDetails?.country_prefix
//                for i in 0..<(appDelegate.userDetails?.locations?.count ?? 0)  {
//                    var dict = [String:Any]()
//                    dict["id"] = appDelegate.userDetails?.locations?[i].id
//                    dict["address"] = appDelegate.userDetails?.locations?[i].address
//                    dict["postal_code"] = appDelegate.userDetails?.locations?[i].postal_code
//                    dict["latitude"] = appDelegate.userDetails?.locations?[i].latitude
//                    dict["longitude"] = appDelegate.userDetails?.locations?[i].longitude
//                    dict["city"] = appDelegate.userDetails?.locations?[i].city
//                    dict["area"] = appDelegate.userDetails?.locations?[i].area
//                    address.append(dict)
//                    print(address)
//                }
                for i in 0..<(self.addressList.count)  {
                    var dict = [String:Any]()
                    dict["id"] = self.addressList[i]?.id
                    dict["address"] = self.addressList[i]?.address
                    dict["postal_code"] = self.addressList[i]?.postal_code
                    dict["latitude"] = self.addressList[i]?.latitude
                    dict["longitude"] = self.addressList[i]?.longitude
                    dict["city"] = self.addressList[i]?.city
                    dict["area"] = self.addressList[i]?.area
                    address.append(dict)
                    print(address)
                }
            }
            else {
                dictGeneral["phone"] = appDelegate.userDetails?.phone//self.txtPhone.text ?? ""
                dictGeneral["country_code"] = appDelegate.userDetails?.country_code
                dictGeneral["country_prefix"] = appDelegate.userDetails?.country_prefix
//                if iscityAdd {
//
//                }
                for i in 0..<(self.addressList.count)  {
                    var dict = [String:Any]()
                    dict["id"] = self.addressList[i]?.id
                    dict["address"] = self.addressList[i]?.address
                    dict["postal_code"] = self.addressList[i]?.postal_code
                    dict["latitude"] = self.addressList[i]?.latitude
                    dict["longitude"] = self.addressList[i]?.longitude
                    dict["city"] = self.addressList[i]?.city
                    dict["area"] = self.addressList[i]?.area
                    address.append(dict)
                    print(address)
                }
            }
            dictGeneral["bio"] = appDelegate.userDetails?.bio//self.txtBio.text ?? ""
            dictGeneral["website"] = appDelegate.userDetails?.website//self.txtWebsite.text ?? ""
            
            dictGeneral["deleted_location_ids"] = self.deletedLocationIds
            print(address)
            dictGeneral["locations"] = self.json(from: address)
//            if self.selectedImage == nil {
//                APIManager().apiCallWithImage(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, parameters: dictGeneral, images: [self.selectedImage], imageParameterName: "photo", imageName: "user.png"){  (response, error) in
//                    if error == nil {
                APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, method: .post, parameters: dictGeneral) { (response, error) in
                    if error == nil {
                        if let response = response {
//                            if let userDetails = response.dictData {
//                                self.saveUserDetails(userDetails: userDetails)
////                                self.startWithAuth(userData: userDetails)
//                            }
//                            self.view.endEditing(true)
//                            self.addressList = self.userData?.locations as! [Locations?]
//                            self.tblAddressList.reloadData()
                            if let userDetails = response.dictData {
                                self.saveUserDetails(userDetails: userDetails)
//                                self.userData = userDetails
                            }
                            if let addressList = appDelegate.userDetails?.locations {//self.userData?.locations {
                                self.addressList = addressList
                                self.tblAddressList.reloadData()
                            }
                              //[Locations?]//appDelegate.userDetails?.locations as! [Locations?]
    //                        self.setDefaultLocation()
                            
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
//            else {
//                APIManager().apiCallWithImage(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, parameters: dictGeneral, images: [self.selectedImage], imageParameterName: "photo", imageName: "user.png"){  (response, error) in
//                    if error == nil {
//                        if let response = response {
//                            if let userDetails = response.dictData {
//                                self.saveUserDetails(userDetails: userDetails)
//                            }
//                            self.view.endEditing(true)
//                            if appDelegate.userDetails?.phone_verified_at == "" || appDelegate.userDetails?.phone_verified_at == nil{
//                                self.navigateToVerfyPhoneNo()
//                            }
//                            else {
//                                if let message = response.message {
//                                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
//                                    alert.view.tintColor = UIColor().alertButtonColor
//
//                                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
//                                        self.navigationController?.popViewController(animated: true)
//                                    })
//                                    alert.addAction(hideAction)
//
//                                    self.navigationController?.popViewController(animated: true)
//                                }
//                            }
//
//                        }
//                    }
//                    else {
//                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                    }
//                }
//            }
            
        
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}

extension UserLocationSetDefaultViewController: GMSAutocompleteViewControllerDelegate  {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        
        self.lat = place.coordinate.latitude
        self.log = place.coordinate.longitude
        self.address = place.formattedAddress!
        
        let component = self.getCityPostCodeArea(addressComponents: place.addressComponents)
        self.txtPostalcode.text = component.postalCode
        self.adddressArea = component.area ?? ""
        self.txtLocatio.text = component.city ?? ""
        self.city = component.city ?? ""
        
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

extension UserLocationSetDefaultViewController: UserLocationDelegate,EditBrandLocationDelegate {
    func LocationFormEditBrandLocationAdd(addressLists: [Locations?], deletedId: [String]) {
        self.addressList.removeAll()
        for temp in addressLists {
            self.addressList.append(temp)
        }
        self.deletedLocationIds = deletedId.joined(separator: ",")
        if addressList.count == 1 {
            if let address = self.addressList[0]?.address {
                if let  postlcode = addressList[0]?.postal_code  {
                    self.txtLocatio.text = "\(address) , \(postlcode)"
                }
            }
        }
        else
        {
            let count  = self.addressList.count
            self.txtLocatio.text = "\(count) Add location"
        }
        self.callUpdetUserProfile()
    }
    
    func LocationFormAdddLocation(address: [Locations?]) {
        self.addressList.removeAll()
        self.addressList.insert(contentsOf: address, at: 0)
        self.txtLocatio.text = "\(address[0]?.address ?? ""), \(address[0]?.postal_code ?? "")"
        self.txtPostalcode.text = "\(address[0]?.postal_code ?? "")"
        self.callUpdetUserProfile()
    }
}

extension UserLocationSetDefaultViewController: EditStoreLocationDelegate {
    func LocationFormEditStoreLocationAdd(addressLists: [Locations?], deletedId: [String]) {
        self.addressList.removeAll()
        for temp in addressLists {
            self.addressList.append(temp)
        }
        self.deletedLocationIds = deletedId.joined(separator: ",")
        if addressList.count == 1 {
            if let address = self.addressList[0]?.address {
                if let  postlcode = addressList[0]?.postal_code  {
                    self.txtLocatio.text = "\(address) , \(postlcode)"
                }
            }
        }
        else
        {
            let count  = self.addressList.count
            self.txtLocatio.text = "\(count) Add location"
        }
        self.callUpdetUserProfile()
    }
    
}
