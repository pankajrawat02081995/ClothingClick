//
//  NewCategoryVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 23/10/24.
//

import UIKit
import IBAnimatable

class NewCategoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnCount: AnimatableButton!
    
    var genderList = [CategoryModel?]()
    var subCategoryList = [ChildCategories?]()
    var categoryList = [Categorie?]()
    var isSaveSearch : Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.callCategoryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        if self.isFilterProduct == true{
            self.btnCount.setTitle("Add", for: .normal)
        }else{
            if self.isSaveSearch == true{
                self.btnCount.setTitle("Add to saved Search", for: .normal)
            }else{
                self.callViewCount()
            }
        }
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func clearAllOnPress(_ sender: UIButton) {
        FilterSingleton.share.filter.categories = ""
        FilterSingleton.share.selectedFilter.categories = ""
        FilterSingleton.share.filter.slectedCategories?.removeAll()
        
        self.tableView.reloadData()
        if self.isFilterProduct == false{
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

extension NewCategoryVC:UITableViewDelegate,UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.genderList.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCatXIB", for: indexPath) as! NewCatXIB
        let indexData = self.categoryList[indexPath.row]
        cell.lblTitle.text = indexData?.name ?? ""
        
        if FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",").contains("\(indexData?.name ?? "")") == true{
            cell.imgCheck.image = UIImage(named: "ic_circle_check")
        }else{
            cell.imgCheck.image = UIImage(named: "ic_circle_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.categoryList[indexPath.row]?.childCategories?.isEmpty == true{
            if FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",").contains(self.categoryList[indexPath.row]?.name ?? "") == true{
                
                let index = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",").firstIndex(of: self.categoryList[indexPath.row]?.name ?? "") ?? 0
                var data = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",")
                data?.remove(at: index)
                FilterSingleton.share.selectedFilter.categories = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
            }else{
                var category = FilterSingleton.share.selectedFilter.categories?.components(separatedBy: ",")
                category?.append(self.categoryList[indexPath.row]?.name ?? "")
                FilterSingleton.share.selectedFilter.categories = category?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
            }
            self.tableView.reloadData()
        }else{
            let viewController = NewCategoryDetailsVC.instantiate(fromStoryboard: .Sell)
            viewController.headertitle = self.categoryList[indexPath.row]?.name ?? ""
            viewController.catID = "\(self.categoryList[indexPath.row]?.category_id ?? 0)"
            debugPrint(self.categoryList[indexPath.row]?.childCategories?.first?.mainid ?? "")
            debugPrint(self.categoryList[indexPath.row]?.childCategories?.first?.category_id ?? 0)
            viewController.isFilterProduct = self.isFilterProduct
            viewController.subCategoryList = self.categoryList[indexPath.row]?.childCategories ?? []
            viewController.isSaveSearch = self.isSaveSearch
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension NewCategoryVC{
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
    
    func callCategoryList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: CategoryModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            if FilterSingleton.share.filter.gender_id?.count == 1{
                                self.categoryList = data.filter{"\($0.gender_id ?? 0)" == FilterSingleton.share.filter.gender_id}.first?.categories ?? []
                            }else{
                                self.categoryList = data.filter{"\($0.gender_id ?? 0)" == "0"}.first?.categories ?? []
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}

extension NewCategoryVC{
    
    func mergeArrays(_ array1: [Categorie], _ array2: [Categorie]) -> [Categorie] {
        // Create a dictionary to store merged items by ID
        var mergedDict: [String: Categorie] = [:]

        // Helper function to merge two items with the same ID
        func mergeItems(_ item1: Categorie, _ item2: Categorie) -> Categorie {
            var mergedItem = item1
            let children1 = item1.childCategories ?? []
                    let children2 = item2.childCategories ?? []
                    let combinedChildren = (children1 + children2).uniqued()
            
            mergedItem.childCategories = combinedChildren
            return mergedItem
        }

        // Add items from the first array to the dictionary
        for item in array1 {
            mergedDict[item.name ?? ""] = item
        }

        // Merge items from the second array, or add if not already present
        for item in array2 {
            if let existingItem = mergedDict[item.name ?? ""] {
                // If the item already exists, merge it
                mergedDict[item.name ?? ""] = mergeItems(existingItem, item)
            } else {
                // If it does not exist, add it to the dictionary
                mergedDict[item.name ?? ""] = item
            }
        }

        // Convert the dictionary back to an array
        return Array(mergedDict.values)
    }


}
// Extension to remove duplicates from an array of ChildItems
extension Array where Element: Equatable {
    func uniqued() -> [Element] {
        var seen: [Element] = []
        return filter { element in
            if seen.contains(element) {
                return false
            } else {
                seen.append(element)
                return true
            }
        }
    }
}


