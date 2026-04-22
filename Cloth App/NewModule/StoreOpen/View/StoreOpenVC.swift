//
//  StoreOpenVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 19/11/24.
//

import UIKit

class StoreOpenVC: UIViewController {
    //MARK: - @IBOutlets
    @IBOutlet weak var lblTodayUntil: UILabel!
    
    //MARK: - Variables
    var arrDays = [String]()
    var arrTime = [String]()
    var todaysTime = String()
    var timings: [String: [String: String]]?
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //        lblTodayUntil.text = todaysTime
        self.updateOpenCloseLabel(timings: timings ?? [:], label: self.lblTodayUntil)
    }
    
    func updateOpenCloseLabel(timings: [String: [String: String]], label: UILabel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let displayTimeFormatter = DateFormatter()
        displayTimeFormatter.dateFormat = "h:mm a"
        
        let calendar = Calendar.current
        let now = Date()
        
        let today = formatter.string(from: now)
        
        guard let todayTiming = timings[today],
              let openTimeStr = todayTiming["open"],
              let closeTimeStr = todayTiming["close"],
              let closeTime = timeFormatter.date(from: closeTimeStr) else {
            label.attributedText = colorText(fullText: "Closed", coloredWord: "Closed", color: .red)
            return
        }
        
        var closeDate = calendar.date(bySettingHour: calendar.component(.hour, from: closeTime),
                                      minute: calendar.component(.minute, from: closeTime),
                                      second: 0,
                                      of: now)!
        
        if now < closeDate {
            // Still open
            let closeDisplay = displayTimeFormatter.string(from: closeDate)
            let fullText = "Open until \(closeDisplay)"
            label.attributedText = colorText(fullText: fullText, coloredWord: "Open", color: .green)
        } else {
            // Closed, find next open day
            var nextDay = calendar.date(byAdding: .day, value: 1, to: now)!
            var nextDayName = formatter.string(from: nextDay)
            
            while timings[nextDayName] == nil {
                nextDay = calendar.date(byAdding: .day, value: 1, to: nextDay)!
                nextDayName = formatter.string(from: nextDay)
            }
            
            if let nextTiming = timings[nextDayName],
               let nextOpenTimeStr = nextTiming["open"],
               let nextOpenTime = timeFormatter.date(from: nextOpenTimeStr) {
                
                var openDate = calendar.date(bySettingHour: calendar.component(.hour, from: nextOpenTime),
                                             minute: calendar.component(.minute, from: nextOpenTime),
                                             second: 0,
                                             of: nextDay)!
                
                let openDisplay = displayTimeFormatter.string(from: openDate)
                let fullText = "Closed - Opens \(openDisplay)"
                label.attributedText = colorText(fullText: fullText, coloredWord: "Closed", color: .red)
            } else {
                label.attributedText = colorText(fullText: "Closed", coloredWord: "Closed", color: .red)
            }
        }
    }
    
    func colorText(fullText: String, coloredWord: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: coloredWord)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.foregroundColor, value: color, range: range)
        }
        
        return attributedString
    }
    
    //MARK: - @IBActions
    @IBAction func dismissOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}

extension StoreOpenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimingsTVC") as! TimingsTVC
        cell.lblDay.text = arrDays[indexPath.row]
        cell.lblTime.text = arrTime[indexPath.row]
        return cell
    }
}
