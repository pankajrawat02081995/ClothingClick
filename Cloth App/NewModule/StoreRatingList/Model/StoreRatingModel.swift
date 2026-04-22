//
//  StoreRatingModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 23/05/25.
//

import Foundation


import ObjectMapper

struct StoreRatingModel : Mappable {
    var count : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        count <- map["count"]
    }

}
