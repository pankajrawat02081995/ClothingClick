//
//  HomePageViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/05/24.
//

import Foundation
import UIKit

class HomePageViewModel{
    var view : HomePageVC?
    var posts = [Posts]()
    var page = 1
    var isLoading = false
    var categoriesList = [CategoriesList]()
    
    func getAllProduct(isShowHud: Bool, cat_id: String = "", sort_by: String = "", sort_value: String = "") {
        let param: [String: Any] = [
            "page": self.page,
            "cat_id": cat_id,
            "sort_by": sort_by,
            "sort_value": sort_value,
            "latitude" : appDelegate.userLocation?.latitude ?? "",
            "longitude" : appDelegate.userLocation?.longitude ?? "",
            "gender": appDelegate.selectGenderId == "0" ? "1" : appDelegate.selectGenderId == "1" ? "2" : "",
            "sizes" : FilterSingleton.share.filter.sizes ?? ""
        ]
        
        APIManager().apiCall(of: ResponseData.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.HOME_PAGE_PRODUCTLIST.rawValue, method: .post, parameters: param) { dict, error in
            
            guard error == nil, let data = dict?.dictData else {
                UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                return
            }
            
            self.posts = self.page == 1 ? data.posts ?? [] : self.posts + (data.posts ?? [])
            self.isLoading = (data.posts?.count ?? 0) >= 10
            
            DispatchQueue.main.async {
                self.view?.badgeView.isHidden = (data.unread_notification ?? 0) == 0
                self.view?.productCollectionView.reloadData()
                
                let categoryName = self.categoriesList.first { "\($0.id ?? 0)" == cat_id }?.name ?? "Data"
                self.view?.productCollectionView.setBackGroundLabel(msg: "No \(categoryName) Found", count: self.posts.count)
            }
        }
    }

    func callCategoryList() {
        guard appDelegate.reachable.connection != .none else { return }
        
        APIManager().apiCall(of: CategoriesListModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES_LIST.rawValue, method: .get, parameters: [:]) { response, error in
            
            guard error == nil, let categories = response?.dictData?.categories else {
                UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                return
            }
            
            self.categoriesList = categories
            DispatchQueue.main.async {
                self.view?.catCollectionView.reloadData()
            }
        }
    }

    func callPostFavourite(action_type: String, postId: String, index: Int) {
        guard appDelegate.reachable.connection != .none else {
            UIAlertController().alertViewWithNoInternet(self.view ?? UIViewController())
            return
        }
        
        let param: [String: Any] = [
            "post_id": postId,
            "action_type": action_type
        ]
        
        APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { response, error in
            
            guard error == nil else {
                UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                return
            }
            
            self.posts[index].is_favourite = (action_type == "1")
            DispatchQueue.main.async {
                self.view?.productCollectionView.reloadData()
            }
        }
    }

}
