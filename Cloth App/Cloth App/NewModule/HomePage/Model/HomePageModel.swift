//
//  HomePageModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/05/24.
//

import Foundation
import ObjectMapper

struct HomePageModel : Mappable {
    var status : Int?
    var message : String?
    var responseData : ResponseData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
        responseData <- map["response"]
    }
    
}

struct ResponseData : Mappable {
    var currentPage : Int?
    var hasMorePages : Bool?
    var posts : [Posts]?
    var unread_notification : Int?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        currentPage <- map["currentPage"]
        hasMorePages <- map["hasMorePages"]
        posts <- map["posts"]
        unread_notification <- map["unread_notification"]
    }
    
}


struct HomePageCatModel : Mappable {
    var status : Int?
    var message : String?
    var responseData : [CategoriesListModel]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
        responseData <- map["response"]
    }
    
}

struct CategoriesListModel : Mappable {
    var categories : [CategoriesList]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        categories <- map["categories"]
    }
    
}

struct CategoriesList:Mappable{
    var id : Int?
    var name : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
    }
}
