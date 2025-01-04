//
//  MySizeModel.swift
//  ClothApp
//
//  Created by Apple on 29/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct MySizeModel : Mappable {
    var gender_id : Int?
    var gender_name : String?
    var categories : [Categories]?

    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        gender_id <- map["gender_id"]
        gender_name <- map["gender_name"]
        categories <- map["categories"]
    }
    
}

struct Categories : Mappable {
    var id : Int?
    var name : String?
    var image : String?
    var sizes : [Sizes]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image <- map["image"]
        sizes <- map["sizes"]
    }

}

struct Sizes : Mappable {
    var id : Int?
    var name : String?
    var isSelect : Bool? //= false

    init?(map: Map) {
    }
    mutating func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }
}


struct BrandeSearchModel : Mappable {
    var brand_id : Int?
    var name : String?
    var photo : String?
    var image: String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        brand_id <- map["brand_id"]
        name <- map["name"]
        photo <- map["photo"]
        image <- map["image"]
    }

}
