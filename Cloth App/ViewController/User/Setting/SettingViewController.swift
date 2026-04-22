////
////  SettingViewController.swift
////  ClothApp
////
////  Created by Apple on 08/04/21.
////  Copyright © 2021 YellowPanther. All rights reserved.
////
//
//import UIKit
//import ObjectMapper
//import SafariServices
//import MessageUI
//
//import FBSDKShareKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import FacebookCore
//import FacebookLogin
//import GoogleSignIn
//
//import AuthenticationServices
//
//class SettingViewController: BaseViewController,MFMailComposeViewControllerDelegate {
//    
//    @IBOutlet weak var CVVerifyAccount: UICollectionView!
//    @IBOutlet weak var CVInvite: UICollectionView!
//    @IBOutlet weak var tblFollowPeople : UITableView!
//    @IBOutlet weak var constHeightForTblFollowPeople: NSLayoutConstraint!
//    @IBOutlet weak var tblAccount : UITableView!
//    @IBOutlet weak var constHeightForTblAccoun: NSLayoutConstraint!
//    @IBOutlet weak var viewStoreAndUser : UIView!
//    @IBOutlet weak var constTopForViewStoreAndUser: NSLayoutConstraint!
//    @IBOutlet weak var lblStoreAndUserTitle : UILabel!
//    @IBOutlet weak var lblChatTitle : UILabel!
//    @IBOutlet weak var btnChatOnOff : UIButton!
//    @IBOutlet weak var imgChateOnOff : UIImageView!
//    @IBOutlet weak var btnOdearOnOff : UIButton!
//    @IBOutlet weak var lblOdearTitle : UILabel!
//    @IBOutlet weak var imgOdearOnOff : UIImageView!
//    @IBOutlet weak var btnStoreAndFindLocation : UIButton!
//    @IBOutlet weak var lblPrivateAccountDetails : UILabel!
//    @IBOutlet weak var constHeightForviewStoreAndUser: NSLayoutConstraint!
//    @IBOutlet weak var viewPrivacy : UIView!
//    @IBOutlet weak var constTopForviewPrivacy: NSLayoutConstraint!
//    @IBOutlet weak var lblPrivacyTitle : UILabel!
//    @IBOutlet weak var lblShowEmail : UILabel!
//    @IBOutlet weak var lblShowPhone : UILabel!
//    @IBOutlet weak var btnShowEmail : CustomButton!
//    @IBOutlet weak var btnShowPhone: CustomButton!
//    
//    @IBOutlet weak var lblNotification : UILabel!
//    @IBOutlet weak var constTopForNotification: NSLayoutConstraint!
//    @IBOutlet weak var tblNotification : UITableView!
//    @IBOutlet weak var constHeightForTblNotification: NSLayoutConstraint!
//    @IBOutlet weak var tblAdditional : UITableView!
//    @IBOutlet weak var constHeightForTblAdditional: NSLayoutConstraint!
//    
//    
//    
//    var loginType = ""
//    var verifyAccount = ["Text","Email","Apple","Google","Facebook"]//"Twitter"email pachi,
//    var verifyImgeAccount = ["Message-ic","email-ic","apple_ic","google_ic","facebook_ic"]//"twitter",
//    var verifyList = ["Text","Email","Facebook","More"]//
//    var verifyImgeList = ["Message-ic","email-ic","facebook_ic","more-ic"] //
//    var FollowPeopleList = ["Qr code"]//"Facebook",
//    var FollowPeopleImgeList = ["qr-code-ic"]//"facebook_ic",
//    var accountLise = ["My sizes","Change password","Blocked users","Delete account","Log out","Log out all","Add account","Payment methods"]
//    var notificationList = ["All notifications","Saved search notifications","Chat notifications","Follower notifications","Rating notifications","Watchlist notifications"] //,"Click Coin notifications"
//    var additionalList = ["Terms and conditions","Account management","Report a problem","Leave a suggestion"]
//    var selectIndexNotification = ""
//    
//    var socialId = ""
//    var firstName = ""
//    var lastName = ""
//    var emailId = ""
//    var registerType = ""
//    //    var loginType = ""
//    var profilePicture = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //1 = user , 2 = store, 3 = brand
//        if appDelegate.userDetails?.role_id == 2 {
//            self.viewStoreAndUser.isHidden = false
//            self.lblStoreAndUserTitle.text = "Find location"
//            self.lblPrivateAccountDetails.isHidden = true
//            self.constHeightForviewStoreAndUser.constant = 99
//            self.lblChatTitle.isHidden = false
//            self.lblOdearTitle.isHidden = true
//            self.btnChatOnOff.isHidden = false
//            self.btnOdearOnOff.isHidden = true
//            self.imgChateOnOff.isHidden = false
//            self.imgOdearOnOff.isHidden = true
//            self.constTopForViewStoreAndUser.constant = -35
//            //            self.constTopForviewPrivacy.constant = -49
//            self.constTopForNotification.constant = -49
//            if appDelegate.userDetails?.isFindlocation() ?? false{
//                self.btnStoreAndFindLocation.isSelected = true
//            }
//            else {
//                self.btnStoreAndFindLocation.isSelected = false
//            }
//            //            self.viewPrivacy.isHidden = false
//        }
//        else if appDelegate.userDetails?.role_id == 1 {
//            self.viewStoreAndUser.isHidden = false
//            self.lblStoreAndUserTitle.text = "Private account"
//            self.lblPrivateAccountDetails.isHidden = false
//            self.constHeightForviewStoreAndUser.constant = 99
//            self.constTopForNotification.constant = 10
//            self.lblChatTitle.isHidden = false
//            self.lblOdearTitle.isHidden = false
//            self.btnChatOnOff.isHidden = false
//            self.btnOdearOnOff.isHidden = false
//            self.imgChateOnOff.isHidden = false
//            self.imgOdearOnOff.isHidden = false
//            self.constTopForViewStoreAndUser.constant = -80
//            if appDelegate.userDetails?.is_private == 1 {
//                self.btnStoreAndFindLocation.isSelected = true
//            }
//            else
//            {
//                self.btnStoreAndFindLocation.isSelected = false
//            }
//            //            self.viewPrivacy.isHidden = true
//            //            self.constTopForNotification.constant = -99
//        }
//        else{
//            self.viewStoreAndUser.isHidden = true
//            self.lblStoreAndUserTitle.text = "Find location"
//            self.lblPrivateAccountDetails.isHidden = true
//            self.constHeightForviewStoreAndUser.constant = 1
//           
//            self.viewPrivacy.isHidden = false
//            //            self.constTopForviewPrivacy.constant = -99
//            self.lblChatTitle.isHidden = false
//            self.lblOdearTitle.isHidden = false
//            self.btnChatOnOff.isHidden = false
//            self.btnOdearOnOff.isHidden = false
//            self.imgChateOnOff.isHidden = false
//            self.imgOdearOnOff.isHidden = false
//            self.constTopForViewStoreAndUser.constant = 10
//            self.constTopForNotification.constant = 5
//            self.btnStoreAndFindLocation.isSelected = false
//        }
//        self.SetSettingData()
//        
//       // GIDSignIn.sharedInstance.delegate = self
//        //GIDSignIn.sharedInstance.presentingViewController = self
//    }
//    
//    func shareFbDailog() {
//        guard let url = URL(string: "\(SERVER_URL)share/profile/\(appDelegate.userDetails?.username ?? "")") else {
//            preconditionFailure("URL is invalid")
//        }
//        print(url)
//        let content = ShareLinkContent()
//        content.contentURL = url
//        
//        let dialog = ShareDialog.init(fromViewController: nil, content: content, delegate: nil)
//        do {
//            try dialog.validate()
//        } catch {
//            print(error)
//        }
//        
//        dialog.show()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        //FollowPeople Table
//        self.tblFollowPeople.reloadData()
//        self.tblFollowPeople.layoutIfNeeded()
//        self.constHeightForTblFollowPeople.constant = self.tblFollowPeople.contentSize.height
//        //Account Table
//        self.tblAccount.reloadData()
//        self.tblAccount.layoutIfNeeded()
//        self.constHeightForTblAccoun.constant = self.tblAccount.contentSize.height
//        //Notification Table
//        self.tblNotification.reloadData()
//        self.tblNotification.layoutIfNeeded()
//        self.constHeightForTblNotification.constant = self.tblNotification.contentSize.height
//        // Additional Table
//        self.tblAdditional.reloadData()
//        self.tblAdditional.layoutIfNeeded()
//        self.constHeightForTblAdditional.constant = self.tblAdditional.contentSize.height
//    }
//    //MARK:- MailcomposerDelegate
//        
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        switch result {
//        case .cancelled:
//            print("User cancelled")
//            break
//            
//        case .saved:
//            print("Mail is saved by user")
//            break
//            
//        case .sent:
//            print("Mail is sent successfully")
//            break
//            
//        case .failed:
//            print("Sending mail is failed")
//            break
//        default:
//            break
//        }
//        
//        controller.dismiss(animated: true)
//        
//    }
//
//    @IBAction func btnChatOnOff_Clicked(_ button: UIButton) {
//        if self.btnChatOnOff.isSelected == true {
//            self.callChatAndOdearSetting(setting_type: "0", value: "0")
//        }
//        else {
//            self.callChatAndOdearSetting(setting_type: "0", value: "1")
//        }
//        self.btnChatOnOff.isSelected = !self.btnChatOnOff.isSelected
//    }
//    
//    @IBAction func btnOdearOnOff_Clicked(_ button: UIButton) {
//        if self.btnOdearOnOff.isSelected == true {
//            self.callChatAndOdearSetting(setting_type: "1", value: "0")
//            
//        }
//        else {
//            self.callChatAndOdearSetting(setting_type: "1", value: "1")
//        }
//        self.btnOdearOnOff.isSelected = !self.btnOdearOnOff.isSelected
//    }
//    
//    @IBAction func btnStoreAndFindLocation_Clicked(_ button: UIButton) {
//        if appDelegate.userDetails?.role_id == 2 {
//            if appDelegate.userDetails?.is_findlocation_on == 1{
//                self.callFienfLocation(status: "0")
//            }
//            else {
//                self.callFienfLocation(status: "1")
//            }
//        }
//        else if appDelegate.userDetails?.role_id == 3 {
//            if appDelegate.userDetails?.is_findlocation_on == 1{
//                self.callFienfLocation(status: "0")
//            }
//            else {
//                self.callFienfLocation(status: "1")
//            }
//        }
//        else if appDelegate.userDetails?.role_id == 1
//        {
//            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "switch to private account?", preferredStyle: .alert)
//            alert.setAlertButtonColor()
//            let yesAction: UIAlertAction = UIAlertAction.init(title: "Switch", style: .default, handler: { (action) in
//                
//                if appDelegate.userDetails?.is_private == 1 {
//                    
//                    self.callPrivetAccount(status: "0")
//                }
//                else {
//                    self.callPrivetAccount(status: "1")
//                }
//            })
//            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
//                
//                self.btnStoreAndFindLocation.isSelected = !self.btnStoreAndFindLocation.isSelected
//            })
//            
//            alert.addAction(noAction)
//            alert.addAction(yesAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//        self.btnStoreAndFindLocation.isSelected = !self.btnStoreAndFindLocation.isSelected
//    }
//    
//    @objc func btnNotificationOnOff_clicked(_ sender: AnyObject) {
//        let poston = sender.convert(CGPoint.zero, to: self.tblNotification)
//        if let indexPath = self.tblNotification.indexPathForRow(at: poston) {
//            let objcet = appDelegate.userDetails?.notificationSetting
//            let cell = self.tblNotification.cellForRow(at: indexPath) as! NotificationCell
//            
//            if cell.btnNotificationOnOff.isSelected {
//                cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                self.callNotificationSetting(notificatonType: String(indexPath.row + 1), value: "0")
//            }
//            else{
//                cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                self.callNotificationSetting(notificatonType: String(indexPath.row + 1), value: "1")
//
//            }
//            cell.btnNotificationOnOff.isSelected = !cell.btnNotificationOnOff.isSelected
//        }
//    }
//    
//    func SetSettingData () {
//        let objcet = appDelegate.userDetails
//        if objcet?.isChatOnOff() ?? false{
//            self.imgChateOnOff.image = UIImage.init(named: "radio_sel")
//        }
//        else {
//            self.imgChateOnOff.image = UIImage.init(named: "radio_unsel")
//        }
//        
//        if objcet?.isOrderOnOff() ?? false {
//            self.imgOdearOnOff.image = UIImage.init(named: "radio_sel")
//        }
//        else {
//            self.imgOdearOnOff.image = UIImage.init(named: "radio_unsel")
//        }
//        if objcet?.notificationSetting?.isAllNotificationOnOff() ?? false {
//            
//        }
//        if appDelegate.userDetails?.isEmailShow() ?? false {
//            self.btnShowEmail.setTitle("Everyone ", for: .normal)
//        }
//        else {
//            self.btnShowEmail.setTitle("Only me ", for: .normal)
//        }
//        if appDelegate.userDetails?.isPhoneShow() ?? false {
//            self.btnShowPhone.setTitle("Everyone ", for: .normal)
//        }
//        else {
//            self.btnShowPhone.setTitle("Only me", for: .normal)
//        }
//    }
//}
//
//extension SettingViewController: UICollectionViewDelegate,UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.CVVerifyAccount {
//            return self.verifyAccount.count
//        }
//        else {
//            return self.verifyList.count
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.CVVerifyAccount {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerifyAccountCell", for: indexPath) as!
//                VerifyAccountCell
//            if verifyAccount[indexPath.item] == "Text" {
//                if appDelegate.userDetails?.phone_verified_at == "" || appDelegate.userDetails?.phone_verified_at == nil{
//                    print("CallAPI")
//                    cell.alphaView.alpha = 0.0
//                }
//                else{
//                    cell.alphaView.alpha = 0.5
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Facebook" {
//                if appDelegate.userDetails?.isFaceBookVerifid() == "" || appDelegate.userDetails?.isFaceBookVerifid() == nil{
//                    print("CallAPI")
//                    cell.alphaView.alpha = 0.0
//                }
//                else{
//                    cell.alphaView.alpha = 0.5
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Email" {
//                if appDelegate.userDetails?.isEmailVerifid() == "" || appDelegate.userDetails?.isEmailVerifid() == nil{
//                    print("CallAPI")
//                    cell.alphaView.alpha = 0.0
//                }
//                else{
//                    cell.alphaView.alpha = 0.5
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Twitter" {
//                if appDelegate.userDetails?.isTwitterVerifid() == "" || appDelegate.userDetails?.isTwitterVerifid() == nil{
//                    print("CallAPI")
//                    cell.alphaView.alpha = 0.0
//                }
//                else{
//                    cell.alphaView.alpha = 0.5
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Apple" {
//                if appDelegate.userDetails?.isAppleVerifid() == "" || appDelegate.userDetails?.isAppleVerifid() == nil{
//                    print("CallAPI")
//                    cell.alphaView.alpha = 0.0
//                }
//                else{
//                    cell.alphaView.alpha = 0.5
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Google" {
//                if appDelegate.userDetails?.isGoogleVerifid() == "" || appDelegate.userDetails?.isGoogleVerifid() == nil{
//                    print("CallAPI")
//                    cell.alphaView.alpha = 0.0
//                }
//                else{
//                    cell.alphaView.alpha = 0.5
//                }
//            }
//            
//            cell.lblVerifyTitle.text = self.verifyAccount[indexPath.item]
//            cell.imgVerify.image = UIImage.init(named: self.verifyImgeAccount[indexPath.item])
//            return cell
//        }
//        else {//if collectionView == self.CVInvite{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VerifyAccountCell", for: indexPath) as!
//                VerifyAccountCell
//            cell.lblVerifyTitle.text = self.verifyList[indexPath.item]
//            cell.imgVerify.image = UIImage.init(named: self.verifyImgeList[indexPath.item])
//            return cell
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == CVInvite {
//            if self.verifyList[indexPath.item] == "Text"{
//                let sms: String = "sms:&body=I'm on Clothing Click as \(appDelegate.userDetails?.username ?? ""). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607"
//                let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
//            }
//            else if self.verifyList[indexPath.item] == "Email"{
////                let mailtoString = "mailto:".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
////                let mailtoUrl = URL(string: mailtoString!)!
////                if UIApplication.shared.canOpenURL(mailtoUrl) {
////                    UIApplication.shared.open(mailtoUrl, options: [:])
////                }
//                if MFMailComposeViewController.canSendMail() {
//                            let mailComposer = MFMailComposeViewController()
//                            mailComposer.setSubject("")
//                            mailComposer.setMessageBody("I'm on Clothing Click as \(appDelegate.userDetails?.username ?? ""). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607", isHTML: false)
//                           // mailComposer.setToRecipients([""])
//                            mailComposer.mailComposeDelegate = self
//                           self.present(mailComposer, animated: true
//                                    , completion: nil)
//                        } else {
//                            print("Email is not configured in settings app or we are not able to send an email")
//                        }
//            }
//            else if self.verifyList[indexPath.item] == "Facebook"{
//                self.shareFbDailog()
//            }
//            else {
//                let text = "I'm on Clothing Click as \(appDelegate.userDetails?.username ?? ""). Install the app to follow my posts and discover great deals on clothing in your area. Download App Now: itms-apps://itunes.apple.com/app/id1605715607"
//                //let myWebsite = NSURL(string: BASE_URL )
//                let shareAll = [text] as [Any]
//                let activityVC = UIActivityViewController(activityItems:  shareAll, applicationActivities: nil)
//                activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
//                self.present(activityVC, animated: true, completion: nil)
//                activityVC.completionWithItemsHandler = { [self] activity, success, items, error in
//                    print("activity: \(activity ?? UIActivity.ActivityType(rawValue: "")), success: \(success), items: \(String(describing: items)), error: \(String(describing: error))")
//                }
//            }
//        }
//        else if collectionView == self.CVVerifyAccount {
//            if verifyAccount[indexPath.item] == "Text" {
//                if appDelegate.userDetails?.phone_verified_at == "" || appDelegate.userDetails?.phone_verified_at == nil{
//                    print("CallAPI")
//                    self.navigateToVerfyOTP()
//                }
//                else{
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: "You have already verify with Mobile number")
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Facebook" {
//                if appDelegate.userDetails?.isFaceBookVerifid() == "" || appDelegate.userDetails?.isFaceBookVerifid() == nil{
//                    print("CallAPI")
//                    self.loginType = "1"
//                    self.registerType = REGISTER_TYPE.FACEBOOK.rawValue
//                    self.getFacebookID()
//                }
//                else{
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: "You have already verify with facebook")
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Email" {
//                if appDelegate.userDetails?.isEmailVerifid() == "" || appDelegate.userDetails?.isEmailVerifid() == nil{
//                    print("CallAPI")
//                    self.callEmailVerify()
//                }
//                else{
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: "You have already verify with Email address")
//                }
//            }
////            else if verifyAccount[indexPath.item] == "Twitter" {
////                if appDelegate.userDetails?.isTwitterVerifid() == "" || appDelegate.userDetails?.isTwitterVerifid() == nil{
////                    print("CallAPI")
////                    self.view.endEditing(true)
////                    //        self.socailLoginType = "Twitter"
////                    self.loginType = "3"
////                    TWTRTwitter.sharedInstance().logIn { session, error in
////                        if session != nil {
////                            print("signed in as \(session!.userName)")
////                            print("signed in userid is \(session!.userID)")
////
////                            self.getEmailOfCurrentUserFromTwitter()
////                        }
////                        else {
////                            print("error: \(error!.localizedDescription)");
////                        }
////                    }
////                }
////                else{
////                    UIAlertController().alertViewWithTitleAndMessage(self, message: "You have already verify with Twitter")
////                }
////            }
//            else if verifyAccount[indexPath.item] == "Apple" {
//                if appDelegate.userDetails?.isAppleVerifid() == "" || appDelegate.userDetails?.isAppleVerifid() == nil{
//                    print("CallAPI")
//                    self.view.endEditing(true)
//                    self.loginType = "4"
//                    let appleIDProvider = ASAuthorizationAppleIDProvider()
//                    let request = appleIDProvider.createRequest()
//                    request.requestedScopes = [.fullName, .email]
//                    
//                    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//                    authorizationController.delegate = self
//                    authorizationController.presentationContextProvider = self
//                    authorizationController.performRequests()
//                }
//                else{
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: "You have already verify with Apple")
//                }
//            }
//            else if verifyAccount[indexPath.item] == "Google" {
//                if appDelegate.userDetails?.isGoogleVerifid() == "" || appDelegate.userDetails?.isGoogleVerifid() == nil{
//                    self.loginType = "2"
////                    GIDSignIn.sharedInstance.clientID = googleClientId
////                    GIDSignIn.sharedInstance.signIn()
////                    let signInConfig = GIDConfiguration.init(clientID: googleClientId)
////                    GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
////                        if (error == nil) {
////                            if let userId = user?.userID {
////                                self.socialId = userId
////                            }
////                            
////                            if let firstName = user?.profile?.givenName {
////                                self.firstName = firstName
////                            }
////                            
////                            if let lastName = user?.profile?.familyName {
////                                self.lastName = lastName
////                            }
////                            
////                            if let email = user?.profile?.email {
////                                self.emailId = email
////                            }
////                            
////                            self.callVerifyAccount()
////                        }
////                        else {
////                            print("\(error!.localizedDescription)")
////                        }
////                       guard error == nil else { return }
////
////                       // If sign in succeeded, display the app's main content View.
////                     }
//                }
//                else{
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: "You have already  verify with Google")
//                }
//            }
//            //            self.CVVerifyAccount.reloadData()
//        }
//    }
//}
//
//class VerifyAccountCell : UICollectionViewCell {
//    @IBOutlet weak var alphaView: UIView!
//    @IBOutlet weak var lblVerifyTitle: UILabel!
//    @IBOutlet weak var imgVerify: UIImageView!
//}
//
//extension SettingViewController : UITableViewDelegate,UITableViewDataSource ,SFSafariViewControllerDelegate{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == self.tblFollowPeople {
//            return self.FollowPeopleList.count
//        }
//        else if tableView == self.tblAccount {
//            return self.accountLise.count
//        }
//        else if tableView == self.tblNotification {
//            return self.notificationList.count
//        }
//        else {
//            return self.additionalList.count
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if tableView == self.tblFollowPeople {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowPeopleCell", for: indexPath) as! FollowPeopleCell
//            cell.lblFollowPeopleTitle.text = self.FollowPeopleList[indexPath.row]
//            cell.imgFollowPeople.image = UIImage.init(named: self.FollowPeopleImgeList[indexPath.item])
//            return cell
//        }
//        else if tableView == self.tblAccount {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
//            cell.lblAccountTitle.text = self.accountLise[indexPath.row]
//            return cell
//        }
//        else if tableView == self.tblNotification {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
//            let objcet = appDelegate.userDetails?.notificationSetting
//            cell.lblNotification.text = self.notificationList[indexPath.row]
//            if objcet?.isAllNotificationOnOff() ?? false{
//                cell.btnNotificationOnOff.isSelected = objcet?.isAllNotificationOnOff() ?? false
//                cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                
//            }
//            else {
//                if indexPath.row == 0 {
//                    cell.btnNotificationOnOff.isSelected = objcet?.isAllNotificationOnOff() ?? false
//                    if objcet?.isAllNotificationOnOff() ?? false {
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                       
//                    }
//                }
//                if indexPath.row == 1 {
//                    cell.btnNotificationOnOff.isSelected = objcet?.isSaveCearchOnOff() ?? false
//                    if objcet?.isSaveCearchOnOff() ?? false {
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                    }
//                }
//                if indexPath.row == 2 {
//                    cell.btnNotificationOnOff.isSelected = objcet?.isChatOnOff() ?? false
//                    if objcet?.isChatOnOff() ?? false {
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                    }
//                }
//                if indexPath.row == 3{
//                    cell.btnNotificationOnOff.isSelected = objcet?.isFollowerOnOff() ?? false
//                    if objcet?.isFollowerOnOff() ?? false {
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                    }
//                }
//                if indexPath.row == 4{
//                    cell.btnNotificationOnOff.isSelected = objcet?.isRatingOnOff() ?? false
//                    if objcet?.isRatingOnOff() ?? false{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                    }
//                }
//                if indexPath.row == 5{
//                    cell.btnNotificationOnOff.isSelected = objcet?.isWarchListOnOff() ?? false
//                    if objcet?.isWarchListOnOff() ?? false {
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                    }
//                }
//                if indexPath.row == 6{
//                    cell.btnNotificationOnOff.isSelected = objcet?.isCoinOnOff() ?? false
//                    if objcet?.isCoinOnOff() ?? false {
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_sel")
//                    }
//                    else{
//                        cell.imgNotificationButton.image = UIImage.init(named: "radio_unsel")
//                    }
//                    
//                }
//            }
//            cell.btnNotificationOnOff.addTarget(self, action: #selector(btnNotificationOnOff_clicked(_:)), for: .touchUpInside)
//            return cell
//        }
//        else
//        {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
//            cell.lblAccountTitle.text = self.additionalList[indexPath.row]
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if tableView == self.tblNotification {
//            self.selectIndexNotification = self.notificationList[indexPath.row]
//            self.tblNotification.reloadRows(at: [indexPath], with: .automatic)
//        }
//        else if tableView == self.tblFollowPeople {
////            if self.FollowPeopleList[indexPath.row] == "Qr code" {
////                let ViewController = self.storyboard?.instantiateViewController(identifier: "QrCodeViewController") as! QrCodeViewController
////                self.navigationController?.pushViewController(ViewController, animated: true)
////            }
//            else if self.FollowPeopleList[indexPath.row] == "Facebook" {
//                self.shareFbDailog()
//            }
//            else if self.FollowPeopleList[indexPath.row] == "Contaect"{
//                let mailtoString = "mailto:\(appDelegate.userDetails?.email)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                let mailtoUrl = URL(string: mailtoString!)!
//                if UIApplication.shared.canOpenURL(mailtoUrl) {
//                    UIApplication.shared.open(mailtoUrl, options: [:])
//                }
//            }
//        }
//        else if tableView == self.tblAccount {
//            if self.accountLise[indexPath.row] == "Change password" {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//            else if self.accountLise[indexPath.row] == "Log out" {
//                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
//                alert.setAlertButtonColor()
//                let yesAction: UIAlertAction = UIAlertAction.init(title: "Logout", style: .default, handler: { (action) in
//                    self.logoutUser(isAll: "0")
//                    
//                })
//                let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
//                })
//                alert.addAction(noAction)
//                alert.addAction(yesAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//            else if self.accountLise[indexPath.row] == "Delete account" {
//                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to Delete account?", preferredStyle: .alert)
//                alert.setAlertButtonColor()
//                let yesAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: .default, handler: { (action) in
//                    self.delleteUser()
//                    
//                })
//                let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
//                })
//                alert.addAction(noAction)
//                alert.addAction(yesAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//            else if self.accountLise[indexPath.row] == "Log out all" {
//                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to Log out allt?", preferredStyle: .alert)
//                alert.setAlertButtonColor()
//                let yesAction: UIAlertAction = UIAlertAction.init(title: "Logout", style: .default, handler: { (action) in
//                    self.logoutUser(isAll: "1")
//                })
//                let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
//                })
//                
//                alert.addAction(noAction)
//                alert.addAction(yesAction)
//                self.present(alert, animated: true, completion: nil)
//                
//            }
//            else if self.accountLise[indexPath.row] == "My sizes" {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "ClothPreferencesViewController") as! ClothPreferencesViewController
//                ViewController.isMySizes = true
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//            else if self.accountLise[indexPath.row] == "Blocked users"
//            {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "BlockeUsersViewController") as! BlockeUsersViewController
//                
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//            else if self.accountLise[indexPath.row] == "Add account" {
//                self.navigateToWelconeScreen()
//            }
//            else if self.accountLise[indexPath.row] == "Payment methods" {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
//                ViewController.isSetting = true
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//        }
//        else if tableView == self.tblAdditional {
//            if self.additionalList[indexPath.row] == "Terms and conditions" {
//               
//                self.openUrl(urlString: "\(Forurl)terms")
//                
//            }
//            else if self.additionalList[indexPath.row] == "Account management" {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "ManageAccountViewController") as! ManageAccountViewController
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//            else if self.additionalList[indexPath.row] == "Report a problem" {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "SuggestionReportViewController") as! SuggestionReportViewController
//                ViewController.headerTitle = self.additionalList[indexPath.row]
//                ViewController.subTitle = "Please Briefly explain the issue"
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//            else if self.additionalList[indexPath.row] == "Leave a suggestion" {
//                let ViewController = self.storyboard?.instantiateViewController(identifier: "SuggestionReportViewController") as! SuggestionReportViewController
//                ViewController.headerTitle = self.additionalList[indexPath.row]
//                ViewController.subTitle = "Let us know how we can better your experience on Clothing Click"
//                self.navigationController?.pushViewController(ViewController, animated: true)
//            }
//        }
//    }
//}
//
//extension SettingViewController {
//    
//    func logoutUser(isAll : String) {
//        if appDelegate.reachable.connection != .none {
//            let param = ["devices_id": UIDevice().deviceID,
//                         "is_all" : isAll]
//            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LOGOUT.rawValue, parameters: param) { (response, error) in
//                if error == nil {
//                    if isAll == "0" {
//                        var arrTemp = [[String:Any]]()
//                        if defaults.value(forKey: kLoginUserList) != nil {
//                            if var arr = defaults.value(forKey: kLoginUserList) as? [[String:Any]], arr.count > 0 {
//                                var isRemove = false
//                                var index = -1
//                                for i in 0..<arr.count {
//                                    let dict = arr[i]
//                                    if let id = dict["id"] as? Int, id == appDelegate.userDetails?.id {
//                                        isRemove = true
//                                        index = i
//                                    }
//                                }
//                                arr.remove(at: index)
//                                arrTemp = arr
//                                defaults.set(arrTemp, forKey: kLoginUserList)
//                                defaults.synchronize()
//                                if arrTemp.count > 0 {
//                                    self.saveUserDetails(userDetails: Mapper<UserDetailsModel>().map(JSON: arrTemp[0])!)
//                                    self.navigateToHomeScreen()
//                                }
//                                else{
////                                    GIDSignIn.sharedInstance.signOut()
//                                    self.clearAllUserDataFromPreference()
//                                    self.navigateToWelconeScreen()
//                                }
//                            }
//                        }
//                        else{
//                            self.clearAllUserDataFromPreference()
//                            self.navigateToLoginScreen()
//                        }
//                    }
//                    else{
//                        self.clearAllUserDataFromPreference()
//                        self.navigateToWelconeScreen()
//                    }
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//    
//    func delleteUser() {
//        if appDelegate.reachable.connection != .none {
//            
//            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.DELETE_ACCOUNT.rawValue, parameters: [:]) { (response, error) in
//                if error == nil {
////                    if isAll == "0" {
//                         var arrTemp = [[String:Any]]()
//                        if defaults.value(forKey: kLoginUserList) != nil {
//                            if var arr = defaults.value(forKey: kLoginUserList) as? [[String:Any]], arr.count > 0 {
//                                var isRemove = false
//                                var index = -1
//                                for i in 0..<arr.count {
//                                    let dict = arr[i]
//                                    
//                                    if let id = dict["id"] as? Int, id == appDelegate.userDetails?.id {
//                                        isRemove = true
//                                        index = i
//                                    }
//                                }
//                                arr.remove(at: index)
//                                arrTemp = arr
//                                defaults.set(arrTemp, forKey: kLoginUserList)
//                                defaults.synchronize()
//                                if arrTemp.count > 0 {
//                                    self.saveUserDetails(userDetails: Mapper<UserDetailsModel>().map(JSON: arrTemp[0])!)
//                                    self.navigateToHomeScreen()
//                                }
//                                else{
////                                    GIDSignIn.sharedInstance.signOut()
//                                    self.clearAllUserDataFromPreference()
//                                    self.navigateToWelconeScreen()
//                                }
//                            }
//                        }
//                        else{
//                            self.clearAllUserDataFromPreference()
//                            self.navigateToLoginScreen()
//                        }
////                    }
////                    else{
////                        self.clearAllUserDataFromPreference()
////                        self.navigateToWelconeScreen()
////                    }
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//    
//    func callPrivetAccount(status : String) {
//        if appDelegate.reachable.connection != .none {
//            let param = ["status" : status]
//            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.USER_CHANGE_PROFILE_STATUS.rawValue, method: .post, parameters: param) { (response, error) in
//                if error == nil {
//                    if let response = response {
//                        if let userDetails = response.dictData {
//                            self.saveUserDetails(userDetails: userDetails)
//                        }
//                        if status == "0" {
//                            self.btnStoreAndFindLocation.isSelected = false
//                        }
//                        else
//                        {
//                            self.btnStoreAndFindLocation.isSelected = true
//                        }
//                        self.view.endEditing(true)
//                        if let message = response.message {
//                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
//                            alert.view.tintColor = UIColor().alertButtonColor
//                            
//                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
//                                self.navigationController?.popViewController(animated: true)
//                            })
//                            alert.addAction(hideAction)
//                        }
//                    }
//                }
//                else {
//                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
//                }
//            }
//        }
//        else {
//            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
//        }
//    }
//    
//    func callFienfLocation(status : String) {
//        if appDelegate.reachable.connection != .none {
//            let param = ["status" : status]
//            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_CHANGE_PROFILE_FINDLOCATION.rawValue, method: .post, parameters: param) { (response, error) in
//                if error == nil {
//                    if let response = response {
//                        if let userDetails = response.dictData {
//                            self.saveUserDetails(userDetails: userDetails)
//                        }
//                        self.view.endEditing(true)
//                        if let message = response.message {
//                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
//                            alert.view.tintColor = UIColor().alertButtonColor
//                            
//                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
//                                self.navigationController?.popViewController(animated: true)
//                            })
//                            alert.addAction(hideAction)
//                            //
//                            //                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//                }
//                else {
//                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
//                }
//            }
//        }
//        else {
//            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
//        }
//    }
//    
//    func callNotificationSetting(notificatonType : String,value : String ) {
//        if appDelegate.reachable.connection != .none {
//            
//            let param = ["notification_type": notificatonType ,
//                         "value" : value
//            ]
//            
//            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.NOTIFICATION_SETTING.rawValue, method: .post, parameters: param) { (response, error) in
//                if error == nil {
//                    if let userDetails = response?.dictData {
//                        self.saveUserDetails(userDetails: userDetails)
//                        self.SetSettingData()
//                        self.tblNotification.reloadData()
//                        print(userDetails)
//                    }
//                    
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//    
//    func callChatAndOdearSetting(setting_type : String,value : String ) {
//        if appDelegate.reachable.connection != .none {
//            
//            let param = ["setting_type": setting_type ,
//                         "value" : value
//            ]
//            
//            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CHAR_ORDER_SETTING.rawValue, method: .post, parameters: param) { (response, error) in
//                if error == nil {
//                    if setting_type == "0" {
//                        if value == "0" {
//                            self.imgChateOnOff.image = UIImage.init(named: "radio_unsel")
//                        }
//                        else {
//                            self.imgChateOnOff.image = UIImage.init(named: "radio_sel")
//                        }
//                    }
//                    else {
//                        if value == "0" {
//                            self.imgOdearOnOff.image = UIImage.init(named: "radio_unsel")
//                        }
//                        else {
//                            self.imgOdearOnOff.image = UIImage.init(named: "radio_sel")
//                        }
//                    }
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//    
//    func callVerifyAccount() {
//        if appDelegate.reachable.connection != .none {
//            
//            let param = ["type": self.loginType ,
//                         "id" : self.socialId
//            ]
//            
//            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.USER_UPDATE_SOCIAL_ACCOUNT_ID.rawValue, method: .post, parameters: param) { (response, error) in
//                if error == nil {
//                    if let response = response {
//                        if let userDetails = response.dictData {
//                            self.saveUserDetails(userDetails: userDetails)
//                        }
//                    }
//                    self.CVVerifyAccount.reloadData()
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//    
//    // SOCIAL LOGIN
//    
//    func callEmailVerify() {
//        if appDelegate.reachable.connection != .none {
//            
//            let param = ["is_email_change": "0",
//                         "email" : appDelegate.userDetails?.email ?? ""] as [String : Any]
//            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.USER_RESEND_EMAIL_VERIFICATION_LINK.rawValue, parameters: param) { (response, error) in
//                if error == nil {
//                    if let response = response {
//                        if let message = response.message {
//                            UIAlertController().alertViewWithTitleAndMessage(self, message: message)
//                        }
//                    }
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
//    }
//    
////    func getEmailOfCurrentUserFromTwitter() {
////        let client = TWTRAPIClient.withCurrentUser()
////        let request = client.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/account/verify_credentials.json",
////                                        parameters: ["include_email": "true", "skip_status": "true"],
////                                        error: nil)
////        
////        client.requestEmail(forCurrentUser: { email, error in
////            if error == nil {
////                print("Email of Current User is: \(String(describing: email))")
////            }
////            else {
////                print("Error in Getting Email: \(String(describing: error?.localizedDescription))")
////            }
////        })
////        
////        client.sendTwitterRequest(request, completion: { response, data, error in
////            if error == nil {
////                print("Response for Email is \(String(describing: response))")
////                if data == nil {
////                    return
////                }
////                
////                if let datastring = String(data: data!, encoding: String.Encoding.utf8) {
////                    print(datastring)
////                    if let dataDictionary = self.convertStringToDictionary(text: datastring) {
////                        if let twitterID = dataDictionary["id_str"] as? String {
////                            self.socialId = twitterID
////                        }
////                        
////                        if let fullName = dataDictionary["name"] as? String {
////                            let array = fullName.components(separatedBy: " ")
////                            if array.count > 1 {
////                                self.firstName = array[0]
////                            }
////                            if array.count >= 2 {
////                                self.lastName = array[1]
////                            }
////                        }
////                        
////                        if let twitterProfileURL = dataDictionary["profile_image_url_https"] as? String {
////                            self.profilePicture = twitterProfileURL
////                        }
////                        
////                        self.callVerifyAccount()
////                    }
////                }
////            }
////            else {
////                print("Error is \(String(describing: error?.localizedDescription))")
////                UIAlertController().alertViewWithTitleAndMessage(self, message: error!.localizedDescription)
////            }
////        })
////    }
////    
//    func getFacebookID() {
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
////    func getFBUserData() {
////        let params = ["fields": "email, id, name, first_name, last_name, picture"]
////        
////        let request = GraphRequest.init(graphPath: "me", parameters: params)
////        
////        request.start { (connection, result, error) in
////            if error != nil {
////                UIAlertController().alertViewWithTitleAndMessage(self, message: error!.localizedDescription)
////                return
////            }
////            
////            // Handle vars
////            if let result = result as? [String: Any] {
////                if let socialId = result["id"] as? String {
////                    self.socialId = socialId
////                }
////                
////                if let firstName = result["first_name"] as? String {
////                    self.firstName = firstName
////                }
////                
////                if let lastName = result["last_name"] as? String {
////                    self.lastName = lastName
////                }
////                
////                if let email = result["email"] as? String {
////                    self.emailId = email
////                }
////                
////                self.callVerifyAccount()
////            }
////        }
////    }
//    
//}
//
////@available(iOS 13.0, *)
////extension SettingViewController: GIDSignInDelegate {
////    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
////        self.present(viewController, animated: true, completion: nil)
////    }
////
////    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
////        self.dismiss(animated: true, completion: nil)
////    }
////
////    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
////        if (error == nil) {
////            if let userId = user.userID {
////                self.socialId = userId
////            }
////
////            if let firstName = user.profile?.givenName {
////                self.firstName = firstName
////            }
////
////            if let lastName = user.profile?.familyName {
////                self.lastName = lastName
////            }
////
////            if let email = user.profile?.email {
////                self.emailId = email
////            }
////
////            self.callVerifyAccount()
////        }
////        else {
////            print("\(error.localizedDescription)")
////        }
////    }
////
////    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
////        UIAlertController().alertViewWithTitleAndMessage(self, message: "\(error.localizedDescription)")
////    }
////}
////
////extension SettingViewController: ASAuthorizationControllerDelegate {
////    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
////        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
////            self.socialId = appleIDCredential.user
////            self.firstName = appleIDCredential.fullName?.givenName ?? ""
////            self.lastName = appleIDCredential.fullName?.familyName ?? ""
////            self.emailId = appleIDCredential.email ?? ""
////            
////            if self.firstName != "" {
////                KeychainService.saveInfo(key: "FirstName", value: self.firstName as NSString)
////            }
////            else {
////                self.firstName = KeychainService.getInfo(key: "FirstName") as String? ?? ""
////            }
////            
////            if self.lastName != "" {
////                KeychainService.saveInfo(key: "LastName", value: self.lastName as NSString)
////            }
////            else {
////                self.lastName = KeychainService.getInfo(key: "LastName") as String? ?? ""
////            }
////            
////            if self.emailId != "" {
////                KeychainService.saveInfo(key: "Email", value: self.emailId as NSString)
////            }
////            else {
////                self.emailId = KeychainService.getInfo(key: "Email") as String? ?? ""
////            }
////            
////            self.callVerifyAccount()
////        }
////        else if let passwordCredential = authorization.credential as? ASPasswordCredential {
////            let userName = passwordCredential.user
////            let password = passwordCredential.password
////            
////            print(userName, password)
////        }
////    }
////    
////    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
////        print(error.localizedDescription)
////    }
////}
////
////extension SettingViewController: ASAuthorizationControllerPresentationContextProviding {
////    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
////        return self.view.window!
////    }
////}
//
//
//class FollowPeopleCell : UITableViewCell {
//    @IBOutlet weak var lblFollowPeopleTitle: UILabel!
//    @IBOutlet weak var imgFollowPeople: UIImageView!
//}
//
//class AccountCell : UITableViewCell {
//    @IBOutlet weak var lblAccountTitle: UILabel!
//}
//
//class NotificationCell : UITableViewCell {
//    @IBOutlet weak var lblNotification: UILabel!
//    @IBOutlet weak var btnNotificationOnOff: UIButton!
//    @IBOutlet weak var imgNotificationButton: UIImageView!
//    
//}
