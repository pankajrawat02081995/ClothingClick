//
//  CheckoutViewController.swift
//  ClothApp
//
//  Created by Apple on 24/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class CheckoutViewController: BaseViewController {

    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblProductType: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductSize: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserBrandName: UILabel!
    @IBOutlet weak var btnBrand: CustomButton!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var lblPostCount: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnEditPaymentMethod: CustomButton!
    @IBOutlet weak var btnPlaceOrder: CustomButton!
    
    var postDetails : PostDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetDataProductAndUser()
    }
    
    func SetDataProductAndUser() {
        let object = postDetails
        if let url = object?.images?[0].image{
            if let image = URL.init(string: url){
                self.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
        if let branName = object?.brand_name {
            self.lblBrandName.text = branName
        }
        if let title = object?.title {
            self.lblProductType.text = title
        }
        if let size = object?.sizes ,size.count > 0 {
            self.lblProductSize.text = size.first?.name ?? ""
        }
        if let price = object?.price {
            self.lblProductPrice.text = String(price)
//            if !(object?.isLblSaleHidden() ?? true) {
//                if let salePrice = object?.sale_price {
//                    cell.lblPrice.text = "$ \(salePrice)"
//                }
//                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(0.0)")
//                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//                cell.lblSelePrice.attributedText = attributeString
//                cell.constLeadingForlblPrice.constant = 2
////                cell.lblPrice.text = "$ \(price)"
//            }
//            else {
//                cell.constLeadingForlblPrice.constant = -37
//                cell.lblPrice.text = "$ \(price)"
//            }
        }
        
        if let url = object?.user_profile_picture {
            if let imamge = URL.init(string: url){
                self.imgUser.kf.setImage(with: imamge,placeholder: ProfileHolderImage)
            }
        }
        if let userName = object?.user_name {
            self.lblUserName.text = userName
        }
        if let userBrandName = object?.user_username {
            self.lblUserBrandName.text = userBrandName
        }
        if let postCount = object?.user_posts?.count {
            self.lblPostCount.text = "\(postCount)"
        }
    }
    
    
    @IBAction func btnPlaceOrder_Clicked(_ button: UIButton) {
        
    }
    
    @IBAction func btnEditPaymentMethod_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnBrand_Clicked(_ button: UIButton) {
        
    }
}

