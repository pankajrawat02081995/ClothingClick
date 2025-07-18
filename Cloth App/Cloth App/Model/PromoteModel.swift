//
//  PromoteModel.swift
//  Cloth App
//
//  Created by Apple on 29/06/21.
//

import Foundation
import ObjectMapper
//"POST_TOP_PICK_COIN_IMG": null,
//    "POST_BUMP_COIN_IMG": null,
//    "POST_HIGHTLIGHT_COIN_IMG": null,
//    "POST_SALE_COIN_IMG": "https:\/\/apps.clothingclick.online\/uploads\/caches\/\/85_80\/img_sale_1645618050_20220223_717.png",
//    "POST_PROFILE_PROMOTE_COIN_IMG": null
struct PromoteModel : Mappable {
    var pOST_TOP_PICK_COIN : Int?
    var pOST_BUMP_COIN : Int?
    var pOST_HIGHTLIGHT_COIN : Int?
    var pOST_SALE_COIN : Int?
    var pOST_PROFILE_PROMOTE_COIN : Int?
    var pOST_TOP_PICK_COIN_DESC : String?
    var pOST_BUMP_COIN_DESC : String?
    var pOST_HIGHTLIGHT_COIN_DESC : String?
    var pOST_SALE_COIN_DESC : String?
    var pOST_PROFILE_PROMOTE_COIN_DESC : String?
    var pOST_TOP_PICK_COIN_IMG : String?
    var pOST_BUMP_COIN_IMG : String?
    var pOST_HIGHTLIGHT_COIN_IMG : String?
    var pOST_SALE_COIN_IMG : String?
    var pOST_PROFILE_PROMOTE_COIN_IMG : String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {

        pOST_TOP_PICK_COIN <- map["POST_TOP_PICK_COIN"]
        pOST_BUMP_COIN <- map["POST_BUMP_COIN"]
        pOST_HIGHTLIGHT_COIN <- map["POST_HIGHTLIGHT_COIN"]
        pOST_SALE_COIN <- map["POST_SALE_COIN"]
        pOST_PROFILE_PROMOTE_COIN <- map["POST_PROFILE_PROMOTE_COIN"]
        pOST_TOP_PICK_COIN_DESC <- map["POST_TOP_PICK_COIN_DESC"]
        pOST_BUMP_COIN_DESC <- map["POST_BUMP_COIN_DESC"]
        pOST_HIGHTLIGHT_COIN_DESC <- map["POST_HIGHTLIGHT_COIN_DESC"]
        pOST_SALE_COIN_DESC <- map["POST_SALE_COIN_DESC"]
        pOST_PROFILE_PROMOTE_COIN_DESC <- map["POST_PROFILE_PROMOTE_COIN_DESC"]
        pOST_TOP_PICK_COIN_IMG <- map["POST_TOP_PICK_COIN_IMG"]
        pOST_BUMP_COIN_IMG <- map["POST_BUMP_COIN_IMG"]
        pOST_HIGHTLIGHT_COIN_IMG <- map["POST_HIGHTLIGHT_COIN_IMG"]
        pOST_SALE_COIN_IMG <- map["POST_SALE_COIN_IMG"]
        pOST_PROFILE_PROMOTE_COIN_IMG <- map["POST_PROFILE_PROMOTE_COIN_IMG"]
    }
    
    func convertToCoins (is_toppick : Int?, is_bump : Int?,is_hightlight : Int?,is_sale : Int?,is_profile_promote : Int?) -> [Coins] {
        var conisList = [Coins]()
        conisList.append(getCoinObject(coins: pOST_TOP_PICK_COIN,description: pOST_TOP_PICK_COIN_DESC,title: "Top Picks",id: 1, color : "000000", sembolIcon : "Top-Picup-ic", semboltext : "T", promotImge : pOST_TOP_PICK_COIN_IMG, isSelected: is_toppick == 1))
        conisList.append(getCoinObject(coins: pOST_BUMP_COIN,description: pOST_BUMP_COIN_DESC,title: "Bump",id: 2, color : "25B83D", sembolIcon : "Bump-ic", semboltext : "B", promotImge : pOST_BUMP_COIN_IMG, isSelected: is_bump == 1))
        conisList.append(getCoinObject(coins: pOST_HIGHTLIGHT_COIN,description: pOST_HIGHTLIGHT_COIN_DESC,title: "Highlight",id: 3, color : "2D50DE", sembolIcon : "Highlight-ic", semboltext : "H", promotImge : pOST_HIGHTLIGHT_COIN_IMG, isSelected: is_hightlight == 1))
        conisList.append(getCoinObject(coins: pOST_SALE_COIN,description: pOST_SALE_COIN_DESC,title: "Sale",id: 4, color : "F80B0B", sembolIcon : "Sale-ic", semboltext : "S", promotImge : pOST_SALE_COIN_IMG, isSelected: is_sale == 1))
        conisList.append(getCoinObject(coins: pOST_PROFILE_PROMOTE_COIN,description: pOST_PROFILE_PROMOTE_COIN_DESC,title: "Profile Promote",id: 5, color : "6A25B8", sembolIcon : "ProfilePromote-ic", semboltext : "P", promotImge : pOST_PROFILE_PROMOTE_COIN_IMG, isSelected: is_profile_promote == 1))
        
        return conisList
    }
    
    func getCoinObject ( coins : Int?, description : String?, title :String, id : Int, color : String?, sembolIcon : String?, semboltext : String?, promotImge : String?, isSelected:Bool? ) -> Coins {
        let topPick = Coins()
        topPick.coins = coins
        topPick.description = description
        topPick.color = color
        topPick.sembolIcon = sembolIcon
        topPick.semboltext = semboltext
        topPick.promotImge = promotImge
        topPick.title = title
        topPick.id = id
        topPick.isSelected = isSelected ?? false
        return topPick
    }
    
}

class Coins {
    var id : Int?
    var title : String?
    var description : String?
    var color : String?
    var sembolIcon : String?
    var semboltext : String?
    var promotImge : String?
    var coins : Int?
    
    var isSelected : Bool = false
    
}
