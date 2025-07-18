//
//  SettingVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 11/06/24.
//

import UIKit
import ObjectMapper
import MessageUI
import FBSDKLoginKit

class SettingVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    ["img":"ic_insta","title":"Link your Instagram account","subtitle":""],
    var setting = [["Header":" Link To Social Accounts","rows":[["img":"ic_fb","title":"Link your Facebook account","subtitle":""]]],
                   ["Header":" More","rows":[
                    ["img":"ic_invite","title":"Invite Friends","subtitle":""],
                    ["img":"ic_black_heart","title":"Liked Products","subtitle":""],
                    ["img":"ic_faq","title":"FAQ","subtitle":""],
                    ["img":"ic_my_size","title":"My Sizes","subtitle":""],
                    ["img":"ic_order_history","title":"Order History","subtitle":""],
                    ["img":"ic_support","title":"Supports & Feedback","subtitle":""],/*["img":"ic_coupon","title":"Discounts from local shops","subtitle":""],["img":"ic_convert_store","title":"Convert to Store Account","subtitle":""],*/
                    ["img":"ic_notification","title":"Notifications","subtitle":""],
                    ["img":"ic_private","title":"Private Account","subtitle":"When your account is private only users you have approved can see your items for sale, your existing followers will not be affected."],
                    ["img":"ic_logout","title":"Logout","subtitle":""],
                    ["img":"ic_change_password","title":"Change Password","subtitle":""],
                    ["img":"ic_block_user","title":"Blocked Users","subtitle":""],
//                    ["img":"ic_promo_code","title":"Promo Codes","subtitle":""],
                    ["img":"ic_terms","title":"Terms & Conditions","subtitle":""],["img":"ic_delete","title":"Delete Account","subtitle":""]]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SettingXIB", bundle: nil), forCellReuseIdentifier: "SettingXIB")
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @objc func notificationOnTap(sender:UIButton){
        debugPrint(sender.tag)
        if sender.tag == 6{
            self.callNotificationSetting(notificatonType: "1", value: appDelegate.userDetails?.notificationSetting?.isAllNotificationOnOff() == true ? "0" : "1")
        }else if sender.tag == 7{
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: appDelegate.userDetails?.is_private == 1 ? "switch to normal account?" : "switch to private account?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Switch", style: .default, handler: { (action) in
                
                if appDelegate.userDetails?.is_private == 1 {
                    
                    self.callPrivetAccount(status: "0")
                }
                else {
                    self.callPrivetAccount(status: "1")
                }
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension SettingVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.setting.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = self.setting[section]["rows"] as? [[String:Any]] ?? []
        return rowCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingXIB") as! SettingXIB
        let rowCount = self.setting[indexPath.section]["rows"] as? [[String:Any]] ?? []
        let indexData = rowCount[indexPath.row]
        cell.lblTitle.text = indexData["title"] as? String ?? ""
        cell.lblSubtitle.text = indexData["subtitle"] as? String ?? ""
        cell.img.image = UIImage(named: indexData["img"] as? String ?? "")
        cell.btnToggle.tag = indexPath.row
        cell.btnToggle.addTarget(self, action: #selector(self.notificationOnTap(sender:)), for: .touchUpInside)
        if indexData["title"] as? String ?? "" == "Notifications" || indexData["title"] as? String ?? "" == "Private Account"{
            cell.btnToggle.setImage(.checkmark, for: .normal)
            cell.btnToggle.isUserInteractionEnabled = true
            
            if indexData["title"] as? String ?? "" == "Notifications"{
                let objcet = appDelegate.userDetails?.notificationSetting
                if objcet?.isAllNotificationOnOff() ?? false{
                    cell.btnToggle.setImage(UIImage(named: "ic_toggle_on"), for: .normal)
                }else{
                    cell.btnToggle.setImage(UIImage(named: "ic_toggle_off"), for: .normal)
                }
            }else{
                if appDelegate.userDetails?.is_private == 1{
                    cell.btnToggle.setImage(UIImage(named: "ic_toggle_on"), for: .normal)
                }else{
                    cell.btnToggle.setImage(UIImage(named: "ic_toggle_off"), for: .normal)
                }
            }
        }else{
            cell.btnToggle.isUserInteractionEnabled = false
            cell.btnToggle.setImage(UIImage(named: "arrow_ic_1"), for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 // or any height you prefer
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = CustomHeaderView(title: self.setting[section]["Header"] as? String ?? "")
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowCount = self.setting[indexPath.section]["rows"] as? [[String:Any]] ?? []
        let indexData = rowCount[indexPath.row]
        
        if indexData["title"] as? String ?? "" == "Change Password" {
            let vc = NewPasswordVC.instantiate(fromStoryboard: .Auth)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Link your Facebook account" {
            if appDelegate.userDetails?.facebook_id ?? "" == "" || appDelegate.userDetails?.facebook_id == nil {
                self.loginWithFacebook(isLink: true)
            }else{
                self.showRevokeAccessAlert(type: "facebook")
            }
        }else if indexData["title"] as? String ?? "" == "Logout" {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Logout", style: .default, handler: { (action) in
                self.logoutUser(isAll: "0")
                
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }else if indexData["title"] as? String ?? "" == "My Sizes" {
            let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
            vc.isMySizes = true
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Blocked Users" {
            let vc = BlockeUsersViewController.instantiate(fromStoryboard: .Main)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Terms & Conditions" {
            self.openUrl(urlString: "\(Forurl)terms")
        }else if indexData["title"] as? String ?? "" == "Blocked Users" {
            let vc = BlockeUsersViewController.instantiate(fromStoryboard: .Main)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Liked Products" {
            let vc = FavoritesViewController.instantiate(fromStoryboard: .Main)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "FAQ" {
            let vc = FaqVC.instantiate(fromStoryboard: .Setting)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Order History" {
            let vc = OrderHistoryVC.instantiate(fromStoryboard: .Setting)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Supports & Feedback" {
            let vc = SupportFeedbackVC.instantiate(fromStoryboard: .Setting)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Promo Codes" {
            let vc = PromoCodeVC.instantiate(fromStoryboard: .Setting)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Invite Friends" {
            self.inviteOnPress()
        }else if indexData["title"] as? String ?? "" == "Convert to Store Account" {
            let vc = StoreCreatationVC.instantiate(fromStoryboard: .Setting)
            self.pushViewController(vc: vc)
        }else if indexData["title"] as? String ?? "" == "Delete Account" {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to Delete account?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: .default, handler: { (action) in
                //                let vc = NewChangePasswordVC.instantiate(fromStoryboard: .Auth)
                //                vc.isDeleteAccountRequest = true
                //                vc.deleteResquestOtpVerify = { isDelete in
                //                    if isDelete{
                self.deleteUser()
                //                    }
                //                }
                //                self.pushViewController(vc: vc)
                
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
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
            
            //            self.callUpdetUserProfile(isRevoke: true)
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


//MARK: For Tableview Header

class CustomHeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // Customize font and color here
        label.font = UIFont.RobotoFont(.robotoMedium, size: 16)
        label.textColor = UIColor.customBlack
        return label
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}


extension SettingVC{
    
    func userVerifyMobileNumber() {
        if appDelegate.reachable.connection != .none {
            var  param = [String:Any]()
#if DEBUG
            param = ["phone": appDelegate.userDetails?.phone ?? "",
                     "country_prefix" : "+91" ,
                     "country_code" : "IN",
                     "is_test" : "1"
            ]
#else
            
            param = ["phone": appDelegate.userDetails?.phone ?? "",
                     "country_prefix" : "+1" ,
                     "country_code" : "CA",
                     "is_test" : "1"
            ]
#endif
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIGNUP_STEP2.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    
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
    
    func deleteUser() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.DELETE_ACCOUNT.rawValue, parameters: [:]) { (response, error) in
                if error == nil {
                    self.clearAllUserDataFromPreference()
                    self.navigateToWelconeScreen()
                    //                    if isAll == "0" {
                    var arrTemp = [[String:Any]]()
//                    if defaults.value(forKey: kLoginUserList) != nil {
//                        if var arr = defaults.value(forKey: kLoginUserList) as? [[String:Any]], arr.count > 0 {
//                            var isRemove = false
//                            var index = -1
//                            for i in 0..<arr.count {
//                                let dict = arr[i]
//                                
//                                if let id = dict["id"] as? Int, id == appDelegate.userDetails?.id {
//                                    isRemove = true
//                                    index = i
//                                }
//                            }
//                            arr.remove(at: index)
//                            arrTemp = arr
//                            defaults.set(arrTemp, forKey: kLoginUserList)
//                            defaults.synchronize()
//                            if arrTemp.count > 0 {
//                                self.saveUserDetails(userDetails: Mapper<UserDetailsModel>().map(JSON: arrTemp[0])!)
//                                self.navigateToHomeScreen()
//                            }
//                            else{
//                                //                                    GIDSignIn.sharedInstance.signOut()
//                                self.clearAllUserDataFromPreference()
//                                self.navigateToWelconeScreen()
//                            }
//                        }
//                    }
//                    else{
//                        self.clearAllUserDataFromPreference()
//                        self.navigateToLoginScreen()
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
    func logoutUser(isAll : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["devices_id": UIDevice().deviceID,
                         "is_all" : isAll]
            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LOGOUT.rawValue, parameters: param) { (response, error) in
                if error == nil {
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
                    //                                    //                                    GIDSignIn.sharedInstance.signOut()
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
                    self.clearAllUserDataFromPreference()
                    //                        self.navigateToWelconeScreen()
                    let vc =  LandingVC.instantiate(fromStoryboard: .Landing)
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.setViewControllers([vc], animated: true)
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


extension SettingVC:MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate{
    
    func inviteOnPress(){
        // Choose how you want to share
        let alert = UIAlertController(title: "Share App", message: "How would you like to share the app?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share via Email", style: .default) { _ in
            self.sendEmailInvitation(from: self)
        })
        
        alert.addAction(UIAlertAction(title: "Share via SMS", style: .default) { _ in
            self.sendSMSInvitation(from: self)
        })
        
        alert.addAction(UIAlertAction(title: "Share via Other Apps", style: .default) { _ in
            self.sendInvitation(from: self)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func sendInvitation(from viewController: UIViewController) {
        let appURL = URL(string: "https://apps.apple.com/in/app/clothing-click-second-hand/id1605715607")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func sendEmailInvitation(from viewController: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            
            mailComposeViewController.setSubject("Check out this app!")
            mailComposeViewController.setMessageBody("I want to invite you to check out this amazing app! Download it from the following link: https://apps.apple.com/in/app/clothing-click-second-hand/id1605715607", isHTML: false)
            
            viewController.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            print("Mail services are not available")
        }
    }
    
    func sendSMSInvitation(from viewController: UIViewController) {
        if MFMessageComposeViewController.canSendText() {
            let messageComposeViewController = MFMessageComposeViewController()
            messageComposeViewController.messageComposeDelegate = self
            
            messageComposeViewController.body = "I want to invite you to check out this amazing app! Download it from the following link: https://apps.apple.com/in/app/clothing-click-second-hand/id1605715607"
            
            viewController.present(messageComposeViewController, animated: true, completion: nil)
        } else {
            print("SMS services are not available")
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}


extension SettingVC{
    func callNotificationSetting(notificatonType : String,value : String ) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["notification_type": notificatonType ,
                         "value" : value
            ]
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.NOTIFICATION_SETTING.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let userDetails = response?.dictData {
                        self.saveUserDetails(userDetails: userDetails)
                        //                        self.SetSettingData()
                        self.tableView.reloadData()
                        print(userDetails)
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
    
    func callPrivetAccount(status : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["status" : status]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.USER_CHANGE_PROFILE_STATUS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                        }
                        self.tableView.reloadData()
                        
                        self.view.endEditing(true)
                        if let message = response.message {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: message, preferredStyle: .alert)
                            alert.view.tintColor = UIColor().alertButtonColor
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(hideAction)
                        }
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
}
