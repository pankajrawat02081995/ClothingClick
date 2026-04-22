//
//  FollowRequestsModel.swift
//  Cloth App
//
//  Created by Apple on 17/06/21.
//

import Foundation
import ObjectMapper

struct FollowRequestsModel : Mappable {
    var totalFollowRequests : Int?
    var currentPage : Int?
    var hasMorePages : Bool?
    var followRequests : [FollowRequests]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        totalFollowRequests <- map["totalFollowRequests"]
        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        followRequests <- map["FollowRequests"]
        
    }

}
struct FollowRequests : Mappable {
    var id : Int?
    var user_id : Int?
    var name : String?
    var username : String?
    var photo : String?
    var role_id : Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        name <- map["name"]
        username <- map["username"]
        photo <- map["photo"]
        role_id <- map["role_id"]
    }

}
