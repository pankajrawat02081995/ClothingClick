//
//  WelcomeViewController.swift
//  ClothApp
//
//  Created by Apple on 18/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController, TTTAttributedLabelDelegate {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblLink: TTTAttributedLabel!
    @IBOutlet weak var imgCenter: UIImageView!
    @IBOutlet weak var btnCreateAccount: CustomButton!
    @IBOutlet weak var btnLogin: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.callGeneralSettingWithAccessCodeScreenAPI()
        self.setup()
    }
    
    func setup(){
        let strTC = "terms"
        let strPP = "privacy policy"
        let strCP = "cookies policy."
        let string = "By tapping create account or login,you agree to our \(strTC). Learn how we process your data in our \(strPP) and \(strCP)"
        let nsString = string as NSString
        let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 1.2
        
        let fullAttributedString = NSAttributedString(string:string, attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.black.cgColor,
            NSAttributedString.Key.font: UIFont(name: string, size: 16.0) ?? 16,
                ])
        self.lblLink.textAlignment = .center
        self.lblLink.attributedText = fullAttributedString;
        
        let rangeTC = nsString.range(of: strTC)
        let rangePP = nsString.range(of: strPP)
        let rangeCP = nsString.range(of: strCP)

        let ppLinkAttributes: [String: Any] = [
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.blue.cgColor,
                NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
        let ppActiveLinkAttributes: [String: Any] = [
                NSAttributedString.Key.foregroundColor.rawValue: UIColor.blue.cgColor,
                NSAttributedString.Key.underlineStyle.rawValue: false,
                ]
        self.lblLink.activeLinkAttributes = ppActiveLinkAttributes
        self.lblLink.linkAttributes = ppLinkAttributes
        
        let urlTC = URL(string: "\(Forurl)terms")!
        let urlPP = URL(string: "\(Forurl)privacy")!
        let urlCP = URL(string: "\(Forurl)cookies")!
        self.lblLink.addLink(to: urlTC, with: rangeTC)
        self.lblLink.addLink(to: urlPP, with: rangePP)
        self.lblLink.addLink(to: urlCP, with: rangeCP)
        self.lblLink.textColor = UIColor.black;
        self.lblLink.delegate = self;
        

    }
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
            if url.absoluteString == "\(Forurl)terms" {
                self.openUrl(urlString: "\(Forurl)terms")
            }
            else if url.absoluteString == "\(Forurl)privacy" {
                self.openUrl(urlString: "\(Forurl)privacy")
            }
            else {
                self.openUrl(urlString: "\(Forurl)cookies")
            }
        }
    
    @IBAction func btnCreateAccount_clicked(_ sender: Any) {
        
        if appDelegate.generalSettings?.is_show_access_code_screen == 1 {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "SignupAccesscodeViewController") as! SignupAccesscodeViewController
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else{
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "SignupSocialViewController") as! SignupSocialViewController
            viewController.accesscode = ""
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func btnLogin_clicked(_ sender: Any) {
        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "LoginSocialViewController") as! LoginSocialViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
extension WelcomeViewController {
    func callGeneralSettingWithAccessCodeScreenAPI() {
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
}

