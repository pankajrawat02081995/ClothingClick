//
//  MessgasModel.swift
//  Cloth App
//
//  Created by Apple on 06/07/21.
//

import Foundation
import ObjectMapper

struct MessgasModel : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var selling_not_read : Int?
    var buying_not_read : Int?
    
    var messages : [Messages]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        selling_not_read <- map["selling_not_read"]
        buying_not_read <- map["buying_not_read"]
        messages <- map["messages"]
    }

}
