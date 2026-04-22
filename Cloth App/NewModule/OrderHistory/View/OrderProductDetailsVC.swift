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
    var model:OrderDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let isRate = UserDefaults.standard.bool(forKey: "isRate")
        debugPrint(isRate)

        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if isRate == false {
                self.showRatepopup()
            }
        }
        
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
//        let viewController = FindLocation.instantiate(fromStoryboard: .Main)
////        viewController.addresslist = locations
//        viewController.lat = Double(self.model?.pickup_address?.latitude ?? "") ?? 0.0
//        viewController.log = Double(self.model?.pickup_address?.longitude ?? "") ?? 0.0
////        viewController.usertype = postDetails?.user_type ?? 0
//        viewController.hidesBottomBarWhenPushed = true
////        
//        self.pushViewController(vc: viewController)
        
        self.showDirectionOptions(toLatitude: Double(self.model?.pickup_address?.latitude ?? "") ?? 0.0, toLongitude: Double(self.model?.pickup_address?.longitude ?? "") ?? 0.0, viewController: self)

    }
    
    func showDirectionOptions(toLatitude latitude: Double, toLongitude longitude: Double, viewController: UIViewController) {
        let appleMapScheme = "http://maps.apple.com/"
        let googleMapScheme = "comgooglemaps://"
        
        var availableMapApps: [(name: String, url: URL)] = []
        
        // Check for Apple Maps (always available on iOS)
        if let appleURL = URL(string: "\(appleMapScheme)?daddr=\(latitude),\(longitude)&dirflg=d") {
            availableMapApps.append(("Apple Maps", appleURL))
        }
        
        // Check if Google Maps is installed
        if let googleURL = URL(string: "\(googleMapScheme)?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(googleURL) {
            availableMapApps.append(("Google Maps", googleURL))
        }
        
        // Present an action sheet if more than one option is available
        if !availableMapApps.isEmpty {
            let alert = UIAlertController(title: "Choose Map", message: "Select an app to show directions", preferredStyle: .actionSheet)
            
            for mapApp in availableMapApps {
                alert.addAction(UIAlertAction(title: mapApp.name, style: .default, handler: { _ in
                    UIApplication.shared.open(mapApp.url, options: [:], completionHandler: nil)
                }))
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Present the alert on the provided view controller
            viewController.present(alert, animated: true, completion: nil)
        } else {
            // Handle the case when no map apps are available
            let noAppsAlert = UIAlertController(title: "No Map Apps Found", message: "No available map applications to show directions.", preferredStyle: .alert)
            noAppsAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(noAppsAlert, animated: true, completion: nil)
        }
    }
    
    func setupView(model:OrderDetailsModel){
        self.model = model
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
        
        self.lbltaxes.text = "$\(model.oderDetails?.tax ?? "")"
        self.lblItemPrice.text = "$\(model.product?.price ?? "")"
        self.lblTotalPrice.text = "$\(model.oderDetails?.total ?? "")"
        self.lbltaxes.text = "$0"
        self.lblShippingCharge.text = self.isShip == true ? "$0.0" : "Free (Pickup)"
        self.lblOrderNumber.text = "\(model.oderDetails?.id ?? 0)"
        self.lblPickupOrderNumber.text = "\(model.oderDetails?.id ?? 0)"
        self.lblSallerUserName.text = model.sellerDetails?.name ?? ""
        self.lblStoreName.text = model.sellerDetails?.name ?? ""
        self.lblProductPriceWithMethod.text = "$\(model.oderDetails?.total ?? "") with \(model.oderDetails?.payment_mode ?? "")"
        self.lblShipAddress.text = model.shipping_address?.address1 ?? ""
        self.lblShippingAddress.text = model.shipping_address?.address1 ?? ""
        
        //Shipped 2-21-2024
        self.lblShipDate.text = model.shipping_address?.createdAt ?? ""
        //Shipped On 2-21-2024
        self.lblShippingDate.text = model.shipping_address?.createdAt ?? ""
        
        //Shipped: December 21
        self.lblShipDateWithMonth.text = model.shipping_address?.createdAt ?? ""
        
        //Purchased on 2-24-2024
        self.lblPurchsedDate.text = "Purchased on \(model.shipping_address?.createdAt ?? "")"
        
        self.imgProduct.setImageFast(with: model.product?.images?.first?.image ?? "")
        
        if let encodedUrlString = model.sellerDetails?.image?.profile_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            self.imgSaller.setImageFast(with: encodedUrlString)
    }
        
        self.lblProductName.text = model.product?.title ?? ""
        self.lblSize.text = "\(model.product?.sizes ?? "") . $\(model.product?.price ?? "")"
        
        
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
