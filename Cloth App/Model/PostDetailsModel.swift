//
//  PostDetailsModel.swift
//  Cloth App
//
//  Created by Apple on 17/06/21.
//

import Foundation
import ObjectMapper
import UIKit

struct PostDetailsModel : Mappable {
    var id : Int?
    var user_id : Int?
    var brand_id : String?
    var product_url : String?
    var type : String?
    var style_id : Int?
    var gender_id : Int?
    var categories : [Categories]?
    var sizes : [Size]?
    var condition_id : Int?
    var colors : [Colors]?
    var title : String?
    var description : String?
    var locations : [Locations]?
    var price_type : String?
    var price : String?
    var total_reviews : Int?
    var images : [ImagesVideoModel]?
    var videos : [ImagesVideoModel]?
    var is_sold : Int?
    var created_at : String?
    var brand_name : String?
    var gender_name : String?
    var condition_name : String?
    var price_type_name : String?
    var post_date_time : String?
    var is_favourite : Bool?
    var receiver_id : Int?
    var post_buynow_button : Int?
    var post_chat_button : Int?
    var post_location_button : Int?
    var user_username : String?
    var user_name : String?
    var user_type : Int?
    var total_posts : Int?
    var user_avg_review : Float?
    var user_profile_picture : String?
    var user_posts : [User_posts]?
    var related_posts : [User_posts]?
    var recently_viewed : [User_posts]?
    var post_views : Int?
    var is_toppick : Int?
    var is_bump : Int?
    var is_hightlight : Int?
    var is_sale : Int?
    var sale_price : Float?
    var is_profile_promote : Int?
    var top_pick_expire_at : String?
    var bump_expire_at : String?
    var hightlight_expire_at : String?
    var sale_expire_at : String?
    var profile_promote_expire_at : String?
    
    init?(map: Map) {
        
    }
    func isFavourite() ->Bool {
        //        let isselect =  == 1
        return is_favourite ?? false
    }
    
    mutating func mapping(map: Map) {
        product_url <- map["product_url"]
        recently_viewed <- map["recently_viewed"]
        sale_price <- map["sale_price"]
        type <- map["type"]
        id <- map["id"]
        total_reviews <- map["total_reviews"]
        user_id <- map["user_id"]
        style_id <- map["style_id"]
        brand_id <- map["brand_id"]
        gender_id <- map["gender_id"]
        categories <- map["categories"]
        sizes <- map["sizes"]
        condition_id <- map["condition_id"]
        colors <- map["colors"]
        title <- map["title"]
        description <- map["description"]
        locations <- map["locations"]
        price_type <- map["price_type"]
        price <- map["price"]
        images <- map["images"]
        videos <- map["videos"]
        is_sold <- map["is_sold"]
        created_at <- map["created_at"]
        brand_name <- map["brand_name"]
        gender_name <- map["gender_name"]
        condition_name <- map["condition_name"]
        price_type_name <- map["price_type_name"]
        post_date_time <- map["post_date_time"]
        is_favourite <- map["is_favourite"]
        post_buynow_button <- map["post_buynow_button"]
        post_chat_button <- map["post_chat_button"]
        receiver_id <- map["receiver_id"]
        post_location_button <- map["post_location_button"]
        user_username <- map["user_username"]
        user_name <- map["user_name"]
        user_type <- map["user_type"]
        total_posts <- map["total_posts"]
        user_avg_review <- map["user_avg_review"]
        user_profile_picture <- map["user_profile_picture"]
        user_posts <- map["user_posts"]
        related_posts <- map["related_posts"]
        post_views <- map["post_views"]
        is_toppick <- map["is_toppick"]
        is_bump <- map["is_bump"]
        is_hightlight <- map["is_hightlight"]
        is_sale <- map["is_sale"]
        is_profile_promote <- map["is_profile_promote"]
        top_pick_expire_at <- map["top_pick_expire_at"]
        bump_expire_at <- map["bump_expire_at"]
        hightlight_expire_at <- map["hightlight_expire_at"]
        sale_expire_at <- map["sale_expire_at"]
        profile_promote_expire_at <- map["profile_promote_expire_at"]
        
    }
    
    func isChatButtonDisplay() -> Bool {
        return post_chat_button == 1
    }
    
    func isBuyNowButtonDisplay() -> Bool {
        return post_buynow_button == 1
    }
    
    func isFiendLocationButtonDisplay() -> Bool {
        return post_location_button == 1
    }
    
    func isItemSold() -> Bool {
        return is_sold == 1
    }
    
    func isHideStackViewBottom() -> Bool {
        return self.isChatButtonDisplay() || self.isBuyNowButtonDisplay() || self.isFiendLocationButtonDisplay()
    }
    
    func isPromotShow () -> Bool{
        if is_toppick != 0{
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
    
    func isPromotExpDate () -> String{
        if top_pick_expire_at != "" && top_pick_expire_at != nil  {
            let iadate = top_pick_expire_at ?? ""
            print(iadate)
            return iadate
        }
        else if bump_expire_at != "" && bump_expire_at != nil {
            let iadate = bump_expire_at ?? ""
            print(iadate)
            return iadate
        }
        else if hightlight_expire_at != "" && hightlight_expire_at != nil{
            let iadate = hightlight_expire_at ?? ""
            print(iadate)
            return iadate
        }
        else if sale_expire_at != "" && sale_expire_at != nil{
            let iadate = sale_expire_at ?? ""
            print(iadate)
            return iadate
        }
        else if profile_promote_expire_at != "" && profile_promote_expire_at != nil
        {
            let iadate = profile_promote_expire_at ?? ""
            print(iadate)
            return iadate
        }
        return ""
    }
}

struct Related_posts : Mappable {
    var id : Int?
    var title : String?
    var price : String?
    var price_type : Int?
    var brand_id : Int?
    var user_id : Int?
    var brand_name : String?
    var created_at : String?
    var image : [Image]?
    var is_favourite : Bool?
    var size_name : String?
    var post_views : Int?
    var is_toppick : Int?
    var is_bump : Int?
    var is_hightlight : Int?
    var is_sale : Int?
    var is_profile_promote : Int?
    var sale_price : Float?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
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
    }
    
}


struct User_posts : Mappable {
    var id : Int?
    var title : String?
    var price : String?
    var price_type : String?
    var price_type_name : String?
    var brand_id : Int?
    var user_id : Int?
    var brand_name : String?
    var created_at : String?
    var image : [Image]?
    var is_favourite : Bool?
    var size_name : String?
    var post_views : Int?
    var is_toppick : Int?
    var is_bump : Int?
    var is_hightlight : Int?
    var is_sale : Int?
    var is_profile_promote : Int?
    var sale_price : Float?
    
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        price_type_name <- map["price_type_name"]
        id <- map["id"]
        title <- map["title"]
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
    
    func isfavourite () -> Bool {
        return is_favourite ?? false
    }
    
    
}


struct ImagesVideoModel: Mappable {
    var id : Int?
    var image : String?
    var image1 : UIImage?
    var video: String?
    var type: String?
    var videoId : String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        image1 <- map["image1"]
        id <- map["id"]
        image <- map["image"]
        video <- map["video"]
        videoId <- map["id"]
    }
    
}


