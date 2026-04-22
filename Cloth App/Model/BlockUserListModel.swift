//
//  BlockUserListModel.swift
//  Cloth App
//
//  Created by Apple on 25/06/21.
//

import Foundation
import ObjectMapper

struct BlockUserListModel : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var blocked_users : [Blocked_users]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        blocked_users <- map["blocked_users"]
    }

}

struct Blocked_users : Mappable {
    var user_id : Int?
    var name : String?
    var username : String?
    var image : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user_id <- map["user_id"]
        name <- map["name"]
        username <- map["username"]
        image <- map["image"]
    }

}
