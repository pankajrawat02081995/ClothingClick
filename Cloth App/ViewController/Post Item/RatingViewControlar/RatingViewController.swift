//
//  RatingViewController.swift
//  ClothApp
//
//  Created by Apple on 19/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import StoreKit

class RatingViewController: BaseViewController {
    @IBOutlet weak var constHeightForrattingview: NSLayoutConstraint!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblTitleUserName: UILabel!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPostCount: UILabel!
    @IBOutlet weak var viewFloatRating: FloatRatingView!
    @IBOutlet weak var lblFloatRatingCount: UILabel!
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var lblBuyerSeller: UILabel!
    @IBOutlet weak var btnDisLike: UIButton!
    @IBOutlet weak var btnLike: UIButton!

    @IBOutlet weak var txtReVview: CustomTextView!
    @IBOutlet weak var btnDone: CustomButton!

    var type = "0"
    var isLickDisLik = "0"
    var userId = ""
    var postId = ""
//    var postDetal : Post?
//    var userList : User_list?
    var fromPushNotification:Bool = false
    var isBuyerSeller = false
    var reviewData : ReviewUserPostDetailsModel?
    let placeholder = "Text review (optional)"
    var typeOfLogin :[String] = ["Buyer","Seller"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewFloatRating.type = .halfRatings
            if self.isBuyerSeller {
                self.lblBuyerSeller.text = "Rate your experience with this buyer"
                self.type = "2"
            }
            else {
                self.lblBuyerSeller.text = "Rate your experience with this seller"
                self.type = "1"
            }
        self.callReviewDetails()
//        self.setUsetAndPostData()
        self.txtReVview.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10 )
        self.txtReVview.text = self.placeholder
        self.txtReVview.textColor = .lightGray
       

    }
    
    func setUsetAndPostData() {
        let object = self.reviewData
        if let url = object?.user?.photo {
            if let image = URL.init(string: url){
                self.imgUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
            }
        }
        if let usertypename = object?.user?.user_type_name {
            if usertypename.lowercased() == "store" || usertypename.lowercased() == "brand"{
                self.viewFloatRating.isHidden = true
                self.lblFloatRatingCount.isHidden = true
                self.constHeightForrattingview.constant = 0
            }
        }
        if let UserName = object?.user?.username {
            self.lblUserName.text = UserName
            self.lblHeaderTitle.text = UserName
            self.lblTitleUserName.text = UserName
        }
        if let address = object?.user?.location{
            self.lblLocation.text = address.city
        }
        if let totalpost = object?.user?.total_posts {
            self.lblPostCount.text = "\(totalpost) post"
        }
        if let totalreviews = object?.user?.total_reviews{
            self.lblFloatRatingCount.text = String(totalreviews)
        }
        if let retingCount = object?.user?.avg_review {
            self.viewFloatRating.rating = Double(retingCount)
        }
        if let url = object?.post?.photo?[0].image {
            if let image = URL.init(string: url){
                self.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
        if let brand = object?.post?.brand_name {
            self.lblBrandName.text = brand
        }
        if let title = object?.post?.name {
            self.lblModel.text = title
        }
        if let pricetype = object?.post?.price_type {
            if pricetype == "1" {
        if let price = object?.post?.price {
            self.lblPrice.text = "$ \(price)"
        }
            }else{
                if let price = object?.post?.price_type_name {
                    self.lblPrice.text = "\(price)".formatPrice()
                }
            }
        }
        if let size = object?.post?.size , size.count > 0 {
            self.lblSize.text = String(size.first ?? "").formatPrice()
        }
    }
    
    @IBAction func btnDisLike_Clicked(_ button: UIButton) {
       
        self.btnDisLike.setImage(UIImage.init(named: "thumbs-Down-Select"), for: .normal)
        self.btnLike.setImage(UIImage.init(named: ""), for: .normal)
        self.isLickDisLik = "0"
        print(self.isLickDisLik)
    }
    
    @IBAction func btnLike_Clicked(_ button: UIButton) {
        
        if appDelegate.userDetails?.total_positive_review ?? 0 >= 3{
            if #available( iOS 10.3,*){
                SKStoreReviewController.requestReview()
            }else{
                self.rateApp()
            }
        }
       // RatingViewController.requestReviewIfAppropriate()
        self.btnLike.setImage(UIImage.init(named: "thumbs-Up-Select"), for: .normal)
        self.btnDisLike.setImage(UIImage.init(named: ""), for: .normal)
        self.isLickDisLik = "5"
        print(self.isLickDisLik)
    }
    
    @IBAction func btnDone_Clicked(_ button: UIButton) {
        self.callAddReview()
    }
    @IBAction func onBtnBack_Clicked(_ sender: Any) {
        if fromPushNotification == false{
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        }else{
            self.navigateToHomeScreen()
        }
    }
 }

extension RatingViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = .black
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .lightGray
            textView.text = placeholder
        }
        else {
        }
    }
}

extension RatingViewController{
    func callAddReview() {
        
        if self.txtReVview.text == placeholder{
            self.txtReVview.text = ""
        }
        
        if appDelegate.reachable.connection != .none {
            let param = ["user_id":  self.userId,
                         "post_id" : self.postId,
                         "rating" : self.isLickDisLik,
                         "review" : self.txtReVview.text ?? "",
                         "type" : self.type
            ]
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.ADD_REVIEW.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let mesage = response?.message {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: mesage, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        let yesAction: UIAlertAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                            self.navigateToHomeScreen(selIndex: 4)
                        })
//                        let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
//                        })
//
                        alert.addAction(yesAction)
                        
                        self.present(alert, animated: true, completion: nil)
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
    
    func callReviewDetails() {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id":  self.userId,
                         "post_id" : self.postId
            ]
            APIManager().apiCall(of:ReviewUserPostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.REVIEW_USER_POST_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let data = response?.dictData {
                        self.reviewData = data
                        self.setUsetAndPostData()
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
