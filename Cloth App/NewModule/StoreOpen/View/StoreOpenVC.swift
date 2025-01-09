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
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTodayUntil.text = todaysTime
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
