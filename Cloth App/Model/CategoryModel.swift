//
//  CategoryModel.swift
//  ClothApp
//
//  Created by Apple on 28/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct CategoryModel : Mappable {
    var gender_id : Int?
    var name : String?
    var categories : [Categorie]?
    var styles : [Styles]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        styles <- map["styles"]
        gender_id <- map["gender_id"]
        name <- map["name"]
        categories <- map["categories"]
    }
}

struct Categorie : Mappable {
    var category_id : Int?
    var name : String?
    var photo : String?
    var childCategories : [ChildCategories]?
    var isSelect : Bool?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        category_id <- map["category_id"]
        photo <- map["photo"]
        name <- map["name"]
        childCategories <- map["childCategories"]
    }
    
    

}

struct Styles : Mappable {
    var id : Int?
    var name : String?
    
    init?(map: Map) {

    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

struct ChildCategories : Mappable,Equatable {
    var id : Int?
    var mainid : String?
    var name : String?
    var parent_id : Int?
    var child_categories : [String]?
    var isSelect : Bool?
    
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        mainid <- map["id"]
        name <- map["name"]
        parent_id <- map["parent_id"]
        child_categories <- map["child_categories"]
    }
    
    // Conformance to Equatable
        static func == (lhs: ChildCategories, rhs: ChildCategories) -> Bool {
            return lhs.id == rhs.id
        }

}
