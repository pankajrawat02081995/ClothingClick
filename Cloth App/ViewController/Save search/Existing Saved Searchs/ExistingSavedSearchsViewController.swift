//
//  ExistingSavedSearchsViewController.swift
//  ClothApp
//
//  Created by Apple on 05/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class ExistingSavedSearchsViewController: BaseViewController {
    
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var tblExistingSavedSearchs: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    var saveSearchList : SaveSearchListMOdel?
    var currentPage = 1
    var hasMorePages = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoData.isHidden = true
        self.setupTableView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callSaveSearchList(page: "\(self.currentPage)", isShowHud: true)
    }
    
    func setupTableView(){
        self.tblExistingSavedSearchs.delegate = self
        self.tblExistingSavedSearchs.dataSource = self
        self.tblExistingSavedSearchs.tableFooterView = UIView()
        self.tblExistingSavedSearchs.register(UINib(nibName: "CustomSaveSearchXIB", bundle: nil), forCellReuseIdentifier: "CustomSaveSearchXIB")
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @objc func btnEdit_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblExistingSavedSearchs)
        if let indexPath = self.tblExistingSavedSearchs.indexPathForRow(at: buttonPosition) {
//            let viewController = self.storyboard?.instantiateViewController(identifier: "SaveSearchViewController") as! SaveSearchViewController
//            viewController.edit = true
//            viewController.saveSearchId = String(self.saveSearchList?.save_searches?[indexPath.row].id ?? 0)
//            self.navigationController?.pushViewController(viewController, animated: true)
            let vc = SaveSearchViewController.instantiate(fromStoryboard: .Main)
            vc.edit = true
            vc.saveSearchId = String(self.saveSearchList?.save_searches?[indexPath.row].id ?? 0)
            vc.hidesBottomBarWhenPushed = true
            self.pushViewController(vc: vc)
        }
    }
    
    @objc func btnDelete_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblExistingSavedSearchs)
        if let indexPath = self.tblExistingSavedSearchs.indexPathForRow(at: buttonPosition) {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: .default, handler: { (action) in
                self.callDeleteSaveSearch(saveSearchId: String(self.saveSearchList?.save_searches?[indexPath.row].id ?? 0), index: indexPath.row)
                
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func btnView_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblExistingSavedSearchs)
        if let indexPath = self.tblExistingSavedSearchs.indexPathForRow(at: buttonPosition) {
            let viewController = self.storyboard?.instantiateViewController(identifier: "PopularBrandsViewController") as! PopularBrandsViewController
            viewController.headerTitel = "Search Results"
            viewController.isSaveSearch = true
            viewController.saveSearchID = String(self.saveSearchList?.save_searches?[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension ExistingSavedSearchsViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.saveSearchList?.save_searches?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSaveSearchXIB", for: indexPath)as! CustomSaveSearchXIB
        let objet = self.saveSearchList?.save_searches?[indexPath.row]
        if let name = objet?.name {
            cell.lblTitle.text = name.capitalized
        }
        cell.lblCount.text = "\(objet?.count ?? "0") Items"
        cell.btnEdit.tag = indexPath.row
        cell.btnDelete.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(btnEdit_Clicked(sender:)), for: .touchUpInside)
        cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked(sender:)), for: .touchUpInside)
//        cell.btnView.addTarget(self, action: #selector(btnView_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.saveSearchList?.save_searches?.count ?? 0 - 1 && hasMorePages == true {
            self.currentPage = self.currentPage + 1
            self.callSaveSearchList(page: "\(self.currentPage)", isShowHud: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewController = self.storyboard?.instantiateViewController(identifier: "PopularBrandsViewController") as! PopularBrandsViewController
//        viewController.headerTitel = "Search Results"
//        viewController.isSaveSearch = true
//        viewController.saveSearchID = String(self.saveSearchList?.save_searches?[indexPath.row].id ?? 0)
//        self.navigationController?.pushViewController(viewController, animated: true)
        let viewController = AllProductViewController.instantiate(fromStoryboard: .Main)
        viewController.titleStr = "Search Results"
        viewController.isSaveList = true
        viewController.saveSearchId = self.saveSearchList?.save_searches?[indexPath.row].id ?? 0
        self.pushViewController(vc: viewController)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
}
extension ExistingSavedSearchsViewController {
    func callSaveSearchList(page : String,isShowHud:Bool) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["page":  page]
            
            APIManager().apiCallWithMultipart(of: SaveSearchListMOdel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.SAVE_SEARCH.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.saveSearchList = data
                        }
                        if self.saveSearchList?.save_searches?.count == 0 {
                            self.lblNoData.isHidden = false
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                        }
                        self.tblExistingSavedSearchs.reloadData()
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
    
    func callDeleteSaveSearch(saveSearchId : String, index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["save_search_id":  saveSearchId ]
            
            APIManager().apiCallWithMultipart(of: SaveSearchListMOdel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SERCH_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    self.saveSearchList?.save_searches?.remove(at: index)
                    self.tblExistingSavedSearchs.reloadData()
                    if let messge = response?.message {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: messge)
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
