//
//  StoreProfileViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 04/09/24.
//

import Foundation
import UIKit

class StoreProfileViewModel{
    
    var view : StoreProfileVC?
    var tabId : String?
    var sort_by : String?
    var sort_value : String?
    var currentPage = 1
    var posts = [Posts]()
    var userID : String?
    
    var otherUserDetailsData : UserDetailsModel?
    
    func callGetOtherUserDetails(userId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["user_id":  userId ]
            
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                            self.view?.lblUserName.text = data.username ?? ""
                            self.callGetOtherUserpost(userId: userId, tabId: self.tabId ?? "")
                            self.view?.tableView.reloadData()
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
    
    func callPostFavourite(action_type : String,postId : String,index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.posts[index].is_favourite = true
                    }
                    else {
                        self.posts[index].is_favourite = false
                    }
                    self.view?.tableView.reloadData()
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self.view ?? UIViewController())
        }
    }
    
    func callFollow(userId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                        }
                        
                        self.view?.tableView.reloadData()
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
    
    func callUnFollow(userId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id" : userId]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.UNFOLLOW_USER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.otherUserDetailsData = data
                        }
                        
                        self.view?.tableView.reloadData()
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
    
    
    func callGetOtherUserpost(userId : String,tabId : String) {
        if appDelegate.reachable.connection != .none {
            
//            let param = ["user_id":  userId,
//                         "tab" : self.view?.isSellling == true ? 1 : 2 ,
//                         "sort_by" : sort_by,
//                         "sort_value" : sort_value,
//                         "page" : "\(self.currentPage)" ] as [String : Any]
            var param = FilterSingleton.share.filter.toDictionary()
            param?.removeValue(forKey: "is_only_count")
            param?.removeValue(forKey: "sort_by")
            param?.removeValue(forKey: "sort_value")
            param?.removeValue(forKey: "notification_item_counter")
            param?["page"] = "\(self.currentPage)"
            param?["user_id"] = userId
            param?["tab"] = tabId
            param?.removeValue(forKey: "slectedCategories")
            
            APIManager().apiCall(of:HomeListDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.USER_POSTS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1{
                                self.posts = data.posts ?? []
                            }else{
                                self.posts += data.posts ?? []
                            }
                            
                            //MARK: only for now
                            if self.tabId == "2"{
                                self.posts.removeAll()
                            }
                            self.view?.tableView.reloadData()
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
