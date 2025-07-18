//
//  ConditionAndSellerViewController.swift
//  ClothApp
//
//  Created by Apple on 02/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol ConditionColorSizeDelegate {
    func selctedCondeition (Condition: [Conditions?], Selecte:Bool,index : Int,hearderTitel: String)
    //    func selctedSize (Size: [Size?], Selecte:Bool,index : Int,hearderTitel: String)
    func selctedColor (color: [Colors?], Selecte:Bool,index : Int,hearderTitel: String)
    func selctedSeller (seller: [Seller?], Selecte:Bool,index : Int,hearderTitel: String)
}

class ConditionAndSellerViewController: BaseViewController {
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tblConditionAndSeller: UITableView!
    @IBOutlet weak var CVSize: UICollectionView!
    @IBOutlet weak var constTopForCVSize: NSLayoutConstraint!
    @IBOutlet weak var constHeightForCVSize: NSLayoutConstraint!
    @IBOutlet weak var btnViewItems: CustomButton!
    var colorid = [String]()
    var selectedIndex = 0
    var conditionColorSizeDelegate : ConditionColorSizeDelegate!
    var condictionColorLise : ConditionColorModel?
    var selectedCondition = [Conditions?]()
    var selectedSize = [Size?]()
    var selectedColor = [Colors?]()
    var selectedSeller = [Seller?]()
    var selectedSellerId = [""]
    var mysizeList = [MySizeModel?]()
    var categoryList = [Categories?]()
    var selectDataList = [String]()
    var selectGengerIndex = -1
    var selectConditionId = ""
    var saveSearch = false
    var list = [Seller?]()
    var headerTitle = ""
    var selected = -1
    var viewCount = 0
    var selectedSellerIndex = [Int]()
    var selectColorId = ""
    var isMySize = ""
    var selectSubCategoryId = [String]()
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isFilterProduct == true{
            self.btnViewItems.setTitle("Add", for: .normal)
        }else{
            if self.saveSearch {
                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
            }
            else {
                self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                self.btnViewItems.backgroundColor = self.viewCount == 0 ? .customButton_bg_gray : .customBlack
            }
        }
        
        if headerTitle == "Color" {
            self.tblConditionAndSeller.isHidden = false
            self.CVSize.isHidden = true
            
            self.callConditionColor(categoryId: String(FilterSingleton.share.filter.categories ?? ""), genderId: FilterSingleton.share.filter.gender_id ?? "" )
            self.callSizeList()
            self.callViewCount()
        }
        else if headerTitle == "Condition"{
            self.tblConditionAndSeller.isHidden = false
            self.CVSize.isHidden = true
            self.callConditionColor(categoryId: String(FilterSingleton.share.filter.categories ?? ""), genderId: FilterSingleton.share.filter.gender_id ?? "" )
            // if self.isFilterProduct == false{
            self.callViewCount()
            // }
        }
        else if headerTitle == "Size" {
            self.tblConditionAndSeller.isHidden = true
            self.CVSize.isHidden = false
            
            self.callConditionColor(categoryId: String(FilterSingleton.share.filter.categories ?? ""), genderId: FilterSingleton.share.filter.gender_id ?? "" )
        }
        else if headerTitle == "Seller" {
            self.tblConditionAndSeller.isHidden = false
            self.CVSize.isHidden = true
            //if self.isFilterProduct == false{
            self.callViewCount()
            //}
        }
        else {
            self.tblConditionAndSeller.isHidden = false
            self.CVSize.isHidden = true
            self.callSizeList()
        }
        self.lblTitle.text = self.headerTitle
        self.tblConditionAndSeller.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        //        self.CVSize.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
    }
    
    //    override func viewDidLayoutSubviews() {
    //        super.viewDidLayoutSubviews()
    //        self.CVSize.reloadData()
    //        self.CVSize.layoutIfNeeded()
    //        self.constHeightForCVSize.constant = self.CVSize.contentSize.height
    //    }
    
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.isFilterProduct == true{
            self.popViewController()
        }else if self.saveSearch {
            if headerTitle == "Color" {
                let objet = self.condictionColorLise?.colors
                for i in 0..<objet!.count{
                    if objet![i].isSelect ?? false {
                        self.selectedColor.append(self.condictionColorLise?.colors?[i])
                    }
                }
                if self.conditionColorSizeDelegate != nil {
                    self.conditionColorSizeDelegate.selctedColor(color: self.selectedColor, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
                }
                self.navigationController?.popViewController(animated: true)
            }
            else if headerTitle == "Condition"{
                
                if self.conditionColorSizeDelegate != nil {
                    self.conditionColorSizeDelegate.selctedCondeition(Condition: self.selectedCondition, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
                }
                self.navigationController?.popViewController(animated: true)
            }
            else if headerTitle == "Seller" {
                for i in 0..<self.list.count {
                    if self.list[i]?.isSelect == true {
                        self.selectedSeller.append(self.list[i])
                    }
                }
                if self.conditionColorSizeDelegate != nil {
                    self.conditionColorSizeDelegate.selctedSeller(seller: self.selectedSeller,Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
                }
                self.navigationController?.popViewController(animated: true)
            }
            //            else if headerTitle == "Size" {
            //                let objet = self.condictionColorLise?.size
            //                for i in 0..<objet!.count{
            //                    if objet?[i].isSelect ?? false {
            //                        self.selectedSize.append(objet?[i])
            //                    }
            //                }
            //                if self.conditionColorSizeDelegate != nil{
            //                    self.conditionColorSizeDelegate.selctedSize(Size: self.selectedSize, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            //                }
            //                self.navigationController?.popViewController(animated: true)
            //            }
        }
        else {
            if self.viewCount != 0 {
                let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                viewController.titleStr = "Search Results"
                viewController.isMySize = self.isMySize
                viewController.selectSubCategoryId = self.selectSubCategoryId
                viewController.selectSizeId = appDelegate.selectSizeId
                viewController.selectColorId = appDelegate.selectColorId
                viewController.selectConditionId = appDelegate.selectConditionId
                viewController.selectPriceId = appDelegate.selectPriceId
                viewController.priceFrom = appDelegate.priceFrom
                viewController.priceTo = appDelegate.priceTo
                viewController.selectDistnce = appDelegate.selectDistnce
                viewController.selectSellerId = appDelegate.selectSellerId
                viewController.selectBrandId = appDelegate.selectBrandId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func btnBack_Clicked(_ button: UIButton) {
        if headerTitle == "Color" {
            if  let objet = self.condictionColorLise?.colors {
                
                for i in 0..<objet.count {
                    if objet[i].isSelect ?? false {
                        self.selectedColor.append(self.condictionColorLise?.colors?[i])
                    }
                }
            }
            if self.conditionColorSizeDelegate != nil {
                self.conditionColorSizeDelegate.selctedColor(color: self.selectedColor, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else if headerTitle == "Condition"{
            
            if self.conditionColorSizeDelegate != nil {
                self.conditionColorSizeDelegate.selctedCondeition(Condition: self.selectedCondition, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else if headerTitle == "Seller" {
            for i in 0..<self.list.count {
                if self.list[i]?.isSelect == true {
                    self.selectedSeller.append(self.list[i])
                }
            }
            if self.conditionColorSizeDelegate != nil {
                self.conditionColorSizeDelegate.selctedSeller(seller: self.selectedSeller,Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        //        else if headerTitle == "Size" {
        //            let objet = self.condictionColorLise?.size
        //            for i in 0..<(objet?.count ?? 0){
        //                if objet?[i].isSelect ?? false {
        //                    self.selectedSize.append(objet?[i])
        //                }
        //            }
        //            if self.conditionColorSizeDelegate != nil{
        //                self.conditionColorSizeDelegate.selctedSize(Size: self.selectedSize, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
        //            }
        //            self.navigationController?.popViewController(animated: true)
        //        }
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        if headerTitle == "Color" {
            if  let objet = self.condictionColorLise?.colors {
                
                for i in 0..<objet.count {
                    if objet[i].isSelect ?? false {
                        self.selectedColor.append(self.condictionColorLise?.colors?[i])
                    }
                }
            }
            if self.conditionColorSizeDelegate != nil {
                self.conditionColorSizeDelegate.selctedColor(color: self.selectedColor, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else if headerTitle == "Condition"{
            
            if self.conditionColorSizeDelegate != nil {
                self.conditionColorSizeDelegate.selctedCondeition(Condition: self.selectedCondition, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        else if headerTitle == "Seller" {
            for i in 0..<self.list.count {
                if self.list[i]?.isSelect == true {
                    self.selectedSeller.append(self.list[i])
                }
            }
            if self.conditionColorSizeDelegate != nil {
                self.conditionColorSizeDelegate.selctedSeller(seller: self.selectedSeller,Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
            self.navigationController?.popViewController(animated: true)
        }
        //        else if headerTitle == "Size" {
        //            let objet = self.condictionColorLise?.size
        //            for i in 0..<(objet?.count ?? 0){
        //                if objet?[i].isSelect ?? false {
        //                    self.selectedSize.append(objet?[i])
        //                }
        //            }
        //            if self.conditionColorSizeDelegate != nil{
        //                self.conditionColorSizeDelegate.selctedSize(Size: self.selectedSize, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
        //            }
        //            self.navigationController?.popViewController(animated: true)
        //        }
        
    }
    
    @IBAction func btnClear_Clicked(_ button: UIButton) {
        self.selected = -1
        if headerTitle == "Size" {
            appDelegate.selectSizeId = ""
            for i in 0..<(self.condictionColorLise?.size!.count)! {
                if self.condictionColorLise?.size![i] != nil {
                    self.condictionColorLise?.size![i].isSelect = false
                }
            }
        }
        else if headerTitle == "Color" {
            //            appDelegate.selectColorId = ""
            //            for i in 0..<(self.condictionColorLise?.colors!.count)! {
            //                if self.condictionColorLise?.colors![i] != nil {
            //                    self.condictionColorLise?.colors![i].isSelect = false
            //                }
            //            }
            FilterSingleton.share.filter.colors = ""
            FilterSingleton.share.selectedFilter.colors = ""
            
            for i in 0..<(condictionColorLise?.colors?.count ?? 0) {
                if let id = condictionColorLise?.colors?[i].id,
                   FilterSingleton.share.filter.colors?.components(separatedBy: ",").contains("\(id)") == true {
                    condictionColorLise?.colors?[i].isSelect = true
                } else {
                    condictionColorLise?.colors?[i].isSelect = false
                }
            }
            
            self.tblConditionAndSeller.reloadData()
        }
        else if headerTitle == "Condition" {
            FilterSingleton.share.filter.condition_id = ""
            FilterSingleton.share.selectedFilter.condition_id = ""
            self.tblConditionAndSeller.reloadData()
        }
        else if headerTitle == "Seller" {
            FilterSingleton.share.filter.seller = ""
            FilterSingleton.share.selectedFilter.seller = ""
            self.tblConditionAndSeller.reloadData()
        }
        if self.saveSearch == false && self.isFilterProduct == false{
            self.callViewCount()
        }
        self.CVSize.reloadData()
        self.tblConditionAndSeller.reloadData()
    }
}

extension ConditionAndSellerViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.headerTitle == "Color" {
            return self.condictionColorLise?.colors?.count ?? 0
        }
        else if self.headerTitle == "Condition"{
            return self.condictionColorLise?.conditions?.count ?? 0
        }
        else if self.headerTitle == "Seller" {
            return self.list.count
        }
        else {
            return self.categoryList.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditonAndSellerCell", for: indexPath) as! ConditonAndSellerCell
        
        if self.headerTitle == "Color" {
            let objet = self.condictionColorLise?.colors
            cell.imgColor.isHidden = false
            cell.lblTitle.text = objet?[indexPath.row].name
            cell.comstraintLeding.constant = 6
            if objet?[indexPath.row].photo == ""{
                cell.imgColor.image = nil
                if let colorcode = objet?[indexPath.row].colorcode {
                    let newColorCode = colorcode.replace("#", replacement: "")
                    cell.imgColor.backgroundColor = UIColor.init(hex: String(newColorCode ))
                    print("Color code : - \(colorcode)")
                }else{
                    cell.imgColor.image = nil
                    cell.imgColor.backgroundColor = .clear
                }
            }
            else{
                if let url = objet?[indexPath.row].photo{
                    print("image: - \(url)")
                    cell.imgColor.setImageFast(with: url)
                }
            }
            
            if FilterSingleton.share.filter.colors?.components(separatedBy: ",").contains( "\(objet?[indexPath.row].id ?? 0)") == true {
                cell.imgSelect.image = UIImage.init(named: "ic_circle_check")
            }
            else{
                cell.imgSelect.image = UIImage.init(named: "ic_circle_uncheck")
            }
        }
        else if self.headerTitle == "Condition"{
            let objet = self.condictionColorLise?.conditions
            cell.imgColor.isHidden = true
            cell.lblTitle.text = objet?[indexPath.row].name
            cell.comstraintLeding.constant = -20
            if FilterSingleton.share.filter.condition_id == "\(objet?[indexPath.row].id ?? 0)" {
                cell.imgSelect.image = UIImage.init(named: "ic_circle_check")
            }
            else{
                cell.imgSelect.image = UIImage.init(named: "ic_circle_uncheck")
            }
        }
        else if self.headerTitle == "Seller"{
            
            cell.imgColor.isHidden = true
            cell.lblTitle.text = self.list[indexPath.row]?.name ?? ""
            cell.comstraintLeding.constant = -20
            if FilterSingleton.share.filter.seller ==  "\(self.list[indexPath.row]?.id ?? 0)"{
                cell.imgSelect.image = UIImage.init(named: "ic_circle_check")
            }
            else{
                cell.imgSelect.image = UIImage.init(named: "ic_circle_uncheck")
            }
        }
        else{
            let objet = self.categoryList[indexPath.item]
            cell.imgColor.isHidden = true
            cell.lblTitle.text = objet?.name
            cell.comstraintLeding.constant = -20
            if self.selected == indexPath.item {
                cell.imgSelect.image = UIImage.init(named: "ic_circle_check")
            }
            else{
                cell.imgSelect.image = UIImage.init(named: "ic_circle_uncheck")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.headerTitle == "Color" {
            let objet = self.condictionColorLise?.colors
            
            if objet?[indexPath.row].isSelect == true {
                self.condictionColorLise?.colors?[indexPath.row].isSelect = false
            }else{
                self.condictionColorLise?.colors?[indexPath.row].isSelect = true
            }
            
            
            FilterSingleton.share.filter.colors = self.condictionColorLise?.colors?.filter{$0.isSelect == true}.map{"\($0.id ?? 0)"}.joined(separator: ",")
            FilterSingleton.share.selectedFilter.colors = self.condictionColorLise?.colors?.filter{$0.isSelect == true}.map{$0.name ?? ""}.joined(separator: ",")
            self.selected = indexPath.item
            self.tblConditionAndSeller.reloadData()
            
            //if self.saveSearch == false && self.isFilterProduct == false{
            self.callViewCount()
            //}
        }
        else if self.headerTitle == "Condition"{
            let objet = self.condictionColorLise?.conditions?[indexPath.row]
            self.selected = indexPath.row
            FilterSingleton.share.filter.condition_id = "\(objet?.id ?? 0)"
            FilterSingleton.share.selectedFilter.condition_id = "\(objet?.name ?? "")"
            self.tblConditionAndSeller.reloadData()
            // if self.saveSearch == false && self.isFilterProduct == false{
            self.callViewCount()
            // }
        }
        else if self.headerTitle == "Seller" {
            let objet = self.list[indexPath.row]
            //            for i in 0..<self.list.count {
            //                if self.list[i] != nil {
            //                    self.list[i]?.isSelect = false
            //                }
            //            }
            //            self.list[indexPath.row]?.isSelect = true
            //            appDelegate.selectSellerId = String(objet?.id ?? 0)
            FilterSingleton.share.filter.seller = String(objet?.id ?? 0)
            FilterSingleton.share.selectedFilter.seller = String(objet?.name ?? "")
            self.tblConditionAndSeller.reloadData()
            // if self.saveSearch == false && self.isFilterProduct == false{
            self.callViewCount()
            // }
        }
        else {
            self.selected = indexPath.item
        }
        self.tblConditionAndSeller.reloadData()
    }
    
}

class ConditonAndSellerCell : UITableViewCell {
    @IBOutlet weak var imgColor: CustomImageView!
    @IBOutlet weak var imgColorPhoto: CustomImageView!
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var comstraintLeding: NSLayoutConstraint!
    
}

extension ConditionAndSellerViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.condictionColorLise?.size?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
        let objet = self.condictionColorLise?.size?[indexPath.item]
        if let size = objet?.name{
            cell.lblTitle.text = size
        }
        if (objet?.isSelect ?? false) {
            cell.bgView.backgroundColor = .black
            cell.lblTitle.textColor = .white
        }
        else {
            cell.bgView.backgroundColor = .white
            cell.lblTitle.textColor = .black
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objet = self.condictionColorLise?.size
        var id  = [String]()
        if objet?[indexPath.item].isSelect == true {
            self.condictionColorLise?.size?[indexPath.item].isSelect = false
            self.selectDataList.removeAll()
            
            for i in 0..<objet!.count {
                if objet?[i].isSelect == true {
                    id.append(String(objet?[i].id ?? 0))
                    self.selectDataList.append(objet?[i].name ?? "")
                    //                    self.selectSize.append(objet![i])
                }
            }
        }
        else {
            self.condictionColorLise?.size?[indexPath.item].isSelect = true
            self.selectDataList.removeAll()
            for i in 0..<objet!.count {
                if objet?[i].isSelect == true {
                    id.append(String(objet?[i].id ?? 0))
                    self.selectDataList.append(objet?[i].name ?? "")
                }
            }
        }
        
        appDelegate.selectSizeId = id.joined(separator: ",")
        self.CVSize.reloadData()
        self.callViewCount()
    }
}

extension ConditionAndSellerViewController {
    func callSizeList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: MySizeModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MY_SIZE_LIST.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.mysizeList = data
                            if self.mysizeList.count > 0{
                                self.selectGengerIndex = 0
                                self.categoryList = self.mysizeList[self.selectGengerIndex]?.categories! as! [Categories?]
                                if self.isFilterProduct == false{
                                    self.callViewCount()
                                }
                            }
                            self.tblConditionAndSeller.reloadData()
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
    
    func callConditionColor( categoryId : String , genderId : String ) {
        if appDelegate.reachable.connection != .none {
            let param = ["category_ids": categoryId,
                         "gender_id" : genderId
            ]
            APIManager().apiCall(of: ConditionColorModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES_SIZE.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.condictionColorLise = data
                        }
                        if self.headerTitle == "Color" {
                            if self.condictionColorLise?.colors?.count == 0 {
                                self.lblNoData.isHidden = false
                            }
                            else {
                                for i in 0..<(self.condictionColorLise?.colors?.count ?? 0){
                                    let data = self.condictionColorLise?.colors?[i]
                                    //                                    if self.saveSearch {
                                    //                                        if self.selectColorId.contains("\(data?.id ?? -1)"){
                                    //                                            self.condictionColorLise?.colors?[i].isSelect = true
                                    //                                        }
                                    //                                    }else{
                                    if FilterSingleton.share.filter.colors?.components(separatedBy: ",").contains("\(data?.id ?? -1)") == true{
                                        self.condictionColorLise?.colors?[i].isSelect = true
                                    }
                                    //                                    }
                                }
                                self.lblNoData.isHidden = true
                            }
                        }
                        else if self.headerTitle == "Condition"{
                            if self.condictionColorLise?.conditions?.count == 0 {
                                self.lblNoData.isHidden = false
                            }
                            else {
                                for i in 0..<(self.condictionColorLise?.conditions?.count ?? 0) {
                                    let data = self.condictionColorLise?.conditions?[i]
                                    if self.saveSearch {
                                        if Int(self.selectConditionId) == data?.id{
                                            self.selected = i
                                            self.selectedCondition.removeAll()
                                            self.selectedCondition.append(data)
                                        }
                                    }else{
                                        if Int(FilterSingleton.share.filter.condition_id ?? "") == data?.id{
                                            self.selected = i
                                            self.selectedCondition.removeAll()
                                            self.selectedCondition.append(data)
                                        }
                                    }
                                }
                                self.lblNoData.isHidden = true
                            }
                        }
                        else if self.headerTitle == "Seller" {
                            if self.list.count == 0 {
                                self.lblNoData.isHidden = false
                            }
                            else {
                                self.lblNoData.isHidden = true
                            }
                        }
                        else {
                            if self.condictionColorLise?.size?.count == 0 {
                                self.lblNoData.isHidden = false
                            }
                            else {
                                self.lblNoData.isHidden = true
                            }
                        }
                        self.tblConditionAndSeller.reloadData()
                        self.CVSize.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            
            //            let param = ["is_mysize":  "0" ,
            //                         "gender_id" : appDelegate.selectGenderId,
            //                         "categories" : String(appDelegate.selectSubCategoryId.joined(separator: ",")),
            //                         "sizes" : appDelegate.selectSizeId,
            //                         "colors" : appDelegate.selectColorId,
            //                         "condition_id" : appDelegate.selectConditionId ,
            //                         "distance" : appDelegate.selectDistnce,
            //                         "seller" : appDelegate.selectSellerId,
            //                         "brand_id" : appDelegate.selectBrandId ,
            //                         "notification_item_counter" : "",
            //                         "name" :  "",
            //                         "price_type" : appDelegate.selectPriceId ,
            //                         "price_from" : appDelegate.priceFrom ,
            //                         "price_to" : appDelegate.priceTo,
            //                         "is_only_count" : "1" ,
            //                         "page" : "0"
            //            ]
            FilterSingleton.share.filter.is_only_count = "1"
            var dict = FilterSingleton.share.filter.toDictionary() ?? [:]
            dict.removeValue(forKey: "slectedCategories")
            dict["latitude"] = appDelegate.userLocation?.latitude ?? ""
            dict["longitude"] = appDelegate.userLocation?.longitude ?? ""
            APIManager().apiCallWithMultipart(of: ViewCountModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FILTER_POST.rawValue, parameters: dict) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData{
                            self.viewCount = data.total_posts ?? 0
                            if self.saveSearch {
                                self.btnViewItems.setTitle("Add to saved Search", for: .normal)
                            }
                            else {
                                self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                                self.btnViewItems.backgroundColor = self.viewCount == 0 ? .customButton_bg_gray : .customBlack
                            }
                            self.tblConditionAndSeller.reloadData()
                            //                            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                            
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

extension ConditionAndSellerViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 5
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (5 + 1)
        let interitemPadding = max(0.0, 5 - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / 6
        return CGSize(width: widthPerItem, height: 55)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
}
