//
//  SortVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 20/10/24.
//

import UIKit
import IBAnimatable
class SortVC: UIViewController {

    @IBOutlet weak var btnCount: AnimatableButton!
    @IBOutlet weak var tableView: UITableView!
    
    let indexData = [["title":"Date: New - Old","sort_by":"date","sort_value":"desc"],["title":"Date: Old - New","sort_by":"date","sort_value":"asc"],["title":"Price: Low - High","sort_by":"price","sort_value":"asc"],["title":"Price: High - Low","sort_by":"price","sort_value":"desc"],["title":"Trending","sort_by":"trending","sort_value":"desc"]]
    
    var isSaveSearch : Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        if self.isFilterProduct == true{
            self.btnCount.setTitle("Add", for: .normal)
        }else{
            if self.isSaveSearch == true{
                //            if FilterSingleton.share.filter.sort_by?.isEmpty == true || FilterSingleton.share.filter.sort_by == nil{
                //                self.btnCount.alpha = 0.5
                //                self.btnCount.isUserInteractionEnabled = false
                //            }else{
                self.btnCount.alpha = 1
                self.btnCount.isUserInteractionEnabled = true
                //            }
                self.btnCount.setTitle("Add to saved Search", for: .normal)
            }else{
                self.callViewCount()
            }
        }
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "SortXIB", bundle: nil), forCellReuseIdentifier: "SortXIB")
    }

    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func clearOnPress(_ sender: UIButton) {
        FilterSingleton.share.filter.sort_by = ""
        FilterSingleton.share.filter.sort_value = ""
        FilterSingleton.share.selectedFilter.sort_by = ""
        FilterSingleton.share.selectedFilter.sort_value = ""
        if self.isFilterProduct == false{
            callViewCount()
        }
        self.tableView.reloadData()
    }
    
    @IBAction func countOnPress(_ sender: UIButton) {
        if self.isSaveSearch == true || self.isFilterProduct == true{
            self.popViewController()
        }else{
            let vc = AllProductViewController.instantiate(fromStoryboard: .Main)
            vc.titleStr = "Search Results"
            self.pushViewController(vc: vc)
        }
    }
}

extension SortVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.indexData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortXIB", for: indexPath) as! SortXIB
        let indexData = self.indexData[indexPath.row]
        cell.lblTitle.text = indexData["title"] ?? ""
        if FilterSingleton.share.selectedFilter.sort_by == indexData["title"] ?? ""{
            cell.imgCheck.image = UIImage(named: "ic_circle_check")
        }else{
            cell.imgCheck.image = UIImage(named: "ic_circle_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FilterSingleton.share.filter.sort_by = self.indexData[indexPath.row]["sort_by"]
        FilterSingleton.share.filter.sort_value = self.indexData[indexPath.row]["sort_value"]
        FilterSingleton.share.selectedFilter.sort_by = self.indexData[indexPath.row]["title"] ?? ""
        if !(self.isSaveSearch ?? false) && self.isFilterProduct == false{
            self.callViewCount()
        }
        self.tableView.reloadData()
    }
}

extension SortVC{
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            
            FilterSingleton.share.filter.is_only_count = "1"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
            dict["latitude"] = appDelegate.userLocation?.latitude ?? ""
            dict["longitude"] = appDelegate.userLocation?.longitude ?? ""
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: dict) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
//                            if self.saveSearch {
//                                self.btnCount.setTitle("Add to saved Search", for: .normal)
//                            }
//                            else {
                            self.btnCount.setTitle("View \(data.total_posts ?? 0) Items", for: .normal)
//                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}
