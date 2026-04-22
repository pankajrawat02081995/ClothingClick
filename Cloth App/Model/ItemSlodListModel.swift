//
//  ItemSlodListModel.swift
//  Cloth App
//
//  Created by Apple on 14/07/21.
//

import Foundation
import ObjectMapper

struct ItemSlodListModel : Mappable {
    var post : Post?
    var user_list : [User_list]?
    var total_sold_items : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        post <- map["post"]
        user_list <- map["user_list"]
        total_sold_items <- map["total_sold_items"]
    }

}
struct Post : Mappable {
    var id : Int?
    var name : String?
    var brand_name : String?
    var photo : [Image]?
    var size : [String]?
    var price : Int?
    var price_type : String?
    var price_type_name : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        brand_name <- map["brand_name"]
        photo <- map["photo"]
        size <- map["size"]
        price <- map["price"]
        price_type <- map["price_type"]
        price_type_name <- map["price_type_name"]
    }

}
struct User_list : Mappable {
    var id : Int?
    var name : String?
    var username : String?
    var photo : String?
    var avg_review : Float?
    var total_reviews : Int?
    var total_posts : Int?
    var location : Locations?
    var user_type_name : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        user_type_name <- map["user_type_name"]
        id <- map["id"]
        total_reviews <- map["total_reviews"]
        name <- map["name"]
        username <- map["username"]
        photo <- map["photo"]
        avg_review <- map["avg_review"]
        total_posts <- map["total_posts"]
        location <- map["location"]
    }

}
