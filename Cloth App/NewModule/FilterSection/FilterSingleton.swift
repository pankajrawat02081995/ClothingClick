//
//  FilterSingleton.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/10/24.
//

import Foundation

struct Filters:Codable{
    var is_mysize : String? = "0"
    var gender_id : String? = ""
    var categories : String? = ""
    var slectedCategories : String? = ""
    var sizes : String? = ""
    var colors : String? = ""
    var condition_id : String? = ""
    var distance : String? = ""
    var seller : String? = ""
    var is_only_count : String? = "1"
    var brand_id : String? = ""
    var price_type : String? = ""
    var price_from : String? = ""
    var price_to : String? = ""
    var sort_by : String? = ""
    var style : String? = ""
    var sort_value : String? = ""
    var page : String? = ""
}

struct FiltersSelectedData:Codable{
    var is_mysize : String? = "0"
    var gender_id : String? = ""
    var categories : String? = ""
    var sizes : String? = ""
    var colors : String? = ""
    var condition_id : String? = ""
    var distance : String? = ""
    var seller : String? = ""
    var is_only_count : String? = "1"
    var brand_id : String? = ""
    var price_type : String? = ""
    var price_from : String? = ""
    var price_to : String? = ""
    var sort_by : String? = ""
    var sort_value : String? = ""
    var style : String? = ""
    var page : String? = ""
}

class FilterSingleton {
    
    static let share = FilterSingleton()
    var filter = Filters()
    var selectedFilter = FiltersSelectedData()
    var genderSelection : Int?
    private init() {}
    
    func getFilterData(completion: @escaping ((ViewCountModel?) -> Void)) {
        guard var parameters = self.filter.toDictionary() else { return debugPrint("error") }
        
        parameters["latitude"] = appDelegate.userLocation?.latitude ?? ""
        parameters["longitude"] = appDelegate.userLocation?.longitude ?? ""
        APIManager().apiCallWithMultipart(of: ViewCountModel.self,
                                          isShowHud: true,
                                          URL: BASE_URL,
                                          apiName: APINAME.FILTER_POST.rawValue,
                                          parameters: parameters) { (response, error) in
            if let error = error {
                UIAlertController().alertViewWithTitleAndMessage(UIViewController(),
                                                                 message: error.domain)
            } else if let response = response, let data = response.dictData {
                completion(data)
            }
        }
    }
}

extension Encodable {
    func toDictionary() -> [String: Any]? {
        // Encode the Codable object into Data
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        // Convert the Data to a [String: Any] dictionary
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}


