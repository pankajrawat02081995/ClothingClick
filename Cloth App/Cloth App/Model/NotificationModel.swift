//
//  NotificationModel.swift
//  Cloth App
//
//  Created by Apple on 16/07/21.
//

import Foundation
import ObjectMapper

struct NotificationModel : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var notifications : [Notifications]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        notifications <- map["notifications"]
    }

}

struct Notifications : Mappable {
    var id : Int?
    var type : String?
    var title : String?
    var message : String?
    var is_read : Int?
    var created_at : String?
    var post_image : [Image]?
    var post_title : String?
    var category : String?
    var post_size : [Sizes]?
    var post_brand : String?
    var post_price : Int?
    var post_desc : String?
    var name : String?
    var username : String?
    var user_photo : String?
    var post_id : Int?
    var seller_id : Int?
    var earned_coin : String?
    var user_id : Int?
    var follow_request_id : Int?
    var save_search_id : Int?
    var save_search_name : String?
    var role_id : Int?
    var sender_user_id : Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        type <- map["type"]
        title <- map["title"]
        message <- map["message"]
        is_read <- map["is_read"]
        created_at <- map["created_at"]
        category <- map["category"]
        post_image <- map["post_image"]
        post_title <- map["post_title"]
        post_size <- map["post_size"]
        post_brand <- map["post_brand"]
        post_price <- map["post_price"]
        post_desc <- map["post_desc"]
        name <- map["name"]
        username <- map["username"]
        user_photo <- map["user_photo"]
        post_id <- map["post_id"]
        seller_id <- map["seller_id"]
        earned_coin <- map["earned_coin"]
        user_id <- map["user_id"]
        follow_request_id <- map ["follow_request_id"]
        save_search_id <- map ["save_search_id"]
        save_search_name <- map ["save_search_name"]
        role_id <- map ["role_id"]
        sender_user_id <- map["sender_user_id"]
    }

}
