//
//  HomePageViewModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/05/24.
//

import Foundation

class HomePageViewModel{
    var view : HomePageVC?
    var posts = [Posts]()
    var page = 1
    var isLoading = false
    var categoriesList = [CategoriesList]()
    
    func getAllProduct(isShowHud:Bool,cat_id:String = "",sort_by:String = "",sort_value:String = ""){
        let param = ["page":self.page,"cat_id":cat_id,"sort_by":sort_by,"sort_value":sort_value] as [String : Any]
        APIManager().apiCall(of: ResponseData.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.HOME_PAGE_PRODUCTLIST.rawValue, method: .post, parameters: param) { dict, error in
            
            if error == nil{
                if self.page == 1{
                    self.posts = dict?.dictData?.posts ?? []
                }else{
                    self.posts += dict?.dictData?.posts ?? []
                }
                
                if dict?.dictData?.posts?.count ?? 0 >= 10{
                    self.isLoading = true
                }else{
                    self.isLoading = false
                }
                
                if dict?.dictData?.unread_notification ?? 0 == 0 ||  dict?.dictData?.unread_notification == nil{
                    self.view?.badgeView.isHidden = true
                }else{
                    self.view?.badgeView.isHidden = false
                }
                
                DispatchQueue.main.async {
                    self.view?.productCollectionView.reloadData()
                }
                let name = self.categoriesList.filter{"\($0.id ?? 0)" == cat_id}
                
                self.view?.productCollectionView.setBackGroundLabel(msg: "No \(name.first?.name ?? "Data") Found",count: self.posts.count)
            }else{
                UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
            }
            
        }
    }
    
    func callCategoryList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: CategoriesListModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES_LIST.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    self.categoriesList = response?.dictData?.categories ?? []
                    self.view?.catCollectionView.reloadData()
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callPostFavourite(action_type : String,postId : String,index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.posts[index].is_favourite = true
                    }
                    else {
                        self.posts[index].is_favourite = false
                    }
                    self.view?.productCollectionView.reloadData()
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self.view ?? UIViewController(), message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self.view ?? UIViewController())
        }
    }
}
