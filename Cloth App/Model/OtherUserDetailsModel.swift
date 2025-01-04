
//
//  OtherUserDetailsModel.swift
//  Cloth App
//
//  Created by Apple on 18/06/21.
//

import Foundation
import ObjectMapper

struct OtherUserDetailsModel : Mappable {
    var id : Int?
    var role_id : Int?
    var name : String?
    var email : String?
    var username : String?
    var country_code : String?
    var country_prefix : String?
    var phone : String?
    var phone_verified_at : String?
    var website : String?
    var bio : String?
    var photo : String?
    var user_selected_gender : Int?
    var is_active : Int?
    var is_private : Int?
    var is_findlocation_on : Int?
    var created_at : String?
    var gender_name : String?
    var totalFollowings : Int?
    var totalFollowers : Int?
    var totalPosts : Int?
    var avg_rating : Float?
    var total_reviews : Int?
    var tabs : [Tabs]?
    var locations : [Locations]?
    var is_sent_follow_request : Bool?
    var follow_request_id : Int?
    var is_following : Int?
    var is_requested : Int?
    var is_phone_show : String?
    var is_email_show : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        role_id <- map["role_id"]
        name <- map["name"]
        email <- map["email"]
        username <- map["username"]
        country_code <- map["country_code"]
        country_prefix <- map["country_prefix"]
        phone <- map["phone"]
        phone_verified_at <- map["phone_verified_at"]
        website <- map["website"]
        bio <- map["bio"]
        photo <- map["photo"]
        user_selected_gender <- map["user_selected_gender"]
        is_active <- map["is_active"]
        is_private <- map["is_private"]
        is_findlocation_on <- map["is_findlocation_on"]
        created_at <- map["created_at"]
        gender_name <- map["gender_name"]
        totalFollowings <- map["totalFollowings"]
        totalFollowers <- map["totalFollowers"]
        totalPosts <- map["totalPosts"]
        avg_rating <- map["avg_rating"]
        total_reviews <- map["total_reviews"]
        tabs <- map["tabs"]
        locations <- map["locations"]
        is_sent_follow_request <- map["is_sent_follow_request"]
        follow_request_id <- map["follow_request_id"]
        is_following <- map["is_following"]
        is_requested <- map["is_requested"]
        is_phone_show <- map["is_phone_show"]
        is_email_show <- map["is_email_show"]
    }
    
    func isEmailShow () -> Bool{
        let isEmail = is_email_show == "1"
        return isEmail
    }
    func isPhoneShow () -> Bool{
        let isPhone = is_phone_show == "1"
        return isPhone
    }

}

struct Tabs : Mappable {
    var type : Int?
    var name : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        type <- map["type"]
        name <- map["name"]
    }
    
}
