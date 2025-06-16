//
//  PostItemsizeConditionColorViewController.swift
//  ClothApp
//
//  Created by Apple on 15/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class PostItemsizeConditionColorViewController: BaseViewController {

    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var stkproduct: UIStackView!
    @IBOutlet weak var conststkHeight: NSLayoutConstraint!
    @IBOutlet weak var lblProducturl: UILabel!
    @IBOutlet weak var txtProducturl: CustomTextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblSizeTitle: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var constTopForlblColor: NSLayoutConstraint!
    @IBOutlet weak var constTopForlblSizeTitle: NSLayoutConstraint!
    @IBOutlet weak var CVSize: UICollectionView!
    @IBOutlet weak var constHeightForCVSize: NSLayoutConstraint!
    @IBOutlet weak var CVCondition: UICollectionView!
    @IBOutlet weak var constHeightForCVCondition: NSLayoutConstraint!
    @IBOutlet weak var tblColor: UITableView!
    @IBOutlet weak var constHeightForTblColor: NSLayoutConstraint!
    @IBOutlet weak var btnNext: CustomButton!

    var selectSizeIndex = -1
    var selectConditionIndex = -1
    var selectColorIndex = -1
    var savegenderId : CategoryModel?
    var selectCategory : Categorie?
    var styles : [Styles]?
    var selectSubcategory : ChildCategories?
    var categorysAndSubCategory = [Categorie]()
    var genderList = [CategoryModel?]()
    var categoryList = [Categorie?]()
    var subCategoryList = [ChildCategories?]()
    var condictionColorLise : ConditionColorModel?
    var selectSize :Size?
    var selectCondiction : Conditions?
    var selectColor = [Colors?]()
    var postImageVideo = [ImagesVideoModel]()
    var edit = false
    var postDetails : PostDetailsModel?
    
    var colorCoutn = 1
    var i = 1
    var isAccessories : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.edit {
            self.btnCross.setImage(UIImage.init(named: "ic_delete_red"), for: .normal)
            if appDelegate.userDetails?.role_id == 3{
                self.lblSizeTitle.isHidden = true
                self.CVSize.isHidden = true
                self.lblCondition.isHidden = true
                self.CVCondition.isHidden = true
                // self.lblSizeTitle.frame.size.height = -30
                self.constTopForlblColor.constant = -140
                var categoryIDString  = [String]()
                self.txtProducturl.text = self.postDetails?.product_url ?? ""
                let dict = ["gender_id": self.postDetails?.gender_id ?? 0,
                            "name": self.postDetails?.gender_name ?? ""] as [String : Any]
                let genderobjCat = CategoryModel.init(JSON: dict)
                //                self.savegenderId = genderobjCat
                //                for i in 0..<(self.postDetails?.categories?.count ?? 0)! {
                //                    let dict = ["category_id": self.postDetails?.categories?[i].id ?? 0,
                //                                "name": self.postDetails?.categories?[i].name ?? ""] as [String : Any]
                //                    let categoryobjCat = Categorie.init(JSON: dict)!
                //                    self.categorysAndSubCategory.append(categoryobjCat)
                //                }
                //                for i in 0..<self.categorysAndSubCategory.count {
                //                    categoryIDString.append(String(categorysAndSubCategory[i].category_id ?? 0))
                //                }
                
                let dict1 = ["category_id": self.selectCategory?.category_id ?? 0,
                             "name": self.selectCategory?.name  ?? ""] as [String : Any]
                let categoryobjCat = Categorie.init(JSON: dict1)!
                self.categorysAndSubCategory.append(categoryobjCat)
                let dict2 = ["category_id": self.selectSubcategory?.category_id ?? 0,
                             "name": self.selectSubcategory?.name ?? ""] as [String : Any]
                let subcategoryobjCat = Categorie.init(JSON: dict2)!
                self.categorysAndSubCategory.append(subcategoryobjCat)
                for i in 0..<self.categorysAndSubCategory.count {
                    categoryIDString.append(String(categorysAndSubCategory[i].category_id ?? 0))
                }
                if let producturl = self.postDetails?.product_url {
                    self.txtProducturl.text = producturl
                }
                if let genderId = self.savegenderId?.gender_id {
                    self.callConditionColor(categoryId: categoryIDString.joined(separator: ","), genderId: "\(genderId)")
                }
                self.btnNext.backgroundColor = .customBlack
            }
            else{
                self.stkproduct.isHidden = true
                self.conststkHeight.constant = 0
                var categoryIDString  = [String]()
                self.txtProducturl.text = self.postDetails?.product_url ?? ""
                let dict = ["gender_id": self.postDetails?.gender_id ?? 0,
                            "name": self.postDetails?.gender_name ?? ""] as [String : Any]
                let genderobjCat = CategoryModel.init(JSON: dict)
                //            self.savegenderId = genderobjCat
                //            for i in 0..<(self.postDetails?.categories?.count ?? 0)! {
                //                let dict = ["category_id": self.postDetails?.categories?[i].id ?? 0,
                //                            "name": self.postDetails?.categories?[i].name ?? ""] as [String : Any]
                //                let categoryobjCat = Categorie.init(JSON: dict)!
                //                self.categorysAndSubCategory.append(categoryobjCat)
                //            }
                //            for i in 0..<self.categorysAndSubCategory.count {
                //                categoryIDString.append(String(categorysAndSubCategory[i].category_id ?? 0))
                //            }
                let dict1 = ["category_id": self.selectCategory?.category_id ?? 0,
                             "name": self.selectCategory?.name  ?? ""] as [String : Any]
                let categoryobjCat = Categorie.init(JSON: dict1)!
                self.categorysAndSubCategory.append(categoryobjCat)
                let dict2 = ["category_id": self.selectSubcategory?.category_id ?? 0,
                             "name": self.selectSubcategory?.name ?? ""] as [String : Any]
                let subcategoryobjCat = Categorie.init(JSON: dict2)!
                self.categorysAndSubCategory.append(subcategoryobjCat)
                for i in 0..<self.categorysAndSubCategory.count {
                    categoryIDString.append(String(categorysAndSubCategory[i].category_id ?? 0))
                }
                if let genderId = self.savegenderId?.gender_id {
                    self.callConditionColor(categoryId: categoryIDString.joined(separator: ","), genderId: "\(genderId)")
                }
                
                self.btnNext.backgroundColor = .customBlack
                
            }
            
        }else
        {
            if appDelegate.userDetails?.role_id == 3{
                self.lblSizeTitle.isHidden = true
                self.CVSize.isHidden = true
                self.lblCondition.isHidden = true
                self.CVCondition.isHidden = true
               // self.lblSizeTitle.frame.size.height = -30
                self.constTopForlblColor.constant = -140
//                self.lblCondition.frame.size.height = -30
//                self.constHeightForCVCondition.constant = -195
                var categoryIDString  = [String]()
                let dict1 = ["category_id": self.selectCategory?.category_id ?? 0,
                            "name": self.selectCategory?.name  ?? ""] as [String : Any]
                let categoryobjCat = Categorie.init(JSON: dict1)!
                self.categorysAndSubCategory.append(categoryobjCat)
                let dict2 = ["category_id": self.selectSubcategory?.category_id ?? 0,
                            "name": self.selectSubcategory?.name ?? ""] as [String : Any]
                let subcategoryobjCat = Categorie.init(JSON: dict2)!
                self.categorysAndSubCategory.append(subcategoryobjCat)
                for i in 0..<self.categorysAndSubCategory.count {
                    categoryIDString.append(String(categorysAndSubCategory[i].category_id ?? 0))
                }
                if let genderId = self.savegenderId?.gender_id {
                    self.callConditionColor(categoryId: categoryIDString.joined(separator: ","), genderId: "\(genderId)")
                }
            }else{
                self.stkproduct.isHidden = true
                self.conststkHeight.constant = 0
            var categoryIDString  = [String]()
            let dict1 = ["category_id": self.selectCategory?.category_id ?? 0,
                        "name": self.selectCategory?.name  ?? ""] as [String : Any]
            let categoryobjCat = Categorie.init(JSON: dict1)!
            self.categorysAndSubCategory.append(categoryobjCat)
            let dict2 = ["category_id": self.selectSubcategory?.category_id ?? 0,
                        "name": self.selectSubcategory?.name ?? ""] as [String : Any]
            let subcategoryobjCat = Categorie.init(JSON: dict2)!
            self.categorysAndSubCategory.append(subcategoryobjCat)
            for i in 0..<self.categorysAndSubCategory.count {
                categoryIDString.append(String(categorysAndSubCategory[i].category_id ?? 0))
            }
            if let genderId = self.savegenderId?.gender_id {
                self.callConditionColor(categoryId: categoryIDString.joined(separator: ","), genderId: "\(genderId)")
            }
        }
        }
        
        if self.isAccessories ?? false == true{
            self.lblSizeTitle.text = ""
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if appDelegate.userDetails?.role_id == 3{
            self.tblColor.reloadData()
            self.tblColor.layoutIfNeeded()
            self.constHeightForTblColor.constant = self.tblColor.contentSize.height
        }else{
        self.CVSize.reloadData()
        self.CVSize.layoutIfNeeded()
        self.constHeightForCVSize.constant = self.CVSize.contentSize.height
        
        self.CVCondition.reloadData()
        self.CVCondition.layoutIfNeeded()
        self.constHeightForCVCondition.constant = self.CVCondition.contentSize.height
        
        self.tblColor.reloadData()
        self.tblColor.layoutIfNeeded()
        self.constHeightForTblColor.constant = self.tblColor.contentSize.height
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnCancel_Clicked(_ button: UIButton) {
        if self.edit{
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
            
        }else{
            self.selectSize = nil
            self.CVSize.reloadData()
            self.selectConditionIndex = -1
            self.CVCondition.reloadData()
            let objet = self.condictionColorLise?.colors
            for i in 0..<Int(objet?.count ?? 0) {
                self.condictionColorLise?.colors?[i].isSelect = false
            }
            self.selectColor.removeAll()
            self.tblColor.reloadData()
            self.navigateToHomeScreen(selIndex: 0)
        }
    }
    
    @IBAction func btnNext_Clicked(_ button: UIButton) {
        let objet = self.condictionColorLise?.colors
        self.selectColor.removeAll()
        for i in 0..<objet!.count  {
            if self.condictionColorLise?.colors?[i].isSelect == true {
                self.selectColor.append(objet?[i])
            }
        }
        var seleAddress = [Locations]()
        for i in 0..<(appDelegate.userDetails?.locations?.count ?? 0) {
            for j in 0..<(self.postDetails?.locations?.count ?? 0) {
                if appDelegate.userDetails?.role_id == 1 {
                    if self.edit {
                    seleAddress.append((self.postDetails?.locations?[j])!)
                    }else{
                        if appDelegate.userDetails?.locations?[i].id == self.postDetails?.locations?[j].id {
                        seleAddress.append((appDelegate.userDetails?.locations?[i])!)
                        }
                    }
                }else{
                if appDelegate.userDetails?.locations?[i].id == self.postDetails?.locations?[j].id {
                    
                    seleAddress.append((appDelegate.userDetails?.locations?[i])!)
                    }
                }
            }
        }
        print(seleAddress)
        if appDelegate.userDetails?.role_id == 3{
            print(self.selectColor)
            if self.txtProducturl.text?.count == 0{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please Enter Product url")
            }
            else{
                if (self.txtProducturl.text ?? "").isValidURL {
                    
                    if selectColor.count == 0 {
                       UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select color")
                   }
                   else {
                       let ViewController = PostDetailsVC.instantiate(fromStoryboard: .Sell)
                       ViewController.priceList = self.condictionColorLise?.price_types as [Price_types?]
                       ViewController.savegenderId = self.savegenderId
                       ViewController.selectCategory = self.selectCategory
                       ViewController.selectSubcategory = self.selectSubcategory
                       ViewController.styles = self.styles
                       ViewController.selectColor = self.selectColor
                       ViewController.Producturl = self.txtProducturl.text!
                       if edit {
                           ViewController.edit = true
                           ViewController.postDetails = self.postDetails
                           ViewController.editpostImageVideo = self.postImageVideo
                           ViewController.categorysAndSubCategory = self.categorysAndSubCategory
                           ViewController.selectAddress = seleAddress
                           ViewController.Producturl = self.txtProducturl.text!
                       }
                       self.navigationController?.pushViewController(ViewController, animated: true)
                   }
                }
                else{
                    UIAlertController().alertViewWithTitleAndMessage(self, message: "Please Enter valid url")
                }
            }
        }else{
        print(self.selectColor)
        if self.selectSize == nil && self.condictionColorLise?.size?.count != 0 && (isAccessories == false || isAccessories == nil){
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select size")
        }
        else
        if selectCondiction == nil {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select condition")
        }
        else if selectColor.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select color")
        }
        else {
            let ViewController = PostDetailsVC.instantiate(fromStoryboard: .Sell)
            
//            let ViewController = storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
            ViewController.priceList = self.condictionColorLise?.price_types as [Price_types?]
//            ViewController.addresslist = appDelegate.userDetails?.locations as! [Locations?]//self.condictionColorLise?.locations as! [Locations?]
            ViewController.savegenderId = self.savegenderId
            ViewController.selectCategory = self.selectCategory
            ViewController.selectSubcategory = self.selectSubcategory
            ViewController.selectSize = self.selectSize
            ViewController.selectCondiction = self.selectCondiction
            ViewController.selectColor = self.selectColor
            ViewController.styles = self.styles
        
                
            if edit {
                ViewController.edit = true
                ViewController.postDetails = self.postDetails
                ViewController.editpostImageVideo = self.postImageVideo
                ViewController.categorysAndSubCategory = self.categorysAndSubCategory
                ViewController.selectAddress = seleAddress
            }
            self.pushViewController(vc: ViewController)
        }
        }
    }
}

extension PostItemsizeConditionColorViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.CVSize {
            return isAccessories ?? false ? 0 : self.condictionColorLise?.size!.count ?? 0
        }
        else{
            return self.condictionColorLise?.conditions!.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.CVSize {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            let objet = self.condictionColorLise?.size?[indexPath.item]
            if let size = objet?.name{
                cell.lblTitle.text = size
            }
            if self.selectSize?.id == objet?.id {
                cell.bgView.backgroundColor = .black
                cell.lblTitle.textColor = .white
            }
            else {
                cell.bgView.backgroundColor = .white
                cell.lblTitle.textColor = .black
            }
            
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            let objet = self.condictionColorLise?.conditions
            if self.selectCondiction?.id == objet?[indexPath.item].id {//self.selectConditionIndex == indexPath.item {
                cell.bgView.backgroundColor = .black
                cell.lblTitle.textColor = .white
                cell.lblTitle.text = objet?[indexPath.item].name
            }
            else {
                cell.bgView.backgroundColor = .white
                cell.lblTitle.textColor = .black
                cell.lblTitle.text = objet?[indexPath.item].name
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.CVSize {
            let objet = self.condictionColorLise?.size?[indexPath.item]
            self.selectSize = objet
            if self.selectSize != nil && self.selectConditionIndex != -1 && self.colorCoutn != 1{
                self.btnNext.backgroundColor = .customBlack
            }else{
                self.btnNext.backgroundColor = .customButton_bg_gray
            }
            self.CVSize.reloadData()
        }
        else {
            let objet = self.condictionColorLise?.conditions
            self.selectConditionIndex = indexPath.item
            self.selectCondiction = objet?[indexPath.item]
            if self.selectSize != nil && self.selectConditionIndex != -1 && self.colorCoutn != 1{
                self.btnNext.backgroundColor = .customBlack
            }else{
                self.btnNext.backgroundColor = .customButton_bg_gray
            }
            self.CVCondition.reloadData()
        }
    }
}

extension PostItemsizeConditionColorViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.condictionColorLise?.colors!.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConditonAndSellerCell", for: indexPath) as! ConditonAndSellerCell
        let objet = self.condictionColorLise?.colors?[indexPath.row]
        cell.lblTitle.text = objet?.name
        
        cell.imgColor.isHidden = true
        cell.imgColorPhoto.isHidden = true
        
        if objet?.photo == ""{
            cell.imgColor.isHidden = false
            if let colorcode = objet?.colorcode {
                let newColorCode = colorcode.replace("#", replacement: "")
                cell.imgColor.backgroundColor = UIColor(hex: newColorCode)//init(hex: String(newColorCode ))
            }
        }else {
            cell.imgColorPhoto.isHidden = false
            let urlString = objet?.photo?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            cell.imgColorPhoto.setImageFast(with: urlString)
        }
                
        if (objet?.isSelect ?? false) {
            cell.imgSelect.image = UIImage(named: "ic_circle_check")
        }
        else{
            cell.imgSelect.image = UIImage(named: "ic_circle_uncheck")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objet = self.condictionColorLise?.colors
        if objet?[indexPath.row].isSelect == true {
            self.condictionColorLise?.colors?[indexPath.row].isSelect = false
            self.colorCoutn = self.colorCoutn - 1
            self.tblColor.reloadData()
        }else {
            if self.colorCoutn < 3 {
                self.condictionColorLise?.colors?[indexPath.row].isSelect = true
                self.colorCoutn = self.colorCoutn + 1
                self.tblColor.reloadData()
            }
            else{
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select any two color")
            }
        }
        if ((self.selectSize != nil && self.isAccessories == nil) || (self.selectSize == nil && self.isAccessories == true)) && self.selectConditionIndex != -1 && self.colorCoutn != 1{
            self.btnNext.backgroundColor = .customBlack
        }else{
            self.btnNext.backgroundColor = .customButton_bg_gray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
}

extension PostItemsizeConditionColorViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }
      
      fileprivate var itemsPerRow: CGFloat {
        return 2
      }
      
      fileprivate var interitemSpace: CGFloat {
            return 0.0
      }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == self.CVCondition {
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 55)
        }
        else{
            let sectionPadding = sectionInsets.left * (5 + 1)
            let interitemPadding = max(0.0, 5 - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / 6
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

extension PostItemsizeConditionColorViewController {
    func callConditionColor( categoryId : String , genderId : String ) {
        if appDelegate.reachable.connection != .none {
            let param = ["category_ids": categoryId,
                         "gender_id" : genderId]
            APIManager().apiCall(of: ConditionColorModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.CATEGORIES_SIZE.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.condictionColorLise = data
                        }
                        if self.edit {
                            if self.postDetails?.sizes?.count != 0 {
                                self.selectSize = self.postDetails?.sizes?[0]
                            }
                            
                            for i in 0..<(self.condictionColorLise?.conditions!.count ?? 0 )! {
                                if self.condictionColorLise?.conditions?[i].id == self.postDetails?.condition_id {
                                    self.selectCondiction = self.condictionColorLise?.conditions?[i]
                                }
                            }
                            self.selectColor = self.postDetails?.colors as! [Colors?]
                            self.colorCoutn = self.selectColor.count + 1
                           
                            for i in 0..<(self.condictionColorLise?.colors!.count ?? 0){
                                if (self.selectColor.contains(where: { $0?.name == self.condictionColorLise?.colors?[i].name  }))  {
                                        // print("1 exists in the array")
                                    self.condictionColorLise?.colors?[i].isSelect = true
                                } else {
                                    
                                }
//                                let results = self.selectColor.filter { $0?.name == self.condictionColorLise?.colors?[i].name }
//                                if results.count > 0{
//                                    self.condictionColorLise?.colors?[i].isSelect = true
//                                }
                            }
                        }
                        self.styles = self.condictionColorLise?.styles ?? []
                        if self.condictionColorLise?.size?.count == 0 {
                            self.lblSizeTitle.isHidden = true
                            self.CVSize.isHidden = true
                            self.constTopForlblSizeTitle.constant = -self.lblSizeTitle.frame.height
                        }                        
                        self.CVSize.reloadData()
                        self.CVCondition.reloadData()
                        self.tblColor.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}


