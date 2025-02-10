//
//  ClothPreferencesViewController.swift
//  ClothApp
//
//  Created by Apple on 15/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit
import AlignedCollectionViewFlowLayout

class ClothPreferencesViewController: BaseViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var CVGender: UICollectionView!
    @IBOutlet weak var constHeightForCVGender: NSLayoutConstraint!
    @IBOutlet weak var tblClothsPref: UITableView!
    @IBOutlet weak var constHeightForTblClothsPref: NSLayoutConstraint!
    
    @IBOutlet weak var btnNext: CustomButton!
    var saveSize = [String]()
    var saveBrand = [String]()
    var selectSize = ""
    var countindex = 0
    var brandSearchList = [BrandeSearchModel?]()
    var mysizeList = [MySizeModel?]()
    var categoryList = [Categories?]()
    var selectGengerIndex = -1
    var selectcategoryIndex = -1
    var isMySizes = false
    
    var selectedIndexPath = [IndexPath]()
    
    var isUserLogin = defaults.value(forKey: kLoginUserList)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isMySizes {
            self.btnBack.isHidden = false
            self.btnNext.setTitle("Save", for: .normal)
            self.callSizeList()
            
        }
        else
        {
            self.btnBack.isHidden = false
            //            self.setNavigationBarShadow(navigationBar: self.navBar)
            self.callSizeList()
            let imageSearch = UIImage(named: "search_ic")?.imageWithColor(color1: UIColor.black)
            //            self.btnSearchBrand.setImage(imageSearch, for: .normal)
            //            let alignedFlowLayout = self.CVSelectedBrand?.collectionViewLayout as? AlignedCollectionViewFlowLayout
            //            alignedFlowLayout?.horizontalAlignment = .left
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if any 'isSelect' is true in the entire categoryList
        let isAnySelected = self.categoryList.contains { outerModel in
            outerModel?.sizes?.contains { $0.isSelect == true } == true
        }

        // Use the result of isAnySelected
        if isAnySelected {
            print("At least one item is selected.")
            self.btnNext.backgroundColor = UIColor.customBlack
            self.btnNext.isUserInteractionEnabled = true
        } else {
            print("No items are selected.")
            self.btnNext.backgroundColor = UIColor.customButton_bg_gray
            self.btnNext.isUserInteractionEnabled = false
        }
    }
    
    func setSelectedSizeDate() {
        for i in 0..<self.categoryList.count {
            var outerModel = self.categoryList[i]
            for j in 0..<(outerModel?.sizes!.count)! {
                var innerModel = outerModel?.sizes![j]
                for size in 0..<(appDelegate.userDetails?.user_size!.count ?? 0)!  {
                    if innerModel?.id == appDelegate.userDetails?.user_size?[size] {
                        innerModel?.isSelect = true
                    }
                    outerModel?.sizes![j] = innerModel!
                }
            }
            self.categoryList[i] = outerModel
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //        self.tblClothsPref.reloadData()
        //        self.tblClothsPref.layoutIfNeeded()
        //        self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
        
        
        //        self.CVGender.reloadData()
        //        self.CVGender.layoutIfNeeded()
        //        self.constHeightForCVGender.constant = self.CVGender.contentSize.height
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnSearchBrand_clicked(_ sender: Any) {
    }
    
    @IBAction func btnNext_clicked(_ sender: Any) {
        if self.isUserLogin == nil{
            self.checkAndFetchLocation { status in
                
                for i in 0..<self.categoryList.count {
                    let outerModel = self.categoryList[i]
                    for j in 0..<(outerModel?.sizes!.count)! {
                        let innerModel = outerModel?.sizes![j]
                        if innerModel?.isSelect == true{
                            self.saveSize.append(String(innerModel?.id ?? 0))
                        }
                    }
                }
                
                for i in 0..<self.brandSearchList.count {
                    let outerModel = self.brandSearchList[i]
                    let Id = outerModel?.brand_id
                    self.saveBrand.append(String(Id ?? 0))
                }
                
                print(self.saveSize)
                
                if let genserId = self.mysizeList[self.selectGengerIndex]?.gender_id{
                    let sizeAreeString = self.saveSize.joined(separator: ",")
                    let brandAreeString = self.saveBrand.joined(separator: ",")
                    FilterSingleton.share.filter.sizes = self.saveSize.joined(separator: ",")
                    self.navigateToHomeScreen()
                    print(sizeAreeString)
                    print(brandAreeString)
                }
                
            }
        }else{
            
            for i in 0..<self.categoryList.count {
                let outerModel = self.categoryList[i]
                for j in 0..<(outerModel?.sizes!.count)! {
                    let innerModel = outerModel?.sizes![j]
                    if innerModel?.isSelect == true{
                        self.saveSize.append(String(innerModel?.id ?? 0))
                    }
                }
            }
            
            for i in 0..<self.brandSearchList.count {
                let outerModel = self.brandSearchList[i]
                
                let Id = outerModel?.brand_id
                
                self.saveBrand.append(String(Id ?? 0))
                
            }
            print(self.saveSize)
            
            if let genserId = self.mysizeList[self.selectGengerIndex]?.gender_id{
                let sizeAreeString = self.saveSize.joined(separator: ",")
                let brandAreeString = self.saveBrand.joined(separator: ",")
                FilterSingleton.share.filter.sizes = self.saveSize.joined(separator: ",")
                self.callSaveSizeList(size: sizeAreeString , brand: brandAreeString, genderId: String(genserId))
                print(sizeAreeString)
                print(brandAreeString)
            }
        }
    }
    
}

extension ClothPreferencesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefHeaderTblCell") as! ClothPrefHeaderTblCell
        let objct = self.categoryList[section]
        cell.imgCloths.isHidden = false
        cell.lblTitle.text = objct?.name
        if let url = objct?.image?.replacingOccurrences(of: " ", with: "%20").trim() {
            if let imgUrl = URL.init(string: url) {
                cell.imgCloths.kf.setImage(with: imgUrl, placeholder: PlaceHolderImage)
            }
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClothPrefRowTblCell", for: indexPath) as! ClothPrefRowTblCell
        
        cell.frame = tblClothsPref.bounds
        cell.layoutIfNeeded()
        cell.CVClothsPref.tag = indexPath.section
        cell.CVClothsPref.reloadData()
        cell.heightConstForCVClothsPref.constant = cell.CVClothsPref.collectionViewLayout.collectionViewContentSize.height
        self.tblClothsPref.layoutIfNeeded()
        self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
    }
}

extension ClothPreferencesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if collectionView == self.CVSelectedBrand {
        //            return self.brandSearchList.count
        //        }
        //        else
        if collectionView == self.CVGender {
            return self.mysizeList.count
        }
        else{
            return self.categoryList[collectionView.tag]?.sizes?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        if collectionView == self.CVSelectedBrand {
        //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectedBrandCVCell", for: indexPath) as! SelectedBrandCVCell
        //            cell.lblTitle.text = self.brandSearchList[indexPath.item]?.name
        //            cell.btnRemove.addTarget(self, action: #selector(btnRemoveBrand_clicked(_:)), for: .touchUpInside)
        //            return cell
        //        }
        //        else
        if collectionView == self.CVGender {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            
            if let gender = self.mysizeList[indexPath.item]?.gender_name {
                cell.lblTitle.text = gender
            }
            
            if self.selectGengerIndex == indexPath.item  && self.mysizeList.count > 1{
                cell.bottomView.backgroundColor = UIColor.customBlack
                //                cell.lblTitle.textColor = UIColor.white
            }
            else{
                cell.bottomView.backgroundColor = UIColor.customBorderColor
                //                cell.lblTitle.textColor = UIColor.black
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            let object = self.categoryList[collectionView.tag]?.sizes![indexPath.item]
            if let sizedata = object?.name {
                cell.lblTitle.text = sizedata
            }
            if object?.isSelect == true  {
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
        if collectionView == self.CVGender {
            if self.mysizeList.count > 1{
                self.selectGengerIndex = indexPath.item
                self.categoryList.removeAll()
                for j in 0..<(self.mysizeList[indexPath.item]?.categories?.count ?? 0) {
                    if self.mysizeList[indexPath.item]?.categories?[j].sizes?.count != 0 {
                        self.categoryList.append(self.mysizeList[indexPath.item]?.categories?[j])
                    }
                }
                self.setSelectedSizeDate()
                self.CVGender.reloadData()
                self.CVGender.layoutIfNeeded()
                self.constHeightForCVGender.constant = self.CVGender.contentSize.height
                self.tblClothsPref.reloadData()
                self.tblClothsPref.layoutIfNeeded()
                self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
            }
        }
        //        else if collectionView == self.CVSelectedBrand {
        //
        //        }
        else {
            for i in 0..<self.categoryList.count {
                var outerModel = self.categoryList[i]
                for j in 0..<(outerModel?.sizes!.count)! {
                    var innerModel = outerModel?.sizes![j]
                    if i == collectionView.tag {
                        if j == indexPath.item {
                            if innerModel?.isSelect == true{
                                innerModel?.isSelect = false
                            }
                            else{
                                innerModel?.isSelect = true
                            }
                        }
                        else{
                        }
                        outerModel?.sizes![j] = innerModel!
                    }
                }
                self.categoryList[i] = outerModel
            }
            // Check if any 'isSelect' is true in the entire categoryList
            let isAnySelected = self.categoryList.contains { outerModel in
                outerModel?.sizes?.contains { $0.isSelect == true } == true
            }

            // Use the result of isAnySelected
            if isAnySelected {
                print("At least one item is selected.")
                self.btnNext.backgroundColor = UIColor.customBlack
                self.btnNext.isUserInteractionEnabled = true
            } else {
                print("No items are selected.")
                self.btnNext.backgroundColor = UIColor.customButton_bg_gray
                self.btnNext.isUserInteractionEnabled = false
            }
            self.tblClothsPref.reloadData()
            self.tblClothsPref.layoutIfNeeded()
            self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
        }
        
    }
    
    @objc func btnRemoveBrand_clicked(_ sender: AnyObject) {
        //        let poston = sender.convert(CGPoint.zero, to: self.CVSelectedBrand)
        //        if let indexPath = self.CVSelectedBrand.indexPathForItem(at: poston) {
        //            self.brandSearchList.remove(at: indexPath.item)
        //            self.CVSelectedBrand.reloadData()
        //        }
    }
}

extension ClothPreferencesViewController: UICollectionViewDelegateFlowLayout {
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
        //        if collectionView == self.CVSelectedBrand {
        //            let height = 40
        //            let brandename = self.brandSearchList[indexPath.item]?.name ?? ""
        //            let width = brandename.width(withConstrainedHeight: CGFloat(height), font: UIFont(name: "ProximaNova-Medium", size: 15)!)
        //            return CGSize(width: width + 70, height: CGFloat(height))
        //        }
        //        else {
        if collectionView == self.CVGender{
            if self.mysizeList.count < 2{
                return CGSize(width: self.CVGender.frame.size.width, height: 55)
            }else{
                return CGSize(width: self.CVGender.frame.size.width / 2, height: 55)
            }
            
        }else{
            if indexPath.section == 0 {
                let sectionPadding = sectionInsets.left * (5 + 1)
                let interitemPadding = max(0.0, 5 - 1) * interitemSpace
                let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
                let widthPerItem = availableWidth / 5
                return CGSize(width: widthPerItem, height: 55)
                
            }
            else {
                let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
                let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
                let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
                let widthPerItem = availableWidth / itemsPerRow
                return CGSize(width: widthPerItem, height: 55)
            }
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

class ClothPrefHeaderTblCell : UITableViewCell {
    @IBOutlet weak var constraintLeding: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgCloths: UIImageView!
}

class ClothPrefRowTblCell : UITableViewCell {
    @IBOutlet weak var CVClothsPref: UICollectionView!
    @IBOutlet weak var heightConstForCVClothsPref: NSLayoutConstraint!
}

class ClothPrefCVCell : UICollectionViewCell {
    @IBOutlet weak var imgCat: UIImageView!{
        didSet{
            self.imgCat.translatesAutoresizingMaskIntoConstraints = false
            self.imgCat.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var lblTitle: UILabel!
    private var currentImageUrl: URL?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear the image and tint color before reuse
        //          imgCat.image = nil
        //          imgCat.tintColor = nil
    }
    
    func configure(with imageUrl: URL, tintColor: UIColor) {
        // Cancel any previous image loading
        currentImageUrl = imageUrl
        imgCat.image = UIImage(named: "placeholder") // Placeholder image
        
        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.image(forKey: imageUrl.absoluteString) {
            self.imgCat.image = cachedImage.withRenderingMode(.alwaysTemplate)
            self.imgCat.tintColor = tintColor
            return
        }
        
        // Asynchronously load the image
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            guard let imageData = try? Data(contentsOf: imageUrl),
                  let image = UIImage(data: imageData) else {
                return
            }
            
            let templateImage = image.withRenderingMode(.alwaysTemplate)
            
            // Cache the image
            ImageCache.shared.save(image: templateImage, forKey: imageUrl.absoluteString)
            
            DispatchQueue.main.async {
                // Ensure the cell is still displaying the correct image
                if self.currentImageUrl == imageUrl {
                    self.imgCat.image = templateImage
                    self.imgCat.tintColor = tintColor
                }
            }
        }
    }
}

class SelectedBrandCVCell : UICollectionViewCell {
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
}

extension ClothPreferencesViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        if textField == txtSearchBrand {
        //            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "FavouriteBrandSearchViewController") as! FavouriteBrandSearchViewController
        //            viewController.favouriteBrandDeleget = self
        //            self.present(viewController, animated: true, completion: nil)
        //            return false
        //        }
        return true
    }
}

extension ClothPreferencesViewController {
    func callSizeList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: MySizeModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.MY_SIZE_LIST.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.mysizeList = data
                            self.categoryList.removeAll()
                            if self.isMySizes{
                                
                                for i in 0..<(appDelegate.userDetails?.user_favourite_brand!.count)!{
                                    
                                    let data = appDelegate.userDetails?.user_favourite_brand![i]
                                    self.brandSearchList.append(data)
                                }
                                
                                
                                self.selectGengerIndex = (appDelegate.userDetails?.user_selected_gender ?? 0) - 1
                                for j in 0..<(self.mysizeList[self.selectGengerIndex == -1 ? 1 : self.selectGengerIndex]?.categories?.count ?? 0) {
                                    if self.mysizeList[self.selectGengerIndex == -1 ? 1 : self.selectGengerIndex]?.categories?[j].sizes?.count != 0 {
                                        self.categoryList.append(self.mysizeList[self.selectGengerIndex == -1 ? 1 : self.selectGengerIndex]?.categories?[j])
                                        
                                    }
                                }
                                self.setSelectedSizeDate()
                            }
                            else {
                                
                                
                                if self.isUserLogin == nil{
                                    debugPrint( self.mysizeList.count)
                                    self.categoryList.removeAll()
                                    if self.selectGengerIndex != -1{
                                        self.mysizeList = self.mysizeList.filter { self.selectGengerIndex == 0 ? $0?.gender_name?.capitalized == "Menswear" : $0?.gender_name?.capitalized == "Womenswear" }
                                    }
                                    
                                    for index in self.mysizeList.first??.categories ?? []{
                                        if index.sizes?.isEmpty == false{
                                            self.categoryList.append(index)
                                        }
                                    }
                                    self.selectGengerIndex = 0
                                    //
                                }else{
                                    if self.mysizeList.count > 0{
                                        self.selectGengerIndex = 0
                                        for j in 0..<(self.mysizeList[self.selectGengerIndex == -1 ? 1 : self.selectGengerIndex]?.categories?.count ?? 0) {
                                            if self.mysizeList[self.selectGengerIndex == -1 ? 1 : self.selectGengerIndex]?.categories?[j].sizes?.count != 0 {
                                                self.categoryList.append(self.mysizeList[self.selectGengerIndex == -1 ? 1 : self.selectGengerIndex]?.categories?[j])
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.CVGender.reloadData()
                            self.CVGender.layoutIfNeeded()
                            self.constHeightForCVGender.constant = self.CVGender.contentSize.height
                            self.tblClothsPref.reloadData()
                            self.tblClothsPref.layoutIfNeeded()
                            self.constHeightForTblClothsPref.constant = self.tblClothsPref.contentSize.height
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
    
    //    func callBrandSearchList(searchtext : String) {
    //        if appDelegate.reachable.connection != .unavailable {
    //            let param = ["name": searchtext]
    //            APIManager().apiCall(of: BrandeSearchModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.BRAND_SEARCH.rawValue, method: .post, parameters: param) { (response, error) in
    //                if error == nil {
    //                    if let response = response {
    //                        if let data = response.arrayData {
    //                            self.brandSearchList = data
    //                            self.CVSelectedBrand.reloadData()
    //                        }
    //                    }
    //                }
    //                else {
    //                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
    //                }
    //            }
    //        }
    //        else {
    //            UIAlertController().alertViewWithNoInternet(self)
    //        }
    //    }
    
    func callSaveSizeList(size : String,brand : String , genderId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["size": size ,
                         "brand" : brand ,
                         "gender_id" : genderId
            ]
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SIZES_SAVE.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let userDetails = response?.dictData {
                        self.saveUserDetails(userDetails: userDetails)
                        self.navigateToHomeScreen()
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

extension ClothPreferencesViewController : FavouriteBrandSearchDelegate {
    func FavouriteBrandSearchAddd(brand: BrandeSearchModel) {
        self.brandSearchList.append(brand)
        //        self.CVSelectedBrand.reloadData()
    }
}

// Simple image cache
class ImageCache {
    static let shared = ImageCache()
    
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

extension ClothPreferencesViewController{
    private func checkAndFetchLocation(complition:@escaping((Bool) -> Void?)) {
        let locationManager = LocationManager.shared
        
        if locationManager.isLocationServicesEnabled() {
            locationManager.getCurrentLocation { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let location):
                        print("Location fetched: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                        complition(true)
                    case .failure(let error):
                        print("Error fetching location: \(error.localizedDescription)")
                        if LocationManager.shared.isLocationSetNotNow == true{
                            complition(false)
                        }else{
                            let vc = DeletePostVC.instantiate(fromStoryboard: .Sell)
                            vc.modalPresentationStyle = .overFullScreen
                            vc.modalTransitionStyle = .crossDissolve
                            vc.isCancelHide = false
                            vc.deleteTitle = "Allow Access"
                            vc.cancelTitle = "Not Now"
                            vc.deleteBgColor = .black
                            vc.titleMain = "Turn on Location"
                            vc.subTitle = " Location services are required to provide the best experience on Clothing Click. Please enable them in your device settings"
                            vc.imgMain = UIImage(named: "ic_location_big")
                            vc.deleteOnTap = {
                                LocationManager.shared.openSettings()
                            }
                            vc.cancelOnTap = {
                                LocationManager.shared.isLocationSetNotNow = true
                                complition(false)
                            }
                            self.present(vc, animated: true)
                        }
                        
                    }
                }
            }
        } else {
            print("Location services are disabled")
            showLocationErrorAlert(error: LocationManager.LocationError.servicesDisabled)
        }
    }
    
    private func showLocationErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Location Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            LocationManager.shared.openSettings()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
