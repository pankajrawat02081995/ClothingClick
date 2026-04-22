//
//  CreditCardModel.swift
//  Cloth App
//
//  Created by Apple on 02/09/21.
//

import Foundation
import ObjectMapper

struct CreditCardModel : Mappable {
    var id : Int?
    var user_id : Int?
    var name : String?
    var brand : String?
    var last_four : String?
    var exp_year : String?
    var exp_month : String?
    var created_at : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        name <- map["name"]
        brand <- map["brand"]
        last_four <- map["last_four"]
        exp_year <- map["exp_year"]
        exp_month <- map["exp_month"]
        created_at <- map["created_at"]
    }

}
