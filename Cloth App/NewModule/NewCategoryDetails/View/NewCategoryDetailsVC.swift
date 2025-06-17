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
    var isSaveSearch : Bool? = false
    var isFilterProduct : Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lbltitle.text = self.headertitle
        debugPrint(self.subCategoryList)
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
        let ids = self.subCategoryList.map{"\($0?.category_id ?? 0)"}
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
        if FilterSingleton.share.filter.slectedCategories?.components(separatedBy: ",").contains("\(indexData?.category_id ?? 0)") == true{
            cell.imgCheck.image = UIImage(named: "ic_circle_check")
        }else{
            cell.imgCheck.image = UIImage(named: "ic_circle_uncheck")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedSubCategory = subCategoryList[indexPath.row],
              let selectedID = selectedSubCategory.category_id else { return }

        var selectedIDs = FilterSingleton.share.filter.slectedCategories?
            .components(separatedBy: ",")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } ?? []

        if indexPath.row == 0 {
            // Selecting "All" category
            selectedIDs = subCategoryList
                .compactMap { "\($0?.category_id ?? 0)" }
            FilterSingleton.share.filter.slectedCategories = selectedIDs.joined(separator: ",")
        } else {
            let firstID = "\(subCategoryList.first??.category_id ?? 0)"

            // Remove "All" if already present
            if let index = selectedIDs.firstIndex(of: firstID) {
                selectedIDs.remove(at: index)
            }

            let idString = "\(selectedID)"
            if selectedIDs.contains(idString) {
                selectedIDs.removeAll { $0 == idString }
            } else {
                selectedIDs.append(idString)
            }

            FilterSingleton.share.filter.slectedCategories = selectedIDs.joined(separator: ",")
        }

        updateFilterCategorySelections()

        tableView.reloadData()

        if isSaveSearch ?? false == false && isFilterProduct ?? false == false {
            callViewCount()
        }
    }

    // MARK: - Helper
    private func updateFilterCategorySelections() {
        let currentSelectedIDs = FilterSingleton.share.filter.slectedCategories?
            .components(separatedBy: ",")
            .filter { !$0.isEmpty } ?? []

        let allValidIDs = subCategoryList
            .compactMap { "\($0?.category_id ?? 0)" }

        let intersectedIDs = currentSelectedIDs.filter { allValidIDs.contains($0) }

        if !intersectedIDs.isEmpty {
            updateCategoryList(add: true)
        } else {
            updateCategoryList(add: false)
        }
    }

    private func updateCategoryList(add: Bool) {
        let title = headertitle
        let categoryID = catID ?? ""

        if add {
            addUniqueValue(to: &FilterSingleton.share.selectedFilter.categories, value: title)
            addUniqueValue(to: &FilterSingleton.share.filter.categories, value: categoryID)
        } else {
            removeValue(from: &FilterSingleton.share.selectedFilter.categories, value: title)
            removeValue(from: &FilterSingleton.share.filter.categories, value: categoryID)
        }
    }

    private func addUniqueValue(to commaSeparatedString: inout String?, value: String) {
        var values = commaSeparatedString?
            .components(separatedBy: ",")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty } ?? []

        if !values.contains(value) {
            values.append(value)
        }
        commaSeparatedString = values.joined(separator: ",")
    }

    private func removeValue(from commaSeparatedString: inout String?, value: String) {
        var values = commaSeparatedString?
            .components(separatedBy: ",")
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty } ?? []

        values.removeAll { $0 == value }
        commaSeparatedString = values.joined(separator: ",")
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
