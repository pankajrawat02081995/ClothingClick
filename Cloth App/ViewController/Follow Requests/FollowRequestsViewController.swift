//
//  FollowRequestsViewController.swift
//  ClothApp
//
//  Created by Apple on 13/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class FollowRequestsViewController: BaseViewController {

    @IBOutlet weak var tblFollowRequsts: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    var currentPage = "1"
    var searchString = ""
    var hasMorePages = false
    var count = 9
    var followRequest = [FollowRequests?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoData.isHidden = true
        self.callFollowingsRequests(isShowHud: true, Search: self.searchString, Page: self.currentPage)
    }
    
    @objc func btnAccepted_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblFollowRequsts)
        if let indexPath = self.tblFollowRequsts.indexPathForRow(at: buttonPosition) {
            self.callFollowRequstAcceptOrReject(followRequestId: String(self.followRequest[indexPath.row]?.id ?? -1), status: "1", index: indexPath.row)
        }
    }
    @objc func btnRejected_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblFollowRequsts)
        if let indexPath = self.tblFollowRequsts.indexPathForRow(at: buttonPosition) {
            self.callFollowRequstAcceptOrReject(followRequestId: String(self.followRequest[indexPath.row]?.id ?? -1), status: "0", index: indexPath.row)
        }
    }
}

extension FollowRequestsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objet = self.followRequest[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestCell", for: indexPath) as! RequestCell
        let urlString = objet?.photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        cell.imgUser.setImageFast(with: urlString)

        if let userNmae = objet?.username {
            cell.lblSubTitle.text = userNmae
        }
        cell.btnAccepted.addTarget(self, action: #selector(btnAccepted_Clicked(sender:)), for: .touchUpInside)
        cell.btnRejected.addTarget(self, action: #selector(btnRejected_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = self.followRequest[indexPath.row]
        if appDelegate.userDetails?.id == object?.user_id {
            self.navigateToHomeScreen(selIndex: 4)
        }
        else {
            if let seller = object?.role_id {
                if seller == 1 {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                    viewController.userId = "\(object?.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else if seller == 2{
                    let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
                    viewController.userId = "\(object?.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else {
                    let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
                    viewController.userId = "\(object?.user_id ?? 0)"
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.followRequest.count ?? 0 - 1 && hasMorePages == true {
            currentPage = String(Int(currentPage) ?? 0 + 1)
            self.callFollowingsRequests(isShowHud: false, Search: self.searchString, Page: currentPage)
        }
    }
}

extension FollowRequestsViewController {
    func callFollowingsRequests(isShowHud: Bool,Search : String, Page : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["page" : Page ,
                         "Search" : Search
                        ]
            APIManager().apiCall(of:FollowRequestsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOW_REQUEST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            if self.currentPage == "1" {
                                self.followRequest.removeAll()
                            }
                            
                            if let hasMorePages = data.hasMorePages {
                                self.hasMorePages = hasMorePages
                            }
                            
                            if let post = data.followRequests {
                                for temp in post {
                                    self.followRequest.append(temp)
                                }
                            }
                        }
                    }
                    if self.followRequest.count == 0 {
                        self.lblNoData.isHidden = false
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    self.tblFollowRequsts.reloadData()
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
    
    func callFollowRequstAcceptOrReject(followRequestId : String,status: String, index : Int) {
        if appDelegate.reachable.connection != .none {
            let param = ["follow_request_id" : followRequestId,
                         "status":status
                        ]
            APIManager().apiCall(of:FollowingsFollowearsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.USER_FOLLOW_REQUESTS_STATUS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.followRequest.remove(at: index)
                    if self.followRequest.count == 0 {
                        self.lblNoData.isHidden = false
                    }
                    else {
                        self.lblNoData.isHidden = true
                    }
                    self.tblFollowRequsts.reloadData()
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
