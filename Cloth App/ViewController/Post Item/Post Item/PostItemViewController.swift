//
//  PostItemViewController.swift
//  ClothApp
//
//  Created by Apple on 14/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout


class PostItemViewController: BaseViewController {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnBack: UIButton!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var tblClothsPref: UITableView!
    @IBOutlet weak var constHeightForTblClothsPref: NSLayoutConstraint!
    @IBOutlet weak var btnNext: CustomButton!
    
    let titleList = ["Department","Category","Subcategory"]
    var genderList = [CategoryModel?]()
    var categoryList = [Categorie?]()
    var subCategoryList = [ChildCategories?]()
    var isFromGender = true
    var saveSearch = false
    var selectCategoryIndex = -1
    var selectSubCategoryIndex = -1
    var selectGengerIndex = -1
    var savegenderId : CategoryModel?
    var saveCategoriseId : Categorie?
    var saveSubCategoryId : ChildCategories?
    
    var edit = false
    var postDetails : PostDetailsModel?
    
    deinit {
        if self.tblClothsPref != nil {
            self.tblClothsPref.removeObserver(self, forKeyPath: "contentSize")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnNext.isHidden = false
        self.btnNext.backgroundColor = UIColor.customButton_bg_gray
        self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
        self.btnNext.isUserInteractionEnabled = false
//        self.constHeightForTblClothsPref.constant = 0
        if let tblClothsPref = tblClothsPref {
            tblClothsPref.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        }

        if self.edit{
            self.btnBack.isHidden = false
            self.btnDelete.isHidden = false
//            self.savegenderId?.gender_id = self.postDetails?.gender_id ?? 0
//            let objet = self.genderList[indexPath.item]
//            self.savegenderId = objet
//            self.categoryList = self.genderList[self.selectGengerIndex]?.categories as! [Categorie?]
//            self.nextButtonHideShow()
        }
    }
    
    // Implement the observer method
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                // Adjust the height constraint of the table view
                constHeightForTblClothsPref.constant = newSize.height
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.isHidden = true
        if savegenderId == nil {
            self.selectGengerIndex = -1
            self.selectCategoryIndex = -1
            self.selectSubCategoryIndex = -1
            self.categoryList.removeAll()
            self.subCategoryList.removeAll()
            self.callCategoryList()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tblClothsPref.reloadData()
        self.tblClothsPref.layoutIfNeeded()
//        self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func deleteOnPress(_ sender: UIButton) {
        let vc = DeletePostVC.instantiate(fromStoryboard: .Sell)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.isCancelHide = false
        vc.deleteTitle = "Delete"
        vc.deleteBgColor = .red
        vc.titleMain = "Are you sure?"
        vc.subTitle = "By clicking delete, you will not be able to recover your listing"
        vc.imgMain = UIImage(named: "ic_delete_big")
        vc.deleteOnTap = {
            DeleteProduct.share.delete(postId: "\(self.postDetails?.id ?? 0)", view: self) { status in
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        self.present(vc, animated: true)
        
    }
    
    @IBAction func btnNext_Clicked(_ button: UIButton) {
        
        if self.savegenderId == nil {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select gender")
        }
        else if self.saveCategoriseId == nil {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select category")
        }
        else {
            let ViewController = PostItemsizeConditionColorViewController.instantiate(fromStoryboard: .Main)
            ViewController.savegenderId = self.savegenderId
            ViewController.selectCategory = self.saveCategoriseId
            ViewController.selectSubcategory = self.saveSubCategoryId
            ViewController.styles = self.genderList.first??.styles ?? []
            ViewController.hidesBottomBarWhenPushed = true
            ViewController.edit = self.edit
            ViewController.postDetails = self.postDetails
            self.navigationController?.pushViewController(ViewController, animated: true)
        }
    }
    
    @IBAction func btnCancel_Clicked(_ button: UIButton) {
        
        self.selectGengerIndex = -1
        self.selectCategoryIndex = -1
        self.selectSubCategoryIndex = -1
        self.savegenderId = nil
        self.saveCategoriseId = nil
        self.saveSubCategoryId = nil
        self.btnNext.backgroundColor = UIColor.customButton_bg_gray
        self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
        self.btnNext.isUserInteractionEnabled = false
        self.categoryList.removeAll()
        self.subCategoryList.removeAll()
        self.tblClothsPref.reloadData()
    }
    
    func nextButtonHideShow () {
        if self.selectGengerIndex !=  -1 {
            if self.categoryList.count != 0 {
                if self.subCategoryList.count != 0 {
                    if self.selectSubCategoryIndex != -1 {
                        self.btnNext.isHidden = false
                        self.btnNext.backgroundColor = UIColor.customBlack
                        self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
                        self.btnNext.isUserInteractionEnabled = true
                    }else {
                        self.btnNext.backgroundColor = UIColor.customButton_bg_gray
                        self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
                        self.btnNext.isUserInteractionEnabled = false
                    }
                }else {
                    if self.selectCategoryIndex != -1 {
                        self.btnNext.isHidden = false
                        self.btnNext.backgroundColor = UIColor.customBlack
                        self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
                        self.btnNext.isUserInteractionEnabled = true
                    }
                    else {
                        self.btnNext.backgroundColor = UIColor.customButton_bg_gray
                        self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
                        self.btnNext.isUserInteractionEnabled = false
                    }
                }
            }else {
                self.btnNext.backgroundColor = UIColor.customButton_bg_gray
                self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
                self.btnNext.isUserInteractionEnabled = false
            }
        }else {
            self.btnNext.backgroundColor = UIColor.customButton_bg_gray
            self.btnNext.setTitleColor(UIColor.customWhite, for: .normal)
            self.btnNext.isUserInteractionEnabled = false
        }
    }
}

extension PostItemViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefHeaderTblCell") as! ClothPrefHeaderTblCell
        if self .titleList[section] == "Category" {
            if self.categoryList.count == 0 {
                cell.lblTitle.isHidden = true
            }
            else {
                cell.lblTitle.isHidden = false
                cell.lblTitle.text = self.titleList[section]
            }
        }
        else if self.titleList[section] == "Subcategory" {
            if self.subCategoryList.count == 0 {
                cell.lblTitle.isHidden = true
            }
            else {
                cell.lblTitle.isHidden = false
                cell.lblTitle.text = self.titleList[section]
            }
        }
        else {
            cell.lblTitle.isHidden = false
            cell.lblTitle.text = self.titleList[section]
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.titleList[section] == "Category" {
            if self.categoryList.count == 0 {
                return 0
            }else {
                return UITableView.automaticDimension
            }
        }
        else if self.titleList[section] == "Subcategory" {
            if self.subCategoryList.count == 0 {
                
                return 0
            }else {
                return UITableView.automaticDimension
            }
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.titleList[indexPath.section] == "Category" {
            if self.categoryList.count == 0 {
                return 0
            }else {
                return UITableView.automaticDimension
            }
        }
        else if self.titleList[indexPath.section] == "Subcategory" {
            if self.subCategoryList.count == 0 {
                return 0
            }else {
                return UITableView.automaticDimension
            }
        }
        else
        {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefRowTblCell", for: indexPath) as! ClothPrefRowTblCell
        cell.CVClothsPref.tag = indexPath.section
        let alignedFlowLayout = cell.CVClothsPref?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        cell.CVClothsPref.dataSource = self
        cell.CVClothsPref.delegate = self
        cell.CVClothsPref.prefetchDataSource = self
        cell.CVClothsPref.reloadData()
        cell.layoutIfNeeded()
        cell.heightConstForCVClothsPref.constant = cell.CVClothsPref.collectionViewLayout.collectionViewContentSize.height
        return cell
    }
}

extension PostItemViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return self.genderList.count
        }
        else if collectionView.tag == 1 {
            return self.categoryList.count
        }
        else if collectionView.tag == 2 {
            return self.subCategoryList.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
        
        cell.imgContainer.isHidden = collectionView.tag != 1
        cell.bottomView.isHidden  = collectionView.tag != 1
        if collectionView.tag == 0 {
            let objet = self.genderList[indexPath.item]
            
            if self.savegenderId?.gender_id == objet?.gender_id {
                cell.bgView.backgroundColor = .customBlack
                cell.lblTitle.textColor = .customWhite
                cell.lblTitle.text = objet?.name
                
            }else {
                cell.bgView.backgroundColor = .customWhite
                cell.lblTitle.textColor = .customBlack
                cell.lblTitle.text = objet?.name
            }
        }
        if collectionView.tag == 1{
            let objet = self.categoryList[indexPath.item]
            
            if let category = objet?.name {
                cell.lblTitle.text = category
            }
            
            if let image  = URL.init(string: objet?.photo ?? ""){
                cell.imgCat.kf.setImage(with: image,placeholder: PlaceHolderImage)
                
                if self.saveCategoriseId?.category_id == objet?.category_id {
                    cell.bgView.backgroundColor = .customBlack
                    cell.lblTitle.textColor = .customWhite
                    cell.configure(with: image, tintColor: .customWhite ?? .white)
                    
                }else{
                    cell.bgView.backgroundColor = .customWhite
                    cell.lblTitle.textColor = .customBlack
                    cell.configure(with: image, tintColor: .customBlack ?? .black)
                }
            }
        }
        if collectionView.tag == 2 {
            let objet = self.subCategoryList[indexPath.item]
            if let subcategory = objet?.name {
                cell.lblTitle.text = subcategory
            }
            if self.saveSubCategoryId?.id == objet?.id {
                cell.bgView.backgroundColor = .customBlack
                cell.lblTitle.textColor = .customWhite
            }else{
                cell.bgView.backgroundColor = .customWhite
                cell.lblTitle.textColor = .customBlack
            }
        }
        return cell
    }
  
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetching items at: \(indexPaths)")
        for indexPath in indexPaths {
            if let imageUrl = URL(string:self.categoryList[indexPath.item]?.photo ?? ""){
                if ImageCache.shared.image(forKey: imageUrl.absoluteString) == nil {
                    DispatchQueue.global().async {
                        guard let imageData = try? Data(contentsOf: imageUrl),
                              let image = UIImage(data: imageData) else {
                            return
                        }
                        let templateImage = image.withRenderingMode(.alwaysTemplate)
                        ImageCache.shared.save(image: templateImage, forKey: imageUrl.absoluteString)
                    }
                }
            }
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            self.selectGengerIndex = indexPath.item
            self.selectCategoryIndex = -1
            self.selectSubCategoryIndex = -1
            self.categoryList.removeAll()
            self.subCategoryList.removeAll()
            let objet = self.genderList[indexPath.item]
            self.savegenderId = objet
            self.postDetails?.gender_id = objet?.gender_id ?? 0
            self.postDetails?.gender_name = objet?.name ?? ""
            if let categories = self.genderList[self.selectGengerIndex]?.categories as? [Categorie?] {
                self.categoryList = categories
            } else {
                self.categoryList = []
            }
            self.nextButtonHideShow()
        }
        
        if collectionView.tag == 1 {
            //            self.nextButtonHideShow()
            self.selectCategoryIndex = indexPath.item
            self.selectSubCategoryIndex = -1
            self.subCategoryList.removeAll()
            let objet = self.categoryList[indexPath.item]
            self.selectCategoryIndex = indexPath.item
            self.subCategoryList = objet?.childCategories as! [ChildCategories?]
            self.saveCategoriseId = objet
            self.nextButtonHideShow()
            
        }
        if collectionView.tag == 2 {
            self.selectSubCategoryIndex = indexPath.item
            let objet = self.subCategoryList[indexPath.item]
            self.saveSubCategoryId = objet
            self.nextButtonHideShow()
            
        }
        self.tblClothsPref.reloadData()
        
    }
}

extension PostItemViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2
    }
    
    fileprivate var itemsPerRowForTag1: CGFloat {
        return 2
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 1{
            let sectionPadding = sectionInsets.left * (itemsPerRowForTag1 + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / itemsPerRowForTag1
            return CGSize(width: widthPerItem, height: 100)
        }else{
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 55)
        }
        
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

extension PostItemViewController {
    func callCategoryList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: CategoryModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.genderList = data
                            self.genderList.removeLast()
//                            if self.genderList.count > 0{
//                                if self.selectGengerIndex != -1{
//                                    self.categoryList = self.genderList[self.selectGengerIndex]?.categories! as! [Categorie]
//                                    self.subCategoryList = self.categoryList[self.selectCategoryIndex]?.childCategories! as![ChildCategories?]
//                                }
//                            }
                            if self.edit{
                                self.selectGengerIndex = self.postDetails?.gender_id ?? 0 == 1 ? 0 : 1
                                self.selectCategoryIndex = -1
                                self.selectSubCategoryIndex = -1
                                self.categoryList.removeAll()
                                self.subCategoryList.removeAll()
                                let objet = self.genderList[self.postDetails?.gender_id ?? 0 == 1 ? 0 : 1]
                                self.savegenderId = objet
                                if let categories = self.genderList[self.selectGengerIndex]?.categories as? [Categorie?] {
                                    self.categoryList = categories
                                } else {
                                    self.categoryList = []
                                }
                                
                                if let index = self.categoryList.firstIndex(where: { $0?.category_id == self.postDetails?.categories?.first?.id ?? 0 }) {
                                    print("Index of category with id 10: \(index)")
                                    self.selectCategoryIndex = index
                                    self.selectSubCategoryIndex = -1
                                    self.subCategoryList.removeAll()
                                    let objet = self.categoryList[index]
                                    self.selectCategoryIndex = index
                                    self.subCategoryList = objet?.childCategories as! [ChildCategories?]
                                    self.saveCategoriseId = objet
                                }
                                
                                if let index = self.subCategoryList.firstIndex(where: { $0?.id == self.postDetails?.categories?.last?.id ?? 0  }) {
                                    
                                    self.selectSubCategoryIndex = index
                                    let objet = self.subCategoryList[index]
                                    self.saveSubCategoryId = objet
                                }
                                self.nextButtonHideShow()
                            }
                            self.tblClothsPref.reloadData()
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
