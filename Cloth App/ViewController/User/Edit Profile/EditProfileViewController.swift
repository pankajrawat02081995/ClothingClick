//
//  EditProfileViewController.swift
//  ClothApp
//
//  Created by Apple on 07/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.

import UIKit
import AVKit
import IBAnimatable
import FBSDKLoginKit
import IQKeyboardManagerSwift

class EditProfileViewController: BaseViewController {
    
    @IBOutlet weak var txtEmail: AnimatableTextField!
    @IBOutlet weak var txtPhoneNumber: AnimatableTextField!
    @IBOutlet weak var fbNextArrow: UIImageView!
    @IBOutlet weak var instaNextArrow: UIImageView!
    @IBOutlet weak var lblFirstLatterName: UILabel!
    @IBOutlet weak var webSiteView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUserProfilPic: CustomImageView!
    @IBOutlet weak var txtDisplayUsearName: AnimatableTextField!
    @IBOutlet weak var btnEditPic: UIButton!
    @IBOutlet weak var txtBrandName: AnimatableTextField!
    @IBOutlet weak var txtWebsite: AnimatableTextField!
    @IBOutlet weak var txtLocation: AnimatableTextField!
    
    @IBOutlet weak var txtBio: CustomTextView!
    @IBOutlet weak var constTopFortxtBio: NSLayoutConstraint!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var viewEmail: CustomView!
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
    var dictGeneral1 = [String:Any]()
    var isEditScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
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
            self.webSiteView.isHidden = false
            self.btnShowEmail.isHidden = false
            self.btnShowPhone.isHidden = false
        }
        else if appDelegate.userDetails?.role_id == 1{
            self.txtBrandName.text = "Name"
            //            self.constTopFortxtBio.constant = -50
            //            self.constTopForBtnSave.constant = -160
            self.lblContact.isHidden = true
            self.txtEmail.isHidden = false
            self.txtPhone.isHidden = true
            self.viewEmail.isHidden = true
            self.viewPhone.isHidden = true
            self.webSiteView.isHidden = true
            self.txtWebsite.isHidden = true
            self.btnShowEmail.isHidden = true
            self.btnShowPhone.isHidden = true
        }else{
            self.txtBrandName.placeholder = "Brand Name"
            self.lblContact.isHidden = false
            self.txtEmail.isHidden = false
            self.txtPhone.isHidden = false
            self.viewEmail.isHidden = false
            self.viewPhone.isHidden = false
            //            self.txtEmail.isUserInteractionEnabled = false
            //            self.txtPhone.isUserInteractionEnabled = false
            self.txtWebsite.isHidden = false
            self.webSiteView.isHidden = false
            self.btnShowEmail.isHidden = false
            self.btnShowPhone.isHidden = false
        }
        
        self.setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func instaonTap(_ sender: UIButton) {
        if appDelegate.userDetails?.instagram_id ?? "" == "" || appDelegate.userDetails?.instagram_id == nil {
            self.authenticateWithInstagram()
        }else{
            self.showRevokeAccessAlert(type: "instagram")
        }
    }
    
    func authenticateWithInstagram() {
        let clientId = "547906594269337"
        let redirectUri = "https://apps.clothingclick.online/auth/instagram/callback"
        
        // Instagram OAuth Authorization URL
        let authURL = "https://api.instagram.com/oauth/authorize?client_id=\(clientId)&redirect_uri=\(redirectUri)&scope=user_profile,user_media&response_type=code"
        
        if let url = URL(string: authURL) {
            // Open Instagram login in a browser
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func fbOnTap(_ sender: UIButton) {
        if appDelegate.userDetails?.facebook_id ?? "" == "" || appDelegate.userDetails?.facebook_id == nil {
            self.loginWithFacebook(isLink: true)
        }else{
            self.showRevokeAccessAlert(type: "facebook")
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
//            else if self.txtLocation.text?.trim().count == 0 {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
//            }
            else if self.txtEmail.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email")
                
            }
            else if self.txtPhoneNumber.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter phone")
                
            }
            else {
                self.selectedImage = self.imgUserProfilPic.image
                if self.txtPhoneNumber.text?.trim() != appDelegate.userDetails?.phone ?? ""{
                    self.userVerifyMobileNumber(phone: self.txtPhoneNumber.text?.trim() ?? "") {
                        self.callUpdetUserProfile()
                    }
                }else{
                    self.callUpdetUserProfile()
                }
            }
        }
        else if appDelegate.userDetails?.role_id == 2 {
            if self.txtDisplayUsearName.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Username")
            }
            else if self.txtBrandName.text?.trim().count == 0{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Store name")
            }
//            else if self.txtLocation.text?.trim().count == 0 {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
//                
//            }
            else if self.txtEmail.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email")
                
            }
            else if self.txtPhoneNumber.text?.trim().count == 0 {
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
//            else if self.txtLocation.text?.trim().count == 0 {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter address")
//                
//            }
            else if self.txtEmail.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter email")
                
            }
            else if self.txtPhoneNumber.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter phone")
                
            }
            else {
                self.selectedImage = self.imgUserProfilPic.image
                self.callUpdetUserProfile()
            }
        }
    }
    
    @IBAction func btnLocation_Clicked(_ button: UIButton) {
        let viewController = MapLocationVC.instantiate(fromStoryboard: .Dashboard)
        viewController.title = "Edit Profile"
        viewController.onDataReceived = { data, address in
            self.isEditScreen = true
            self.txtLocation.text = address
            self.dictGeneral1["locations"] = data["locations"]//self.json(from: data)
        }
        self.pushViewController(vc: viewController)
        //        if appDelegate.userDetails?.role_id == 2 {
        //            let viewController = self.storyboard?.instantiateViewController(identifier: "EditeStoreLocationViewController") as! EditeStoreLocationViewController
        //            viewController.editStoreLocationDelegate = self
        //            viewController.addresslist = appDelegate.userDetails?.locations! as! [Locations?]
        //            self.navigationController?.pushViewController(viewController, animated: true)
        //        }
        //        else if appDelegate.userDetails?.role_id == 1{
        //            let viewController = MapLocationVC.instantiate(fromStoryboard: .Dashboard)
        ////            viewController.edit = true
        ////            viewController.locationdelegate = self
        ////            viewController.addresslist = appDelegate.userDetails?.locations! as! [Locations?]
        //            self.navigationController?.pushViewController(viewController, animated: true)
        //        }
        //        else{
        //            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandLocationViewController") as! BrandLocationViewController
        //            viewController.edit = true
        //            viewController.editeBrandlocationdelegate = self
        //            self.navigationController?.pushViewController(viewController, animated: true)
        //        }
    }
    
    func setData() {
        if let url = appDelegate.userDetails?.photo {
            if let imgUrl = URL.init(string: url) {
                self.lblFirstLatterName.isHidden = true
                self.imgUserProfilPic.setImageFast(with: url)
            }else{
                self.imgUserProfilPic.backgroundColor = .black
                self.lblFirstLatterName.isHidden = true
                self.lblFirstLatterName.text = appDelegate.userDetails?.name?.first?.description
            }
        }
        if appDelegate.userDetails?.role_id == 1 {
            if let name = appDelegate.userDetails?.name {
                
                self.txtBrandName.text = name
            }
            if let useraName = appDelegate.userDetails?.username{
                self.txtDisplayUsearName.text = useraName
            }
            
            if let email = appDelegate.userDetails?.email{
                self.txtEmail.text = email
            }
            
            if let phone = appDelegate.userDetails?.phone{
                self.txtPhoneNumber.text = phone
            }
            
            if let bio = appDelegate.userDetails?.bio {
                self.txtBio.text = bio
            }else{
                self.txtBio.text = placeholder
            }
            if !isEditScreen {
                if let address = appDelegate.userDetails?.locations{
                    self.txtLocation.text = address.first?.address ?? ""
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
                self.txtLocation.text = address.first?.address ?? ""
            }
            if let phono = appDelegate.userDetails?.phone {
                self.txtPhone.text = phono
            }
            if let email = appDelegate.userDetails?.email {
                self.txtEmail.text = email
            }
            if let email = appDelegate.userDetails?.phone {
                self.txtPhoneNumber.text = email
            }
            //            if let address = appDelegate.userDetails?.locations{
            //                self.txtLocation.text = "\(address.count) Location"
            //                for i in 0..<address.count {
            ////                    var dict : [String:Any]()
            //                    var dict = [String:Any]()
            //                    dict["id"] = address[i].id
            //                    dict["address"] = address[i].address
            //                    dict["postal_code"] = address[i].postal_code
            //                    dict["latitude"] = address[i].latitude
            //                    dict["longitude"] = address[i].longitude
            //                    dict["city"] = address[i].city
            //                    dict["area"] = address[i].area
            ////                    dict?.address = address[i].address ?? ""
            ////                    dict?.postal_code = address[i].postal_code ?? ""
            ////                    dict?.latitude = address[i].latitude ?? ""
            ////                    dict?.longitude = address[i].longitude ?? ""
            ////                    dict?.city = address[i].city ?? ""
            ////                    dict?.area = address[i].area ?? ""
            //                    let addressobject = Locations.init(JSON: dict)
            //                    self.addressList.append(addressobject)
            //                    print(self.addressList[i])
            //                }
            //            }
        }
    }
    
    // Your button action for editing pic
    @IBAction func btnEditPic_Clicked(_ button: UIButton) {
        self.showActionSheet()
    }
    
    // Check camera permissions
    func checkCameraPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch authStatus {
        case .authorized:
            self.camera()
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined:
            // Request permissions if not determined yet
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.camera()
                } else {
                    self?.alertPromptToAllowCameraAccessViaSetting()
                }
            }
        default:
            break
        }
    }
    
    // Alert prompt to allow camera access via Settings
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Camera Access Required", message: "Please enable camera access in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        })
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }
    
    // Show action sheet to choose camera or photo library
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Use Camera", style: .default) { _ in
            self.checkCameraPermissions()
        })
        actionSheet.addAction(UIAlertAction(title: "Choose Existing Photo", style: .default) { _ in
            self.photoLibrary()
        })
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    // Camera action
    func camera() {
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            myPickerController.allowsEditing = true
            self.present(myPickerController, animated: true)
        }
    }
    
    // Photo Library action
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
        present(myPickerController, animated: true)
    }
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // When image is selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        DispatchQueue.main.async {
            if let image = info[.originalImage] as? UIImage {
                let fixedImage = self.fixOrientation(image: image)
                self.imgUserProfilPic.image = fixedImage
                self.lblFirstLatterName.isHidden = true
                self.selectedImage = fixedImage
            }
        }
        
        dismiss(animated: true)
    }
    
    // Fix image orientation if needed
    func fixOrientation(image: UIImage) -> UIImage {
        if image.imageOrientation == .up { return image }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let fixedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return fixedImage ?? image
    }
    
    // If user cancels image selection
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
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
        
        if textField == self.txtPhoneNumber {
            let maxLength = 16
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if textField == self.txtBrandName {
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            return newLength <= 30
        } else {
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
    func callUpdetUserProfile(isRevoke:Bool = false) {
        
        guard appDelegate.reachable.connection != .none else {
            UIAlertController().alertViewWithNoInternet(self)
            return
        }
        
        guard appDelegate.userDetails?.role_id == 1 else {
            print("Invalid role. Only role_id 1 is supported.")
            return
        }
        
        var dictGeneral: [String: Any] = [
            "name": txtBrandName.text ?? "",
            "email": appDelegate.userDetails?.email ?? "",
            "username": self.txtDisplayUsearName.text ?? "",
            "phone": appDelegate.userDetails?.phone ?? "",
            "country_code": appDelegate.userDetails?.country_code ?? "",
            "country_prefix": appDelegate.userDetails?.country_prefix ?? "",
            "facebook_id": appDelegate.userDetails?.facebook_id ?? "",
            "instagram_id": appDelegate.userDetails?.instagram_id ?? "",
            "website": txtWebsite.text ?? "",
            "deleted_location_ids": deletedLocationIds
        ]
        
        if txtBio.text != placeholder {
            dictGeneral["bio"] = txtBio.text ?? ""
        } else {
            dictGeneral["bio"] = ""
        }
        
        var addressListArray = addressList.compactMap { address -> [String: Any]? in
            guard let address = address else { return nil }
            return [
                "id": address.id ?? 0,
                "address": address.address ?? "",
                "postal_code": address.postal_code ?? "",
                "latitude": address.latitude ?? "",
                "longitude": address.longitude ?? "",
                "city": address.city ?? "",
                "area": address.area ?? ""
            ]
        }
        
        dictGeneral["locations"] = dictGeneral1["locations"] as? String ?? json(from: addressListArray)
        if self.selectedImage == nil {
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, method: .post, parameters: dictGeneral) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh"), object: nil,userInfo: nil)
                        }
                        self.view.endEditing(true)
                        if let message = response.message {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
                            alert.view.tintColor = UIColor().alertButtonColor
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(hideAction)
                            if isRevoke == false{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    //                        }
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
                        if let message = response.message {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
                            alert.view.tintColor = UIColor().alertButtonColor
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(hideAction)
                            if isRevoke == false{
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    //                        }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
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
            if let address = self.addressList.first??.address {
                if let  postlcode = addressList.first??.postal_code  {
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
        self.txtLocation.text = "\(address.first??.address ?? ""), \(address.first??.postal_code ?? "")"
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
            if let address = self.addressList.first??.address {
                if let  postlcode = addressList.first??.postal_code  {
                    self.txtLocation.text = "\(address) , \(postlcode)"
                }
            }
        } else {
            let count  = self.addressList.count
            self.txtLocation.text = "\(count) Add location"
        }
    }
    
    func showRevokeAccessAlert(type:String) {
        // Create the alert controller
        let alertController = UIAlertController(title: "Revoke Access",
                                                message: "Do you want to revoke access for \(type)?",
                                                preferredStyle: .alert)
        
        // Create the "Revoke Access" action
        let revokeAction = UIAlertAction(title: "Revoke Access", style: .destructive) { _ in
            // Call the function to revoke access from both Facebook and Instagram
            if type.lowercased() == "facebook"{
                LoginManager().logOut()
                appDelegate.userDetails?.facebook_id = ""
            }else{
                appDelegate.userDetails?.instagram_id = ""
            }
            
            self.callUpdetUserProfile(isRevoke: true)
        }
        
        // Create the "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add the actions to the alert controller
        alertController.addAction(revokeAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller (you need to present this from a view controller)
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension String{
    func isInstagramProfileURL() -> Bool {
        guard let url = URL(string: self) else {
            return false
        }
        // Check if the host is Instagram
        let instagramHost = "www.instagram.com"
        return url.host == instagramHost && url.pathComponents.count >= 2 && url.pathComponents[1] != ""
    }
    
    func isFacebookProfileURL() -> Bool {
        guard let url = URL(string: self) else {
            return false
        }
        // Check if the host is Facebook
        let facebookHost = "www.facebook.com"
        return url.host == facebookHost && url.pathComponents.count >= 2 && url.pathComponents[1] != ""
    }
    
}

extension UIViewController{
    
    func showAlertWithTextField(on viewController: UIViewController, title: String, message: String, placeholder: String,textFieldText:String, saveAction: @escaping (String?) -> Void) {
        // Create alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a text field to the alert
        alertController.addTextField { textField in
            textField.text = textFieldText
            textField.placeholder = placeholder
        }
        
        // Add "Cancel" button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Add "Save" button
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Get the text from the text field and pass it to the saveAction closure
            let textField = alertController.textFields?.first
            saveAction(textField?.text)
        }
        alertController.addAction(saveAction)
        
        // Present the alert on the provided view controller
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func openInstagramProfile(username: String) {
        let appURL = URL(string: "instagram://user?username=\(username)")!
        let webURL = URL(string: "https://www.instagram.com/\(username)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            // Open Instagram app
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            // Open in Safari if Instagram app is not installed
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    
    func openFacebookProfile(facebookID: String) {
        let appURL = URL(string: "fb://profile/\(facebookID)")!
        let webURL = URL(string: "https://www.facebook.com/\(facebookID)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            // Open Facebook app
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            // Open in Safari
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}

extension EditProfileViewController{
    func userVerifyMobileNumber(phone:String,compltion:@escaping()->Void) {
        if appDelegate.reachable.connection != .none {
            var  param = [String:Any]()
#if DEBUG
            param = ["phone": phone,
                     "country_prefix" : "+91" ,
                     "country_code" : "IN",
                     "is_test" : "1"
            ]
#else
            
            param = ["phone": phone,
                     "country_prefix" : "+1" ,
                     "country_code" : "CA",
                     "is_test" : "1"
            ]
#endif
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            let vc = OtpViewVC.instantiate(fromStoryboard: .Auth)
                            vc.isProfileUpdate = true
                            vc.mobileNumberUpdated = { [weak self] status in
                                compltion()
                            }
                            self.pushViewController(vc: vc)
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
