//
//  DeleteProductSingleTon.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 30/09/24.
//

import Foundation

class DeleteProduct{
    static let share = DeleteProduct()
    private init(){}
    func delete(postId:String,view:UIViewController,completion:@escaping((Bool)->Void?)){
        if appDelegate.reachable.connection != .none {
            let param = ["post_id" : postId]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    completion(true)
                }else {
                    UIAlertController().alertViewWithTitleAndMessage(view, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(view)
        }
    }
}
