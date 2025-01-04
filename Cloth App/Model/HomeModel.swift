//
//  HomeModel.swift
//  Cloth App
//
//  Created by Apple on 11/06/21.
//

import Foundation
import ObjectMapper

struct HomeModel : Mappable {
    var type_id : Int?
    var name : String?
    var type : String?
    var unread_notification : Int?
    var list : [List]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        type_id <- map["type_id"]
        unread_notification <- map["unread_notification"]
        name <- map["name"]
        type <- map["type"]
        list <- map["list"]
    }

}

struct List : Mappable {
    var photo : String?
    var id : Int?
    var title : String?
    var price : String?
    var price_type : String?
    var price_type_name : String?
    var brand_id : Int?
    var user_id : Int?
    var brand_name : String?
    var image : [Image]?
    var is_favourite : Bool?
    var size_name : String?
    var name : String?
    var created_at : String!
    var category_id: Int?
    var post_views : Int?
    var is_toppick : Int?
    var is_bump : Int?
    var is_hightlight : Int?
    var is_sale : Int?
    var is_profile_promote : Int?
    var sale_price : Float?
    var user_image : String?
    var profile_image : String?
    var icon : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        price_type_name <- map["price_type_name"]
        profile_image <- map["profile_image"]
        photo <- map["photo"]
        id <- map["id"]
        title <- map["title"]
        category_id <- map["category_id"]
        icon <- map["icon"]
        price <- map["price"]
        price_type <- map["price_type"]
        brand_id <- map["brand_id"]
        user_id <- map["user_id"]
        brand_name <- map["brand_name"]
        image <- map["image"]
        is_favourite <- map["is_favourite"]
        size_name <- map["size_name"]
        name <- map["name"]
        created_at <- map["created_at"]
        post_views <- map["post_views"]
        is_toppick <- map["is_toppick"]
        is_bump <- map["is_bump"]
        is_hightlight <- map["is_hightlight"]
        is_sale <- map["is_sale"]
        is_profile_promote <- map["is_profile_promote"]
        sale_price <- map["sale_price"]
        user_image <- map["user_image"]
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
struct Image : Mappable {
    var id : Int?
    var image : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        image <- map["image"]
    }

}
