//
//  EarnCoinModel.swift
//  Cloth App
//
//  Created by Apple on 13/07/21.
//

import Foundation
import ObjectMapper

struct EarnCoinModel : Mappable {
    var earn_coin_info : [Earn_coin_info]?
    var pREMIUM_PRICE : Double?
    var pREMIUM_FREE_TRAIL_DAYS : Int?
    var coins : [CoinsInfo]?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

        earn_coin_info <- map["earn_coin_info"]
        pREMIUM_PRICE <- map["PREMIUM_PRICE"]
        pREMIUM_FREE_TRAIL_DAYS <- map["PREMIUM_FREE_TRAIL_DAYS"]
        coins <- map["coins"]
    }
}


struct Earn_coin_info : Mappable {
    var title : String?
    var price : Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        title <- map["title"]
        price <- map["price"]
    }
}


struct CoinsInfo : Mappable {
    var id : Int?
    var name : String?
    var price : Double?
    var photo : String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        photo <- map["photo"]
    }

}
