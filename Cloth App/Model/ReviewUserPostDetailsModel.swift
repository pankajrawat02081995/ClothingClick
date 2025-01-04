//
//  ReviewUserPostDetailsModel.swift
//  Cloth App
//
//  Created by Apple on 30/07/21.
//

import Foundation
import ObjectMapper

struct ReviewUserPostDetailsModel : Mappable {
    var user : User_list?
    var post : Post?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        user <- map["user"]
        post <- map["post"]
    }

}
