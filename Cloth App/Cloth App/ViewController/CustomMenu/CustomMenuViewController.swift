//
//  CustomMenuViewController.swift
//  Cloth App
//
//  Created by Apple on 01/07/21.
//

import UIKit

@objc protocol CustomMenuDelegate {
    @objc optional func dismissCustomMenu()
}

class CustomMenuViewController: BaseViewController {
    
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var constHeightForTblMenu: NSLayoutConstraint!
    @IBOutlet weak var constWidthForTblMenu: NSLayoutConstraint!
    
    var delegate: CustomMenuDelegate!
    var menuList = [String]()
    var userId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMenu.reloadData()
        self.constHeightForTblMenu.constant = CGFloat(self.menuList.count * Int(VERTICALMENU_SIZE.HEIGHT.rawValue - 10))
        self.constWidthForTblMenu.constant = VERTICALMENU_SIZE.WIDTH.rawValue
    }
    
    @IBAction func btnBack_Clicked(_ button: UIButton) {
        self.dismiss(animated: true, completion: .none)
    }
}

extension CustomMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMenuCell", for: indexPath) as! CustomMenuCell
        
        let menuTitle = self.menuList[indexPath.row]
        cell.lblMenu.text = menuTitle
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if menuList[indexPath.row] == FEED_MORE_MENU.BLOCK.rawValue {
            self.callBlockUser(userId: self.userId)
        }
        else {
            self.dismiss(animated: true, completion: .none)
            if self.delegate != nil {
                self.delegate.dismissCustomMenu?()
            }
        }
    }
}

class CustomMenuCell: UITableViewCell {
    @IBOutlet weak var lblMenu: UILabel!
}

extension CustomMenuViewController{
    func callBlockUser(userId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.BLOCK_USER.rawValue, method: .post, parameters: param) { (response, error) in
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
    
    func callReportUser(reportUserId : String) {
        
    }
    
}
