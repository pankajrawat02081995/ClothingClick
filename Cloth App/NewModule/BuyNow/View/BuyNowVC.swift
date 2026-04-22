//
//  BuyNowVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 01/09/24.
//

import UIKit
import StripePaymentSheet
import StripeApplePay
import KRProgressHUD

enum DeliveryType {
    case Pickup
    case Ship
}

class BuyNowVC: UIViewController {
    
    var paymentSheet: PaymentSheet?
    
    @IBOutlet weak var lblSizeTitle: UILabel!
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
    
    var price : String?
    var size : String?
    var color : String?
    var varientID : String?
    var isOnlyShip : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isOnlyShip ?? false == true{
            pickupContainer.isHidden = true
            shipOnPress()
        }else{
            self.pickupOnPress()
            self.pickupAddressContainer.layer.cornerRadius = 5
        }
        self.setupData()
    }
    
    func setupData(){
        
        if let gender = self.postDetails?.gender_name{
            self.lblSize.text = "\(gender == "Menswear" ? "Men" : "Women")'s \(self.size ?? "")"
        }
        if let condiction = self.postDetails?.condition_name {
            self.lblCondition.text = condiction
        }
        if let locations = self.postDetails?.locations{
            self.lblCity.text = locations.first?.city ?? ""
            self.lblCompleteAddress.text = locations.first?.address ?? ""
        }
        
        self.lblPrice.text = "$ \(self.price?.formatPrice() ?? self.postDetails?.price ?? "")"
        self.btnPay.setTitle("Pay $ \(self.price?.formatPrice() ?? self.postDetails?.price ?? "")", for: .normal)
        
        if let title = self.postDetails?.title {
            self.lblPostName.text = title
        }
        let images = self.images(for: self.size ?? "", color: self.color ?? "", in: self.postDetails?.variants ?? [])
        self.imgPost.setImageFast(with: images.first?.image ?? "")

    }
    func images(
        for size: String?,
        color: String?,
        in variants: [Variants]
    ) -> [VariantsImages] {
        if size == nil || size?.isEmpty == true{
            lblSizeTitle.text = "Category"
            lblSize.text = "\(self.postDetails?.categories?.last?.name ?? "")"
        }
        let matchedVariants = variants.filter { variant in
            // Size match logic
            let sizeMatch: Bool = {
                guard let size = size, !size.isEmpty else {
                    return variant.size == nil || variant.size?.isEmpty == true
                }
                return variant.size == size
            }()

            // Color match logic
            let colorMatch: Bool = {
                guard let color = color, !color.isEmpty else { return true }
                return variant.color == color
            }()

            return sizeMatch && colorMatch
        }

        return matchedVariants
            .compactMap { $0.image }
            .flatMap { $0 }
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

        LoaderManager.shared.show()

        guard let backendUrl = URL(string: "\(BASE_URL)create_payment_intent") else {
            LoaderManager.shared.hide()
            return
        }

        var request = URLRequest(url: backendUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let bearerToken = appDelegate.headerToken
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "post_id": self.postDetails?.id ?? 0,
            "variant_id": self.varientID ?? ""
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                LoaderManager.shared.hide()
            }

            guard let data = data, error == nil else {
                print("API Error:", error?.localizedDescription ?? "")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let clientSecret = json["client_secret"] as? String {

                    DispatchQueue.main.async {

                        self.client_secret = clientSecret
                        self.paymentID = json["id"] as? String ?? ""

                        if let pk = json["pk"] as? String {
                            StripeAPI.defaultPublishableKey = pk
                        }

                        var configuration = PaymentSheet.Configuration()
                        configuration.merchantDisplayName = self.postDetails?.user_name ?? "Clothing Click"
                        configuration.allowsDelayedPaymentMethods = false
                        configuration.link.display = .never

                        // Shipping
                        if self.deliveryType == .Ship {
                            configuration.billingDetailsCollectionConfiguration.email = .always
                            configuration.billingDetailsCollectionConfiguration.phone = .always
                            configuration.billingDetailsCollectionConfiguration.address = .full
                            configuration.billingDetailsCollectionConfiguration.name = .always
                            configuration.allowsPaymentMethodsRequiringShippingAddress = true
                        }

                        // ✅ Apple Pay (Canada testing)
                        configuration.applePay = .init(
                            merchantId: "merchant.com.clothingclick",
                            merchantCountryCode: "US"
                        )

                        // ✅ Required redirect
                        configuration.returnURL = "clothingclick://stripe-redirect"

                        self.paymentSheet = PaymentSheet(
                            paymentIntentClientSecret: clientSecret,
                            configuration: configuration
                        )

                        self.payButtonTapped()
                    }
                }
            } catch {
                print("Parsing error:", error.localizedDescription)
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
        param["variant_id"] = self.varientID ?? ""
        
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
                        self.pushViewController(vc: vc)
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self , message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}
