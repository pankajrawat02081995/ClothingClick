//
//  MessageDetailsModel.swift
//  Cloth App
//
//  Created by Apple on 06/07/21.
//

import Foundation
import ObjectMapper

struct MessageDetailsModel : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var post_id : Int?
    var post_user_id : Int?
    var post_brand : String?
    var post_name : String?
    var post_image : [Image]?
    var post_size : [String]?
    var price_type : String?
    var price_type_name : String?
    var post_price : String?
    var seller : SellerMessage?
    var buyer : SellerMessage?
    var receiver_id : Int?
    var messages : [Messages]?

    init?(map: Map) {
    }

    func getHeaderDeatils() -> SellerMessage? {
        if appDelegate.userDetails?.id == post_user_id {
            return buyer
        }
        else {
            return seller
        }
        
    }
    
    mutating func mapping(map: Map) {
        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        post_id <- map["post_id"]
        price_type <- map["price_type"]
        price_type_name <- map["price_type_name"]
        post_user_id <- map["post_user_id"]
        post_brand <- map["post_brand"]
        post_name <- map["post_name"]
        post_image <- map["post_image"]
        post_size <- map["post_size"]
        post_price <- map["post_price"]
        seller <- map["seller"]
        buyer <- map["buyer"]
        receiver_id <- map["receiver_id"]
        messages <- map["messages"]
    }
}

struct Messages : Mappable {
    var id : Int?
    var sender_user_id : Int?
    var post_user_id : Int?
    var receiver_user_id : Int?
    var message : String?
    var file : String?
    var thumbnail : String?
    var is_read : Int?
    var created_at : String?
    var post_id : Int?
    var post_brand : String?
    var post_name : String?
    var post_image : [Image]?
    var post_size : [String]?
    var type : String?
    var username : String?
    var user_profile_picture : String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        thumbnail <- map["thumbnail"]
        sender_user_id <- map["sender_user_id"]
        post_user_id <- map["post_user_id"]
        type <- map["type"]
        receiver_user_id <- map["receiver_user_id"]
        message <- map["message"]
        file <- map["file"]
        is_read <- map["is_read"]
        created_at <- map["created_at"]
        post_id <- map["post_id"]
        post_brand <- map["post_brand"]
        post_name <- map["post_name"]
        post_image <- map["post_image"]
        post_size <- map["post_size"]
        username <- map["username"]
        user_profile_picture <- map["user_profile_picture"]
    }
    
    func isReadMessge() -> Bool {
        return is_read == 1
    }
}

struct SellerMessage : Mappable {
    var username : String?
    var user_profile_picture : String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        username <- map["username"]
        user_profile_picture <- map["user_profile_picture"]
    }

}
