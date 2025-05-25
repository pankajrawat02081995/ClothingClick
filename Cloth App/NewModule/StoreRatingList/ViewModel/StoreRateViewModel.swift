//
//  StoreRateViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 22/05/25.
//

import Foundation

class StoreRateViewModel{
    
    weak var view : StoreRateVC?
    
    init(view: StoreRateVC? = nil) {
        self.view = view
    }
    
    func callAddReview() {
        
        if appDelegate.reachable.connection != .none {
            let param = ["user_id": "\(self.view?.otherUserDetailsData?.id ?? 0)",
                         "rating" : "\(Int(self.view?.rateVIew.rating ?? 0.0))",
                         "review" : self.view?.txtDescription.text ?? "",
            ] as [String : Any]
            
            APIManager().apiCallWithImage(of: StoreRatingModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_REVIEW.rawValue, parameters: param, images: view?.isNewImage ?? true ? [self.view?.imgProduct.image ?? UIImage()] : [UIImage()], imageParameterName: "image[]", imageName: "post_image.png"){  (response, error) in
                if error == nil {
                    if let mesage = response?.message {
                        let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: mesage, preferredStyle: .alert)
                        alert.setAlertButtonColor()
                        let yesAction: UIAlertAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                            self.view?.popViewController()
                        })
                        alert.addAction(yesAction)
                        
                        self.view?.present(alert, animated: true, completion: nil)
                    }
                    
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error!.domain)
                }
            }
        }
        else {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
        }
    }
}
