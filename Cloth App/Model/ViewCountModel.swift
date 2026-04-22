//
//  ViewCountModel.swift
//  Cloth App
//
//  Created by Apple on 17/06/21.
//

import Foundation
import ObjectMapper

struct ViewCountModel : Mappable {
    var total_posts : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        total_posts <- map["total_posts"]
    }

}
