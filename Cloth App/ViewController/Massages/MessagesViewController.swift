//
//  MessagesViewController.swift
//  ClothApp
//
//  Created by Apple on 13/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AVFoundation
import UniformTypeIdentifiers
import YPImagePicker
import IBAnimatable

protocol MessageTimeDeleget {
    func messageTime(Date: String,indepath:IndexPath)
}

class MessagesViewController: BaseViewController {
    
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var sendMsgContainer: NSLayoutConstraint!
    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductModealAndTitle: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var tblMessages: UITableView!
    @IBOutlet weak var btnCemara: UIButton!
    @IBOutlet weak var txtMessges: CustomTextView!
    @IBOutlet weak var btnSend: UIButton!
    
    var messagetimeDeleget : MessageTimeDeleget!
    var currentPage = "1"
    var hasMorePages = false
    var selectedImage: UIImage!
    var receiverId = ""
    var postId = ""
    var fromPushNotification:Bool = false
    var senderuserId = ""
    var messageDetails : MessageDetailsModel?
    var messegaList = [Messages]()
    var seller = 0
    
    var isBuySelected = false
    
    var lastScrolledRow = 0
    var scrollToRow = 0
    let placeholder = "Say something…"
    var indepath :IndexPath!
    var isVideoTrue : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.txtMessges.delegate = self
        self.txtMessges.text = placeholder
        self.txtMessges.textColor = UIColor.lightGray
        self.txtMessges.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10 )
        self.callMessgeDetails(isShowHud: true, isScrollToBottom: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    
    private func updateUIForKeyboard(height: CGFloat) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.sendMsgContainer.constant = height
//            self.tblMessages.contentInset.bottom = height
//            if #available(iOS 13.0, *) {
//                self.tblMessages.verticalScrollIndicatorInsets.bottom = height
//            } else {
//                self.tblMessages.scrollIndicatorInsets.bottom = height
//            }
            self.view.layoutIfNeeded()
        }
        scrollToBottom(animated: true)
    }
    
    // MARK: - Scrolling Functions
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.messegaList.count > 0 else { return }
            let indexPath = IndexPath(row: self.messegaList.count - 1, section: 0)
            self.tblMessages.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            self.lastScrolledRow = self.messegaList.count - 1
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            updateUIForKeyboard(height: keyboardHeight)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        updateUIForKeyboard(height: 0)
    }
    
    @IBAction func onBtnBack_Clicked(_ sender: UIButton) {
        if fromPushNotification == false{
            self.view.endEditing(true)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.navigateToHomeScreen()
        }
    }
    
    @IBAction func btnPost_Clicked(_ button: Any) {
        
        if self.messageDetails?.post_user_id == appDelegate.userDetails?.id {
            let viewController = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            viewController.postId = String(self.postId)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            let viewController = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            viewController.postId = self.postId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    @IBAction func btnUserProfile_Clicked(_ button: Any) {
        
        if self.receiverId == "\(appDelegate.userDetails?.id ?? 0)" {
            self.navigateToHomeScreen(selIndex: 4)
        }else{
            if self.seller == 1 {
                let viewController = self.storyBoard.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                viewController.userId = receiverId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else if self.seller == 2{
                let viewController = self.storyBoard.instantiateViewController(withIdentifier: "StoreProfileViewController") as! StoreProfileViewController
                viewController.userId = receiverId
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
            else {
                let viewController = self.storyBoard.instantiateViewController(withIdentifier: "BrandProfileViewController") as! BrandProfileViewController
                viewController.userId = receiverId
                self.navigationController?.pushViewController(viewController, animated: true)
                
            }
        }
    }
    
    
    @IBAction func btnCemara_Clicked(_ button: Any) {
        self.showActionSheet()
    }
    
    @IBAction func btnSend_Clicked(_ button: Any) {
        self.selectedImage = nil
        self.isVideoTrue = false
        if self.txtMessges.text.trim().count == 0 {
            
        }
        else if self.txtMessges.textColor == UIColor.lightGray{
            print("enater message")
        }
        else {
            self.callMessgeSend()
        }
    }
    
    func scrollToBottom(animate: Bool, row: Int, scrollPosition: UITableView.ScrollPosition) {
        DispatchQueue.main.async {
            if self.messegaList.count > 0 {
                let indexPath = IndexPath(row: row, section: 0)
                self.tblMessages.scrollToRow(at: indexPath, at: scrollPosition, animated: animate)
            }
        }
    }
    
    func scrollToBottom() {
        if self.messegaList.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.messegaList.count - 1, section: 0)
                self.tblMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.lastScrolledRow = self.messegaList.count - 1
            }
        }
    }
    
    func showActionSheet() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1
        config.library.mediaType = .photoAndVideo
        config.wordings.libraryTitle = "Gallery"
        config.wordings.cameraTitle = "Camera"
        config.targetImageSize = YPImageSize.original
        config.showsVideoTrimmer = true
        config.showsPhotoFilters = false
        config.startOnScreen = YPPickerScreen.library
        config.video.compression = AVAssetExportPresetHighestQuality
        config.video.fileType = .mov
        config.video.recordingTimeLimit = 30.0
        config.video.libraryTimeLimit = 300.0
        config.video.minimumTimeLimit = 3.0
        config.video.trimmerMaxDuration = 30.0
        config.video.trimmerMinDuration = 3.0
        
        config.screens = [.library, .photo]
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    print(photo)
                    self.isVideoTrue = false
                    self.selectedImage = photo.originalImage
                    self.callMessgeSend()
                case .video(let video):
                    print(video)
                    if let video = items.singleVideo {
                        print(video.fromCamera)
                        print(video.thumbnail)
                        print(video.url)
                        self.isVideoTrue = true
                        self.selectedImage = video.thumbnail
                        self.callMessgeSend(video: self.dataFromURL(urlString: video.url.absoluteString), thumnail: video.thumbnail)
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        //        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        //        actionSheet.setAlertButtonColor()
        //        actionSheet.addAction(UIAlertAction(title: "Using Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
        //            self.camera()
        //        }))
        //        actionSheet.addAction(UIAlertAction(title: "Choose Existing Photo", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
        //            self.photoLibrary()
        //        }))
        //
        //        actionSheet.addAction(UIAlertAction(title: "Choose Existing Video", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
        //            self.video()
        //        }))
        //        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        //        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func video() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        if #available(iOS 14.0, *) {
            myPickerController.mediaTypes = [UTType.movie.identifier]
        } else {
            // Fallback on earlier versions
        }
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = false
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self //as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = false
        myPickerController.modalPresentationStyle = .overCurrentContext
        myPickerController.addStatusBarBackgroundView()
        myPickerController.view.tintColor = UIColor().alertButtonColor
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func setProductData() {
        let object = self.messageDetails
        
        let urlString = object?.getHeaderDeatils()?.user_profile_picture?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.imgUser.setImageFast(with: urlString)
        
        if let userName = object?.getHeaderDeatils()?.username {
            self.lblUserName.text = userName.capitalized
        }
        
        
        if let imageStr = object?.post_image?.first?.image,
           let encodedStr = imageStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            self.imgProduct.setImageFast(with: encodedStr)
        } else {
            print("Image string is nil or invalid.")
            // Optionally, set a placeholder image
            self.imgProduct.image = PlaceHolderImage
        }

        
        if let brandName = object?.post_brand {
            self.lblBrandName.text = brandName
        }
        if let title = object?.post_name {
            self.lblProductModealAndTitle.text = title
        }
        if let price = object?.post_price {
            self.lblPrice.text = "\(price)"
        }
        if let producttype = object?.price_type{
            if producttype == "1"{
                if let price = object?.post_price {
                    self.lblPrice.text = " . $\(price)"
                }
            }else{
                if let pricetypename = object?.price_type_name {
                    self.lblPrice.text = pricetypename
                }
            }
        }
        if let size = object?.post_size , size.count > 0 {
            self.lblProductSize.text = "\(size.first ?? "")"
        }
        else {
            self.lblProductSize.text = ""
        }
    }
}

extension MessagesViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messegaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objcet = self.messegaList[indexPath.row]
        if appDelegate.userDetails?.id == objcet.sender_user_id {
            if objcet.message != "" {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OwnerCell", for: indexPath) as! OwnerCell
//                if let message = objcet.message{
//                    cell.lblMessage.text = message
//                }
                
                cell.configureCell(with: objcet.message ?? "")
                if let strDate = objcet.created_at{
                    let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                    print("\(date) : - \(Date().offset(from: date))")
                    cell.lblDateTime.text  = Date().offset(from: date) //"Monday,10:30"//self.time[indexPath.row]
                }
                return cell
            } else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OwnerImageCell", for: indexPath) as! OwnerImageCell
                
                if let strDate = objcet.created_at{
                    let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                    cell.lblDateTime.text  = Date().offset(from: date) //"Monday,10:30"//self.time[indexPath.row]
                }
                
                if objcet.type?.lowercased() == "image"{
                    cell.imgPlay.isHidden = true
                    let urlString = objcet.file?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgOwnerImage.setImageFast(with: urlString)
                }else{
                    cell.imgPlay.isHidden = false
                    let urlString = objcet.thumbnail?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgOwnerImage.setImageFast(with: urlString)
                }
                
                return cell
            }
        }
        else {
            if objcet.message != ""{
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OpponentCell", for: indexPath) as! OpponentCell
                if let message = objcet.message{
                    cell.lblMessage.text = message
                }
                if let strDate = objcet.created_at{
                    let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                    cell.lblDateTime.text  = Date().offset(from: date) //"Monday,10:30"//self.time[indexPath.row]
                }
                //                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05, execute: {
                //                    cell.bgView.roundCorners([.topRight,.bottomLeft,.bottomRight], radius: 10)
                //                })
                return cell
            }
            else {
                let cell =  tableView.dequeueReusableCell(withIdentifier: "OpponentImageCell", for: indexPath) as! OpponentImageCell
                if let strDate = objcet.created_at{
                    let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                    cell.lblDateTime.text  = Date().offset(from: date) //"Monday,10:30"//self.time[indexPath.row]
                }
                if objcet.type?.lowercased() == "image"{
                    cell.imgPlay.isHidden = true
                    let urlString = objcet.file?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgOwnerImage.setImageFast(with: urlString)
                }else{
                    cell.imgPlay.isHidden = false
                    let urlString = objcet.thumbnail?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgOwnerImage.setImageFast(with: urlString)

                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objcet = self.messegaList[indexPath.row]
        if objcet.message == "" {
            if objcet.type?.lowercased() == "image"{
                let viewController = self.storyboard?.instantiateViewController(identifier: "PhotoViewController") as! PhotoViewController
                viewController.imageUrl = objcet.file ?? ""
                self.present(viewController, animated: true, completion: nil)
            }else{
                if let url = URL(string: objcet.file ?? ""){
                    self.playVideo(url: url)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.messegaList .count - 1 && hasMorePages == true {
            currentPage = String(Int(currentPage) ?? 0 + 1)
            self.callMessgeDetails(isShowHud: false, isScrollToBottom: false)
        }
    }
}

class OwnerCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblMessage: UITextView!
    @IBOutlet weak var lblDateTime: UILabel!
    
    func configureCell(with message: String) {
        // Check if the message contains a link
        if let url = extractURL(from: message) {
            // If a URL is found, make the link clickable
            let fullMessage = message
            let attributedText = NSMutableAttributedString(string: fullMessage)
            
            // Apply attributes for the entire message
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: fullMessage.count))
            
            // Apply hyperlink attributes to the URL
            let linkRange = (fullMessage as NSString).range(of: url.absoluteString)
            attributedText.addAttribute(.link, value: url, range: linkRange)
            attributedText.addAttributes([.underlineStyle: NSUnderlineStyle.single.rawValue], range: linkRange)
            
            // Set the text to the UITextView
            lblMessage.attributedText = attributedText
            
            // Enable link detection
            lblMessage.isUserInteractionEnabled = true
            lblMessage.linkTextAttributes = [.foregroundColor: UIColor.white, .underlineStyle: NSUnderlineStyle.single.rawValue]
            lblMessage.isEditable = false
            lblMessage.isSelectable = true
        } else {
            // If no link is found, use the normal message
            let fullMessage = message
            let attributedText = NSMutableAttributedString(string: fullMessage)
            
            // Apply default styling
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: UIColor.white
            ]
            attributedText.addAttributes(attributes, range: NSRange(location: 0, length: fullMessage.count))
            
            // Set the text to the UITextView
            lblMessage.attributedText = attributedText
            
            lblMessage.isUserInteractionEnabled = false
            lblMessage.isEditable = false
            lblMessage.isSelectable = false
        }
    }
      
      // Function to extract URL from the message
      func extractURL(from message: String) -> URL? {
          // Regular expression to detect URLs
          let types: NSTextCheckingResult.CheckingType = .link
          let detector = try? NSDataDetector(types: types.rawValue)
          let matches = detector?.matches(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count))
          
          // Return the first match if it's a valid URL
          return matches?.first?.url
      }
}

class OwnerImageCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgPlay: AnimatableImageView!
    @IBOutlet weak var imgOwnerImage: CustomImageView!
    @IBOutlet weak var lblDateTime: UILabel!
}

class OpponentCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblMessage: UITextView!
    @IBOutlet weak var lblDateTime: UILabel!
}

class OpponentImageCell: UITableViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imgPlay: AnimatableImageView!
    
    @IBOutlet weak var imgOwnerImage: CustomImageView!
    @IBOutlet weak var lblDateTime: UILabel!
}

extension MessagesViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = .black
            textView.text = ""
            
            //            if self.messegaList.count < 6{
            //                self.updateTableContentInset()
            //            }
//            scrollToBottomNew()
            
        }
    }
    
    
//    func scrollToBottomNew() {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            let numberOfSections = self.tblMessages.numberOfSections
//            guard numberOfSections > 0 else { return }
//            
//            let lastSection = numberOfSections - 1
//            let lastRow = self.tblMessages.numberOfRows(inSection: lastSection) - 1
//            
//            guard lastRow >= 0 else { return }
//            
//            let indexPath = IndexPath(row: lastRow, section: lastSection)
//            self.tblMessages.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .lightGray
            textView.text = placeholder
            if self.messegaList.count < 6{
                self.endeditingupdateTableContentInset()
            }
        }
        else {
        }
    }
    
    func updateTableContentInset() {
        let numRows = self.tblMessages.numberOfRows(inSection: 0)
        var contentInsetTop = self.tblMessages.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tblMessages.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tblMessages.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
    }
    
    func endeditingupdateTableContentInset() {
        
        self.tblMessages.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
}
extension MessagesViewController {
    
    func dataFromURL(urlString: String) -> Data? {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print("Error converting URL to data: \(error)")
            return nil
        }
    }
    func callMessgeSend(video:Data? = nil,thumnail:UIImage? = nil) {
        if appDelegate.reachable.connection != .none {
            var param = [String:Any]()
            param["post_id"] = self.postId
            if self.selectedImage != nil {
                param["message"] = ""
            }
            else {
                param["message"] = self.txtMessges.text ?? ""
            }
            param["receiver_id"] = "\(appDelegate.userDetails?.id ?? 0)" == self.receiverId ? self.senderuserId : self.receiverId
            //            param["sender_user_id"] = "\(appDelegate.userDetails?.id ?? 0)"
            
            if selectedImage != nil {
                if self.isVideoTrue == true{
                    APIManager().apiCallWithImageAndVideo(of: Messages.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MESSAGE_SEND.rawValue, parameters: param, images: thumnail ?? UIImage(), videoData: video ?? Data(), imageParameterName: "file", imageName: "sendImage.png"){  (response, error) in
                        if error == nil {
                            if let data = response?.dictData {
                                if let DateString = data.created_at{
                                    if self.messagetimeDeleget != nil{
                                        self.messagetimeDeleget.messageTime(Date: DateString, indepath: self.indepath)
                                    }
                                }
                            }
                            self.selectedImage = nil
                            self.txtMessges.text = ""
                            self.callMessgeDetails(isShowHud: false, isScrollToBottom: true)
                            
                        }
                        else {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                        }
                    }
                }else{
                    APIManager().apiCallWithImage(of: Messages.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MESSAGE_SEND.rawValue, parameters: param, images: [self.selectedImage], imageParameterName: "file", imageName: "sendImage.png"){  (response, error) in
                        if error == nil {
                            if let data = response?.dictData {
                                if let DateString = data.created_at{
                                    if self.messagetimeDeleget != nil{
                                        self.messagetimeDeleget.messageTime(Date: DateString, indepath: self.indepath)
                                    }
                                }
                            }
                            self.selectedImage = nil
                            self.txtMessges.text = ""
                            self.callMessgeDetails(isShowHud: false, isScrollToBottom: true)
                            
                        }
                        else {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                        }
                    }
                }
            }
            else {
                APIManager().apiCallWithMultipart(of: Messages.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MESSAGE_SEND.rawValue, parameters: param) { (response, error) in
                    if error == nil {
                        if let data = response?.dictData {
                            if let DateString = data.created_at{
                                if self.messagetimeDeleget != nil{
                                    self.messagetimeDeleget.messageTime(Date: DateString, indepath: self.indepath)
                                }
                            }
                        }
                        self.txtMessges.text = ""
                        self.callMessgeDetails(isShowHud: false, isScrollToBottom: true)
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                    }
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
    func callGetOtherUserDetails(userId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["user_id":  userId ]
            
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.lblRate.text = "\(data.avg_rating ?? 0.0) (\(data   .total_reviews ?? 0) Reviews)"
                            if let roleid = data.role_id {
                                self.seller = roleid
                            }
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
    func callMessgeDetails(isShowHud : Bool, isScrollToBottom : Bool) {
        if appDelegate.reachable.connection != .none {
            let param = ["post_id": self.postId,"sender_user_id":self.senderuserId]
            APIManager().apiCallWithMultipart(of: MessageDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.MESSAGE_DETAILS.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let data = response?.dictData {
                        self.messageDetails = data
                        
                        if self.currentPage == "1" {
                            self.messegaList.removeAll()
                        }
                        
                        if let hasMorePages = data.hasMorePages{
                            self.hasMorePages = hasMorePages
                        }
                        
                        if let messageList = self.messageDetails?.messages {
                            for temp in messageList {
                                self.messegaList.insert(temp, at: 0)
                            }
                        }
//                        self.messegaList.reverse()
                        self.receiverId = String(self.messageDetails?.receiver_id ?? 0)
                        self.scrollToBottom()
                        self.callGetOtherUserDetails(userId: self.receiverId)
                    }
                    self.setProductData()
                    self.tblMessages.reloadData()
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

extension MessagesViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImage = image
            self.callMessgeSend()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension MessagesViewController{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check if the return key was pressed
        if text == "\n" {
            // Dismiss the keyboard by ending editing
            textView.resignFirstResponder()
            // Return false to prevent a new line from being inserted
            return false
        }
        let text = textView.text ?? ""
        if text.count > 150 {
            self.txtMessges.isScrollEnabled = true
        }else{
            self.txtMessges.isScrollEnabled = false
        }
        // Allow other text changes
        return true
    }
    
}

class NetworkManager {
    
    static func fetchData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                completion(data, nil)
            } else {
                completion(nil, NSError(domain: "HTTPError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load data"]))
            }
        }
        
        task.resume()
    }
}
