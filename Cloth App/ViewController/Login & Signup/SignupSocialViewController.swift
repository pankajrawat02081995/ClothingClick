//
//  SignupSocialViewController.swift
//  ClothApp
//
//  Created by Apple on 18/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore
import FacebookLogin
//import TwitterKit
import GoogleSignIn
import AuthenticationServices
//import Google

class SignupSocialViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLoginWithFB: UIButton!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    @IBOutlet weak var btnLoginWithApple: UIButton!
    @IBOutlet weak var btnLoginWithTwitter: UIButton!
    @IBOutlet weak var btnLoginWithEmail: UIButton!
    
    
    //Social Login
    var socialId = ""
    var firstName = ""
    var lastName = ""
    var emailId = ""
    var loginType = ""
    var profilePicture = ""
    var accesscode = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarToTransparant(navigationBar: self.navBar)
        
       // GIDSignIn.sharedInstance.delegate = self
      //  GIDSignIn.sharedInstance.presentingViewController = self
    }
    
    @IBAction func btnLoginWithFB_clicked(_ sender: Any) {
        self.loginType = "2"
        self.loginWithFacebook()
    }
    
    @IBAction func btnLoginWithGoogle_clicked(_ sender: Any) {
        self.loginType = "4"
        self.loginWithGoogle { user in
            if let userId = user?.userID {
                self.socialId = userId
            }
            if let firstName = user?.profile?.givenName {
                self.firstName = firstName
            }
            if let lastName = user?.profile?.familyName {
                self.lastName = lastName
            }
            if let email = user?.profile?.email {
                self.emailId = email
            }
            self.socialLogin()
            
        }
//        GIDSignIn.sharedInstance.clientID = googleClientId
//        GIDSignIn.sharedInstance.signIn()
//        let signInConfig = GIDConfiguration.init(clientID: googleClientId)
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//            if (error == nil) {
//                if let userId = user?.userID {
//                    self.socialId = userId
//                }
//                
//                if let firstName = user?.profile?.givenName {
//                    self.firstName = firstName
//                }
//                
//                if let lastName = user?.profile?.familyName {
//                    self.lastName = lastName
//                }
//                
//                if let email = user?.profile?.email {
//                    self.emailId = email
//                }
//                
//                self.socialLogin()
//            }
//            else {
//                print("\(error!.localizedDescription)")
//            }
//           guard error == nil else { return }
//
//           // If sign in succeeded, display the app's main content View.
//         }
    }
    
    @IBAction func btnLoginWithApple_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.loginType = "5"
        self.loginWithApple()
    }
    
    @IBAction func btnLoginWithTwitter_clicked(_ sender: Any) {
//        self.loginType = "3"
//        TWTRTwitter.sharedInstance().logIn { session, error in
//            if session != nil {
//                print("signed in as \(session!.userName)")
//                print("signed in userid is \(session!.userID)")
//
//                self.getEmailOfCurrentUserFromTwitter()
//            }
//            else {
//                print("error: \(error!.localizedDescription)");
//            }
//        }
    }
    
    @IBAction func btnLoginWithEmail_clicked(_ sender: Any) {
        let viewController =  SignupViewController.instantiate(fromStoryboard: .Auth)
        viewController.loginType = "1"
        viewController.accesscode = self.accesscode
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SignupSocialViewController {
//    func loginWithFacebook() {
//        if AccessToken.current == nil {
//            let loginManager = LoginManager()
//            loginManager.logIn(permissions: [Permission.publicProfile, Permission.email], viewController: self, completion: { (loginResult) in
//                switch loginResult {
//                case .failed(let error):
//                    print(error.localizedDescription)
//                case .cancelled:
//                    print("User cancelled login.")
//                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//                    print("\(grantedPermissions)")
//                    print("\(declinedPermissions)")
//                    print("\(accessToken)")
//                    
//                    if grantedPermissions.contains("email") || grantedPermissions.contains("publicProfile")  {
//                        print("Logged in!")
//                        
//                        self.getFBUserData()
//                    }
//                }
//            })
//        }
//        else {
//            print("Current Access Token is:\(String(describing: AccessToken.current))")
//            self.getFBUserData()
//        }
//    }
//    
//    func getFBUserData() {
//        let params = ["fields": "email, id, name, first_name, last_name, picture"]
//        
//        let request = GraphRequest.init(graphPath: "me", parameters: params)
//        
//        request.start { (connection, result, error) in
//            if error != nil {
//                UIAlertController().alertViewWithTitleAndMessage(self, message: error!.localizedDescription)
//                return
//            }
//            
//            // Handle vars
//            if let result = result as? [String: Any] {
//                if let socialId = result["id"] as? String {
//                    self.socialId = socialId
//                }
//                
//                if let firstName = result["first_name"] as? String {
//                    self.firstName = firstName
//                }
//                
//                if let lastName = result["last_name"] as? String {
//                    self.lastName = lastName
//                }
//                
//                if let email = result["email"] as? String {
//                    self.emailId = email
//                }
//                
//                self.socialLogin()
//            }
//        }
//    }
}

extension SignupSocialViewController {
    func socialLogin() {
        
        let param = ["username": self.socialId,
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
                    if self.loginType == "5"{
                        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "SignupAppleViewController") as! SignupAppleViewController
                        viewController.socialId = self.socialId
                        viewController.firstName = self.firstName
                        viewController.lastName = self.lastName
                        viewController.emailId = self.emailId
                        viewController.loginType = self.loginType
                        viewController.accesscode = self.accesscode
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }else{
                        let viewController = SignupViewController.instantiate(fromStoryboard: .Auth)
                        viewController.socialId = self.socialId
                        viewController.firstName = self.firstName
                        viewController.lastName = self.lastName
                        viewController.emailId = self.emailId
                        viewController.loginType = self.loginType
                        viewController.accesscode = self.accesscode
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
//    func getEmailOfCurrentUserFromTwitter() {
//        let client = TWTRAPIClient.withCurrentUser()
//        let request = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json",
//                                        parameters: ["include_email": "true", "skip_status": "true"],
//                                        error: nil)
//        
//        client.requestEmail(forCurrentUser: { email, error in
//            if error == nil {
//                print("Email of Current User is: \(String(describing: email))")
//            }
//            else {
//                print("Error in Getting Email: \(String(describing: error?.localizedDescription))")
//            }
//        })
//        
//        client.sendTwitterRequest(request, completion: { response, data, error in
//            if error == nil {
//                print("Response for Email is \(String(describing: response))")
//                if data == nil {
//                    return
//                }
//                
//                if let datastring = String(data: data!, encoding: String.Encoding.utf8) {
//                    print(datastring)
//                    if let dataDictionary = self.convertStringToDictionary(text: datastring) {
//                        if let twitterID = dataDictionary["id_str"] as? String {
//                            self.socialId = twitterID
//                        }
//                        if let email = dataDictionary["email"] as? String {
//                            self.emailId = email 
//                        }
//                        if let fullName = dataDictionary["name"] as? String {
//                            let array = fullName.components(separatedBy: " ")
//                            if array.count > 1 {
//                                self.firstName = array[0]
//                            }
//                            if array.count >= 2 {
//                                self.lastName = array[1]
//                            }
//                        }
//                        
//                        if let twitterProfileURL = dataDictionary["profile_image_url_https"] as? String {
//                            self.profilePicture = twitterProfileURL
//                        }
//                        
//                        self.socialLogin()
//                    }
//                }
//            }
//            else {
//                print("Error is \(String(describing: error?.localizedDescription))")
//                UIAlertController().alertViewWithTitleAndMessage(self, message: error!.localizedDescription)
//            }
//        })
//    }
}

//extension SignupSocialViewController: ASAuthorizationControllerDelegate {
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//            self.socialId = appleIDCredential.user
//            self.firstName = appleIDCredential.fullName?.givenName ?? ""
//            self.lastName = appleIDCredential.fullName?.familyName ?? ""
//            self.emailId = appleIDCredential.email ?? ""
//            
//            if self.firstName != "" {
//                KeychainService.saveInfo(key: "FirstName", value: self.firstName as NSString)
//            }
//            else {
//                self.firstName = KeychainService.getInfo(key: "FirstName") as String? ?? ""
//            }
//            
//            if self.lastName != "" {
//                KeychainService.saveInfo(key: "LastName", value: self.lastName as NSString)
//            }
//            else {
//                self.lastName = KeychainService.getInfo(key: "LastName") as String? ?? ""
//            }
//            
//            if self.emailId != "" {
//                KeychainService.saveInfo(key: "Email", value: self.emailId as NSString)
//            }
//            else {
//                self.emailId = KeychainService.getInfo(key: "Email") as String? ?? ""
//            }
//            self.socialLogin()
//        }
//        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
//            let userName = passwordCredential.user
//            let password = passwordCredential.password
//
//            print(userName, password)
//        }
//    }
//    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print(error.localizedDescription)
//    }
//}
//
//extension SignupSocialViewController: ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
