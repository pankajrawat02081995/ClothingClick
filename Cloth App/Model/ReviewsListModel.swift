//
//  ReviewsListModel.swift
//  Cloth App
//
//  Created by Apple on 13/07/21.
//

import Foundation
import ObjectMapper

struct ReviewsListModel : Mappable {
    var total_buyer_review : Int?
    var total_seller_review : Int?
    var currentPage : Int?
    var hasMorePages : Bool?
    var reviews : [Reviews]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total_buyer_review <- map["total_buyer_review"]
        total_seller_review <- map["total_seller_review"]
        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        reviews <- map["reviews"]
    }

}
struct Reviews : Mappable {
    var id : Int?
    var review_by : Int?
    var rating : Int?
    var review : String?
    var created_at : String?
    var review_by_name : String?
    var review_by_photo : String?
    var photo : [Photo]?
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        photo <- map["photo"]
        review_by_name <- map["review_by_name"]
        review_by_photo <- map["review_by_photo"]
        review_by <- map["review_by"]
        rating <- map["rating"]
        review <- map["review"]
        created_at <- map["created_at"]
    }

}

struct Photo : Mappable {
    var id : Int?
    var image : String?
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        image <- map["image"]
    }

}
