//
//  BaseViewController.swift
//  eLaunch
//
//  Created by Hardik Shekhat on 17/11/17.
//  Copyright © 2018 Hardik Shekhat. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher
import GooglePlaces
import StoreKit
import Firebase
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import AVFoundation
import AVKit
import LinkPresentation
import SafariServices
import GoogleSignIn
import AuthenticationServices
import libPhoneNumber_iOS

class BaseViewController: UIViewController, UINavigationBarDelegate {
    
    static let sharedInstance = BaseViewController()
    
    let phoneNumberUtil = NBPhoneNumberUtil.sharedInstance()
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var metaDataDict = [String: LPLinkMetadata]()

    @IBOutlet weak var navBar: UINavigationBar!
    
    let googleSignin    = GoogleLoginIntegration.shared
    var socialIdNew = ""
    var firstNameNew = ""
    var lastNameNew = ""
    var emailIdNew = ""
    var loginTypeNew = ""
    var profilePictureNew = ""
    var accesscodeNew = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    //MARK: - Common Method -
    
    func getCityPostCodeArea(addressComponents: [GMSAddressComponent]?)->(city : String?, postalCode : String? ,area : String?,state : String?, country : String?){
        var postalCode:String? = ""
        var area:String? = ""
        var city:String? = ""
        var state:String? = ""
        var country:String? = ""
        if addressComponents != nil {
            for addressComponent in (addressComponents)!{
                let component = getValueFromAddressComponents(addressComponent: addressComponent)
                if(postalCode == ""){
                    postalCode = component.postalCode
                }
                if(area == ""){
                    area = component.area
                }
                if(city == ""){
                    city = component.city
                }
                if(country == ""){
                    country = component.country
                }
                if(state == ""){
                    state = component.state
                }
                
            }
            
        }
        return ( city,postalCode,area,state,country )
    }
    
    func getValueFromAddressComponents(addressComponent: GMSAddressComponent)->(city : String?, postalCode : String? ,area : String?,state : String?,country : String?){
        var sublocality_level_2 = ""
        var sublocality_level_1 = ""
        var administrative_area_level_2 = ""
        var administrative_area_level_1 = ""
        var locality = ""
        var country = ""
        var postal_code = ""
        for type in (addressComponent.types){
            switch(type){
            case "sublocality_level_2":
                sublocality_level_2 = addressComponent.name
                print(sublocality_level_2)
            case "sublocality_level_1":
                sublocality_level_1 = addressComponent.name
                print(sublocality_level_1)
            case "administrative_area_level_2":
                administrative_area_level_2 = addressComponent.name
                print(administrative_area_level_2)
            case "administrative_area_level_1":
                administrative_area_level_1 = addressComponent.name
                print(administrative_area_level_1)
            case "locality":
                locality = addressComponent.name
                print(locality)
            case "country":
                country = addressComponent.name
                print(country)
            case "postal_code":
                postal_code = addressComponent.name
                print(postal_code)
            default:
                break
            }
        }
        var city = ""
        if locality != ""{
            city = locality
        }
        else if administrative_area_level_2 != ""{
            city = administrative_area_level_2
        }
        else if sublocality_level_1 != ""{
            city = sublocality_level_1
        }
        else if sublocality_level_2 != ""{
            city = sublocality_level_2
        }
        else if administrative_area_level_1 != ""{
            city = administrative_area_level_1
        }
        return ( city,postal_code,administrative_area_level_2,administrative_area_level_1,country )
    }
    
    func changeAppIcon(name: String) {
        UIApplication.shared.setAlternateIconName(name != "" ? name : nil) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("Success!")
            }
        }
    }
    
    func getAppVersionAndBuildNo() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return version.appending("(\(build))")
    }
    
    func setPriceFormat(price:Double) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.minimumFractionDigits = DecimalPtsConst
        currencyFormatter.maximumFractionDigits = DecimalPtsConst
        currencyFormatter.numberStyle = .currency
        // localize to your grouping and decimal separator
        currencyFormatter.locale = Locale(identifier: "en_CA")
        
        // We'll force unwrap with the !, if you've got defined data you may need more error checking
        let priceString = currencyFormatter.string(from: NSNumber(value: price))!
        // Displays $9,999.99 in the US locale
        
        return priceString
    }
    
    
    func getOSInfo() -> String {
            let os = ProcessInfo().operatingSystemVersion
            return String(os.majorVersion) + "." + String(os.minorVersion) + "." + String(os.patchVersion)
        }
    
    func saveUserDetails(userDetails: UserDetailsModel) {
        var userDetails = userDetails
        if userDetails.token == nil {
            userDetails.token = appDelegate.headerToken
        }
        
        var arrTempUser = [[String:Any]]()
        let currentDict = userDetails.toJSON()
        if defaults.value(forKey: kLoginUserList) != nil {
            if var arr = defaults.value(forKey: kLoginUserList) as? [[String:Any]], arr.count > 0 {
                
                var isAdded = false
                var index = -1
                for i in 0..<arr.count {
                    let dict = arr[i]
                    
                    if dict["id"] as? Int == currentDict["id"] as? Int {
                        isAdded = true
                        index = i
                    }
                }
                
                if isAdded {
                    arr[index] = currentDict
                }
                else{
                    arr.append(currentDict)
                }
                
                arrTempUser = arr
            }
        }
        else{
            arrTempUser.append(currentDict)
        }
        
        defaults.set(arrTempUser, forKey: kLoginUserList)
        
        appDelegate.userDetails = userDetails
        
        if let token = userDetails.token , token != "" {
            appDelegate.headerToken = token
            defaults.set(appDelegate.headerToken, forKey: kHeaderToken)
        }
     
        let data = NSKeyedArchiver.archivedData(withRootObject: userDetails.toJSONString()!)
        defaults.set(data, forKey: kUserDetails)
        defaults.synchronize()
        
        if defaults.value(forKey: kDeviceToken) as? String != nil {
            appDelegate.headerToken = defaults.value(forKey: kHeaderToken) as! String
        }
    }

    func clearAllUserDataFromPreference() {
        appDelegate.headerToken = ""
        appDelegate.generalSettings = nil
        appDelegate.userDetails = nil
        
        //Logout From Facebook
        let loginManager = LoginManager()
        loginManager.logOut()
       
        let cookies = HTTPCookieStorage.shared
        let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
        for cookie in facebookCookies! {
            cookies.deleteCookie(cookie )
        }
        
        if defaults.value(forKey: kDeviceToken) as? String != nil {
            appDelegate.deviceToken = defaults.value(forKey: kDeviceToken) as! String
        }
        
        if defaults.value(forKey: kHeaderToken) as? String != nil {
            appDelegate.headerToken = defaults.value(forKey: kHeaderToken) as! String
        }
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        defaults.set(appDelegate.deviceToken, forKey: kDeviceToken)
        defaults.set(appDelegate.headerToken, forKey: kHeaderToken)
        defaults.synchronize()
    }
    
    func saveGeneralSetting(generalSetting: GeneralSettingModel) {
        appDelegate.generalSettings = generalSetting
        let data = NSKeyedArchiver.archivedData(withRootObject: generalSetting.toJSONString()!)
        defaults.set(data, forKey:kGeneralSettingDetails)
        defaults.synchronize()
    }

    
    func removeNullValueFromDict(dict : [String : AnyObject]) -> [String : AnyObject] {
        var dictAfterRemoveNull = dict
        for key in dict.keys {
            if (dict[key] as? NSNull) != nil  {
                dictAfterRemoveNull.removeValue(forKey: key)
            }
        }
        return dictAfterRemoveNull
    }
    
    func convertStringToDictionary(text: String) -> [String: AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            }
            catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func startWithAuth (userData : UserDetailsModel) {
        self.callGeneralSettingAPI()
        
        if userData.phone == "" || userData.phone == nil{
            self.navigateToVerfyPhoneNo()
        }
//        else if userData.phone_verified_at == "" || userData.phone_verified_at == nil{
//            self.navigateToVerfyPhoneNo()
//        }
//        else if userData.locations?.count == 0 || userData.locations == nil{
//            self.navigateToLocation(rolId: String(userData.role_id!))
//        }
//        else if userData.gender_name == nil  {
//            self.navigateToClothPreferece()
//        }
//        else if userData.user_size?.count == 0 {
//            self.navigateToClothPreferece()
//        }
        else {
            self.navigateToHomeScreen()
        }
    }
    
    //MARK: - API Method -
    
     func autoLogin() {
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.AUTOLOGIN.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.startWithAuth(userData: userDetails)
                        }
                    }
                }
                else {
                    self.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
                }
            }
        }
        else {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
        }
    }
   
    func callGeneralSettingAPI() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: GeneralSettingModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.GET_GENERAL_DATA.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let generalSettingDetails = response.dictData {
                            self.saveGeneralSetting(generalSetting: generalSettingDetails)
                        }
                    }
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
    // MARK: - Validation -
    func isValidEmail(str:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    
    func isValidPhoneNumber(phoneNumber: String, countryCode: String) -> Bool {
        do {
            // Parse the phone number with the country code (defaultRegion)
            let phoneNumberObject = try phoneNumberUtil?.parse(phoneNumber, defaultRegion: countryCode)
            
            // Validate the phone number by checking its validity
            if let phoneNumberObject = phoneNumberObject {
                return try phoneNumberUtil?.isValidNumber(phoneNumberObject) ?? false
            } else {
                return false
            }
        } catch {
            // In case of error, return false
            return false
        }
    }
    
    func isValidPassword(password: String) -> Bool {
        /*
         ^                         = Start anchor
         (?=.*[A-Z])               = Ensure string has one uppercase letters.
         (?=.*[0-9])               = Ensure string has one digits.
         (?=.*[a-z])               = Ensure string has three lowercase letters.
         .{8}                      = Ensure string is of length 8.
         $                         = End anchor.
         */
        let passwordRegex = "^(?=.*[0-9])(?=.*[A-Z]).{8,}$"//"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
//        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func isStringEmpty(str : String) -> Bool {
        return str.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Date and Time Method -
    func getMediaDuration(url: URL!) -> Float64 {
        let asset: AVURLAsset = AVURLAsset.init(url: url)
        let duration: CMTime = asset.duration
        return CMTimeGetSeconds(duration)
    }

    func getDateInStringFromTimeInterval(timeStamp: String) -> String {
        let dateBooking = NSDate(timeIntervalSince1970: Double(timeStamp)! / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: dateBooking as Date)
        return strDate
    }
    
    func getDateTimeInStringFromTimeInterval(timeStamp: String) -> String {
        let dateBooking = NSDate(timeIntervalSince1970: Double(timeStamp)! / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: dateBooking as Date)
        return strDate
    }
    
    func getTimeInStringFromTimeInterval(timeStamp: String) -> String {
        let dateBooking = NSDate(timeIntervalSince1970: Double(timeStamp)! / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat =  dateFormateForDisplay//"dd MMM hh:mm a"
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: dateBooking as Date)
        return strDate
    }
    
    func getDateTimeInStringFromTimeIntervalWithFormat(timeStamp: String, format: String) -> String {
        let dateBooking = NSDate(timeIntervalSince1970: Double(timeStamp)! / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: dateBooking as Date)
        return strDate
    }
    
    func convertDateToString(format: String, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    func convertStringToDate(format: String, strDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        
        if strDate.isEmpty {
            return Date()
        }
        else {
            if let date = dateFormatter.date(from: strDate) {
                return date
            }
            return Date()
        }
    }
    
    func convertWebStringToDate(strDate: String) -> Date {
        let dateString = strDate.replace("T", replacement: " ")
        var format: String = ""
        if(dateString.count == 27 ){
            format = "yyyy-MM-dd HH:mm:ss.SSSSSS'Z'"
        }
        if(dateString.count == 26 ){
            format = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        }
        if(dateString.count == 19 ){
            format = "yyyy-MM-dd HH:mm:ss"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        
        if dateString.isEmpty {
            return Date()
        }
        else {
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            return Date()
        }
    }
     
    func getDay( formDate: Date, toDate: Date) -> Int {
        let calendar = Calendar.current

        let formDate = calendar.startOfDay(for: formDate)
        let toDate = calendar.startOfDay(for: toDate)
        let components = calendar.dateComponents([.day], from: formDate, to: toDate)
        return components.day ?? 0
    }

    func pushToViewController(viewControllerIdentifier: String, withAnimation: Bool) {
        if let vc = self.storyBoard.instantiateViewController(withIdentifier: viewControllerIdentifier) as? UIViewController {
            if self.navigationController == nil {
                if #available(iOS 13.0, *) {
                    let navigationController: UINavigationController = appDelegate.window?.rootViewController as! UINavigationController
                } else {
                    // Fallback on earlier versions
                }
                navigationController!.pushViewController(vc, animated: true)
            }
            else {
                self.navigationController?.pushViewController(vc, animated: withAnimation)
            }
        }
    }
    
    func setLeftSideImageInTextField(textField: UITextField, image: UIImage) {
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit//.center
        leftImageView.frame = CGRect(x: 10, y: ((textField.frame.height / 2) / 2), width: 30, height: 30)
        leftImageView.image = image
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height)
        textField.leftViewMode = .always
        textField.leftView = leftView
        
        leftView.addSubview(leftImageView)
    }
    
    func setRightSideImageInTextField(textField: UITextField, image: UIImage) {
        let rightImageView = UIImageView()
        rightImageView.contentMode = .scaleAspectFit//.center
        rightImageView.frame = CGRect(x: 10, y: ((textField.frame.height / 2) / 2), width: 30, height: 30)
        rightImageView.image = image
        
        let rightView = UIView()
        rightView.frame = CGRect(x: 0, y: 0, width: textField.frame.size.height, height: textField.frame.size.height)
        textField.rightViewMode = .always
        textField.rightView = rightView
        
        rightView.addSubview(rightImageView)
    }
    
    func setNavigationBarToTransparant(navigationBar: UINavigationBar) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
 
    func setNavigationBarShadow(navigationBar: UINavigationBar) {
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOpacity = 0.5
        navigationBar.layer.shadowOffset = CGSize.zero
        navigationBar.layer.shadowRadius = 10
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    
    //MARK: - Button Actions -
    @IBAction func onBackClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func menuOpenClicked(_ sender: Any) {
//        self.view.endEditing(true)
//        self.slideMenuController()?.openLeft()
//    }
    
//    @IBAction func menuCloseClicked(_ sender: Any) {
//        self.view.endEditing(true)
//        self.slideMenuController()?.closeLeft()
//    }
    
    @IBAction func onHomeClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func navigateToLoginScreen() {
        appDelegate.deviceAuthKey = ""
        appDelegate.generalSettings = nil
        appDelegate.userDetails = nil
        
        let loginViewController = LoginViewController.instantiate(fromStoryboard: .Auth)
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }

    
    func navigateToHomeScreen() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive })?.delegate as? SceneDelegate else {
            print("SceneDelegate not found!")
            return
        }
        
        let viewController = TabbarViewController.instantiate(fromStoryboard: .Main)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        
        sceneDelegate.window?.rootViewController = navigationController
        sceneDelegate.window?.makeKeyAndVisible()
    }

    func navigateToClothPreferece() {
        let loginViewController = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    func navigateToWelconeScreen() {
        // Instantiate the LandingVC from the Landing storyboard
        let loginViewController = WelcomeViewController.instantiate(fromStoryboard: .Main)//LandingVC.instantiate(fromStoryboard: .Landing)
        
        // Initialize a UINavigationController with the loginViewController as the root
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        
        // Assuming this is within the SceneDelegate
        if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = navigationController
            sceneDelegate.window = window
            window.makeKeyAndVisible()
        }
    }

    func navigateToVerfyPhoneNo() {
        let loginViewController = MobileNumberVC.instantiate(fromStoryboard: .Auth)
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    
    func navigateToVerfyOTP() {
        let loginViewController = OtpViewVC.instantiate(fromStoryboard: .Auth)
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    
    func navigateToLocation(rolId : String) {
        if rolId == "1" {
            let loginViewController = UserLocationViewController.instantiate(fromStoryboard: .Main)
            let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.isHidden = true
            sceneDelegate.window?.rootViewController = navigationController
        }
        else if rolId == "2" {
            let loginViewController = StoreLocationViewController.instantiate(fromStoryboard: .Main)
            let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.isHidden = true
            sceneDelegate.window?.rootViewController = navigationController
        }
        else {
            let loginViewController = BrandLocationViewController.instantiate(fromStoryboard: .Main)
            let navigationController: UINavigationController = UINavigationController.init(rootViewController: loginViewController)
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.isHidden = true
            sceneDelegate.window?.rootViewController = navigationController
        }
    }
    
    func navigateToHomeScreen(selIndex: Int) {
        let viewController = TabbarViewController.instantiate(fromStoryboard: .Main)
        viewController.selectedIndex = selIndex
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
        //        sceneDelegate.window?.rootViewController = navigationController
    }
    func navigateToLinkWithStoreProfile(userName: String) {
        let viewController = StoreProfileViewController.instantiate(fromStoryboard: .Main)
        viewController.userId = userName
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
        
    }
    
    func navigateToLinkWithUserProfile(userName: String) {
        let viewController = OtherUserProfileViewController.instantiate(fromStoryboard: .Main)
        viewController.userId = userName
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
        
    }
    
    func deeplinkClear() {
        if appDelegate.deeplinkurltype != "" && appDelegate.deeplinkid != "" {
            appDelegate.deeplinkurltype = ""
            appDelegate.deeplinkid = ""
        }
    }
    func rateApp() {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(APP_APPSTORE_ID)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
   
    func navigateToChatview(postId: Int,sendUserId:Int) {
        let viewController = MessagesViewController.instantiate(fromStoryboard: .Main)
        viewController.postId = "\(postId)"
        viewController.senderuserId = "\(sendUserId)"
        viewController.fromPushNotification = true
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    
    func navigateToClickCoinsView() {
    let viewController = self.storyBoard.instantiateViewController(identifier: "ClickCoinsViewController") as! ClickCoinsViewController
        viewController.fromPushNotification = true
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    func navigateToRatingView(postId: Int,sendUserId:Int) {
    let viewController = NewRatingViewController.instantiate(fromStoryboard: .Setting)
        viewController.fromPushNotification = true
        viewController.postId = "\(postId)"
        viewController.userId = "\(sendUserId)"
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    func navigateToNotificationlistView() {
    let viewController = self.storyBoard.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
        viewController.fromPushNotification = true
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    func navigateToProductDetailsView(postId: Int) {
        let viewController = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        viewController.fromPushNotification = true
        viewController.postId = "\(postId)"
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
    }
    
    func navigateToLinkWithBrandProfile(userName: String) {
        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "BrandProfileViewController") as! BrandProfileViewController
        viewController.userId = userName
        let navigationController: UINavigationController = UINavigationController.init(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.isHidden = true
        sceneDelegate.window?.rootViewController = navigationController
        
    }
    //MARK: - ALERT Method -
    func showAlertWithTitleAndMessage(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.setAlertButtonColor()
        alert.addAction(UIAlertAction(title: kOk, style: .cancel, handler: nil));
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func alertWindow(message: String) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        
        let alert2 = UIAlertController(title: AlertViewTitle, message: message, preferredStyle: .alert)
        let defaultAction2 = UIAlertAction(title: kOk, style: .default, handler: { action in
        })
        alert2.addAction(defaultAction2)
        
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert2, animated: true, completion: nil)
        
    }
    
    //MARK: - MultiLanguage Method -
    func getLocalizeTextForKey(keyName : String) -> String {
        return NSLocalizedString(keyName, comment: "")
    }
    
    func imageWith(name: String?, imageSize: CGFloat = 80, fontSize: CGFloat = 24) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
        let nameLabel = UILabel(frame: frame)
        nameLabel.font = UIFont.init(name: String().themeFontName, size: fontSize)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor().alertButtonColor
        nameLabel.textColor = .white
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized
                }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first {
                    initials += String(lastLetter).capitalized
                }
            }
        }
        else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        
        return nil
    }
    
    //Clear Documents Directory
    func clearDocumentsDirectory() {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let items = try? fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
        items?.forEach { item in
            try? fileManager.removeItem(at: item)
        }
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
//    //Add Firebase Custome Event
//    func addFirebaseCustomeEvent(eventName: String, param: [String: NSObject]) {
//        //self.addFirebaseCustomeEvent(eventName: "HomeScreen", param: [:])
//        Analytics.logEvent(eventName, parameters: param)
//    }
    
    func addFacebookEvent(eventName: AppEvents.Name, parameters: [String: Any]) {
        //let parameters = ["pageName": "pixo3"]
        //appDelegate.addFacebookEvent(eventName: AppEvents.Name(rawValue: "logPixoAppSubscriptionPageEvent"), parameters: parameters)
        #if RELEASE
        // Log Facebook Events
        Analytics.logEvent(eventName, parameters: parameters)
        // Log Firebase Events
        Analytics.logEvent(eventName.rawValue, parameters: parameters)
        #endif
    }
    
    //Open Safari ViewController
        func openSafariViewController(strUrl: String) {
            if strUrl.trim().isEmpty {
                return
            }
            
            var tmpStrUrl = strUrl
            if !tmpStrUrl.lowercased().hasPrefix("http") {
                tmpStrUrl = "http://" + tmpStrUrl
            }
            if let url = URL.init(string: tmpStrUrl) {
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            }
            else {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Not a valid url")
                print("Not a valid url")
            }
        }
}

extension BaseViewController{
    func loginWithFacebook(isLink:Bool = false) {
        if AccessToken.current == nil {
            let loginManager = LoginManager()
            loginManager.logIn(permissions: [Permission.publicProfile, Permission.email], viewController: self, completion: { (loginResult) in
                switch loginResult {
                case .failed(let error):
                    print(error.localizedDescription)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("\(grantedPermissions)")
                    print("\(declinedPermissions)")
                    print("\(accessToken)")
                    
                    if grantedPermissions.contains("email") || grantedPermissions.contains("publicProfile")  {
                        print("Logged in!")
                        
                        self.getFBUserData(isLink:isLink)
                    }
                @unknown default:
                    break
                }
            })
        }
        else {
            print("Current Access Token is:\(String(describing: AccessToken.current))")
            self.getFBUserData(isLink:isLink)
        }
    }
    
    func getFBUserData(isLink:Bool = false) {
        let params = ["fields": "email, id, name, first_name, last_name, picture"]
        
        let request = GraphRequest.init(graphPath: "me", parameters: params)
        
        request.start { (connection, result, error) in
            if error != nil {
                UIAlertController().alertViewWithTitleAndMessage(self, message: error!.localizedDescription)
                return
            }
            
//             Handle vars
            if let result = result as? [String: Any] {
                if let socialId = result["id"] as? String {
                    self.socialIdNew = socialId
                    appDelegate.userDetails?.facebook_id = "100008293572085"
                }
                
                if let firstName = result["first_name"] as? String {
                    self.firstNameNew = firstName
                }
                
                if let lastName = result["last_name"] as? String {
                    self.lastNameNew = lastName
                }
                
                if let email = result["email"] as? String {
                    self.emailIdNew = email
                }
                if isLink == false{
                    self.socialLogin(loginType: "2")
                }
            }
        }
    }
    
    func loginWithGoogle(complition: @escaping(GIDGoogleUser?)-> Void?) {
        googleSignin.signInWith(presentingVC: self)
        googleSignin.closureDidGetUserDetails = { [weak self] user in
            guard let self else{return}
            print(user)
//            complition(googleUser)
            if let userId = user.userID {
                self.socialIdNew = userId
            }
            if let firstName = user.profile?.givenName {
                self.firstNameNew = firstName
            }
            if let lastName = user.profile?.familyName {
                self.lastNameNew = lastName
            }
            if let email = user.profile?.email {
                self.emailIdNew = email
            }
            self.socialLogin(loginType: "4")
        }
    }
    
    func loginWithApple(){

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func socialLogin(loginType:String) {
        let param = ["name" : "\(self.firstNameNew) \(self.lastNameNew)",
                     "email" : self.emailIdNew,
                     "username": "\(self.firstNameNew.lowercased())_\(self.lastNameNew.lowercased())",
                     "password": "",
                     "app_version": APP_VERSION,
                     "devices_name": UIDevice().modelName,
                     "os": UIDevice().getOS(),
                     "devices_id": UIDevice().deviceID,
                     "devices_type": DEVICE_TYPE,
                     "devices_token": appDelegate.deviceToken,
                     "login_type": loginType]
        
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LOGIN.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if response.status == kIsSuccess {
                            if let userDetails = response.dictData {
                                self.saveUserDetails(userDetails: userDetails)
                                self.startWithAuth(userData: userDetails)
                            }
                        }
                        else {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: response.message ?? "")
                           
                        }
                    }
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

extension BaseViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            self.socialIdNew = appleIDCredential.user
            self.firstNameNew = appleIDCredential.fullName?.givenName ?? ""
            self.lastNameNew = appleIDCredential.fullName?.familyName ?? ""
            self.emailIdNew = appleIDCredential.email ?? ""
            
            if self.firstNameNew != "" {
                KeychainService.saveInfo(key: "FirstName", value: self.firstNameNew as NSString)
            }
            else {
                self.firstNameNew = KeychainService.getInfo(key: "FirstName") as String? ?? ""
            }
            
            if self.lastNameNew != "" {
                KeychainService.saveInfo(key: "LastName", value: self.lastNameNew as NSString)
            }
            else {
                self.lastNameNew = KeychainService.getInfo(key: "LastName") as String? ?? ""
            }
            
            if self.emailIdNew != "" {
                KeychainService.saveInfo(key: "Email", value: self.emailIdNew as NSString)
            }
            else {
                self.emailIdNew = KeychainService.getInfo(key: "Email") as String? ?? ""
            }
            
            self.socialLogin(loginType: "5")
        }
        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let userName = passwordCredential.user
            let password = passwordCredential.password
            
            print(userName, password)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
extension BaseViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
