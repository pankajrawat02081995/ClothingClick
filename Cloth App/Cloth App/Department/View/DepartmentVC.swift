//
//  DepartmentVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 26/06/24.
//

import UIKit

class DepartmentVC: UIViewController {

    @IBOutlet weak var btnResult: CustomButton!
    @IBOutlet weak var tableView: UITableView!
    
    var genderId : Int?
    var viewModel = DepartmentViewModel()
    var isEdit : Bool?
    var genderDelegate : GenderDelegate?
    var isFromSearch : Bool?
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isFilterProduct == true{
            self.btnResult.setTitle("Add", for: .normal)
            self.btnResult.isUserInteractionEnabled = true
            self.btnResult.alpha = 1
        }else{
            if self.isSaveSearch == true{
                if FilterSingleton.share.filter.gender_id?.isEmpty == false && FilterSingleton.share.filter.gender_id != nil{
                    self.btnResult.isUserInteractionEnabled = true
                    self.btnResult.alpha = 1
                }
                self.btnResult.setTitle("Add to saved Search", for: .normal)
            }else{
                FilterSingleton.share.filter.is_only_count = "1"
                FilterSingleton.share.getFilterData {[weak self] model in
                    DispatchQueue.main.async {
                        self?.btnResult.isUserInteractionEnabled = model?.total_posts ?? 0 > 0
                        self?.btnResult.alpha = 1
                        self?.tableView.reloadData()
                        if self?.isSaveSearch == true{
                            self?.btnResult.setTitle("Add to saved Search", for: .normal)
                        }else{
                            self?.btnResult.setTitle("View \(model?.total_posts ?? 0) Items", for: .normal)
                            self?.btnResult.isUserInteractionEnabled = model?.total_posts == 0 ? false : true
                            self?.btnResult.alpha = model?.total_posts == 0 ? 0.5 : 1
                        }
                    }
                }
            }
        }
    }
    
    func setupTableView(){
        self.viewModel.view = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "DepartmentXIB", bundle: nil), forCellReuseIdentifier: "DepartmentXIB")
        self.btnResult.isUserInteractionEnabled = false
        self.btnResult.alpha = 0.5
        if !(self.isFromSearch ?? false) && self.isFilterProduct == false{
            self.clearOnPress(self.btnResult)
        }
        self.viewModel.callSizeList()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func resultOnPress(_ sender: UIButton) {
        if self.isSaveSearch ?? false == true || self.isFilterProduct == true{
            self.popViewController()
        }else{
            if self.isFromSearch == true {
                let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
                viewController.titleStr = "Search Results"
                self.navigationController?.pushViewController(viewController, animated: true)
            }else{
                if let genderModel = self.viewModel.mysizeList
                    .compactMap({ $0 })  // Removes nil values from the array (if `mysizeList` is an array of optionals)
                    .filter({ model in
                        guard let genderId = model.gender_id else { return false }
                        return FilterSingleton.share.filter.gender_id?.contains("\(genderId)") ?? false
                    })
                    .first {
                    let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
                    viewController.titleStr = "Search Results"
                    self.navigationController?.pushViewController(viewController, animated: true)
                    self.genderDelegate?.selectGendr(gender: genderModel)
                } else {
                    let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
                    viewController.titleStr = "Search Results"
                    self.navigationController?.pushViewController(viewController, animated: true)
                    //self.genderDelegate?.selectGendr(gender: genderModel)
                    //self.popViewController()
                }
            }
        }
        
    }
    
    @IBAction func clearOnPress(_ sender: UIButton) {
        FilterSingleton.share.filter.gender_id =  ""
        FilterSingleton.share.selectedFilter.gender_id =  ""
        FilterSingleton.share.filter.is_only_count = "1"
        if self.isSaveSearch == false && self.isFilterProduct == false {
            FilterSingleton.share.getFilterData {[weak self] model in
                DispatchQueue.main.async {
                    self?.btnResult.isUserInteractionEnabled = model?.total_posts ?? 0 > 0
                    self?.btnResult.alpha = 1
                    self?.tableView.reloadData()
                    self?.btnResult.setTitle("View \(model?.total_posts ?? 0) Items", for: .normal)
                    self?.btnResult.isUserInteractionEnabled = model?.total_posts == 0 ? false : true
                    self?.btnResult.alpha = model?.total_posts == 0 ? 0.5 : 1
                }
            }
        }
        else if self.isFromSearch == false{
            FilterSingleton.share.filter.is_only_count = "1"
            FilterSingleton.share.getFilterData {[weak self] model in
                DispatchQueue.main.async {
                    self?.btnResult.isUserInteractionEnabled = true
                    self?.btnResult.alpha = 1
                    self?.tableView.reloadData()
                    self?.btnResult.setTitle("View \(model?.total_posts ?? 0) Items", for: .normal)
                    self?.btnResult.isUserInteractionEnabled = model?.total_posts == 0 ? false : true
                    self?.btnResult.alpha = model?.total_posts == 0 ? 0.5 : 1
                }
            }
        }
        else {
            self.btnResult.isUserInteractionEnabled = false
            self.btnResult.alpha = 0.5
            self.tableView.reloadData()
        }
    }
    
}


extension DepartmentVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.mysizeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentXIB", for: indexPath) as! DepartmentXIB
        let indexData = self.viewModel.mysizeList[indexPath.row]
        cell.lblTitle.text = indexData?.gender_name ?? ""
        if FilterSingleton.share.filter.gender_id?.contains("\(indexData?.gender_id ?? 0)") == true{
            cell.imgCheck.image = UIImage.init(named: "ic_circle_check")
        }else{
            cell.imgCheck.image = UIImage.init(named: "ic_circle_uncheck")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FilterSingleton.share.filter.is_only_count = "1"
        if FilterSingleton.share.filter.gender_id?.components(separatedBy: ",").contains("\(self.viewModel.mysizeList[indexPath.row]?.gender_id ?? 0)") == true{
            let index = FilterSingleton.share.filter.gender_id?.components(separatedBy: ",").firstIndex(of: "\(self.viewModel.mysizeList[indexPath.row]?.gender_id ?? 0)") ?? 0
            var dataGender = FilterSingleton.share.filter.gender_id?.components(separatedBy: ",")
            dataGender?.remove(at: index)
            FilterSingleton.share.filter.gender_id = dataGender?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
            var dataGenderName = FilterSingleton.share.selectedFilter.gender_id?.components(separatedBy: ",")
            dataGenderName?.remove(at: index)
            FilterSingleton.share.selectedFilter.gender_id =   dataGenderName?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
        }else{
            var dataGender = FilterSingleton.share.filter.gender_id?.components(separatedBy: ",")
            dataGender?.append("\(self.viewModel.mysizeList[indexPath.row]?.gender_id ?? 0)")
            FilterSingleton.share.filter.gender_id = dataGender?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
            
            var dataGenderName = FilterSingleton.share.selectedFilter.gender_id?.components(separatedBy: ",")
            dataGenderName?.append("\(self.viewModel.mysizeList[indexPath.row]?.gender_name ?? "")")

            FilterSingleton.share.selectedFilter.gender_id =   dataGenderName?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
        }

        if self.isFromSearch == false{
            FilterSingleton.share.filter.is_only_count = "1"
            
            FilterSingleton.share.getFilterData {[weak self] model in
                DispatchQueue.main.async {
                    self?.btnResult.isUserInteractionEnabled = true
                    self?.btnResult.alpha = 1
                    self?.tableView.reloadData()
                    self?.btnResult.setTitle("View \(model?.total_posts ?? 0) Items", for: .normal)
                    self?.tableView.reloadData()
                }
            }
        }else{
            self.btnResult.isUserInteractionEnabled = true
            self.btnResult.alpha = 1
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}
