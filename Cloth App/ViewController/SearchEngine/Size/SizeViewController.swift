//
//  SizeViewController.swift
//  ClothApp
//
//  Created by Apple on 03/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

protocol GenderDelegate {
    func selectGendr(gender: MySizeModel?)
}

protocol SizeDelegate {
    func selctedSize (Size: [Sizes?], Selecte:Bool,index : Int,hearderTitel: String)
}



class SizeViewController: BaseViewController {
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var CVGender: UICollectionView!
    @IBOutlet weak var constHeightForCVGender: NSLayoutConstraint!
    @IBOutlet weak var tblClothsPref: UITableView!
    @IBOutlet weak var constTopForTblClothsPref: NSLayoutConstraint!
    @IBOutlet weak var constHeightForTblClothsPref: NSLayoutConstraint!
    
    @IBOutlet weak var btnViewItems: CustomButton!
    @IBOutlet weak var constTopForbtnViewItems: NSLayoutConstraint!
    
    var selectedSize = [Sizes?]()
    var condictionColorLise : ConditionColorModel?
    var genderDelegate : GenderDelegate!
    var sizeDelegate : SizeDelegate!
    var userDetail : UserDetailsModel?
    var selectSize : MySizeModel?
    var mysizeList = [MySizeModel?]()
    var categoryList = [Categories?]()
    var selectGenderId = -1
    var viewCount = 0
    var isFromGender = false
    var saveSearch = false
    var filterSize = false
    var isMySize = ""
    var selectSubCategoryId = [String]()
    var selectedIndex = 0
    var headerTitle = ""
    var selectSizeId = ""
    var selectedSizeID = [String]()
    var selectedSizeName = [String]()
    var isSaveSearch :Bool?
    var isFilterProduct : Bool?
    deinit {
        tblClothsPref.removeObserver(self, forKeyPath: "contentSize")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callViewCount()
        self.lblNoData.isHidden = true
        self.tblClothsPref.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
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
        
        if !self.filterSize {
            //            self.callSizeList()
        }
        
        if self.isFromGender {
            self.lblTitle.text = "Gender"
            self.tblClothsPref.isHidden = true
            //            self.constTopForbtnViewItems.constant = -120
        }
        
        else {//if self.filterSize {
            self.lblGender.isHidden = true
            self.CVGender.isHidden = true
            self.tblClothsPref.isHidden = false
            self.lblTitle.text = "Size"
            self.constTopForTblClothsPref.constant = -(self.CVGender.bounds.height + self.lblGender.bounds.height + 35 ) //-100
            //            self.constTopForbtnViewItems.constant = 20
//            if self.saveSearch{
//                self.callConditionColor(categoryId: String(self.selectSubCategoryId.joined(separator: ",")), genderId: "\(selectGenderId)" )
//            }else{
                
                self.callConditionColor(categoryId: FilterSingleton.share.filter.categories ?? "", genderId: FilterSingleton.share.filter.gender_id ?? "" )
//            }
        }
    }
    
    // Implement the observer method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                // Adjust the height constraint of the table view
                self.constHeightForTblClothsPref.constant = newSize.height
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        if !self.isFromGender {
        //            self.tblClothsPref.reloadData()
        //            self.tblClothsPref.layoutIfNeeded()
        //            self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
        //        }
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnClear_Clicked(_ button: Any) {
        if self.isFromGender == true{
            
            if self.saveSearch {
                self.selectGenderId = -1
                self.selectSize = nil
            }else{
                FilterSingleton.share.filter.gender_id = ""
                self.selectSize = nil
            }
            self.tblClothsPref.reloadData()
            self.CVGender.reloadData()
            if self.isFilterProduct == false{
                self.callViewCount()
            }
        }else{
            if self.saveSearch || self.isFilterProduct == true {
                //                for i in 0..<self.categoryList.count {
                //                    var outerModel = self.categoryList[i]
                //                    for j in 0..<(outerModel?.sizes!.count)! {
                //                        var innerModel = outerModel?.sizes![j]
                //                        if innerModel?.isSelect == true{
                //                            innerModel?.isSelect = false
                //                        }
                //                        else{
                //                            innerModel?.isSelect = false
                //                        }
                //                        outerModel?.sizes![j] = innerModel!
                //                    }
                //                    self.categoryList[i] = outerModel
                //                    self.selectedSize.removeAll()
                //                    self.tblClothsPref.reloadData()
                //                }
                DispatchQueue.main.async {
                    FilterSingleton.share.filter.sizes = ""
                    FilterSingleton.share.selectedFilter.sizes = ""
                    self.tblClothsPref.reloadData()
                }
            }else{
                
                DispatchQueue.main.async {
                    FilterSingleton.share.filter.sizes = ""
                    FilterSingleton.share.selectedFilter.sizes = ""
                   // if self.isFilterProduct == false{
                        self.callViewCount()
                   // }
                    self.tblClothsPref.reloadData()
                }
                
            }
        }
    }
    @IBAction func btnViewCount_Clicked(_ button: UIButton) {
        if self.saveSearch || self.isFilterProduct == true{
            //            if self.genderDelegate != nil {
            //                self.genderDelegate.selectGendr(gender: self.selectSize)
            //                self.navigationController?.popViewController(animated: true)
            //            }
            //            else if self.filterSize{
            //                let objet = self.categoryList
            //                self.selectedSize.removeAll()
            //                for i in 0..<(objet.count ){
            //                    for j in 0..<(objet[i]?.sizes?.count ?? 0){
            //                        if objet[i]?.sizes?[j].isSelect ?? false {
            //                            if let size = objet[i]?.sizes?[j]{
            //                                self.selectedSize.append(size)
            //                            }
            //                        }
            //                    }
            //                }
            //                if self.sizeDelegate != nil{
            //
            //                    self.sizeDelegate.selctedSize(Size: self.selectedSize, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            //                    self.navigationController?.popViewController(animated: true)
            //
            //                }
            //            }
            self.popViewController()
        }
        else {
            if self.viewCount != 0 {
                let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
                //                viewController.titleStr = "Search Results"
                viewController.titleStr = "Search Results"
                //                viewController.selectGenderId =  appDelegate.selectGenderId
                //                viewController.isMySize = self.isMySize
                //                viewController.selectSubCategoryId = self.selectSubCategoryId
                //                viewController.selectSizeId = appDelegate.selectSizeId
                //                viewController.selectColorId = appDelegate.selectColorId
                //                viewController.selectConditionId = appDelegate.selectConditionId
                //                viewController.selectPriceId = appDelegate.selectPriceId
                //                viewController.priceFrom = appDelegate.priceFrom
                //                viewController.priceTo = appDelegate.priceTo
                //                viewController.selectDistnce = appDelegate.selectDistnce
                //                viewController.selectSellerId = appDelegate.selectSellerId
                //                viewController.selectBrandId = appDelegate.selectBrandId
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        
    }
    
    @IBAction func btnBack_Clicked(_ button: UIButton) {
        if self.isFromGender {
            if self.genderDelegate != nil {
                self.genderDelegate.selectGendr(gender: self.selectSize)
            }
        }
        else if self.filterSize{
            let objet = self.categoryList
            self.selectedSize.removeAll()
            for i in 0..<(objet.count ){
                for j in 0..<(objet[i]?.sizes?.count ?? 0){
                    if objet[i]?.sizes?[j].isSelect ?? false {
                        if let size = objet[i]?.sizes?[j]{
                            self.selectedSize.append(size)
                        }
                    }
                }
            }
            if self.sizeDelegate != nil{
                self.sizeDelegate.selctedSize(Size: self.selectedSize, Selecte: true, index: self.selectedIndex, hearderTitel: self.headerTitle)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension SizeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefHeaderTblCell") as! ClothPrefHeaderTblCell
    //        let objct = self.categoryList[section]
    //        cell.imgCloths.isHidden = false
    //        cell.lblTitle.text = objct?.name
    //        if let url = objct?.image {
    //            if let imgUrl = URL.init(string: url) {
    //                cell.imgCloths.kf.setImage(with: imgUrl, placeholder: PlaceHolderImage)
    //            }
    //        }
    //        return cell.contentView
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefHeaderTblCell") as! ClothPrefHeaderTblCell
        let objct = self.categoryList[section]
        cell.imgCloths.isHidden = false
        cell.lblTitle.text = objct?.name
        if let url = objct?.image?.replacingOccurrences(of: " ", with: "%20").trim() {
            cell.imgCloths.setImageFast(with: url)
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefRowTblCell", for: indexPath) as! ClothPrefRowTblCell
        cell.CVClothsPref.tag = indexPath.section
        let alignedFlowLayout = cell.CVClothsPref?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        cell.CVClothsPref.dataSource = self
        cell.CVClothsPref.delegate = self
        cell.CVClothsPref.tag = indexPath.section
        cell.frame = tblClothsPref.bounds
        cell.layoutIfNeeded()
        cell.CVClothsPref.reloadData()
        cell.heightConstForCVClothsPref.constant = cell.CVClothsPref.collectionViewLayout.collectionViewContentSize.height
        self.tblClothsPref.layoutIfNeeded()
//        self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height + 20
        return cell
    }
    
    
}

extension SizeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.CVGender {
            return self.mysizeList.count
        }
        else{
            return self.categoryList[collectionView.tag]?.sizes?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.CVGender {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            
            if let gender = self.mysizeList[indexPath.item]?.gender_name {
                cell.lblTitle.text = gender
            }
            if self.saveSearch {
                if  Int(selectGenderId) == mysizeList[indexPath.row]?.gender_id {
                    cell.bgView.backgroundColor = UIColor.black
                    cell.lblTitle.textColor = UIColor.white
                }
                else{
                    cell.bgView.backgroundColor = UIColor.white
                    cell.lblTitle.textColor = UIColor.black
                }
            }else{
                if  Int(FilterSingleton.share.filter.gender_id ?? "") == mysizeList[indexPath.row]?.gender_id {
                    cell.bgView.backgroundColor = UIColor.black
                    cell.lblTitle.textColor = UIColor.white
                }
                else{
                    cell.bgView.backgroundColor = UIColor.white
                    cell.lblTitle.textColor = UIColor.black
                }
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            let object = self.categoryList[collectionView.tag]?.sizes![indexPath.item]
            if let sizedata = object?.name {
                cell.lblTitle.text = sizedata
            }
            if FilterSingleton.share.filter.sizes?.components(separatedBy: ",").contains("\(object?.id ?? 0)") == true{
                cell.bgView.backgroundColor = UIColor.black
                cell.lblTitle.textColor = UIColor.white
            }
            else{
                cell.bgView.backgroundColor = UIColor.white
                cell.lblTitle.textColor = UIColor.black
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == CVGender {
            appDelegate.isMySize = "0"
            appDelegate.selectBrandId = ""
            appDelegate.selectGenderId = ""
            appDelegate.selectSubCategoryId.removeAll()
            appDelegate.selectSubCategoryName.removeAll()
            appDelegate.selectPriceId = ""
            appDelegate.priceFrom = ""
            appDelegate.priceTo = ""
            appDelegate.selectDistnce = ""
            appDelegate.selectSizeId = ""
            appDelegate.selectConditionId = ""
            appDelegate.selectSellerId = ""
            appDelegate.selectColorId = ""
            let objet = self.mysizeList[indexPath.item]
            self.selectSize = objet
            if let gender = self.mysizeList[indexPath.item]?.gender_id {
                if self.saveSearch {
                    self.selectGenderId = gender
                }else{
                    FilterSingleton.share.filter.gender_id = "\(gender)"
                }
                self.callViewCount()
            }
            self.CVGender.reloadData()
        }
        else
        {
            let object = self.categoryList[collectionView.tag]?.sizes![indexPath.item]
            debugPrint(object?.id ?? 0)
            if FilterSingleton.share.filter.sizes?.components(separatedBy: ",").contains("\(object?.id ?? 0)") == true{
                let index = FilterSingleton.share.filter.sizes?.components(separatedBy: ",").firstIndex(of: "\(object?.id ?? 0)")  ?? 0
                var data = FilterSingleton.share.filter.sizes?.components(separatedBy: ",")
                data?.remove(at: index)
                FilterSingleton.share.filter.sizes = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
                
                var dataName = FilterSingleton.share.selectedFilter.sizes?.components(separatedBy: ",")
                dataName?.remove(at: index)
                FilterSingleton.share.selectedFilter.sizes = dataName?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
            }else{
                var data = FilterSingleton.share.filter.sizes?.components(separatedBy: ",")
                data?.append("\(object?.id ?? 0)")
                FilterSingleton.share.filter.sizes = data?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
                
                var dataName = FilterSingleton.share.selectedFilter.sizes?.components(separatedBy: ",")
                dataName?.append("\(object?.name ?? "")")
                FilterSingleton.share.selectedFilter.sizes = dataName?.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }.joined(separator: ",")
            }
            
            collectionView.reloadData()
            if self.saveSearch == false || self.isFilterProduct == false {
                self.callViewCount()
            }
        }
    }
    
    @objc func btnRemoveBrand_clicked(_ sender: Any) {
    }
    
}


extension SizeViewController: UICollectionViewDelegateFlowLayout {
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
        
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
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

extension SizeViewController {
    func callSizeList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: MySizeModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MY_SIZE_LIST.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.mysizeList = data
                            for i in 0..<self.mysizeList.count{
                                if self.saveSearch{
                                    if self.mysizeList[i]?.gender_id == Int(self.selectGenderId) {
                                        self.selectSize = self.mysizeList[i]
                                    }
                                }else{
                                    if self.mysizeList[i]?.gender_id == Int(FilterSingleton.share.filter.gender_id ?? "") {
                                        self.selectSize = self.mysizeList[i]
                                    }
                                }
                            }
                            self.CVGender.reloadData()
                            self.CVGender.layoutIfNeeded()
                            self.constHeightForCVGender.constant = self.CVGender.contentSize.height
                            
                            //                            self.tblClothsPref.reloadData()
                            if !self.saveSearch{
                                self.callViewCount()
                            }
                            
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
    
    func callViewCount() {
        if appDelegate.reachable.connection != .none {
            //            let objet = self.categoryList
            //            self.selectedSize.removeAll()
            //            for i in 0..<(objet.count ){
            //                for j in 0..<(objet[i]?.sizes?.count ?? 0){
            //                    if objet[i]?.sizes?[j].isSelect ?? false {
            //                        if let size = objet[i]?.sizes?[j]{
            //                            //                            self.selectedSize.append(size)
            //                            self.selectedSize.append(size)
            //                        }
            //                    }
            //                }
            //            }
            ////            var id  = [String]()
            ////            for i in 0..<self.selectedSize.count{
            ////                id.append(String(self.selectedSize[i]?.id ?? 0))
            ////            }
            //            let id = self.selectedSize.map{"\($0?.id ?? 0)"}.joined(separator: ",")
            ////            appDelegate.selectSizeId = id
            
            //            FilterSingleton.share.filter.sizes = id
            //            FilterSingleton.share.selectedFilter.sizes = self.selectedSize.map{"\($0?.name ?? "")"}.joined(separator: ",")
            
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
                            //                            self.btnViewItems.setTitle("View \(self.viewCount) Items", for: .normal)
                            
                        }
                        //                        self.navigateToHomeScreen()
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
                        if var group_size = self.condictionColorLise?.group_size{
                            for i in 0..<group_size.count{
                                if group_size[i].sizes?.count != 0 {
                                    for j in 0..<(group_size[i].sizes?.count ?? 0){
                                        if let id = group_size[i].sizes?[j].id {
                                            if !self.saveSearch{
                                                if FilterSingleton.share.filter.sizes?.components(separatedBy: ",").contains("\(id)") == true{
                                                    group_size[i].sizes?[j].isSelect = true
                                                }
                                            }else{
                                                if self.selectSizeId.contains("\(id)"){
                                                    group_size[i].sizes?[j].isSelect = true
                                                }
                                            }
                                        }
                                    }
                                    self.categoryList.append(group_size[i])
                                }
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
                        self.tblClothsPref.reloadData()
                        self.tblClothsPref.layoutIfNeeded()
//                        self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
                        //                        self.CVSize.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}
