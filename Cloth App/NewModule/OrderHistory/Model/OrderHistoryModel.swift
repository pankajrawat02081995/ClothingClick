//
//  OrderHistoryModel.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 02/09/24.
//

import Foundation
import ObjectMapper

struct OrderHistoryModel : Mappable {
    var product : ProductDetails?
    var oderDetails :OrderDetails?
    var sellerDetails : SellerDetails?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        product <- map["product_details"]
        oderDetails <- map["order_details"]
        sellerDetails <- map["seller_details"]
    }
    
}

struct OrderDetails:Mappable{
    var id : Int?
    var seller_id : String?
    var buyer_id : String?
    var product_id : String?
    var tax : String?
    var total : String?
    var payment_mode : String?
    var transaction_id : String?
    var type_of_order : String?
    var status : String?
    var shipping_address_id : String?
    var created_at : String?
    var updated_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        seller_id <- map["seller_id"]
        buyer_id <- map["buyer_id"]
        product_id <- map["product_id"]
        type_of_order <- map["type_of_order"]
        tax <- map["tax"]
        total <- map["total"]
        payment_mode <- map["payment_mode"]
        transaction_id <- map["transaction_id"]
        status <- map["status"]
        shipping_address_id <- map["shipping_address_id"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
    }
}

struct SellerDetails:Mappable{
    var name : String?
    var image : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        image <- map["image"]
    }
}

struct ProductDetails:Mappable{
    var price : String?
    var title : String?
    var images : [ProudctImages]?
    var sizes : [String]?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        price <- map["price"]
        title <- map["title"]
        images <- map["images"]
        sizes <- map["sizes"]
    }
}

struct ProudctImages:Mappable{
    var id : Int?
    var image : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        image <- map["image"]
    }
}

//MARK: OrderDetails Model

struct OrderDetailsModel : Mappable {
    var product : ProductDetails?
    var oderDetails :OrderDetails?
    var sellerDetails : SellerDetails?
    var pickup_address : Pickup_address?
    var shipping_address : shipping_address?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        product <- map["product_details"]
        oderDetails <- map["order_details"]
        sellerDetails <- map["seller_details"]
        pickup_address <- map["pickup_address"]
        shipping_address <- map["shipping_address"]
    }
    
}

struct Pickup_address : Mappable {
    
    var id, userID: Int?
    var shopifyID, storeDescription, timings, address1: String?
    var address2, city, country: String?
    var coverImage, profileImage: String?
    var totalProducts, createdAt, updatedAt: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        userID <- map["user_id"]
        shopifyID <- map["shopify_id"]
        storeDescription <- map["store_description"]
        timings <- map["timings"]
        address1 <- map["address1"]
        address2 <- map["address2"]
        city <- map["city"]
        country <- map["country"]
        coverImage <- map["cover_image"]
        profileImage <- map["profile_image"]
        totalProducts <- map["total_products"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

struct shipping_address : Mappable {
    
    var id, userID: Int?
    var shopifyID,first_name,last_name, storeDescription, timings, address1: String?
    var address2, city, country: String?
    var coverImage, profileImage: String?
    var totalProducts, createdAt, updatedAt: String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        id <- map["id"]
        userID <- map["user_id"]
        shopifyID <- map["shopify_id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        storeDescription <- map["store_description"]
        timings <- map["timings"]
        address1 <- map["address"]
        address2 <- map["address2"]
        city <- map["city"]
        country <- map["country"]
        coverImage <- map["cover_image"]
        profileImage <- map["profile_image"]
        totalProducts <- map["total_products"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}
