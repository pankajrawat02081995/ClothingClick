//
//  PromoteViewController.swift
//  ClothApp
//
//  Created by Apple on 16/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class PromoteViewController: BaseViewController {
    
    @IBOutlet weak var lblCoinCount: UILabel!
    @IBOutlet weak var btnCoin: UIButton!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnPriductDetails: UIButton!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProduceType: UILabel!
    @IBOutlet weak var lblPrise: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var tblPromotelist: UITableView!
    @IBOutlet weak var constHeightForTblPromotelist: NSLayoutConstraint!
    @IBOutlet weak var btnByCoin: UIButton!
    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var viewPromoteDetail: UIView!
    @IBOutlet weak var btnvPromoteviewHide: UIButton!
    @IBOutlet weak var imgSembol: CustomImageView!
    @IBOutlet weak var lblSembol: UILabel!
    @IBOutlet weak var lblPromotTitle: UILabel!
    @IBOutlet weak var imgDetailPromote: UIImageView!
    @IBOutlet weak var txtPromoteDetails: UITextView!
    @IBOutlet weak var btnPromote: UIButton!
    @IBOutlet weak var btnSaleSElect: CustomButton!
    @IBOutlet weak var lblCurrentprice: UILabel!
    @IBOutlet weak var txtSaleprice: CustomTextField!
    @IBOutlet weak var viewSale: UIView!
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    var selectPromote: Coins?
    var postDetail : PostDetailsModel?
    var postId = ""
    var getPromotData : PromoteModel?
    var isGotoHome = false
    var edit = false
    var sendproductImage = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblCoinCount.text = String(appDelegate.userDetails?.coins ?? 0)
        setUserData()
        self.callGetPromoteList()
        self.viewPromoteDetail.isHidden = true
        self.viewSale.isHidden = true
       // self.lblPhoneNo.text = "Phone : \(appDelegate.userDetails?.phone ?? "")"
        if isGotoHome {
            self.btnBack.image = #imageLiteral(resourceName: "ic_blackclose")
        }
        else {
            self.btnBack.image = #imageLiteral(resourceName: "back_ic")
        }
    }
    
    func setUserData () {
        let urlString = postDetail?.images?.first?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.imgProduct.setImageFast(with: urlString)
        
        if let brandeName = self.postDetail?.brand_name {
            self.lblBrandName.text = brandeName
        }
        if let title = self.postDetail?.title {
            self.lblProduceType.text = title
        }
        if let pricetype = self.postDetail?.price_type {
            if pricetype == "1"{
                if let saletype = self.postDetail?.is_sale {
                    if saletype == 1 {
                        if let price = self.postDetail?.sale_price {
                            self.lblPrise.text = "$ \(price)"
                            self.lblCurrentprice.text = "\(price)".formatPrice()
                        }
                    }
                    else{
                        if let price = self.postDetail?.price{
                            self.lblPrise.text = "$ \(price.formatPrice())"
                            self.lblCurrentprice.text = "\(price.formatPrice())"
                        }
                    }
                }
                else{
        if let price = self.postDetail?.price{
            self.lblPrise.text = "$ \(price.formatPrice())"
            self.lblCurrentprice.text = "\(price)".formatPrice()
        }
                }
            }else{
                if let price = self.postDetail?.price_type_name{
                    self.lblPrise.text = String(price)
                   // self.lblCurrentprice.text = String(price)
                }
            }
        }
        if let size = self.postDetail?.sizes {
            if size.count != 0 {
                self.lblSize.text = size[0].name
            }
        }
    }
    
    @IBAction func btnBack_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        if isGotoHome {
            if self.viewPromoteDetail.isHidden == false{
                self.selectPromote = nil
                self.viewPromoteDetail.isHidden = true
                self.tblPromotelist.reloadData()
            }else{
           // navigateToHomeScreen()
                let viewController = self.storyboard?.instantiateViewController(identifier: "CongratulationsViewController") as! CongratulationsViewController
                viewController.sendproductImage = self.sendproductImage
                    self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        else {
            if self.viewPromoteDetail.isHidden == false{
                self.selectPromote = nil
                self.viewPromoteDetail.isHidden = true
                self.tblPromotelist.reloadData()
            }else{
            self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnvPromoteviewHide_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        if self.selectPromote?.title == "Sale" {
            self.viewPromoteDetail.isHidden = false
            self.viewSale.isHidden = false
        }
        else {
            self.viewPromoteDetail.isHidden = true
        }
    }
    @IBAction func btnPriductDetails_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        if self.postDetail?.user_id == appDelegate.userDetails?.id {
            let viewController = self.storyboard?.instantiateViewController(identifier: "AdPlacementViewController") as! AdPlacementViewController
            if let id = self.postDetail?.id{
                viewController.postId = String(id)
            }
            self.navigationController?.pushViewController(viewController, animated: true)
        }else{
       
//        let ViewController = storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        ViewController.postId = String(self.postDetail?.id ?? 0)
//        self.navigationController?.pushViewController(ViewController, animated: true)
            let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            vc.postId = String(self.postDetail?.id ?? 0)
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc: vc)
        }
    }
    
    @IBAction func btnSaleSElect_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        if self.txtSaleprice.text?.trim().count  == 0 {
            
        }
        self.viewSale.isHidden = true
        self.viewPromoteDetail.isHidden = true
    }
    
    @IBAction func btnByCoin_Clicked(_ sender: Any) {
        self.view.endEditing(true)
        let ViewController = storyboard?.instantiateViewController(identifier: "ClickCoinsViewController") as! ClickCoinsViewController
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    @IBAction func btnNext_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        if (appDelegate.userDetails?.coins ?? 0) < (self.selectPromote?.coins ?? 0) {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "You dont have sufficient coins, please purchase coin to continue.", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Buy Now", style: .default, handler: { (action) in
                self.btnByCoin_Clicked(self)
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        else if self.selectPromote == nil {
            navigateToHomeScreen()
        }
        else {
            if self.selectPromote?.title  == "Sale" {
                if self.txtSaleprice.text?.trim().count == 0 {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter saleprice")
                    self.viewSale.isHidden = false
                }
                else if Float(self.txtSaleprice.text!) ?? 0 <= 0 {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter valid sale price")
                    self.viewSale.isHidden = false
                }
                else {
                    self.callAddPromotePost(postId: String(self.postDetail?.id ?? 0), type: String(self.selectPromote?.id ?? 0))
                }
            }
            else {
                self.callAddPromotePost(postId: String(self.postDetail?.id ?? 0), type: String(self.selectPromote?.id ?? 0))
            }
        }
    }
    
    @objc func btnInfo_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblPromotelist)
        if let indexPath = self.tblPromotelist.indexPathForRow(at: buttonPosition) {
            let objet = self.getPromotData?.convertToCoins(is_toppick: self.postDetail?.is_toppick, is_bump: self.postDetail?.is_bump, is_hightlight: self.postDetail?.is_hightlight, is_sale: self.postDetail?.is_sale, is_profile_promote: postDetail?.is_profile_promote)[indexPath.row]
            self.selectPromote = objet!
            self.viewSale.isHidden = true
            self.viewPromoteDetail.isHidden = false
            self.imgSembol.image = UIImage.init(named: objet?.sembolIcon ?? "")
            let urlString = objet?.promotImge?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            self.imgDetailPromote.setImageFast(with: urlString)

            self.txtPromoteDetails.text = objet?.description
            self.lblPromotTitle.text = objet?.title
            self.btnPromote.setTitle("Select \(objet?.title ?? "")", for: .normal)
        }
    }
}

extension PromoteViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getPromotData?.convertToCoins(is_toppick: self.postDetail?.is_toppick, is_bump: self.postDetail?.is_bump, is_hightlight: self.postDetail?.is_hightlight, is_sale: self.postDetail?.is_sale, is_profile_promote: postDetail?.is_profile_promote).count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromoteCell", for: indexPath) as! PromoteCell
        let objet = self.getPromotData?.convertToCoins(is_toppick: self.postDetail?.is_toppick, is_bump: self.postDetail?.is_bump, is_hightlight: self.postDetail?.is_hightlight, is_sale: self.postDetail?.is_sale, is_profile_promote: postDetail?.is_profile_promote)[indexPath.row]
        
        if self.selectPromote?.title == objet?.title {
            cell.imgSelect.borderWidth = 0
            cell.imgSelect.borderColor = .darkGray
            cell.imgSelect.backgroundColor = UIColor.init(named: "BlueColor")
            cell.imgSembol.image = UIImage.init(named: objet?.sembolIcon ?? "")
            cell.lblCoinCount.text = String(objet?.coins ?? 0)
            cell.lblTitle.text = objet?.title
        }
        else{
            cell.imgSelect.borderWidth = 1
            cell.imgSelect.borderColor = .darkGray
            cell.imgSelect.backgroundColor = .white
            cell.imgSembol.image = UIImage.init(named: objet?.sembolIcon ?? "")
            cell.lblCoinCount.text = String(objet?.coins ?? 0)
            cell.lblTitle.text = objet?.title
            //            cell.btnInfo.addTarget(self, action: #selector(btnInfo_Clicked(sender:)), for: .touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objet = self.getPromotData?.convertToCoins(is_toppick: self.postDetail?.is_toppick, is_bump: self.postDetail?.is_bump, is_hightlight: self.postDetail?.is_hightlight, is_sale: self.postDetail?.is_sale, is_profile_promote: postDetail?.is_profile_promote)[indexPath.row]
        
        if self.selectPromote?.title == objet?.title {
            self.selectPromote = nil
        }
        else {
            self.selectPromote = objet ?? Coins()
            self.viewSale.isHidden = true
            self.viewPromoteDetail.isHidden = false
            self.imgSembol.image = UIImage.init(named: objet?.sembolIcon ?? "")
            let urlString = objet?.promotImge?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            self.imgDetailPromote.setImageFast(with: urlString)
            
            self.txtPromoteDetails.text = objet?.description
            self.lblPromotTitle.text = objet?.title
            self.btnPromote.setTitle("Select \(objet?.title ?? "")", for: .normal)
        }
        self.tblPromotelist.reloadData()
    }
}

class PromoteCell : UITableViewCell {
    @IBOutlet weak var imgSelect: CustomImageView!
    @IBOutlet weak var imgSembol: CustomImageView!
    @IBOutlet weak var imgCoin: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCoinCount: UILabel!
    @IBOutlet weak var btnInfo: UIButton!
}
extension PromoteViewController {
    func callGetPromoteList() {
        if appDelegate.reachable.connection != .none {
            //            APIManager().apiCallWithMultipart(of: PromoteModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.GET_PROMOTE.rawValue, parameters: [:]) { (response, error) in
            APIManager().apiCall(of: PromoteModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.GET_PROMOTE.rawValue, method: .get, parameters: [:]) { (response, error) in
                
                if error == nil {
                    if let data = response?.dictData {
                        self.getPromotData = data
                    }
                    self.tblPromotelist.reloadData()
                    self.tblPromotelist.layoutIfNeeded()
                    self.constHeightForTblPromotelist.constant = self.tblPromotelist.contentSize.height
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
    
    func callAddPromotePost(postId : String,type: String) {
        if appDelegate.reachable.connection != .none {
            let param = ["post_id" : postId,
                         "type":  type,
                         "sale_price" : self.txtSaleprice.text ?? ""
            ]
            APIManager().apiCall(of: PromoteModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.ADD_PROMOTE_TO_POT.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    let ViewController = self.storyboard?.instantiateViewController(identifier: "CongratulationsViewController") as! CongratulationsViewController
                    self.navigationController?.pushViewController(ViewController, animated: true)
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
}
