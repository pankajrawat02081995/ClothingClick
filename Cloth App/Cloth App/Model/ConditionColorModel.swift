//
//  ConditionColorModel.swift
//  ClothApp
//
//  Created by Apple on 26/05/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct ConditionColorModel : Mappable {
//    var size : [Size]?
//    var conditions : [Conditions]?
//    var colors : [Colors]?
//    var price_types : [Price_types]?
//    var locations : [Locations]?
//
//    init?(map: Map) {
//
//    }
//
//    mutating func mapping(map: Map) {
//
//        size <- map["size"]
//        conditions <- map["conditions"]
//        colors <- map["colors"]
//        price_types <- map["price_types"]
//        locations <- map["locations"]
//    }
    var size : [Size]?
    var styles :[Styles]?
    var group_size : [Categories]?
    var conditions : [Conditions]?
    var colors : [Colors]?
    var price_types : [Price_types]?
    var locations : [Locations]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        size <- map["size"]
        styles <- map["styles"]
        group_size <- map["group_size"]
        conditions <- map["conditions"]
        colors <- map["colors"]
        price_types <- map["price_types"]
        locations <- map["locations"]
    }

}

struct Size : Mappable {
    var id : Int?
    var name : String?
    var isSelect : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}
struct Seller {
    var id : Int?
    var name : String?
    var isSelect : Bool?
}

struct Conditions : Mappable {
    var id : Int?
    var name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}

struct Colors : Mappable {
    var id : Int?
    var name : String?
    var colorcode : String?
    var photo : String?
    var isSelect : Bool?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        colorcode <- map["colorcode"]
        photo <- map["photo"]

    }

}

struct Price_types : Mappable {
    var id : Int?
    var name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}

struct Group_size : Mappable {
    var name : String?
    var image : String?
    var sizes : [Sizes]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        name <- map["name"]
        image <- map["image"]
        sizes <- map["sizes"]
    }

}
