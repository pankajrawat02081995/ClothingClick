//
//  StyleVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 15/07/24.
//

import UIKit
import IBAnimatable

protocol SelectedStyle {
    func selectedStyle(ids:[Int],styleName:[String])
}

class StyleVC: BaseViewController {

    @IBOutlet weak var btnSave: AnimatableButton!
    @IBOutlet weak var tableView: UITableView!
    var selectedID = [Int]()
    var selectedName = [String]()
    var viewModel = StyleViewModel()
    var delegate : SelectedStyle?
    
    var isFromFilterSection :Bool?
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.view = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "StyleXIB", bundle: nil), forCellReuseIdentifier: "StyleXIB")
        self.tableView.tableFooterView = UIView()
        self.viewModel.getStyle()
        if self.isFilterProduct == true{
            self.callViewCount()
            self.btnSave.setTitle("Add", for: .normal)
        }else{
            if self.isFromFilterSection == true{
                self.callViewCount()
            }else{
                if FilterSingleton.share.filter.style?.isEmpty == false && FilterSingleton.share.filter.style != nil{
                    self.btnSave.isUserInteractionEnabled = true
                    self.btnSave.backgroundColor = .customBlack
                    self.btnSave.alpha = 1
                }
                
                self.btnSave.setTitle("Add to saved Search", for: .normal)
                
            }
        }
    }
    
    func saveButtonSetup(){
        if self.selectedID.count > 0 {
            self.btnSave.backgroundColor = .customBlack
            self.btnSave.isUserInteractionEnabled = true
        }else{
            self.btnSave.isUserInteractionEnabled = false
            self.btnSave.backgroundColor = .customButton_bg_gray
        }
    }
    
    @IBAction func clearAllOnPress(_ sender: UIButton) {
        //        if self.isFromFilterSection == false{
        //        self.selectedID.removeAll()
        //        self.saveButtonSetup()
        //        self.tableView.reloadData()
        //        }else{
        FilterSingleton.share.filter.style = ""
        FilterSingleton.share.selectedFilter.style = ""
        self.callViewCount()
        if self.isFromFilterSection == true && self.isFilterProduct == false{
            self.callViewCount()
        }else{
            let  data = FilterSingleton.share.filter.style?.components(separatedBy: ",")
           let FilterData = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
            if FilterData?.count ?? 0 > 0{
                self.btnSave.isUserInteractionEnabled = true
                self.btnSave.backgroundColor = .customBlack
            }else{
                self.btnSave.isUserInteractionEnabled = false
                self.btnSave.backgroundColor = .customButton_bg_gray
            }
        }
        self.tableView.reloadData()
        //        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func addToSave(_ sender: UIButton) {
        if self.isFromFilterSection == false || self.isFilterProduct == true{
//            if let del = self.delegate{
//                del.selectedStyle(ids: self.selectedID, styleName: self.selectedName)
//                self.popViewController()
//            }
            self.popViewController()
        }else{
            let vc = AllProductViewController.instantiate(fromStoryboard: .Main)
            vc.titleStr = "Search Results"
            self.pushViewController(vc: vc)
        }
    }
    
}

extension StyleVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.modelData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StyleXIB", for: indexPath) as! StyleXIB
        let indexData = self.viewModel.modelData[indexPath.row]
        cell.lblTitle.text = indexData.name ?? ""
//        if self.isFromFilterSection == false{
//            if self.selectedID.contains(indexData.id ?? 0) == true{
//                cell.imgCheck.image = UIImage(named: "ic_circle_check")
//            }else{
//                cell.imgCheck.image = UIImage(named: "ic_circle_uncheck")
//            }
//        }else{
            if FilterSingleton.share.filter.style?.components(separatedBy: ",").contains("\(indexData.id ?? 0)") == true{
                cell.imgCheck.image = UIImage(named: "ic_circle_check")
            }else{
                cell.imgCheck.image = UIImage(named: "ic_circle_uncheck")
            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexData = self.viewModel.modelData[indexPath.row]
//        if self.isFromFilterSection == false{
//            
//            if self.selectedID.contains(indexData.id ?? 0) == true{
//                let index = self.selectedID.firstIndex(of: indexData.id ?? 0) ?? 0
//                self.selectedID.remove(at: index)
//                self.selectedName.remove(at: index)
//            }else{
//                self.selectedID.append(indexData.id ?? 0)
//                self.selectedName.append(indexData.name ?? "")
//            }
//            self.saveButtonSetup()
//        }else{
            
            if FilterSingleton.share.filter.style?.components(separatedBy: ",").contains("\(indexData.id ?? 0)") == true{
                let index = FilterSingleton.share.filter.style?.components(separatedBy: ",").firstIndex(of: "\(indexData.id ?? 0)") ?? 0
                var data = FilterSingleton.share.filter.style?.components(separatedBy: ",")
                data?.remove(at: index)
                FilterSingleton.share.filter.style = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
                
                var dataName = FilterSingleton.share.selectedFilter.style?.components(separatedBy: ",")
                dataName?.remove(at: index)
                FilterSingleton.share.selectedFilter.style = dataName?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
            }else{
                var data = FilterSingleton.share.filter.style?.components(separatedBy: ",")
                var dataName = FilterSingleton.share.selectedFilter.style?.components(separatedBy: ",")
                dataName?.append("\(indexData.name ?? "")")
                data?.append("\(indexData.id ?? 0)")
                FilterSingleton.share.filter.style = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
                FilterSingleton.share.selectedFilter.style = dataName?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",").trimmingCharacters(in: .whitespacesAndNewlines)
            }
        self.callViewCount()
        if self.isFromFilterSection == true && self.isFilterProduct == false{
            self.callViewCount()
        }else{
            let  data = FilterSingleton.share.filter.style?.components(separatedBy: ",")
            if data?.count ?? 0 > 0{
                self.btnSave.isUserInteractionEnabled = true
                self.btnSave.backgroundColor = .customBlack
            }else{
                self.btnSave.isUserInteractionEnabled = false
                self.btnSave.backgroundColor = .customButton_bg_gray
            }
        }
        self.callViewCount()
        self.tableView.reloadData()
    }
}

extension StyleVC{
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
                            if self.isFromFilterSection == false {
                                self.btnSave.setTitle("Add to saved Search", for: .normal)
                            }
                            else {
                                self.btnSave.setTitle("View \(data.total_posts ?? 0) Items", for: .normal)
                                self.btnSave.isUserInteractionEnabled = data.total_posts == 0 ? false : true
                                self.btnSave.backgroundColor = data.total_posts == 0 ? .customButton_bg_gray : .customBlack
                            }
                            if data.total_posts ?? 0 > 0{
                                self.btnSave.isUserInteractionEnabled = true
                                self.btnSave.backgroundColor = .customBlack
                            }else{
                                self.btnSave.isUserInteractionEnabled = false
                                self.btnSave.backgroundColor = .customButton_bg_gray
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
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
}
