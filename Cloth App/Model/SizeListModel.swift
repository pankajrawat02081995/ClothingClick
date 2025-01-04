//
//  SizeListModel.swift
//  ClothApp
//
//  Created by Apple on 29/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct SizeListModel : Mappable {
    var footwear : [Footwear]?
    var tops : [Tops]?
    var outerwear : [Outerwear]?
    var bottoms : [Bottoms]?
    var jeans : [Jeans]?
    var dresses : [Dresses]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        footwear <- map["Footwear"]
        tops <- map["Tops"]
        outerwear <- map["Outerwear"]
        bottoms <- map["Bottoms"]
        jeans <- map["Jeans"]
        dresses <- map["Dresses"]
    }

    struct Footwear : Mappable {
        var sid : Int?
        var category_id : Int?
        var sname : Int?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            sid <- map["sid"]
            category_id <- map["category_id"]
            sname <- map["sname"]
        }
    }
    
    struct Tops : Mappable {
        var sid : Int?
        var category_id : Int?
        var sname : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            sid <- map["sid"]
            category_id <- map["category_id"]
            sname <- map["sname"]
        }

    }
    
    struct Outerwear : Mappable {
        var sid : Int?
        var category_id : Int?
        var sname : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            sid <- map["sid"]
            category_id <- map["category_id"]
            sname <- map["sname"]
        }

    }
    
    struct Bottoms : Mappable {
        var sid : Int?
        var category_id : Int?
        var sname : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            sid <- map["sid"]
            category_id <- map["category_id"]
            sname <- map["sname"]
        }

    }
    
    struct Jeans : Mappable {
        var sid : Int?
        var category_id : Int?
        var sname : Int?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            sid <- map["sid"]
            category_id <- map["category_id"]
            sname <- map["sname"]
        }

    }

    struct Dresses : Mappable {
        var sid : Int?
        var category_id : Int?
        var sname : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            sid <- map["sid"]
            category_id <- map["category_id"]
            sname <- map["sname"]
        }

    }


}
