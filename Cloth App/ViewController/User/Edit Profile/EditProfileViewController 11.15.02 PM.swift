//
//  EditProfileViewController.swift
//  ClothApp
//
//  Created by Apple on 07/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import AVKit
class EditProfileViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUserProfilPic: CustomImageView!
    @IBOutlet weak var btnEditPic: UIButton!
    @IBOutlet weak var txtDisplayUsearName: CustomTextField!
    @IBOutlet weak var txtBrandName: CustomTextField!
    @IBOutlet weak var txtWebsite: CustomTextField!
    @IBOutlet weak var txtBio: CustomTextView!
    @IBOutlet weak var constTopFortxtBio: NSLayoutConstraint!
    @IBOutlet weak var txtLocation: CustomTextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var viewEmail: CustomView!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var viewPhone: CustomView!
    @IBOutlet weak var txtPhone: CustomTextField!
    @IBOutlet weak var btnSave: CustomButton!
    @IBOutlet weak var constTopForBtnSave: NSLayoutConstraint!
    @IBOutlet weak var btnShowEmail : CustomButton!
    @IBOutlet weak var btnShowPhone: CustomButton!
    
    var addressList = [Locations?]()
    var selectedImage: UIImage!
    let placeholder = "Bio"
    var loginType = ""
    var deletedLocationIds = ""
    var iscityAdd = false
    var isEmailShow = "0"
    var isPhoneShow = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtBio.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10 )
        
        self.setEmailPhoneButtonTitel()
        if appDelegate.userDetails?.role_id == 2 {
            self.txtBrandName.placeholder = "Store Name"
            self.lblContact.isHidden = false
            self.txtEmail.isHidden = false
            self.txtPhone.isHidden = false
            self.viewEmail.isHidden = false
            self.viewPhone.isHidden = false
//            self.txtEmail.isUserInteractionEnabled = false
//            self.txtPhone.isUserInteractionEnabled = false
            self.txtWebsite.isHidden = false
            self.btnShowEmail.isHidden = false
            self.btnShowPhone.isHidden = false
        }
        else if appDelegate.userDetails?.role_id == 1{
            self.txtBrandName.text = "Name"
            self.constTopFortxtBio.constant = -50
            self.constTopForBtnSave.constant = -160
            self.lblContact.isHidden = true
            self.txtEmail.isHidden = true
            self.txtPhone.isHidden = true
            self.viewEmail.isHidden = true
            self.viewPhone.isHidden = true
            self.txtWebsite.isHidden = true
            self.btnShowEmail.isHidden = true
            self.btnShowPhone.isHidden = true
        }
        else{
            self.txtBrandName.placeholder = "Brand Name"
            self.lblContact.isHidden = false
            self.txtEmail.isHidden = false
            self.txtPhone.isHidden = false
            self.viewEmail.isHidden = false
            self.viewPhone.isHidden = false
//            self.txtEmail.isUserInteractionEnabled = false
//            self.txtPhone.isUserInteractionEnabled = false
            self.txtWebsite.isHidden = false
            self.btnShowEmail.isHidden = false
            self.btnShowPhone.isHidden = false
        }
        self.setData()
    }
    
    func setEmailPhoneButtonTitel() {
        if appDelegate.userDetails?.isEmailShow() ?? false{
            self.btnShowEmail.setTitle("Show", for: .normal)
        }
        else {
            self.btnShowEmail.setTitle("Don't show", for: .normal)
        }
        if appDelegate.userDetails?.isPhoneShow() ?? false{
            self.btnShowPhone.setTitle("Show", for: .normal)
        }
        else {
            self.btnShowPhone.setTitle("Don't show", for: .normal)
        }
    }
    
    @IBAction func btnShowEmail_Clicked(_ button: UIButton) {
        if btnShowEmail.titleLabel?.text == "Show"{
            self.isEmailShow = "0"
        }
        else {
            self.isEmailShow = "1"
        }
        self.callIsEmailShow()
    }
    
    @IBAction func btnShowPhone_Clicked(_ button: UIButton) {
        if btnShowPhone.titleLabel?.text == "Show"{
            self.isPhoneShow = "0"
        }
        else {
            self.isPhoneShow = "1"
        }
        self.callIsPhoneShow()
    }
    
    @IBAction func btnSave_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        if appDelegate.userDetails?.role_id == 1 {
            if self.txtDisplayUsearName.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Username")
            }
            else if self.txtBrandName.text?.trim().count == 0{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter name")
            }
            else if self.txtLocation.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
            }
            else {
                self.selectedImage = self.imgUserProfilPic.image
                self.callUpdetUserProfile()
            }
        }
        else if appDelegate.userDetails?.role_id == 2 {
             if self.txtDisplayUsearName.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Username")
            }
            else if self.txtBrandName.text?.trim().count == 0{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Store name")
            }
            else if self.txtLocation.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")

            }
            else if self.txtEmail.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email")

            }
            else if self.txtPhone.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter phone")

            }
            else {
                self.selectedImage = self.imgUserProfilPic.image
                self.callUpdetUserProfile()
            }
        }
        else {
            if self.txtDisplayUsearName.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Username")

            }
            else if self.txtBrandName.text?.trim().count == 0{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter brand name")
            }
            else if self.txtLocation.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")

            }
            else if self.txtEmail.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email")

            }
            else if self.txtPhone.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter phone")

            }
            else {
                self.selectedImage = self.imgUserProfilPic.image
                self.callUpdetUserProfile()
            }
        }
    }
    
    @IBAction func btnLocation_Clicked(_ button: UIButton) {
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
            viewController.addresslist = appDelegate.userDetails?.locations! as! [Locations?]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else{
            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandLocationViewController") as! BrandLocationViewController
            viewController.edit = true
            viewController.editeBrandlocationdelegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func setData () {
        if let url = appDelegate.userDetails?.photo {
            if let imgUrl = URL.init(string: url) {
                self.imgUserProfilPic.kf.setImage(with: imgUrl, placeholder: ProfileHolderImage)
                
            }
        }
        if appDelegate.userDetails?.role_id == 1 {
            if let name = appDelegate.userDetails?.name {
                
                self.txtBrandName.text = name
            }
            if let useraName = appDelegate.userDetails?.username{
                self.txtDisplayUsearName.text = useraName
            }
            if let bio = appDelegate.userDetails?.bio {
                self.txtBio.text = bio
            }else{
                self.txtBio.text = placeholder
            }
            if let address = appDelegate.userDetails?.locations{
                self.txtLocation.text = address[0].address
                for i in 0..<address.count {
                    var dict = [String:Any]()
                    dict["id"] = address[i].id
                    dict["address"] = address[i].address
                    dict["postal_code"] = address[i].postal_code
                    dict["latitude"] = address[i].latitude
                    dict["longitude"] = address[i].longitude
                    dict["city"] = address[i].city
                    dict["area"] = address[i].area
                    let addressobject = Locations.init(JSON: dict)
                    self.addressList.append(addressobject)
                }
            }
        }
        else {
            if let name = appDelegate.userDetails?.name {
                self.txtBrandName.text = name
            }
            if let Website = appDelegate.userDetails?.website {
                self.txtWebsite.text = Website
            }
            if let bio = appDelegate.userDetails?.bio {
                self.txtBio.text = bio
            }
            else{
                self.txtBio.text = placeholder
            }
            if let useraName = appDelegate.userDetails?.username{
                self.txtDisplayUsearName.text = useraName
            }
            if let address = appDelegate.userDetails?.locations{
                self.txtLocation.text = address[0].address
            }
            if let phono = appDelegate.userDetails?.phone {
                self.txtPhone.text = phono
            }
            if let email = appDelegate.userDetails?.email {
                self.txtEmail.text = email
            }
            if let address = appDelegate.userDetails?.locations{
                self.txtLocation.text = "\(address.count) Location"
                for i in 0..<address.count {
//                    var dict : [String:Any]()
                    var dict = [String:Any]()
                    dict["id"] = address[i].id
                    dict["address"] = address[i].address
                    dict["postal_code"] = address[i].postal_code
                    dict["latitude"] = address[i].latitude
                    dict["longitude"] = address[i].longitude
                    dict["city"] = address[i].city
                    dict["area"] = address[i].area
//                    dict?.address = address[i].address ?? ""
//                    dict?.postal_code = address[i].postal_code ?? ""
//                    dict?.latitude = address[i].latitude ?? ""
//                    dict?.longitude = address[i].longitude ?? ""
//                    dict?.city = address[i].city ?? ""
//                    dict?.area = address[i].area ?? ""
                    let addressobject = Locations.init(JSON: dict)
                    self.addressList.append(addressobject)
                    print(self.addressList[i])
                }
            }
        }
    }
    
    @IBAction func btnEditPic_Clicked(_ button: UIButton) {
        self.showActionSheet()
    }
    
    func checkcameraPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            self.camera()
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        default:
            // Not determined fill fall here - after first use, when is't neither authorized, nor denied
            // we try to use camera, because system will ask itself for camera permissions
            self.camera()
        }
    }
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: AlertViewTitle, message: "Camera access required", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })

        present(alert, animated: true)
    }
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.setAlertButtonColor()
        
        actionSheet.addAction(UIAlertAction(title: "Using Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.checkcameraPermissions()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Existing Photo", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self //as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
        myPickerController.modalPresentationStyle = .overCurrentContext
        myPickerController.addStatusBarBackgroundView()
        myPickerController.view.tintColor = UIColor().alertButtonColor
        self.present(myPickerController, animated: true, completion: nil)
        
    }
}
extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.imgUserProfilPic.image = image
            self.selectedImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            //textView.textColor = UIColor(named: "DarkGrayColor")!
        }
        if textView.text == placeholder{
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == txtBio {
            if textView.text.isEmpty {
                textView.text = ""
                textView.textColor = UIColor.black
            }
//            else {
//                self.txtBio.text = appDelegate.userDetails?.bio
//            }
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtPhone {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txtDisplayUsearName.isFirstResponder {
            txtBrandName.becomeFirstResponder()
        }
        else if txtBrandName.isFirstResponder {
            txtWebsite.becomeFirstResponder()
        }
        else if txtWebsite.isFirstResponder {
            txtBio.becomeFirstResponder()
        }
        else if txtBio.isFirstResponder {
            txtLocation.becomeFirstResponder()
        }
        else if txtLocation.isFirstResponder {
            txtEmail.becomeFirstResponder()
        }
        else if txtEmail.isFirstResponder {
            txtPhone.resignFirstResponder()
        }
        return true
    }
}

extension EditProfileViewController {
    func callUpdetUserProfile() {
        if appDelegate.reachable.connection != .none {
            
            var dictGeneral = [String:Any]()
            
            var address = [[String:Any]]()
            
            dictGeneral["name"] = self.txtBrandName.text ?? ""
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
                dictGeneral["phone"] = self.txtPhone.text ?? ""
                dictGeneral["country_code"] = appDelegate.userDetails?.country_code
                dictGeneral["country_prefix"] = appDelegate.userDetails?.country_prefix
                if iscityAdd {
                    
                }
                for i in 0..<(self.addressList.count)  {
                    var dict = [String:Any]()
                    dict["id"] = "\(self.addressList[i]?.id ?? 0)"
                    dict["address"] = "\(self.addressList[i]?.address ?? "")"
                    dict["postal_code"] = "\(self.addressList[i]?.postal_code ?? "")"
                    dict["latitude"] = "\(self.addressList[i]?.latitude ?? "")"
                    dict["longitude"] = "\(self.addressList[i]?.longitude ?? "")"
                    dict["city"] = "\(self.addressList[i]?.city ?? "")"
                    dict["area"] = "\(self.addressList[i]?.area ?? "")"
                    address.append(dict)
                    print(address)
                }
            }
            if self.txtBio.text != placeholder{
            dictGeneral["bio"] = self.txtBio.text ?? ""
            }else{
                dictGeneral["bio"] = ""
            }
            dictGeneral["website"] = self.txtWebsite.text ?? ""
            
            dictGeneral["deleted_location_ids"] = self.deletedLocationIds
            print(address)
            dictGeneral["locations"] = self.json(from: address)
            if self.selectedImage == nil {
//                APIManager().apiCallWithImage(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, parameters: dictGeneral, images: [self.selectedImage], imageParameterName: "photo", imageName: "user.png"){  (response, error) in
//                    if error == nil {
                APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, method: .post, parameters: dictGeneral) { (response, error) in
                    if error == nil {
                        if let response = response {
                            if let userDetails = response.dictData {
                                self.saveUserDetails(userDetails: userDetails)
//                                self.startWithAuth(userData: userDetails)
                            }
                            self.view.endEditing(true)
                            if appDelegate.userDetails?.phone_verified_at == "" || appDelegate.userDetails?.phone_verified_at == nil{
                                self.navigateToVerfyPhoneNo()
                            }
                            else {
                                if let message = response.message {
                                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
                                    alert.view.tintColor = UIColor().alertButtonColor
                                    
                                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                    alert.addAction(hideAction)
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
            else {
                APIManager().apiCallWithImage(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, parameters: dictGeneral, images: [self.selectedImage], imageParameterName: "photo", imageName: "user.png"){  (response, error) in
                    if error == nil {
                        if let response = response {
                            if let userDetails = response.dictData {
                                self.saveUserDetails(userDetails: userDetails)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil,userInfo: nil)
                               
                                
                            }
                            self.view.endEditing(true)
                            if appDelegate.userDetails?.phone_verified_at == "" || appDelegate.userDetails?.phone_verified_at == nil{
                                self.navigateToVerfyPhoneNo()
                            }
                            else {
                                if let message = response.message {
                                    let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
                                    alert.view.tintColor = UIColor().alertButtonColor
                                    
                                    let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    })
                                    alert.addAction(hideAction)
                                    
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
            
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
    func callIsEmailShow() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["status": self.isEmailShow ]
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.IS_EMAIL_SHOW.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                        }
                        self.setEmailPhoneButtonTitel()
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
    
    func callIsPhoneShow() {
        if appDelegate.reachable.connection != .none {
            
            let param = ["status": self.isPhoneShow ]
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.IS_PHONE_SHOW.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                        }
                        self.setEmailPhoneButtonTitel()
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
extension EditProfileViewController: UserLocationDelegate,EditBrandLocationDelegate {
    func LocationFormEditBrandLocationAdd(addressLists: [Locations?], deletedId: [String]) {
        self.addressList.removeAll()
        for temp in addressLists {
            self.addressList.append(temp)
        }
        self.deletedLocationIds = deletedId.joined(separator: ",")
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
    
    func LocationFormAdddLocation(address: [Locations?]) {
        self.addressList.removeAll()
        self.addressList.insert(contentsOf: address, at: 0)
        self.txtLocation.text = "\(address[0]?.address ?? ""), \(address[0]?.postal_code ?? "")"
    }
}

extension EditProfileViewController: EditStoreLocationDelegate {
    func LocationFormEditStoreLocationAdd(addressLists: [Locations?], deletedId: [String]) {
        self.addressList.removeAll()
        for temp in addressLists {
            self.addressList.append(temp)
        }
        self.deletedLocationIds = deletedId.joined(separator: ",")
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
