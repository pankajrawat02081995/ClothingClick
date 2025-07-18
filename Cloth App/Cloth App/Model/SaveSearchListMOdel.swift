//
//  SaveSearchListMOdel.swift
//  Cloth App
//
//  Created by Apple on 12/06/21.
//

import Foundation
import ObjectMapper

struct SaveSearchListMOdel : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var save_searches : [Save_searches]?
    var posts : [Posts]?
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        save_searches <- map["save_searches"]
        posts <- map["posts"]
    }

}
struct Save_searches : Mappable {
    var id : Int?
    var name : String?
    var count : Int?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        count <- map["count"]
        name <- map["name"]
    }

}
