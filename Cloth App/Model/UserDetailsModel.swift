//
//  UserDetailsModel.swift
//  Ashton
//
//  Created by Apple on 29/10/20.
//  Copyright © 2020 Sagar Nandha. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserLocation{
    var address : String?
    var city : String?
    var area : String?
    var postal_code : String?
    var latitude : String?
    var longitude : String?
}

struct UserDetailsModel : Mappable {
    var name : String?
    var email : String?
    var username : String?
    var role_id : Int?
    var facebook_id : String?
    var instagram_id : String?
    var google_id : String?
    var twitter_id : String?
    var apple_id : String?
    var email_verified_at : String?
    var id : Int?
    var token : String?
    var is_first_login : Bool?
    var phone : String?
    var phone_verified_at : String?
    var photo : String?
    var user_selected_gender : Int?
    var is_active : Int?
    var is_private : Int?
    var created_at : String?
    var gender_name : String?
    var user_size : [Int]?
    var user_favourite_brand : [BrandeSearchModel]?
    var locations : [Locations]?
    var country_code : String?
    var country_prefix : String?
    var notificationSetting : NotificationSetting?
    var otp : String?
    var website : String?
    var bio : String?
    var is_findlocation_on : Int?
    var totalFollowings : Int?
    var totalFollowers : Int?
    var totalPosts : Int?
    var avg_rating : Float?
    var joined_at : String?
    var total_reviews : Int?
    var coins : Int?
    var cover_image : String?
    var tabs : [Tabs]?
    var is_chat : Int?
    var is_order : Int?
    var total_unread_notifications : Int?
    var is_sent_follow_request : Bool?
    var follow_request_id : Int?
    var is_premium_user : Int?
    var premium_end_at : String?
    var is_premium_activated : Int?
    var is_phone_show : String?
    var is_email_show : String?
    var is_requested : Int?
    var is_following : Int?
    var storeDetail : Pickup_address?
    var total_positive_review : Int?
    var user_sizes_details : [String]?
    init?(map: Map) {
    }
    
    
    func getUserDisplayName () -> String {
        return username ?? ""
    }

    mutating func mapping(map: Map) {
        
        user_sizes_details <- map["user_sizes_details"]
        storeDetail <- map["store_details"]
        name <- map["name"]
        email <- map["email"]
        username <- map["username"]
        role_id <- map["role_id"]
        cover_image <- map["cover_image"]
        facebook_id <- map["facebook_id"]
        instagram_id <- map["instagram_id"]
        google_id <- map["google_id"]
        twitter_id <- map["twitter_id"]
        apple_id <- map["apple_id"]
        email_verified_at <- map["email_verified_at"]
        id <- map["id"]
        joined_at <- map["joined_at"]
        token <- map["token"]
        phone <- map["phone"]
        phone_verified_at <- map["phone_verified_at"]
        photo <- map["photo"]
        user_selected_gender <- map["user_selected_gender"]
        is_active <- map["is_active"]
        is_private <- map["is_private"]
        created_at <- map["created_at"]
        gender_name <- map["gender_name"]
        user_size <- map["user_size"]
        total_positive_review <- map["total_positive_review"]
        user_favourite_brand <- map["user_favourite_brand"]
        locations <- map["locations"]
        country_code <- map["country_code"]
        country_prefix <- map["country_prefix"]
        notificationSetting <- map["notificationSetting"]
        otp <- map["otp"]
        website <- map["website"]
        bio <- map["bio"]
        is_findlocation_on <- map["is_findlocation_on"]
        totalFollowings <- map["totalFollowings"]
        totalFollowers <- map["totalFollowers"]
        totalPosts <- map["totalPosts"]
        avg_rating <- map["avg_rating"]
        total_reviews <- map["total_reviews"]
        coins <- map["coins"]
        tabs <- map["tabs"]
        is_chat <- map["is_chat"]
        is_order <- map["is_order"]
        total_unread_notifications <- map["total_unread_notifications"]
        is_sent_follow_request <- map["is_sent_follow_request"]
        follow_request_id <- map["follow_request_id"]
        is_premium_user <- map["is_premium_user"]
        premium_end_at <- map["premium_end_at"]
        is_premium_activated <- map["is_premium_activated"]
        is_phone_show <- map["is_phone_show"]
        is_email_show <- map["is_email_show"]
        is_requested <- map["is_requested"]
        is_following <- map["is_following"]
    }
    func isEmailShow () -> Bool{
        let isEmail = is_email_show == "1"
        return isEmail
    }
    func isPhoneShow () -> Bool{
        let isPhone = is_phone_show == "1"
        return isPhone
    }
    func isChatOnOff () -> Bool {
        let isVisible = is_chat == 1
        return isVisible
    }
    func isFindlocation () -> Bool {
        let isVisible = is_findlocation_on == 1
        return isVisible
    }
    func isOrderOnOff () -> Bool {
        let isVisible = is_order == 1
        return isVisible
    }
    func isAccountPrivetOnOff () -> Bool {
        let isVisible = is_private == 1
        return isVisible
    }
    func isFaceBookVerifid() -> String {
        let isverifid = facebook_id ?? ""
        return isverifid
    }
    func isGoogleVerifid() -> String {
        let isverifid = google_id ?? ""
        return isverifid
    }
    func isTwitterVerifid() -> String {
        let isverifid = twitter_id ?? ""
        return isverifid
    }
    func isAppleVerifid() -> String {
        let isverifid = apple_id ?? ""
        return isverifid
    }
    func isEmailVerifid() -> String {
        let isverifid = email_verified_at ?? ""
        return isverifid
    }
    func isPrivate() -> Bool {
        let isPrivate = is_private == 1
        return isPrivate
    }
}

struct Locations : Mappable {
    var id : Int?
    var address : String?
    var city : String?
    var area : String?
    var postal_code : String?
    var latitude : String?
    var longitude : String?
    var is_default : Int?
    var is_Selected : Bool?
    var is_paid : Int?
    var price : Int?
    var expire_at : String?
    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        id <- map["id"]
        address <- map["address"]
        city <- map["city"]
        area <- map["area"]
        postal_code <- map["postal_code"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        is_default <- map["is_default"]
        is_paid <- map["is_paid"]
        price <- map ["price"]
        expire_at <- map ["expire_at"]
    }
    
    func isPaidPrise () -> Int {
        let isPaid = price
        return isPaid ?? 0
    }
    
    func isSelectedAddress () -> Bool {
        let isVisible = is_default == 1
        return isVisible
    }

    func isPayAddress () -> Bool{
        let ispaid = is_paid == 1
        return ispaid 
    }
    
}
struct User_favourite_brand : Mappable {
    var brand_id : Int?
    var name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        brand_id <- map["brand_id"]
        name <- map["name"]
    }

}

struct NotificationSetting : Mappable {
    var is_all : Int?
    var is_save_search : Int?
    var is_chat : Int?
    var is_follower : Int?
    var is_rating : Int?
    var is_watchlist : Int?
    var is_coin : Int?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

        is_all <- map["is_all"]
        is_save_search <- map["is_save_search"]
        is_chat <- map["is_chat"]
        is_follower <- map["is_follower"]
        is_rating <- map["is_rating"]
        is_watchlist <- map["is_watchlist"]
        is_coin <- map["is_coin"]
    }
    
    func isAllNotificationOnOff () -> Bool {
        let isVisible = is_all == 1
        return isVisible
    }
    func isSaveCearchOnOff () -> Bool {
        let isVisible = is_save_search == 1
        return isVisible
    }
    func isChatOnOff () -> Bool {
        let isVisible = is_chat == 1
        return isVisible
    }
    func isFollowerOnOff () -> Bool {
        let isVisible = is_follower == 1
        return isVisible
    }
    func isWarchListOnOff () -> Bool {
        let isVisible = is_watchlist == 1
        return isVisible
    }
    func isCoinOnOff () -> Bool {
        let isVisible = is_coin == 1
        return isVisible
    }
    func isRatingOnOff () -> Bool {
        let isVisible = is_rating == 1
        return isVisible
    }
}

class Human{
    var isDefected:Bool? = false
    var hairColor:String? = "red"
    var eyeColor:String?="blue"
    func getHairClor() -> String?{
        return hairColor
    }
}

class Man:Human{
    
}
