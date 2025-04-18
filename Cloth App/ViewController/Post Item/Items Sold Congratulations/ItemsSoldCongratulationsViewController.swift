//
//  ItemsSoldCongratulationsViewController.swift
//  ClothApp
//
//  Created by Apple on 19/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class ItemsSoldCongratulationsViewController: BaseViewController {

    @IBOutlet weak var lblNodata: UILabel!
    @IBOutlet weak var lblItemSoldCount: UILabel!
    @IBOutlet weak var tblItemSoldeUserLiset: UITableView!
    @IBOutlet weak var constHightFortblItemSoldeUserLiset: NSLayoutConstraint!
    @IBOutlet weak var btnNotSoldItem: UIButton!

    var postId = ""
    var postDetal : Post?
    var userList = [User_list]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNodata.isHidden = true
        self.callGetItemSoldList(postId: self.postId)
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.tblItemSoldeUserLiset.reloadData()
//        self.tblItemSoldeUserLiset.layoutIfNeeded()
//        self.constHightFortblItemSoldeUserLiset.constant = self.tblItemSoldeUserLiset.contentSize.height
//    }
    
    @IBAction func btnNotSoldItem_Clicked(_ button: UIButton) {
        self.navigateToHomeScreen(selIndex: 4)
//        let viewController = self.storyboard?.instantiateViewController(identifier: "UserViewController") as! UserViewController
//        viewController.loginType = "User"
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ItemsSoldCongratulationsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserLisetCell", for: indexPath) as! UserLisetCell
        let object = self.userList[indexPath.row]
        let urlString = object.photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        cell.imgUser.setImageFast(with: urlString)
        
        if let username = object.username {
            cell.lblUserName.text = username
        }
        if let name = object.name {
            cell.lblName.text = name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = NewRatingViewController.instantiate(fromStoryboard: .Setting)
        viewController.isBuyerSeller = true
        viewController.postId = "\(self.postDetal?.id ?? 0)"
        viewController.userId = "\(self.userList[indexPath.row].id ?? 0)"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ItemsSoldCongratulationsViewController {
    func callGetItemSoldList(postId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["post_id":  postId
            ]
            APIManager().apiCall(of:ItemSlodListModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.POST_SOLD_USER_LIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.postDetal = data.post
                            self.userList = data.user_list!
                            if let itemSoldCount = data.total_sold_items {
                                self.lblItemSoldCount.text = "\(itemSoldCount) Items Sold"
                            }
                        }
                        if self.userList.count == 0 {
                            self.lblNodata.isHidden = false
                        }
                        else {
                            self.lblNodata.isHidden = true
                        }
                        self.tblItemSoldeUserLiset.reloadData()
                        self.tblItemSoldeUserLiset.layoutIfNeeded()
                        self.constHightFortblItemSoldeUserLiset.constant = self.tblItemSoldeUserLiset.contentSize.height + 100
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
