//
//  GlobalSearchModel.swift
//  Cloth App
//
//  Created by Apple on 21/06/21.
//

import Foundation
import ObjectMapper

struct GlobalSearchModel : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var data : [Datas]? 
    var posts : [Posts]?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        data <- map["data"]
    }

}
struct Datas : Mappable {
    var id : Int?
    var name : String?
    var username : String?
    var userimage : String?
    var title : String?
    var image : [Image]?
    var followers : Int?
    var total_posts : Int?
   
   
    var price : String?
    var price_type : String?
    var brand_id : Int?
    var user_id : Int?
    var brand_name : String?
    var created_at : String!
   
    var is_favourite : Bool?
    var size_name : String?
    
    var price_type_name : String?
    var post_views : Int?
    var is_toppick : Int?
    var is_bump : Int?
    var is_hightlight : Int?
    var is_sale : Int?
    var is_profile_promote : Int?
    var sale_price : Float?
    var is_sold : Int?
    var user_image : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        total_posts <- map["total_posts"]
        username <- map["username"]
        userimage <- map["userimage"]
        title <- map["title"]
        image <- map["image"]
        
        price_type_name <- map["price_type_name"]
       
        price <- map["price"]
        price_type <- map["price_type"]
        brand_id <- map["brand_id"]
        user_id <- map["user_id"]
        brand_name <- map["brand_name"]
        created_at <- map["created_at"]
        image <- map["image"]
        is_favourite <- map["is_favourite"]
        size_name <- map["size_name"]
        
        post_views <- map["post_views"]
        is_toppick <- map["is_toppick"]
        is_bump <- map["is_bump"]
        is_hightlight <- map["is_hightlight"]
        is_sale <- map["is_sale"]
        is_profile_promote <- map["is_profile_promote"]
        sale_price <- map["sale_price"]
        is_sold <- map["is_sold"]
       
    }
    func isItemSold() -> Bool {
        return is_sold == 1
    }

    func isViewSaleHidden () -> Bool {
        let isVisible = is_sale == 1 || is_hightlight == 1
        return !isVisible
    }
    
    func isLblSaleHidden () -> Bool {
        let isVisible = is_sale == 1
        return !isVisible
    }
    
    func isTopPickHidden () -> Bool {
        let isVisible = is_toppick == 1
        return !isVisible
    }
    
    func isPromotShow () -> Bool{
        if is_toppick != 0 {
            let isVisible = is_toppick == 1
            return !isVisible
        }
        else if is_bump != 0 {
            let isVisible = is_bump == 1
            return !isVisible
        }
        else if is_hightlight != 0 {
            let isVisible = is_hightlight == 1
            return !isVisible
        }
        else if is_toppick != 0 {
            let isVisible = is_toppick == 1
            return !isVisible
        }
        else if is_sale != 0 {
            let isVisible = is_sale == 1
            return !isVisible
        }
        else
        {
            let isVisible = is_profile_promote == 1
            return !isVisible
        }
        
    }
    
    func isPromotImage () -> String{
        if is_toppick == 1 {
            let isImage = "Top-Picup-ic"
            return isImage
        }
        else if is_bump == 1 {
            let isImage = "Bump-ic"
            return isImage
        }
        else if is_hightlight == 1 {
            let isImage = "Highlight-ic"
            return isImage
        }
//        else if is_toppick == 1 {
//            let isImage = ""
//            return isImage
//        }
        else if is_sale == 1 {
            let isImage = "Sale-ic"
            return isImage
        }
        else
        {
            let isImage = "ProfilePromote-ic"
            return isImage
        }
    }
    
    func getBackgroundColor() -> UIColor?{
        if(is_sale == 1){
            return UIColor().redColor
        }
        if(is_hightlight == 1){
            return UIColor().blueColor
        }
        return nil
    }
}
