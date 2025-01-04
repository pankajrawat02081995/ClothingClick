
import UIKit
import StripePaymentSheet
import StripeApplePay
import PassKit

class PaymentViewController: UIViewController {
    var paymentSheet: PaymentSheet?
    

//    let shippingDetails = PaymentSheet.ShippingDetails
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Pay now", for: .normal)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        button.addTarget(self, action: #selector(self.payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        //            button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
//                setupPaymentSheet()
    }
    
    
    
    @objc func payButtonTapped() {
        if let paymentSheet = self.paymentSheet {
            paymentSheet.present(from: self) { paymentResult in
                switch paymentResult {
                case .completed:
                    print("Payment complete")
                case .failed(let error):
                    print("Payment failed: \(error)")
                case .canceled:
                    print("Payment canceled")
                }
            }
        }
    }
}
