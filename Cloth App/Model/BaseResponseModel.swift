//
//  BaseResponseModel.swift
//  RaniCircle
//
//  Created by Apple on 30/09/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import Foundation
import ObjectMapper

struct BaseResponseModel<T> : Mappable where T:Mappable {
    var arrayData : [T]?
    var dictData : T?
    var message : String?
    var status : Int? 

    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]

        if let _ = try? map.value("response") as [T] {
           arrayData <- map["response"]
        }
        else {
           dictData <- map["response"]
        }
    }
}
