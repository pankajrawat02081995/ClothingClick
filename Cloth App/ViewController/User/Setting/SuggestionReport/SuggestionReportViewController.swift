//
//  SuggestionReportViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class SuggestionReportViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var txtMessge: CustomTextView!
    @IBOutlet weak var btnSubmit: UILabel!
    
    var headerTitle = ""
    var subTitle = ""
    var userId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = self.headerTitle
        self.lblSubTitle.text = self.subTitle
    }
    
    @IBAction func btnSubmit_Clicked(_ button: UIButton) {
        if self.txtMessge.text.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter any message")
        }
        else {
            self.callRepott()
        }
    }
}
extension SuggestionReportViewController {
    
    func callRepott() {
        if self.headerTitle == "Report a problem" {
            if appDelegate.reachable.connection != .none {
                
                let param = ["message": self.txtMessge.text ?? ""
                ]
                APIManager().apiCall(of: UserDetailsModel.self,isShowHud: true, URL: BASE_URL, apiName: APINAME.REPORT_PROBLEM.rawValue, method: .post, parameters: param) { (response, error) in
                    if error == nil {
                        if let response = response {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(hideAction)
                            self.present(alert, animated: true, completion: nil)
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
        else if self.headerTitle == "Report user" {
            if appDelegate.reachable.connection != .none {
                let param = ["reported_user_id" : self.userId,
                             "message" : self.txtMessge.text ?? ""] as [String : Any]
                APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.REPORT_USER.rawValue, method: .post, parameters: param) { (response, error) in
                    if error == nil {
                        self.navigateToHomeScreen()
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
        else {
            if appDelegate.reachable.connection != .none {
                
                let param = ["message": self.txtMessge.text ?? ""
                ]
                APIManager().apiCall(of: UserDetailsModel.self,isShowHud: true, URL: BASE_URL, apiName: APINAME.LEAVE_SUGGESTION.rawValue, method: .post, parameters: param) { (response, error) in
                    if error == nil {
                        if let response = response {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                self.navigationController?.popViewController(animated: true)
                            })
                            alert.addAction(hideAction)
                            self.present(alert, animated: true, completion: nil)
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
}

