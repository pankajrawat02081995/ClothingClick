//
//  ChatViewController.swift
//  ClothApp
//
//  Created by Apple on 13/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController {
    
    @IBOutlet weak var btnBuying: UIButton!
    @IBOutlet weak var viewLinebtnBuying: UIView!
    @IBOutlet weak var btnSelling: UIButton!
    @IBOutlet weak var viewLinebtnSelling: UIView!
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtSearch: CustomTextField!
    @IBOutlet weak var lblNodata: UILabel!
    
    var messagesData : MessgasModel?
    var messageList = [Messages]()
    var messageFilterList = [Messages]()
    var currentPage = "1"
    var hasMorePages = false
    var chatType = "1"
    var chatTypeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.btnBuying_Clicked(self)
        self.lblNodata.isHidden = true
        self.txtSearch.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.setupTableView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        debugPrint(textField.text ?? "")
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        self.messageList.removeAll()
        
        if trimmedText.isEmpty {
            self.messageList = self.messageFilterList
        } else {
            self.messageList = self.messageFilterList.filter { $0.username?.lowercased().hasPrefix(trimmedText) == true }
        }

        self.tblChat.reloadData()
    }

    
    func setupTableView(){
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.tblChat.tableFooterView = UIView()
        self.tblChat.register(UINib(nibName: "ChatListXIB", bundle: nil), forCellReuseIdentifier: "ChatListXIB")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isHidden = true
        if chatType == "1"{
            self.btnBuying_Clicked(self.btnBuying)
        }else {
            self.btnSelling_Clicked(self.btnSelling)
        }
    }
    
    @IBAction func btnBuying_Clicked(_ button: UIButton) {
        self.chatTypeName = "buyer"
        self.chatType = "1"
        self.viewLinebtnBuying.backgroundColor = UIColor.init(named: "Black_Theme_Color")
        self.viewLinebtnSelling.backgroundColor = UIColor.init(named: "App_Light_Border_Color")
        self.callMessgeList(isShowHud: true, page: self.currentPage, type: self.chatType)
    }
    
    @IBAction func btnSelling_Clicked(_ button: UIButton) {
        self.chatTypeName = "seller"
        self.viewLinebtnBuying.backgroundColor = UIColor.init(named: "App_Light_Border_Color")
        self.viewLinebtnSelling.backgroundColor = UIColor.init(named: "Black_Theme_Color")
        self.chatType = "2"
        self.callMessgeList(isShowHud: true, page: self.currentPage, type: self.chatType)
    }
}

extension ChatViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let object = self.messageList[indexPath.row]
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBuyAndSellCell", for: indexPath) as! ChatBuyAndSellCell
        //        //        cell.imgReadUnred.isHidden = true
        //                cell.imgReadUnred.isHidden = object.isReadMessge()
        //
        //        if let url = object.post_image?[0].image {
        //            if let image = URL.init(string: url){
        //                cell.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
        //            }
        //        }
        //        if let url = object.user_profile_picture {
        //            if let image = URL.init(string: url){
        //                cell.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
        //            }
        //            else{
        //                cell.imgUser.setImage(ProfileHolderImage!)
        //            }
        //        }
        //        else{
        //            cell.imgUser.setImage(ProfileHolderImage!)
        //        }
        //        if let brandName = object.post_brand {
        //            cell.lblBrandName.text = brandName
        //        }
        //        if let title = object.post_name {
        //            cell.lblProductModealAndTitle.text = title
        //        }
        //        if let size = object.post_size , size.count > 0 {
        //            cell.lblProductSize.text = "\(size.first ?? "")"
        //        }
        //        else {
        //            cell.lblProductSize.text = ""
        //        }
        //        if let userName = object.username {
        //            cell.lblUserName.text = userName
        //        }
        //        if let strDate = object.created_at{
        //            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
        //            print(date)
        //            cell.lblTime.text  = Date().offset(from: date) //"Monday,10:30"//self.time[indexPath.row]
        //        }
        //        if object.file != "" {
        //            cell.lbldescripction.text = "Image"
        //        }
        //        else {
        //            if let message = self.messageList[indexPath.row].message {
        //                cell.lbldescripction.text = message
        //            }
        //
        //
        //        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListXIB", for: indexPath) as! ChatListXIB
        let object = self.messageList[indexPath.row]
        
        if object.isReadMessge(){
            cell.lblMsg.textColor = UIColor.customChatRead
            cell.lblDate.textColor = UIColor.customChatRead
        }else{
            cell.lblMsg.textColor = UIColor.customBlack
            cell.lblDate.textColor = UIColor.customBlack
        }
        
        if !object.isReadMessge(){
            cell.lblName.font = UIFont.RobotoFont(.robotoBold, size: 16)
            cell.lblMsg.font = UIFont.RobotoFont(.robotoBold, size: 14)
            cell.lblDate.font = UIFont.RobotoFont(.robotoBold, size: 12)
        }else{
            cell.lblName.font = UIFont.RobotoFont(.robotoRegular, size: 16)
            cell.lblMsg.font = UIFont.RobotoFont(.robotoRegular, size: 14)
            cell.lblDate.font = UIFont.RobotoFont(.robotoRegular, size: 12)
        }
        
        if appDelegate.userDetails?.id == object.sender_user_id{
            if object.type?.lowercased() == "image"{
                cell.lblMsg.text = object.file?.isEmpty == true ? object.message ?? "" : "you sent an image"
            }else{
                cell.lblMsg.text = object.file?.isEmpty == true ? object.message ?? "" : "you sent a video"
            }
        }else{
            if object.type?.lowercased() == "image"{
                cell.lblMsg.text = object.file?.isEmpty == true ? object.message ?? "" : "\(object.username ?? "") sent an image"
            }else{
                cell.lblMsg.text = object.file?.isEmpty == true ? object.message ?? "" : "\(object.username ?? "") sent a video"
            }
        }
        
        cell.lblName.text = object.username?.capitalized ?? ""
        if let url = URL.init(string: object.post_image?.first?.image ?? ""){
            cell.imgUser.kf.setImage(with: url,placeholder: PlaceHolderImage)
        }else{
            cell.imgUser.image = PlaceHolderImage
        }
        if let strDate = object.created_at{
            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
            print(date)
            cell.lblDate.text  = Date().offset(from: date)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.chatType == "1"{
            let viewController = self.storyboard?.instantiateViewController(identifier: "MessagesViewController") as! MessagesViewController
            viewController.postId = String(self.messageList[indexPath.row].post_id ?? 0)
            //  viewController.seller = self.messageList[indexPath.row].sender_user_id ?? 0
            viewController.senderuserId = String(self.messageList[indexPath.row].post_user_id ?? 0)
            viewController.indepath = indexPath
            viewController.messagetimeDeleget = self
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }else
        {
            let viewController = self.storyboard?.instantiateViewController(identifier: "MessagesViewController") as! MessagesViewController
            viewController.postId = String(self.messageList[indexPath.row].post_id ?? 0)
            //   viewController.seller = self.messageList[indexPath.row].sender_user_id ?? 0
            viewController.senderuserId = String(self.messageList[indexPath.row].sender_user_id ?? 0)
            viewController.indepath = indexPath
            viewController.messagetimeDeleget = self
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath)  {
        if indexPath.item == self.messageList.count - 1 && hasMorePages == true {
            currentPage = String(Int(currentPage) ?? 0 + 1)
            self.callMessgeList(isShowHud: false, page: self.currentPage, type: self.chatType)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let object = self.messageList[indexPath.row]
            let id = object.post_id ?? 0
            let seconduserid = object.sender_user_id ?? 0
            self.DeleteChatAPI(isShowHud: true, Id: "\(id)", Index: indexPath.row,seconduserid:seconduserid)
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ChatViewController: MessageTimeDeleget {
    func messageTime(Date: String, indepath: IndexPath) {
        self.messageList[indepath.row].created_at = Date
        self.tblChat.reloadRows(at: [indepath], with: .automatic)
        if chatType == "1"{
            self.btnBuying_Clicked(self.btnBuying)
        }
        else {
            self.btnSelling_Clicked(self.btnSelling)
        }
    }
}

class ChatBuyAndSellCell : UITableViewCell {
    @IBOutlet weak var imgReadUnred: CustomImageView!
    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductModealAndTitle: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var lbldescripction: UILabel!
    @IBOutlet weak var lblTime: UILabel!
}

extension ChatViewController {
    func DeleteChatAPI(isShowHud: Bool ,Id : String,Index:Int,seconduserid:Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["message_id": Id,
                         "type":self.chatTypeName,
                         "second_user_id":seconduserid] as [String : Any]
            
            APIManager().apiCall(of: MessgasModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MESSAGEDELETE.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.messageList.remove(at: Index)
                    self.tblChat.reloadData()
                }
                else {
                    //  UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    func callMessgeList(isShowHud : Bool,page : String,type : String) {
        let param = ["page" : page,
                     "type":  type
        ]
        self.txtSearch.text = ""
        self.view.endEditing(true)
        if appDelegate.reachable.connection != .none {
            APIManager().apiCallWithMultipart(of: MessgasModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.MESSAGES.rawValue, parameters: param) { (response, error) in
                self.messageList.removeAll()
                self.messageFilterList.removeAll()
                if error == nil {
                    if let data = response?.dictData {
                        self.messagesData = data
                        if let buyCiunt = self.messagesData?.buying_not_read {
                            if buyCiunt > 0{
                                self.btnBuying.titleLabel?.font = UIFont.RobotoFont(.robotoBold, size: 16)
                            }else{
                                self.btnBuying.titleLabel?.font = UIFont.RobotoFont(.robotoRegular, size: 16)
                            }
                        }
                        if let sellingCount = self.messagesData?.selling_not_read {
                            if sellingCount > 0{
                                self.btnSelling.titleLabel?.font = UIFont.RobotoFont(.robotoBold, size: 16)
                            }else{
                                self.btnSelling.titleLabel?.font = UIFont.RobotoFont(.robotoRegular, size: 16)
                            }
                        }
                        if self.currentPage == "1" {
                            self.messageList.removeAll()
                        }
                        
                        if let hasMorePages = data.hasMorePages{
                            self.hasMorePages = hasMorePages
                        }
                        
                        if let messages = self.messagesData?.messages {
                            for temp in messages {
                                self.messageFilterList.append(temp)
                                self.messageList.append(temp)
                            }
                        }
                        if self.messageList.count == 0 {
                            self.lblNodata.isHidden = true
                        }
                        else {
                            self.lblNodata.isHidden = true
                        }
                        
                        self.tblChat.setBackGroundLabel(count: self.messageList.count)
                        
                    }
                    self.tblChat.reloadData()
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
