//
//  NewRatingViewController.swift
//  Cloth App
//
//  Created by Radhika Anand on 07/01/25.
//

import UIKit
import IBAnimatable
import Cosmos

class NewRatingViewController: BaseViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var btnDone: CustomButton!
    @IBOutlet weak var vwReviews: UIView!
    @IBOutlet weak var viewFloatRating: CosmosView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblExpTitle: UILabel!
    @IBOutlet weak var imgVwUser: AnimatableImageView!
    @IBOutlet weak var collVwRating: UICollectionView!
    @IBOutlet weak var txtVwDescription: CustomTextView!
    
    //MARK: - Variables
    var selectedIndex = -1
    var arrReviews = ["Quick payment", "Communication", "Punctuality", "On-Time Meet Up"]
    var type = "0"
    var isLickDisLik = "0"
    var userId = ""
    var postId = ""
    var fromPushNotification:Bool = false
    var isBuyerSeller = false
    var reviewData : ReviewUserPostDetailsModel?
    let placeholder = "Text review (optional)"
    var typeOfLogin :[String] = ["Buyer","Seller"]
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFloatRating.settings.starMargin = 5
        viewFloatRating.settings.fillMode = .full
        
//        viewFloatRating.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            // Center horizontally in its superview
//            viewFloatRating.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            // Center vertically in its superview (adjust if needed)
//            viewFloatRating.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            
//            // Optionally set a fixed width and height for the CosmosView
//            viewFloatRating.widthAnchor.constraint(equalToConstant: 200),
//            viewFloatRating.heightAnchor.constraint(equalToConstant: 40)
//        ])
        
        let urlString = reviewData?.user?.photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.imgVwUser.setImageFast(with: urlString)
        
        lblUserName.text = reviewData?.user?.name
            if self.isBuyerSeller {
                self.lblExpTitle.text = "Rate your experience with this buyer"
                self.type = "2"
            }
            else {
                self.lblExpTitle.text = "How was your experience with \(reviewData?.user?.name ?? "")"
                self.type = "1"
            }
        self.callReviewDetails()
        self.txtVwDescription.text = self.placeholder
        self.txtVwDescription.textColor = .lightGray
        viewFloatRating.didTouchCosmos = { rating in
            if rating > 0 {
                self.vwReviews.isHidden = false
                self.btnDone.isUserInteractionEnabled = true
                self.btnDone.backgroundColor = .customBlack
            } else {
                self.vwReviews.isHidden = true
                self.btnDone.isUserInteractionEnabled = false
                self.btnDone.backgroundColor = .customButton_bg_gray
            }
        }
    }
    
    //MARK: - @IBActions
    @IBAction func actionDone(_ sender: Any) {
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
    
    func setUsetAndPostData() {
        let object = self.reviewData
        if let url = object?.user?.photo {
            if let image = URL.init(string: url){
                self.imgVwUser.kf.setImage(with: image,placeholder: ProfileHolderImage)
            }
        }
        if let usertypename = object?.user?.user_type_name {
            if usertypename.lowercased() == "store" || usertypename.lowercased() == "brand"{
//                self.viewFloatRating.isHidden = true
//                self.constHeightForrattingview.constant = 0
            }
        }
        if let UserName = object?.user?.username {
            self.lblUserName.text = UserName
        }
//        if let address = object?.user?.location{
//            self.lblLocation.text = address.city
//        }
//        if let totalpost = object?.user?.total_posts {
//            self.lblPostCount.text = "\(totalpost) post"
//        }
//        if let totalreviews = object?.user?.total_reviews{
//            self.lblFloatRatingCount.text = String(totalreviews)
//        }
        if let retingCount = object?.user?.avg_review {
            self.viewFloatRating.rating = Double(retingCount)
        }
        if let url = object?.post?.photo?[0].image {
            if let image = URL.init(string: url){
                //self.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
//        if let brand = object?.post?.brand_name {
//            self.lblBrandName.text = brand
//        }
//        if let title = object?.post?.name {
//            self.lblModel.text = title
//        }
//        if let pricetype = object?.post?.price_type {
//            if pricetype == "1" {
//        if let price = object?.post?.price {
//            self.lblPrice.text = "$ \(price)"
//        }
//            }else{
//                if let price = object?.post?.price_type_name {
//                    self.lblPrice.text = "\(price)".formatPrice()
//                }
//            }
//        }
//        if let size = object?.post?.size , size.count > 0 {
//            self.lblSize.text = String(size.first ?? "").formatPrice()
//        }
    }
}

extension NewRatingViewController: UITextViewDelegate {
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

extension NewRatingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func ratingDidChange(rating: Float) {
        vwReviews.isHidden = false
        btnDone.isUserInteractionEnabled = true
        btnDone.backgroundColor = .customBlack
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrReviews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewRatingCVC", for: indexPath) as? NewRatingCVC else {
            return UICollectionViewCell()
        }
        cell.lblTitle.text = arrReviews[indexPath.row]
        cell.lblTitle.textColor = selectedIndex != indexPath.row ? .customBlack : .white
        cell.vwBackground.backgroundColor = selectedIndex == indexPath.row ? .customBlack : .clear
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collVwRating.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: CGRect.zero)
        label.text = arrReviews[indexPath.item]
        label.sizeToFit()
        return CGSize(width: label.frame.width+10, height: 40)
    }
}

extension NewRatingViewController {
    func callAddReview() {
        
        if self.txtVwDescription.text == placeholder{
            self.txtVwDescription.text = ""
        }
        
        if appDelegate.reachable.connection != .none {
            let param = ["user_id":  self.userId,
                         "post_id" : self.postId,
                         "rating" : self.isLickDisLik,
                         "review" : self.txtVwDescription.text ?? "",
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
