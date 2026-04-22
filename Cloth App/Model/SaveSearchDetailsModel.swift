//
//  SaveSearchDetailsModel.swift
//  Cloth App
//
//  Created by Apple on 12/06/21.
//

import Foundation
import ObjectMapper

struct SaveSearchDetailsModel : Mappable {
    var id : Int?
    var user_id : Int?
    var name : String?
    var is_mysize : Int?
    var seller : String?
    var gender_id : Int?
    var brand_id : Int?
    var condition_id : Int?
    var sizes : [Sizes]?
    var categories : [Categories]?
    var colors : [Colors]?
    var distance : String?
    var price_type : Int?
    var price_from : String?
    var style_name : String?
    var style : String?
    var price_to : String?
    var notification_item_counter : Int?
    var created_at : String?
    var gender_name : String?
    var condition_name : String?
    var brand_name : String?
    var price_type_name : String?
    var seller_name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        style_name <- map["style_name"]
        style <- map["style"]
        name <- map["name"]
        is_mysize <- map["is_mysize"]
        seller <- map["seller"]
        gender_id <- map["gender_id"]
        brand_id <- map["brand_id"]
        condition_id <- map["condition_id"]
        sizes <- map["sizes"]
        categories <- map["categories"]
        colors <- map["colors"]
        distance <- map["distance"]
        price_type <- map["price_type"]
        price_from <- map["price_from"]
        price_to <- map["price_to"]
        notification_item_counter <- map["notification_item_counter"]
        created_at <- map["created_at"]
        gender_name <- map["gender_name"]
        condition_name <- map["condition_name"]
        brand_name <- map["brand_name"]
        price_type_name <- map["price_type_name"]
        seller_name <- map["seller_name"]
    }

}
