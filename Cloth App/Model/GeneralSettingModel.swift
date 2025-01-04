//
//  GeneralSettingModel.swift
//  RaniCircle
//
//  Created by Apple on 06/10/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct GeneralSettingModel : Mappable {
    var terms_conditions : String?
    var privacy_policy : String?
    var about_us : String?
    var facebook : String?
    var instagram : String?
    var twitter : String?
    var youtube : String?
    var tiktok : String?
    var snapchat : String?
    var additional_store_location_rate : String?
    var additional_brand_location_rate : String?
    var cities : [Cities]?
    var is_show_access_code_screen :Int?
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        terms_conditions <- map["terms_conditions"]
        privacy_policy <- map["privacy_policy"]
        about_us <- map["about_us"]
        facebook <- map["facebook"]
        instagram <- map["instagram"]
        twitter <- map["twitter"]
        youtube <- map["youtube"]
        tiktok <- map["tiktok"]
        snapchat <- map["snapchat"]
        additional_store_location_rate <- map["additional_store_location_rate"]
        additional_brand_location_rate <- map["additional_brand_location_rate"]
        cities <- map["cities"]
        is_show_access_code_screen <- map["is_show_access_code_screen"]
    }

    struct Cities : Mappable {
        var id : Int?
        var name : String?

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {

            id <- map["id"]
            name <- map["name"]
        }

    }

}
