//
//  Model.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 15/07/24.
//

import Foundation
import ObjectMapper

struct StyleModel:Mappable{
    
    var styles : [StyleModelList]?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        styles <- map["styles"]
    }
}

struct StyleModelList : Mappable {
    var name : String?
    var id : Int?
    var isActive : Bool?
    var idDelete : Bool?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        id <- map["id"]
        isActive <- map["is_active"]
        idDelete <- map["id_delete"]
    }
}
