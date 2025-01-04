//
//  BlockeUsersViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class BlockeUsersViewController: BaseViewController {

    @IBOutlet weak var tblBlockUser: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var blockUserList = [Blocked_users]()
    var currentPage = "1"
    var hasMorePages = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoData.isHidden = true
        self.callBlockUserList()
    }
   
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @objc func btnUnBlock_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblBlockUser)
        if let indexPath = self.tblBlockUser.indexPathForRow(at: buttonPosition) {
            if let userId = self.blockUserList[indexPath.row].user_id {
                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to unblock \(self.blockUserList[indexPath.row].username ?? "") profile ?", preferredStyle:.alert)
                alert.setAlertButtonColor()
                let yesAction: UIAlertAction = UIAlertAction.init(title: "YES", style: .default, handler: { (action) in
                    self.callUnBlockUser(userId: String(userId), index: indexPath.row)
                })
                let noAction: UIAlertAction = UIAlertAction.init(title: "NO", style: .default, handler: { (action) in
                })
                
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension BlockeUsersViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blockUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlackUserCell", for: indexPath) as! BlackUserCell
        if let url = self.blockUserList[indexPath.row].image{
            if let image = URL.init(string: url){
                cell.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
            }
        }
//        if let userName = self.blockUserList[indexPath.row].username {
//            cell.lblUserName.text = userName
//        }
        if let name = self.blockUserList[indexPath.row].name {
            cell.lblName.text = name
        }
        cell.btnUnBlock.addTarget(self, action: #selector(btnUnBlock_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.blockUserList.count - 1 && hasMorePages == true {
            currentPage = String(Int(currentPage) ?? 0 + 1)
            self.callBlockUserList()
        }
    }
}

class BlackUserCell : UITableViewCell {
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnUnBlock: CustomButton!
}

extension BlockeUsersViewController {
    func callBlockUserList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: BlockUserListModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.BLOCK_USERS_LIST.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == "1" {
                                self.blockUserList.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages {
                                self.hasMorePages = hasMorePages
                            }
                            if let blockUserList = data.blocked_users {
                                for temp in blockUserList {
                                    self.blockUserList.append(temp)
                                }
                            }
                            if self.blockUserList.count != 0 {
                                self.lblNoData.isHidden = true
                            }
                            else {
                                self.lblNoData.isHidden = true
                            }
                            self.lblNoData.text = "No blocked users"
                            self.tblBlockUser.setBackGroundLabel(count: self.blockUserList.count)
                            self.tblBlockUser.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callUnBlockUser(userId : String, index : Int) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.UNBLOCK_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response
                    {
                        if let message = response.message {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: message)
                        }
                    }
                    self.blockUserList.remove(at: index)
                    if self.blockUserList.count != 0 {
                        self.lblNoData.isHidden = true
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    self.tblBlockUser.setBackGroundLabel(count: self.blockUserList.count)
                    self.tblBlockUser.reloadData()
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
