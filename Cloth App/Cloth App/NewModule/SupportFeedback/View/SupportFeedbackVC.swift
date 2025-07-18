//
//  SupportFeedbackVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/06/24.
//

import UIKit

class SupportFeedbackVC: BaseViewController {

    @IBOutlet weak var btnGallery: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var containerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var txtView: CustomTextView!
    @IBOutlet weak var tableView: UITableView!
    
    var isReport : Bool?
    var userId : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }
    
    func setupTableView(){
        if self.isReport == true {
            self.btnGallery.isHidden = false
            self.lblTitle.text = "Report User"
        }else{
            self.lblTitle.text = "Support & Feedback"
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "NoFeedbackMsgXIB", bundle: nil), forCellReuseIdentifier: "NoFeedbackMsgXIB")
        self.tableView.register(UINib(nibName: "ReportXIB", bundle: nil), forCellReuseIdentifier: "ReportXIB")
    }
    
    @IBAction func sendOnPress(_ sender: UIButton) {
        if self.isReport == true {
            if self.txtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
                BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: "Please Enter Your Report Message")
            }else{
                self.reportUser()
            }
        }else{
            if self.txtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true{
                BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: "Please Enter Your Message")
            }else{
                self.support()
            }
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    

    @IBAction func galleryOnPress(_ sender: UIButton) {
    }
    
    func support(){
        if appDelegate.reachable.connection != .none {
            
            let param = ["message": self.txtView.text ?? ""
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
    
    func reportUser(){
        if appDelegate.reachable.connection != .none {
            let param = ["reported_user_id" : self.userId,
                         "message" : self.txtView.text ?? ""] as [String : Any]
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
    
}

extension SupportFeedbackVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isReport == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportXIB", for: indexPath) as! ReportXIB
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoFeedbackMsgXIB", for: indexPath) as! NoFeedbackMsgXIB
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
