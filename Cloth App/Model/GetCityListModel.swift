//
//  GetCityListModel.swift
//  ClothApp
//
//  Created by Apple on 19/05/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct GetCityListModel :  Mappable {
    var predictions : [Predictions]?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        predictions <- map["predictions"]
        status <- map["status"]
    }
        
//        if let _ = try? map.value("predictions") as [T] {
//            predictions <- map["predictions"]
//        }
//        else {
//            predictions <- map["predictions"]
//        }
    }



struct Predictions : Mappable {
    var description : String?
    var matched_substrings : [Matched_substrings]?
    var place_id : String?
    var reference : String?
    var structured_formatting : Structured_formatting?
    var terms : [Terms]?
    var types : [String]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        description <- map["description"]
        matched_substrings <- map["matched_substrings"]
        place_id <- map["place_id"]
        reference <- map["reference"]
        structured_formatting <- map["structured_formatting"]
        terms <- map["terms"]
        types <- map["types"]
    }

}
struct Main_text_matched_substrings : Mappable {
    var length : Int?
    var offset : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        length <- map["length"]
        offset <- map["offset"]
    }

}
struct Matched_substrings : Mappable {
    var length : Int?
    var offset : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        length <- map["length"]
        offset <- map["offset"]
    }

}
struct Structured_formatting : Mappable {
    var main_text : String?
    var main_text_matched_substrings : [Main_text_matched_substrings]?
    var secondary_text : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        main_text <- map["main_text"]
        main_text_matched_substrings <- map["main_text_matched_substrings"]
        secondary_text <- map["secondary_text"]
    }

}
struct Terms : Mappable {
    var offset : Int?
    var value : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        offset <- map["offset"]
        value <- map["value"]
    }

}
