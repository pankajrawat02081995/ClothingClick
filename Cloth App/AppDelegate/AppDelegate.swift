//
//  AppDelegate.swift
//  Cloth App
//
//  Created by Apple on 14/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Reachability
import UserNotifications
import KRProgressHUD
import Firebase
import FirebaseCore
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import CoreLocation
import GoogleSignIn
import SwiftyJSON
import ObjectMapper
import CoreLocation
import GooglePlaces
import GoogleMaps
import CoreLocation
//import TwitterKit
import GoogleMobileAds
import StripePaymentSheet

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate,CLLocationManagerDelegate{
    let notificationCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    let gcmnotificationdata = "gcm.notification.data"
    var reachable: Reachability!
    var deviceToken = ""
    var deviceAuthKey = ""
    //        var userDetails = [UserDetailsModel?]()
    var userDetails : UserDetailsModel?
    var generalSettings: GeneralSettingModel?
    var locationManager = CLLocationManager()
    var defaultLatitude: Double = 0.0
    var defaultLongitude: Double = 0.0
    var currentAddress = ""
    var referenceCode = ""
    var authKey = ""
    var currentLocation: String = ""
    var deeplinkurltype = ""
    var deeplinkid = ""
    var headerToken = ""
    
    ///filter variable
    var category = ""
    var selectSubCategoryId = [String]()
    var selectSubCategoryName = [String]()
    var selectGenderId = ""
    var selectDistnce = ""
    var selectSellerId = ""
    var selectBrandId = ""
    var selectConditionId = ""
    var selectSizeId = ""
    var selectColorId = ""
    var selectPriceId = ""
    var priceFrom = ""
    var priceTo = ""
    var isMySize = "0"
    var mySize = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DispatchQueue.global(qos: .background).async {
            sleep(UInt32(0.1))
        }
        
        
        StripeAPI.defaultPublishableKey = "pk_test_51HoxITH8pVCp4ycElWEGx500WjsGV6DtiOpWBxoparNkQdIzhkPtK2oT4zrUDaaqw0W8Ty7DiIuBh6nGzfDLwXFW00c9xiol5S"
        
        
        FirebaseApp.configure()
        print("FirebaseApp.configure")
        Messaging.messaging().delegate = self
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        GMSServices.provideAPIKey(googleAPIKey)
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor().alertButtonColor
        
        
        UITextField.appearance().tintColor = UIColor().alertButtonColor
        UITextView.appearance().tintColor = UIColor().alertButtonColor
        UITextView.appearance().linkTextAttributes = [.foregroundColor: UIColor().alertButtonColor]
        
        do {
            try reachable = Reachability.init()
        }
        catch {
            print("error in init Reachability")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged, object: reachable)
        do {
            try reachable.startNotifier()
        }
        catch {
            print("could not start reachability notifier")
        }
        //        self.getRemoteNotificationandLocationPermission()
        self.`getRemoteNotificationandPermission`()
        
        print("country Code : - \(Locale.current.regionCode!)")
        if let deviceToken = defaults.value(forKey: kDeviceToken) as? String {
            self.deviceToken = deviceToken
        }
        
        if let data = UserDefaults.standard.object(forKey: kGeneralSettingDetails) as? Data {
            if let generalSettingDetails = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                self.generalSettings = Mapper<GeneralSettingModel>().map(JSONString: generalSettingDetails)
            }
        }
        
        if let token = defaults.value(forKey: kHeaderToken) as? String {
            self.headerToken = token
            
            if let data = UserDefaults.standard.object(forKey: kUserDetails) as? Data {
                if let userDetails = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                    self.userDetails = Mapper<UserDetailsModel>().map(JSONString: userDetails)
                }
            }
            if defaults.value(forKey: kLoginUserList) != nil{
                self.locationManager.requestAlwaysAuthorization()
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()
                
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                    BaseViewController.sharedInstance.autoLogin()
                    //BaseViewController.sharedInstance.navigateToHomeScreen()
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02) {
                    BaseViewController.sharedInstance.navigateToWelconeScreen()
                }
            }
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.02) {
                BaseViewController.sharedInstance.navigateToWelconeScreen()
            }
        }
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
        
        CommonUtility.share.callSettingApi(appDelegate: self)
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let urlString = url.absoluteString
        
        return GIDSignIn.sharedInstance.handle(url)
        
    }
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func clearAllNotifications() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications() // To remove all delivered notifications
        }
        else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken as Data
        print("DeviceToken:- \(deviceToken)")
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        self.deviceToken = fcmToken ?? ""
        defaults.setValue(deviceToken, forKey: kDeviceToken)
        defaults.synchronize()
        let dataDict:[String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    //This method will call when clcik on notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UserInfo : \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber - 1
        if let notificationdic = userInfo as? [AnyHashable : Any]   {
            if let type = notificationdic["type"] as? String {
                if type == NOTIFICATIONSTYPE.MESSAGE_SEND.rawValue{
                    if let post_id = notificationdic["post_id"] as? String, post_id != "", let sender_id = notificationdic["sender_id"] as? String, sender_id != "" {
                        BaseViewController.sharedInstance.navigateToChatview(postId: Int(post_id) ?? 0, sendUserId: Int(sender_id) ?? 0)
                    }
                }
                else{
                    BaseViewController.sharedInstance.navigateToNotificationlistView()
                }
            }
            else{
                BaseViewController.sharedInstance.navigateToNotificationlistView()
            }
        }
    }
    
    func application(_ application: UIApplication,didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler:@escaping (UIBackgroundFetchResult) -> Void) {
        
        let state : UIApplication.State = application.applicationState
        if (state == .inactive || state == .background) {
            // go to screen relevant to Notification content
            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
            print("background")
            completionHandler(UIBackgroundFetchResult.newData)
        } else {
            // App is in UIApplicationStateActive (running in foreground)
            print("foreground")
            showLocalNotification(userInfo: userInfo)
        }
    }
    fileprivate func showLocalNotification(userInfo:[AnyHashable: Any]) {
        //creating the notification content
        let content = UNMutableNotificationContent()
        //adding title, subtitle, body and badge
        content.userInfo = userInfo
        // content.sound = UNNotificationSound.default
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Revisedv2.wav"))
        //UNNotificationSound(named: "Revisedv2.mp4")
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
        //adding the notification to notification center
        notificationCenter.add(request, withCompletionHandler: nil)
        
    }
    //This method will call when app is in Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var notificationUserInfo = NSDictionary()
        notificationUserInfo = notification.request.content.userInfo as NSDictionary
        let content = UNMutableNotificationContent() // notification content object
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Revisedv2.wav"))
        print("UserInfo : \(notification.request.content.userInfo)")
        UIApplication.shared.applicationIconBadgeNumber =  UIApplication.shared.applicationIconBadgeNumber + 1
        if #available(iOS 14.0, *) {
            completionHandler(
                [UNNotificationPresentationOptions.banner,
                 UNNotificationPresentationOptions.sound,
                 UNNotificationPresentationOptions.badge,
                 UNNotificationPresentationOptions.alert])
        } else {
            // Fallback on earlier versions
            completionHandler(
                [UNNotificationPresentationOptions.alert,
                 UNNotificationPresentationOptions.sound,
                 UNNotificationPresentationOptions.badge])
        }
    }
    
    //MARK: - Permission Method
    func getRemoteNotificationandPermission() {
        let application = UIApplication.shared
        
        //Override point for customization after application launch.
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting: UIUserNotificationSettings = UIUserNotificationSettings.init(types: type, categories: nil)
            application.registerUserNotificationSettings(setting)
            application.registerForRemoteNotifications()
            application.applicationIconBadgeNumber = 1
        }
    }
    //MARK: - Reachability Method
    @objc func reachabilityChanged(note: NSNotification) {
        let reachable = note.object as! Reachability
        if reachable.connection != .none {
            if reachable.connection != .wifi {
                print("Reachable via WiFi")
            }
            else {
                print("Reachable via Cellular")
            }
        }
        else {
            self.displayAlert(title: AlertViewTitle, message: NoInternet)
        }
    }
    
    func displayAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setAlertButtonColor()
        alert.addAction(UIAlertAction(title: kOk, style: .cancel, handler: nil));
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CLLocationManager Delegate Methods -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0]
        defaultLatitude = userLocation.coordinate.latitude
        defaultLongitude = userLocation.coordinate.longitude
        self.getAddressFromLatLon(latitude: defaultLatitude, longitude: defaultLongitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        locationManager.stopUpdatingLocation()
    }
    
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            if placemarks == nil {
                return
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subLocality! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                
                self.currentLocation = addressString
                print(addressString)
            }
        })
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        //            if DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) != nil {
        //                // Handle the deep link. For example, show the deep-linked content or
        //                // apply a promotional offer to the user's account.
        //                // ...
        //                return true
        //            }
        return false
    }
    
    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?
        ) -> Void) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL,
              let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            
            return false
        }
        return false
    }
    //    var otherUserDetailsData : OtherUserDetailsModel?
    
    func presentDetailViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard
            let detailVC = storyboard
                .instantiateViewController(withIdentifier: "HomeViewController")
                as? HomeViewController,
            let navigationVC = storyboard
                .instantiateViewController(withIdentifier: "NavigationController")
                as? UINavigationController
        else { return }
        
        
        navigationVC.modalPresentationStyle = .formSheet
        navigationVC.pushViewController(detailVC, animated: true)
    }
}
