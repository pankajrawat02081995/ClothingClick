//
//  OrderProductDetailsVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 15/09/24.
//

import UIKit
import IBAnimatable

class OrderProductDetailsVC: UIViewController {

    var viewModel : OrderHistoryViewModel?
    var orderID : Int?
    var isShip : Bool?
    var isAfterBuy : Bool?
    
    @IBOutlet weak var lblPickupOrderNumber: UILabel!
    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var lblMainTitle: UILabel!
    @IBOutlet weak var lblShipDateWithMonth: UILabel!
    @IBOutlet weak var firstSlideBar: UIView!
    @IBOutlet weak var secondSlideBar: UIView!
    @IBOutlet weak var lblShipTitle: UILabel!
    @IBOutlet weak var imgShip: UIImageView!
    @IBOutlet weak var lblDelivedTitle: UILabel!
    @IBOutlet weak var imgDelived: UIImageView!
    
    @IBOutlet weak var imgProduct: AnimatableImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    
    @IBOutlet weak var shipView: UIView!
    @IBOutlet weak var lblShippingDate: UILabel!
    @IBOutlet weak var lblShippingAddress: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    
    @IBOutlet weak var lblShipDate: UILabel!
    @IBOutlet weak var lblShipAddress: UILabel!
    @IBOutlet weak var lblProductPriceWithMethod: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblShippingCharge: UILabel!
    @IBOutlet weak var lbltaxes: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var imgSaller: UIImageView!
    @IBOutlet weak var lblPurchsedDate: UILabel!
    @IBOutlet weak var lblSallerUserName: UILabel!
    
    @IBOutlet weak var lblPicupLocation: UILabel!
    
    @IBOutlet weak var lblStoreName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = OrderHistoryViewModel()
        self.viewModel?.callGetOrderDetails(order_id: self.orderID ?? 0, complition: { [weak self] response in
            debugPrint(response.shipping_address?.address1 ?? "")
            self?.setupView(model:response)
        })
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        if self.isAfterBuy == true{
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.popViewController()
        }
    }
    
    @IBAction func directionOnPress(_ sender: UIButton) {
    }
    
    func setupView(model:OrderDetailsModel){
    
        if self.isShip == true{
            self.shipView.isHidden = false
            self.pickupView.isHidden = true
            self.lblMainTitle.text = "Your order is on its way"
            self.lblShipTitle.text = "Shipped"
            self.lblDelivedTitle.text = "Delivered"
        }else{
            self.shipView.isHidden = true
            self.pickupView.isHidden = false
            self.lblMainTitle.text = "Order is ready for pickup"
            self.lblShipTitle.text = "Processing"
            self.lblDelivedTitle.text = "Pickup"
        }
        
        self.lbltaxes.text = "$\(model.oderDetails?.tax ?? 0.0)"
        self.lblItemPrice.text = "$\(model.product?.price ?? "")"
        self.lblTotalPrice.text = "$\(model.oderDetails?.total ?? 0)"
        self.lblShippingCharge.text = self.isShip == true ? "$0.0" : "Free (Pickup)"
        self.lblOrderNumber.text = "\(model.oderDetails?.id ?? 0)"
        self.lblPickupOrderNumber.text = "\(model.oderDetails?.id ?? 0)"
        self.lblSallerUserName.text = model.sellerDetails?.name ?? ""
        self.lblStoreName.text = model.sellerDetails?.name ?? ""
        self.lblProductPriceWithMethod.text = "$\(model.oderDetails?.total ?? 0) with \(model.oderDetails?.payment_mode ?? "")"
        self.lblShipAddress.text = model.shipping_address?.address1 ?? ""
        self.lblShippingAddress.text = model.shipping_address?.address1 ?? ""
        
        //Shipped 2-21-2024
        self.lblShipDate.text = "\(model.oderDetails?.status ?? "") \(GetData.shared.convertDateFormat(date: model.shipping_address?.createdAt ?? "", getFormat: "MMM dd", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.000000Z"))"
        //Shipped On 2-21-2024
        self.lblShippingDate.text = "\(model.oderDetails?.status ?? "") on \(GetData.shared.convertDateFormat(date: model.shipping_address?.createdAt ?? "", getFormat: "MMM dd", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.000000Z"))"
        
        //Shipped: December 21
        self.lblShipDateWithMonth.text = "\(model.oderDetails?.status ?? ""): \(GetData.shared.convertDateFormat(date: model.shipping_address?.createdAt ?? "", getFormat: "MMM dd", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.000000Z"))"
       
        //Purchased on 2-24-2024
        self.lblPurchsedDate.text = "\(model.oderDetails?.status ?? "") on \(GetData.shared.convertDateFormat(date: model.shipping_address?.createdAt ?? "", getFormat: "MMM dd", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.000000Z"))"
        
        if let imge = URL.init(string: model.product?.images?.first?.image ?? ""){
            self.imgProduct.kf.setImage(with: imge,placeholder: PlaceHolderImage)
        }
        
        if let imge = URL.init(string: model.sellerDetails?.image ?? ""){
            self.imgSaller.kf.setImage(with: imge,placeholder: PlaceHolderImage)
        }
        
        self.lblProductName.text = model.product?.title ?? ""
        self.lblSize.text = "\(model.product?.sizes?.first ?? "") . $\(model.product?.price ?? "")"
        
        
        if model.oderDetails?.status?.lowercased() == "purchased"{
            self.firstSlideBar.backgroundColor = .customNotificationBG
            self.secondSlideBar.backgroundColor = .customNotificationBG
        }else if model.oderDetails?.status?.lowercased() == "shipped" || model.oderDetails?.status?.lowercased() == "processing"{
            self.firstSlideBar.backgroundColor = .black
            self.secondSlideBar.backgroundColor = .customNotificationBG
            self.lblShipTitle.text = model.oderDetails?.status ?? ""
        }else if model.oderDetails?.status?.lowercased() == "delivered" || model.oderDetails?.status?.lowercased() == "pickup"{
            self.firstSlideBar.backgroundColor = .black
            self.secondSlideBar.backgroundColor = .black
            self.lblDelivedTitle.text = model.oderDetails?.status ?? ""
        }
    }
    
}
