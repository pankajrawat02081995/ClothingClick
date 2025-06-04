//
//  NewCategoryDetailsVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 23/10/24.
//

import UIKit
import IBAnimatable
class NewCategoryDetailsVC: UIViewController {
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCount: AnimatableButton!
    
    var subCategoryList = [ChildCategories?]()
    var headertitle = ""
    var catID : String?
    var isSaveSearch : Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbltitle.text = self.headertitle
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFilterProduct == true{
            self.btnCount.setTitle("Add", for: .normal)
        }else if self.isSaveSearch ?? false == false && self.isFilterProduct ?? false == false{
            self.callViewCount()
        }else{
            self.btnCount.setTitle("Add to saved search", for: .normal)
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func clearAllOnPress(_ sender: UIButton) {
        let ids = self.subCategoryList.map{"\($0?.id ?? 0)"}
        let array = FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",").filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let filterArray = array?.filter { !(ids.contains($0)) == true }
        FilterSingleton.share.filter.slectedCategories = filterArray?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
        
        if filterArray?.isEmpty == true{
            let index = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",").firstIndex(of: self.headertitle) ?? 0
            var data = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",")
            data?.remove(at: index)
            FilterSingleton.share.selectedFilter.categories = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        self.tableView.reloadData()
        if self.isSaveSearch ?? false == false && self.isFilterProduct ?? false == false{
            self.callViewCount()
        }
    }
    
    @IBAction func countOnPress(_ sender: UIButton) {
        if self.isSaveSearch == true || self.isFilterProduct == true{
            self.popViewController()
        }else{
            let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
            viewController.titleStr = "Search Results"
            self.pushViewController(vc: viewController)
        }
    }
  
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "NewCatXIB", bundle: nil), forCellReuseIdentifier: "NewCatXIB")
    }

}

extension NewCategoryDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subCategoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCatXIB", for: indexPath) as! NewCatXIB
        let indexData = self.subCategoryList[indexPath.row]
        cell.lblTitle.text = indexData?.name ?? ""
        if FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",").contains("\(indexData?.id ?? 0)") == true{
            cell.imgCheck.image = UIImage(named: "ic_circle_check")
        }else{
            cell.imgCheck.image = UIImage(named: "ic_circle_uncheck")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.subCategoryList[indexPath.row]?.id ?? 0
        if indexPath.row == 0{
            FilterSingleton.share.filter.slectedCategories = self.subCategoryList.map{"\($0?.id ?? 0)"}.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
        }else{
            
            var data = FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",")
            if let index = data?.firstIndex(where: { $0 == "\(self.subCategoryList.first??.id ?? 0)" }) {
                data?.remove(at: index)
                FilterSingleton.share.filter.slectedCategories = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",").contains("\(id)") == true{
                let index = FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",").firstIndex(of: "\(id)") ?? 0
                var data = FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",")
                data?.remove(at: index)
                FilterSingleton.share.filter.slectedCategories = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
            }else{
                var category = FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",")
                category?.append("\(id)")
                FilterSingleton.share.filter.slectedCategories = category?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
            }
            
            let ids = self.subCategoryList.map{"\($0?.id ?? 0)"}
            let array = FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",")
            let filterArray = array?.filter { (ids.contains($0)) == true }
            
            if filterArray?.isEmpty == false{
                var category = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",")
                if !(category?.contains(self.headertitle) ?? true) == true{
                    category?.append(self.headertitle)
                }
                FilterSingleton.share.selectedFilter.categories = category?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
                
                var catID = FilterSingleton.share.filter.categories?.components(separatedBy: ",")
                if !(catID?.contains(self.catID ?? "") ?? true) == true{
                    catID?.append(self.catID ?? "")
                }
                FilterSingleton.share.filter.categories = catID?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
                
            }else{
                let index = FilterSingleton.share.filter.categories?.components(separatedBy: ",").firstIndex(of: self.catID ?? "") ?? 0
                var data = FilterSingleton.share.filter.categories?.components(separatedBy: ",")
                data?.remove(at: index)
                FilterSingleton.share.filter.categories = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
                
                let index1 = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",").firstIndex(of: self.catID ?? "") ?? 0
                var data1 = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",")
                data1?.remove(at: index)
                FilterSingleton.share.selectedFilter.categories = data1?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
                
            }
        }
        self.tableView.reloadData()
        if self.isSaveSearch ?? false == false && self.isFilterProduct ?? false == false{
            self.callViewCount()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension NewCategoryDetailsVC{
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            
            
            FilterSingleton.share.filter.is_only_count = "1"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
            dict["latitude"] = appDelegate.userLocation?.latitude ?? ""
            dict["longitude"] = appDelegate.userLocation?.longitude ?? ""
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters:dict ) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.btnCount.setTitle("View \(data.total_posts ?? 0) Items", for: .normal)
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
