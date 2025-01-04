//
//  FaqModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/06/24.
//

import Foundation
import ObjectMapper

struct FaqModel:Mappable{
    
    var faq : [FaqModelData]?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        faq <- map["faqs"]
    }
}

struct FaqModelData :Mappable{
    var question : String?
    var answer : String?
    
    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        question <- map["question"]
        answer <- map["answer"]
    }
}
