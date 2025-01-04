//
//  FilterProductVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 07/11/24.
//

import UIKit

class FilterProductVC: UIViewController {
    
    @IBOutlet weak var btnResult: CustomButton!
    @IBOutlet weak var tableView: UITableView!
    var categoryList = ["My Sizes" ,"Department","Category" ,"Size","Style","Brand Name","Color","Condition","Seller","Price","Distance","Sort"]
    
    var callBack : (()-> Void)?
    var isJustFilter : Bool?
    var isSaveSearch :Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "FilterProductXIB", bundle: nil), forCellReuseIdentifier: "FilterProductXIB")
    }
    
    @IBAction func clearOnPress(_ sender: UIButton) {
        
        FilterSingleton.share.filter = Filters()
        FilterSingleton.share.selectedFilter = FiltersSelectedData()
        self.tableView.reloadData()
        
    }
    
    @IBAction func resultOnPress(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.callBack?()
        }
    }
    
    @IBAction func crossOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isJustFilter == false{
            FilterSingleton.share.filter.is_only_count = "1"
            FilterSingleton.share.getFilterData { model in
                self.btnResult.setTitle("View \(model?.total_posts ?? 0) Items", for: .normal)
                self.tableView.reloadData()
            }
        }else{
            self.tableView.reloadData()
            self.btnResult.setTitle("Save", for: .normal)
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func addMySize(sender:UIButton){
        //        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            sender.isSelected = false
            
            FilterSingleton.share.filter.is_mysize = "0"
            FilterSingleton.share.selectedFilter.sizes = ""
            FilterSingleton.share.filter.sizes = ""
            
            FilterSingleton.share.selectedFilter.gender_id = ""
            FilterSingleton.share.filter.gender_id = ""
        }else{
            sender.isSelected = true
            
            FilterSingleton.share.filter.is_mysize = "1"
            FilterSingleton.share.filter.sizes = appDelegate.userDetails?.user_size?.map { String($0) }.joined(separator: ",")
            FilterSingleton.share.selectedFilter.sizes = appDelegate.userDetails?.user_sizes_details?.joined(separator: ",")
            FilterSingleton.share.selectedFilter.gender_id = appDelegate.userDetails?.gender_name ?? ""
            FilterSingleton.share.filter.gender_id = "\(appDelegate.userDetails?.user_selected_gender ?? 0)"
        }
        self.tableView.reloadData()
    }
}

extension FilterProductVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterProductXIB", for: indexPath) as! FilterProductXIB
        let indexData = self.categoryList[indexPath.row]
        cell.btnMySize.isSelected = FilterSingleton.share.filter.is_mysize ?? "" == "1" ? true : false
        if indexData == "My Sizes"{
            cell.btnMySize.isHidden = false
        }else{
            cell.btnMySize.isHidden = true
        }
        cell.btnMySize.addTarget(self, action: #selector(self.addMySize(sender:)), for: .touchUpInside)
        cell.lblCategoryList.text = indexData
        
        switch indexData{
        case "Department" :
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.gender_id ?? ""
        case "Category" :
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.categories ?? ""
        case "Size":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.sizes ?? ""
        case "Brand Name":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.brand_id ?? ""
        case "Color":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.colors ?? ""
        case "Condition":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.condition_id ?? ""
        case "Seller":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.seller ?? ""
        case "Price":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.price_to?.isEmpty == false ? "Under $\(FilterSingleton.share.selectedFilter.price_to ?? "")" : ""
        case "Distance":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.distance?.isEmpty == false ? "\(FilterSingleton.share.selectedFilter.distance ?? "")" : ""
        case "Sort":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.sort_by ?? ""
            
        case "Style":
            cell.lblSelectCategory.text = FilterSingleton.share.selectedFilter.style ?? ""
            
        default:
            cell.lblSelectCategory.text = ""
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.categoryList[indexPath.row] == "Department" {
            let vc = DepartmentVC.instantiate(fromStoryboard: .Dashboard)
            vc.isFilterProduct = true
            self.pushViewController(vc: vc)
        }else if self.categoryList[indexPath.row] == "Sort" {
            let vc = SortVC.instantiate(fromStoryboard: .Sell)
            vc.isFilterProduct = true
            self.pushViewController(vc: vc)
        }else if self.categoryList[indexPath.row] == "Style" {
            let vc = StyleVC.instantiate(fromStoryboard: .Sell)
//            vc.isFromFilterSection = false
            vc.isFilterProduct = true
            self.pushViewController(vc: vc)
        }
        else if self.categoryList[indexPath.row] == "Category" {
            
            let vc = NewCategoryVC.instantiate(fromStoryboard: .Sell)
            vc.isFilterProduct = true
            self.pushViewController(vc: vc)
        }
        else if self.categoryList[indexPath.row] == "Brand Name" {
            let viewController = BrandsSearchViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.isFilterProduct = true
//            viewController.isSaveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Color" {
            let viewController = ConditionAndSellerViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.isFilterProduct = true
//            viewController.isSaveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Condition" {
            let viewController =  ConditionAndSellerViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.isFilterProduct = true
//            viewController.isSaveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Seller" {
            let viewController =  ConditionAndSellerViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            var sellerList = [
                Seller(id: 1,name: "Individual Sellers",isSelect: false),
                Seller(id: 2,name: "Store",isSelect: false),
            ]
            viewController.saveSearch = true
            viewController.list = sellerList
            viewController.isFilterProduct = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Price" {
            let viewController = PiseSearchViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.headerTitle = self.categoryList[indexPath.row]
            viewController.isFilterProduct = true
//            viewController.isSaveSearch = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Distance" {
            let viewController = DistanceViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.isFilterProduct = true
//            viewController.isSaveSearch = true
            viewController.headerTitle = self.categoryList[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.categoryList[indexPath.row] == "Size" {
            let viewController =  SizeViewController.instantiate(fromStoryboard: .Main)
            viewController.selectedIndex = indexPath.row
            viewController.isFilterProduct = true
//            viewController.isSaveSearch = true
            viewController.headerTitle = self.categoryList[indexPath.row]
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
