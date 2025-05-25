//
//  StoreRatingViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 22/05/25.
//

import Foundation

class StoreRatingViewModel{
    
   private weak var view : StoreRatingListVC?
    var reviewData : ReviewsListModel?
    var reviews = [Reviews]()
    var currentPage = 1
    var hasMorePages = false
    
    init(view: StoreRatingListVC? = nil) {
        self.view = view
    }
 
    func callGetReviews(userId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id":  userId,
                         "page" : "\(self.currentPage)"
            ]
            APIManager().apiCall(of:ReviewsListModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.REVIEWS_STORE_LIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.reviewData = data
                            if self.currentPage == 1 {
                                self.reviews.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            if let reviews = data.reviews {
                                for temp in reviews {
                                    self.reviews.append(temp)
                                }
                            }
                            self.view?.tableView.setBackGroundLabel(count: self.reviews.count,text: "No Reviews Found")
                            self.view?.tableView.reloadData()
                        }
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
