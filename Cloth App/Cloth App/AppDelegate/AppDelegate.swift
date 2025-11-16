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
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
import CoreLocation
import GoogleSignIn
import SwiftyJSON
import ObjectMapper
import GooglePlaces
import GoogleMaps
import GoogleMobileAds
import YPImagePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, CLLocationManagerDelegate {
    
    // MARK: - Properties
    let notificationCenter = UNUserNotificationCenter.current()
    var window: UIWindow?
    var reachable: Reachability!
    
    var deviceToken = ""
    var deviceAuthKey = ""
    var userDetails: UserDetailsModel?
    var userLocation: UserLocation?
    var generalSettings: GeneralSettingModel?
    
    var locationManager = CLLocationManager()
    var defaultLatitude: Double = 0.0
    var defaultLongitude: Double = 0.0
    var currentAddress = ""
    var referenceCode = ""
    var authKey = ""
    var currentLocation = ""
    var deeplinkurltype = ""
    var deeplinkid = ""
    var headerToken = ""
    
    // Filter variables
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
    
    // MARK: - App Launch
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        YPImagePickerConfiguration.shared.library.preselectedItems = []
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
        
        // Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        // Google Ads
        MobileAds.shared.start(completionHandler: nil)
        
        // Google APIs
        GMSPlacesClient.provideAPIKey(googleAPIKey)
        GMSServices.provideAPIKey(googleAPIKey)
        
        // Keyboard
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor().alertButtonColor
        UITextField.appearance().tintColor = UIColor().alertButtonColor
        UITextView.appearance().tintColor = UIColor().alertButtonColor
        UITextView.appearance().linkTextAttributes = [.foregroundColor: UIColor().alertButtonColor]
        
        // Reachability
        setupReachability()
        
        // Notifications
        getRemoteNotificationandPermission()
        
        // Debug Country Code
        print("Country Code: \(Locale.current.regionCode ?? "")")
        
        // Load Device Token
        if let storedDeviceToken = defaults.value(forKey: kDeviceToken) as? String {
            deviceToken = storedDeviceToken
        }
        
        // Load General Settings
        if let data = UserDefaults.standard.object(forKey: kGeneralSettingDetails) as? Data,
           let generalSettingDetails = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
            generalSettings = Mapper<GeneralSettingModel>().map(JSONString: generalSettingDetails)
        }
        
        // Load User Session
        if let token = defaults.value(forKey: kHeaderToken) as? String {
            headerToken = token
            
            if let data = UserDefaults.standard.object(forKey: kUserDetails) as? Data,
               let details = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                userDetails = Mapper<UserDetailsModel>().map(JSONString: details)
            }
            
            if defaults.value(forKey: kLoginUserList) != nil {
                requestLocationAccess()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    BaseViewController.sharedInstance.autoLogin()
                }
            } else {
                navigateToWelcome()
            }
        } else {
            navigateToWelcome()
        }
        
        // Facebook
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Google Sign-In
        GIDSignIn.sharedInstance.restorePreviousSignIn { _, _ in }
        
        // App Settings API Call
        CommonUtility.share.callSettingApi(appDelegate: self)
        
        return true
    }
    
    // MARK: - Navigation Helpers
    private func navigateToWelcome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            BaseViewController.sharedInstance.navigateToWelconeScreen()
        }
    }
    
    // MARK: - Location
    private func requestLocationAccess() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: - Reachability
    private func setupReachability() {
        do {
            reachable = try Reachability()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(reachabilityChanged),
                                                   name: Notification.Name.reachabilityChanged,
                                                   object: reachable)
            try reachable.startNotifier()
        } catch {
            print("Reachability setup failed: \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: NSNotification) {
        guard let reachability = note.object as? Reachability else { return }
        
        if reachability.connection == .none {
            displayAlert(title: AlertViewTitle, message: NoInternet)
        } else if reachability.connection == .wifi {
            print("Reachable via WiFi")
        } else {
            print("Reachable via Cellular")
        }
    }
    
    private func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.setAlertButtonColor()
        alert.addAction(UIAlertAction(title: kOk, style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    
    // MARK: - Push Notifications
    func getRemoteNotificationandPermission() {
        if #available(iOS 10.0, *) {
            notificationCenter.delegate = self
            notificationCenter.requestAuthorization(options: [.sound, .alert, .badge]) { granted, _ in
                if granted {
                    DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
                }
            }
        } else {
            let types: UIUserNotificationType = [.badge, .alert, .sound]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 1
        }
    }
    
    func clearAllNotifications() {
        if #available(iOS 10.0, *) {
            notificationCenter.removeAllDeliveredNotifications()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
    
    // MARK: - Remote Notification Handling
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("DeviceToken: \(deviceToken)")
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        deviceToken = fcmToken ?? ""
        defaults.setValue(deviceToken, forKey: kDeviceToken)
        defaults.synchronize()
        NotificationCenter.default.post(name: Notification.Name("FCMToken"),
                                        object: nil,
                                        userInfo: ["token": fcmToken ?? ""])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UserInfo : \(response.notification.request.content.userInfo)")
        let userInfo = response.notification.request.content.userInfo
        UIApplication.shared.applicationIconBadgeNumber -= 1
        
        if let notificationDic = userInfo as? [AnyHashable : Any],
           let type = notificationDic["type"] as? String {
            if type == NOTIFICATIONSTYPE.MESSAGE_SEND.rawValue,
               let post_id = notificationDic["post_id"] as? String, !post_id.isEmpty,
               let sender_id = notificationDic["sender_id"] as? String, !sender_id.isEmpty {
                BaseViewController.sharedInstance.navigateToChatview(postId: Int(post_id) ?? 0,
                                                                     sendUserId: Int(sender_id) ?? 0)
            } else {
                BaseViewController.sharedInstance.navigateToNotificationlistView()
            }
        } else {
            BaseViewController.sharedInstance.navigateToNotificationlistView()
        }
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let state = application.applicationState
        if state == .inactive || state == .background {
            application.applicationIconBadgeNumber += 1
            completionHandler(.newData)
        } else {
            showLocalNotification(userInfo: userInfo)
        }
    }
    
    private func showLocalNotification(userInfo: [AnyHashable: Any]) {
        let content = UNMutableNotificationContent()
        content.userInfo = userInfo
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Revisedv2.wav"))
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber += 1
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge, .alert])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        defaultLatitude = userLocation.coordinate.latitude
        defaultLongitude = userLocation.coordinate.longitude
        getAddressFromLatLon(latitude: defaultLatitude, longitude: defaultLongitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
        locationManager.stopUpdatingLocation()
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double) {
        let ceo = CLGeocoder()
        let loc = CLLocation(latitude: latitude, longitude: longitude)
        
        ceo.reverseGeocodeLocation(loc) { placemarks, error in
            if let error = error {
                print("Reverse geocode fail: \(error.localizedDescription)")
                return
            }
            guard let pm = placemarks?.first else { return }
            var addressString = ""
            if let subLocality = pm.subLocality { addressString += subLocality + ", " }
            if let thoroughfare = pm.thoroughfare { addressString += thoroughfare + ", " }
            if let locality = pm.locality { addressString += locality + ", " }
            if let country = pm.country { addressString += country + ", " }
            if let postalCode = pm.postalCode { addressString += postalCode }
            
            self.currentLocation = addressString
            print(addressString)
        }
    }
    
    // MARK: - URL Handling
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        return false
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let _ = userActivity.webpageURL else {
            return false
        }
        return false
    }
    
    // MARK: - Present Detail
    func presentDetailViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController,
              let navigationVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController else { return }
        
        navigationVC.modalPresentationStyle = .formSheet
        navigationVC.pushViewController(detailVC, animated: true)
    }
}
