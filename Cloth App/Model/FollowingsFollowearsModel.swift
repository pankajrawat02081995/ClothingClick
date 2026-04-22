//
//  FollowingsFollowearsModel.swift
//  ClothApp
//
//  Created by Apple on 17/05/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct FollowingsFollowearsModel : Mappable {
    var totalFollowings : Int?
    var totalFollowers : Int?
    var totalFollowRequests : Int?
    var currentPage : Int?
    var hasMorePages : Bool?
    var followings : [FollowingsFollowearModel]?
    var followears : [FollowingsFollowearModel]?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        totalFollowings <- map["totalFollowings"]
        totalFollowers <- map["totalFollowers"]
        totalFollowRequests <- map["totalFollowRequests"]
        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        followings <- map["followings"]
        followears <- map["followers"]
    }

}

struct FollowingsFollowearModel : Mappable {
    var user_id : Int?
    var name : String?
    var username : String?
    var followers : Int?
    var photo : String?
    var is_following : Int?
    var is_requested : Int?
    var total_posts : Int?
    var role_id : Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user_id <- map["user_id"]
        followers <- map["followers"]
        total_posts <- map["total_posts"]
        name <- map["name"]
        username <- map["username"]
        photo <- map["photo"]
        is_following <- map["is_following"]
        is_requested <- map["is_requested"]
        role_id <- map["role_id"]
    }

}
