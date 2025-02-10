//
//  BuyNowVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 01/09/24.
//

import UIKit
import StripePaymentSheet
import StripeApplePay
//import PassKit
import KRProgressHUD

enum DeliveryType {
    case Pickup
    case Ship
}

class BuyNowVC: UIViewController {
    
    var paymentSheet: PaymentSheet?
    
    @IBOutlet weak var btnPay: CustomButton!
    @IBOutlet weak var pickupAddressMainContainer: UIView!
    @IBOutlet weak var pickupAddressContainer: UIView!
    @IBOutlet weak var pickupContainer: UIView!
    @IBOutlet weak var shipContainer: UIView!
    @IBOutlet weak var imgPickup: UIImageView!
    @IBOutlet weak var imgShip: UIImageView!
    
    
    @IBOutlet weak var lblCompleteAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblPostName: UILabel!
    @IBOutlet weak var imgPost: CustomImageView!
    
    
    var deliveryType : DeliveryType? = .Pickup
    var postDetails : PostDetailsModel?
    var paymentID:String?
    var client_secret : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickupOnPress()
        self.pickupAddressContainer.layer.cornerRadius = 5
        self.setupData()
    }
    
    func setupData(){
        if let imge = URL.init(string: self.postDetails?.images?.first?.image ?? ""){
            self.imgPost.kf.setImage(with: imge,placeholder: PlaceHolderImage)
        }
        if let gender = self.postDetails?.gender_name,let size  = self.postDetails?.sizes?.first?.name {
            self.lblSize.text = "\(gender == "Menswear" ? "Men" : "Women")'s \(size)"
        }
        if let condiction = self.postDetails?.condition_name {
            self.lblCondition.text = condiction
        }
        if let locations = self.postDetails?.locations{
            self.lblCity.text = locations.first?.city ?? ""
            self.lblCompleteAddress.text = locations.first?.address ?? ""
        }
        
        if let price = self.postDetails?.price {
            self.lblPrice.text = "$ \(price.formatPrice())"
            self.btnPay.setTitle("Pay $ \(price.formatPrice())", for: .normal)
        }
        if let title = self.postDetails?.title {
            self.lblPostName.text = title
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func buyNowOnPress(_ sender: UIButton) {
        self.setupPaymentSheet()
    }
    
    @IBAction func shipOnPress(_ sender: UIButton) {
        self.shipOnPress()
    }
    
    @IBAction func pickupOnPress(_ sender: UIButton) {
        self.pickupOnPress()
    }
    
    func shipOnPress(){
        self.shipContainer.layer.cornerRadius = 5
        self.shipContainer.layer.borderColor = UIColor.customBlack?.cgColor
        self.shipContainer.layer.borderWidth = 1
        self.imgShip.image = UIImage(named: "ic_selected_cirlce")
        
        self.pickupContainer.layer.cornerRadius = 5
        self.pickupContainer.layer.borderColor = UIColor.customBorderColor?.cgColor
        self.pickupContainer.layer.borderWidth = 1
        self.imgPickup.image = UIImage(named: "ic_circle")
        
        self.deliveryType = .Ship
        self.pickupAddressMainContainer.isHidden = true
    }
    
    func pickupOnPress(){
        self.pickupContainer.layer.cornerRadius = 5
        self.pickupContainer.layer.borderColor = UIColor.customBlack?.cgColor
        self.pickupContainer.layer.borderWidth = 1
        self.imgPickup.image = UIImage(named: "ic_selected_cirlce")
        
        self.shipContainer.layer.cornerRadius = 5
        self.shipContainer.layer.borderColor = UIColor.customBorderColor?.cgColor
        self.shipContainer.layer.borderWidth = 1
        self.imgShip.image = UIImage(named: "ic_circle")
        
        self.deliveryType = .Pickup
        self.pickupAddressMainContainer.isHidden = false
    }
}

extension BuyNowVC {
    func setupPaymentSheet() {
        KRProgressHUD.show()
        
        guard let backendUrl = URL(string: "\(BASE_URL)create_payment_intent") else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: backendUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add Bearer token authorization
        let bearerToken = appDelegate.headerToken  // Replace this with your actual token
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "post_id": self.postDetails?.id ?? 0
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("Error encoding request body: \(error.localizedDescription)")
            KRProgressHUD.dismiss()
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    print("HTTP Error: \(httpResponse.statusCode)")
                }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let clientSecret = json["client_secret"] as? String {
                    
                    DispatchQueue.main.async {
                        self.client_secret = clientSecret
                        self.paymentID = json["id"] as? String ?? ""
                        
                        // Configure PaymentSheet
                        var configuration = PaymentSheet.Configuration()
                        configuration.merchantDisplayName = self.postDetails?.user_name ?? ""
                        configuration.allowsDelayedPaymentMethods = true
                        
                        // Enable shipping details collection if applicable
                        if self.deliveryType == .Ship {
                            
                            // Collect all necessary billing details
                            configuration.billingDetailsCollectionConfiguration.email = .always
                            configuration.billingDetailsCollectionConfiguration.phone = .always
                            configuration.billingDetailsCollectionConfiguration.address = .full
                            configuration.billingDetailsCollectionConfiguration.name = .always
                            
                            configuration.allowsPaymentMethodsRequiringShippingAddress = true
                            configuration.billingDetailsCollectionConfiguration.attachDefaultsToPaymentMethod = false
                        }
                        
                        // Apple Pay configuration (optional)
                        configuration.applePay = .init(merchantId: "merchant.com.clothingclick", merchantCountryCode: "US")
                        
                        // Initialize PaymentSheet with client secret and configuration
                        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
                        
                        KRProgressHUD.dismiss()
                        
                        DispatchQueue.main.async {
                            self.payButtonTapped()
                        }
                    }
                } else if let errorResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                        print("Error Response: \(errorResponse)")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    KRProgressHUD.dismiss()
                    print("Error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func payButtonTapped() {
        if let paymentSheet = self.paymentSheet {
            DispatchQueue.main.async {
                paymentSheet.present(from: self) { paymentResult in
                    switch paymentResult {
                    case .completed:
                        print("Payment complete")
                        self.callSaveOrderApi()
                        
                    case .failed(let error):
                        print("Payment failed: \(error.localizedDescription)")
                        debugPrint(error)
                        
                    case .canceled:
                        print("Payment canceled")
                    }
                }
            }
        } else {
            print("Error: paymentSheet is nil")
        }
    }
    
    func fetchPaymentMethodDetails(paymentMethodId: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let urlString = "\(BASE_URL)get-payment-method/\(paymentMethodId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(.success(json))
                }
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }
        
        task.resume()
    }
    
    
    
    func fetchPaymentMethod(completion: @escaping (STPPaymentMethod?) -> Void) {
        guard let clientSecret = self.client_secret, !clientSecret.isEmpty else {
            print("Client secret is nil or empty.")
            completion(nil)
            return
        }
        
        STPAPIClient.shared.retrievePaymentIntent(withClientSecret: clientSecret) { paymentIntent, error in
            if let error = error {
                print("Error fetching payment intent: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let paymentIntent = paymentIntent else {
                print("Failed to retrieve payment intent.")
                completion(nil)
                return
            }
            
            if let paymentMethod = paymentIntent.paymentMethod {
                completion(paymentMethod)
            } else {
                print("Payment method is nil in the payment intent.")
                completion(nil)
            }
        }
    }
    
    func callSaveOrderApi() {
        var param = [String:Any]()
        
        param["seller_id"] = self.postDetails?.user_id ?? 0
        param["product_id"] = self.postDetails?.id ?? 0
        param["payment_mode"] = "stripe"
        param["status"] = "Purchased"
        param["transaction_id"] = self.paymentID
        
        if self.deliveryType == .Ship{
            param["type_of_order"] = "1"
        }else{
            param["type_of_order"] = "2"
        }
        
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: OrderDetails.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_ORDER.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    UIAlertController().alertViewWithTitleAndMessage(self , message: response?.message ?? "") {
                        let vc = OrderProductDetailsVC.instantiate(fromStoryboard: .Sell)
                        vc.orderID = response?.dictData?.id ?? 0
                        vc.isShip = self.deliveryType == .Ship ? true : false
                        vc.isAfterBuy = true
                        self.pushViewController(vc: vc)                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self , message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}
