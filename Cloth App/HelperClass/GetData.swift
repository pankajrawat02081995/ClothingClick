//
//  GetData.swift
//  Cloth App
//
//  Created by Radhika Anand on 09/01/25.
//

import UIKit

class GetData{
    
    static let shared = GetData()
    
    func convertTo12HourFormat(_ time: String) -> String? {
        let dateFormatter24 = DateFormatter()
        dateFormatter24.dateFormat = "HH:mm"  // 24-hour format

        if let date = dateFormatter24.date(from: time) {
            let dateFormatter12 = DateFormatter()
            dateFormatter12.dateFormat = "h:mm a"  // 12-hour format with AM/PM
            return dateFormatter12.string(from: date)
        }
        return nil
    }
    
    func getTodayCloseTime(for timings: [String: [String: String]]) -> String? {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())  // Sunday = 1, Monday = 2, ..., Saturday = 7
        
        let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        let today = daysOfWeek[weekday - 1]
        
        if let closeTime = timings[today]?["close"] {
            return convertTo12HourFormat(closeTime)
        }
        return nil
    }
}
