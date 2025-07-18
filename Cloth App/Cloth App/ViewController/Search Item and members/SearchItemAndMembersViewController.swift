//
//  SearchItemAndMembersViewController.swift
//  ClothApp
//
//  Created by Apple on 01/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class SearchItemAndMembersViewController: BaseViewController {
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var profileBottomLine: UIView!
    @IBOutlet weak var itemBottomLine: UIView!
    @IBOutlet weak var btnItem: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var btnSearchEngine: UIButton!
    @IBOutlet weak var btnColse: UIButton!
    
    @IBOutlet weak var SearchItemAndMembers: CustomTextField!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var viewItem: UIView!
    
    @IBOutlet weak var viewProfile: UIView!
    @IBOutlet weak var tblViewProfile: UITableView!
    @IBOutlet weak var CVProducts: UICollectionView!
    var currentPage = 1
    var hasMorePages = false
    var itemList = ["Footwear","Top","Outwear","Bottoms","Jeans"]
    var searchType = ""
    var searchValue = ""
    var sort_by = "date"
    var sort_value = "desc"
    var searchData = [Datas]()
    var FromSearchEngine:Bool = false
    override func viewDidLoad(){
        super.viewDidLoad()
        self.SearchItemAndMembers.placeholder = "Search Products"
        self.btnFilter.isHidden = true
        self.btnItem_Clicked((Any).self)
        self.setupTableView()
        self.setupCollectionView()
        self.SearchItemAndMembers.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.SearchItemAndMembers.backgroundColor = .clear
        //        if self.FromSearchEngine == true{
        //            self.btnSearchEngine.setImage(UIImage(named: "back_ic"), for: .normal)
        //        }else{
        //            self.btnSearchEngine.setImage(UIImage(named: "search_ic_1"), for: .normal)
        //        }
    }
    
    func setupTableView(){
        self.tblViewProfile.delegate = self
        self.tblViewProfile.dataSource = self
        self.tblViewProfile.tableFooterView = UIView()
        self.tblViewProfile.register(UINib(nibName: "UserProfileListXIB", bundle: nil), forCellReuseIdentifier: "UserProfileListXIB")
    }
    
    func setupCollectionView(){
        self.CVProducts.delegate = self
        self.CVProducts.dataSource = self
        self.CVProducts.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        //        let viewController = ShortByViewController.instantiate(fromStoryboard: .Main)
        //        viewController.sort_by = self.sort_by
        //        viewController.sort_value = self.sort_value
        //        viewController.shortByDeleget = self
        //        viewController.modalPresentationStyle = .custom
        //        viewController.transitioningDelegate = customTransitioningDelegate
        //        self.present(viewController, animated: true, completion: nil)
        
        let vc = FilterProductVC.instantiate(fromStoryboard: .Dashboard)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.callBack = {
            self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
        }
        vc.isJustFilter = true
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        debugPrint(textField.text ?? "")
        let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        if trimmedText.isEmpty {
            self.searchData.removeAll()
            self.CVProducts.reloadData()
            self.tblViewProfile.reloadData()
            self.btnFilter.isHidden = true
        } else {
            if self.searchType == "0"{
                self.btnFilter.isHidden = false
                self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
            }else{
                self.currentPage = 1
                self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
            }
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.SearchItemAndMembers.endEditing(true)
    }
    
    @IBAction func btnItem_Clicked(_ button: Any) {
        self.SearchItemAndMembers.placeholder = "Search Products"
        //        self.btnItem.isSelected = true
        //        if self.btnItem.isSelected {
        //            self.btnItem.backgroundColor = UIColor.white
        //            self.btnItem.setTitleColor(UIColor.black, for: .normal)
        //            self.btnProfile.backgroundColor = UIColor.init(named: "LightGrayColor")
        //            self.btnProfile.isSelected = false
        self.viewItem.isHidden = false
        self.viewProfile.isHidden = true
        //        self.btnFilter.isHidden = trur
        //        }
        //        else {
        //            self.btnItem.backgroundColor = UIColor.init(named: "LightGrayColor")
        //            self.btnProfile.setTitleColor(UIColor.black, for: .normal)
        //            self.btnProfile.backgroundColor = UIColor.white
        //            self.btnItem.isSelected = true
        //            self.viewProfile.isHidden = false
        //            self.viewItem.isHidden = true
        //        }
        
        self.itemBottomLine.backgroundColor = UIColor.init(named: "Black_Theme_Color")
        self.profileBottomLine.backgroundColor = UIColor.init(named: "App_Light_Border_Color")
        
        self.searchType = "0"
        if self.SearchItemAndMembers.text != "" {
            self.searchData.removeAll()
            self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
        }else {
            self.searchData.removeAll()
            self.CVProducts.reloadData()
            
        }
        //        self.btnItem.isSelected = !self.btnItem.isSelected
    }
    
    @IBAction func btnSearchEngine_Clicked(_ button: Any) {
        if self.FromSearchEngine == true{
            self.onBackClicked(self)
        }else{
            navigateToHomeScreen()
        }
    }
    
    @IBAction func btnMembrs_Clicked(_ button: Any) {
        self.SearchItemAndMembers.placeholder = "Search Profiles"
        //        self.btnProfile.isSelected = true
        //        if self.btnProfile.isSelected {
        //            self.btnProfile.backgroundColor = UIColor.white
        //            self.btnProfile.setTitleColor(UIColor.black, for: .normal)
        //            self.btnItem.backgroundColor = UIColor.init(named: "LightGrayColor")
        //            self.btnItem.isSelected = false
        self.viewProfile.isHidden = false
        self.viewItem.isHidden = true
        self.btnFilter.isHidden = true
        //        }
        //        else {
        //            self.btnProfile.backgroundColor = UIColor.init(named: "LightGrayColor")
        //            self.btnItem.setTitleColor(UIColor.black, for: .normal)
        //            self.btnItem.backgroundColor = UIColor.white
        //            self.btnProfile.isSelected = true
        //            self.viewProfile.isHidden = true
        //            self.viewItem.isHidden = false
        //        }
        self.profileBottomLine.backgroundColor = UIColor.init(named: "Black_Theme_Color")
        self.itemBottomLine.backgroundColor = UIColor.init(named: "App_Light_Border_Color")
        self.searchType = "1"
        if self.SearchItemAndMembers.text != "" {
            self.searchData.removeAll()
            self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
        }
        else {
            self.searchData.removeAll()
            self.tblViewProfile.reloadData()
        }
        //        self.btnProfile.isSelected = !self.btnProfile.isSelected
    }
}

extension SearchItemAndMembersViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentString: NSString = (self.SearchItemAndMembers.text ?? "") as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
        if newString != "" {
            self.currentPage = 1
            self.callGlobalSearch(searchtext: newString as String, searchType: self.searchType)
        }
        else {
            self.searchData.removeAll()
            if self.searchType == "0" {
                self.CVProducts.reloadData()
            }
            else
            {
                self.tblViewProfile.reloadData()
            }
            
        }
        return true
    }
}

extension SearchItemAndMembersViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblViewProfile {
            return self.searchData.count
        }
        else{
            return self.searchData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tblViewProfile {
            let objet = self.searchData[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileListXIB", for: indexPath) as! UserProfileListXIB
            
            cell.imgUser.setImageFast(with: objet.userimage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            
            cell.lblFollowerCount.text = "\(objet.total_posts ?? 0) Listings"
            
            if objet.userimage == nil || objet.userimage?.isEmpty == true{
                cell.imgUser.backgroundColor = .customBlack
                cell.lblNameLetter.isHidden = false
                cell.lblNameLetter.text = objet.name?.first?.description.capitalized ?? ""
            }else{
                cell.imgUser.backgroundColor = .customBlack
                cell.lblNameLetter.isHidden = true
            }
            
            if let name = objet.username {
                cell.lblName.text = name.capitalized
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemListCell", for: indexPath) as! ItemListCell
            let objet = self.searchData[indexPath.row]
            
            cell.imgItem.setImageFast(with: objet.image?[0].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            
            if let name = objet.title {
                cell.lblItemName.text = name
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.searchData.count - 1 && hasMorePages == true {
            self.currentPage = self.currentPage + 1
            self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblViewProfile {
            if let id = self.searchData[indexPath.row].id{
                self.callGetOtherUserDetails(userId: "\(id)")
            }
            
        }
        else{
            if let id = self.searchData[indexPath.row].id{
                //            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
                //            viewController.postId = "\(id)"
                //            self.navigationController?.pushViewController(viewController, animated: true)
                let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
                vc.postId = "\(id)"
                vc.hidesBottomBarWhenPushed = true
                self.pushViewController(vc: vc)
            }
        }
    }
}
class UserLisetCell: UITableViewCell {
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
}
class ItemListCell: UITableViewCell {
    @IBOutlet weak var imgItem: CustomImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var viewLine: UIView!
}
extension SearchItemAndMembersViewController {
    
    func callGlobalSearch(searchtext : String,searchType : String) {
        if appDelegate.reachable.connection != .none {
            //            let param = ["search_value": searchtext,
            //                         "search_type" : searchType,
            //                         "page" : "\(self.currentPage)"
            //            ]
            
            var param = FilterSingleton.share.filter.toDictionary()
            param?.removeValue(forKey: "is_only_count")
            param?["page"] = "\(self.currentPage)"
            param?["search_value"] = searchtext
            param?["search_type"] = searchType
            param?.removeValue(forKey: "slectedCategories")
            APIManager().apiCall(of: GlobalSearchModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.GLOBAL_SEARCH.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1{
                                self.searchData.removeAll()
                            }
                            
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            
                            if let post = data.data {
                                for temp in post {
                                    self.searchData.append(temp)
                                }
                            }
                        }
                        if searchType == "0" {
                            self.CVProducts.reloadData()
                        }
                        else
                        {
                            self.tblViewProfile.reloadData()
                        }
                        if self.searchData.count == 0 {
                            self.lblNoData.isHidden = false
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
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
    
    func callGetOtherUserDetails(userId : String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["user_id":  userId ]
            
            APIManager().apiCall(of:UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            let objet = data
                            if appDelegate.userDetails?.id == objet.id {
                                self.navigateToHomeScreen(selIndex: 4)
                            }
                            else {
                                if let seller = objet.role_id {
                                    if seller == 2{
//                                        let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
//                                        viewController.userId = "\(objet.id ?? 0)"
//                                        self.navigationController?.pushViewController(viewController, animated: true)
                                        
                                        let vc = StoreProfileVC.instantiate(fromStoryboard: .Store)
                                        vc.viewModel.userID = "\(objet.id ?? 0)"
                                        self.pushViewController(vc: vc)
                                    }
                                    else if seller == 3 {
                                        let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
                                        viewController.userId = "\(objet.id ?? 0)"
                                        self.navigationController?.pushViewController(viewController, animated: true)
                                    }
                                    else{
                                        let viewController = self.storyboard?.instantiateViewController(identifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                                        viewController.userId = "\(objet.id ?? 0)"
                                        self.navigationController?.pushViewController(viewController, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
                }
            }
        }
        else {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
        }
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVProducts)
        if let indexPath = self.CVProducts.indexPathForItem(at: poston) {
            let cell = self.CVProducts.cellForItem(at: indexPath) as! HomePageBrowserXIB
            if cell.btnLike.isSelected {
                if  let postId = self.searchData[indexPath.item].id {
                    self.callPostFavourite(action_type: "0", postId: String(postId) , index: indexPath.item)
                }
            }
            else {
                if  let postId = self.searchData[indexPath.item].id {
                    self.callPostFavourite(action_type: "1", postId: String(postId) , index: indexPath.item)
                }
            }
        }
    }
    
    func callPostFavourite(action_type : String,postId : String,index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if action_type == "1"{
                        self.searchData[index].is_favourite = true
                    }
                    else {
                        self.searchData[index].is_favourite = false
                    }
                    self.CVProducts.reloadData()
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
extension SearchItemAndMembersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
        let objet = self.searchData[indexPath.item]
        
        cell.imgProduct.setImageFast(with: objet.image?.first?.image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
        if let is_favourite = objet.is_favourite {
            cell.btnLike.isSelected = is_favourite
        }
        if let title = objet.title {
            cell.lblProductName.text = title
        }
        
        if let producttype = objet.price_type{
            if producttype == "1"{
                if let price = objet.price {
                    if !(objet.isLblSaleHidden()) {
                        if let salePrice = objet.sale_price {
                            cell.lblPrice.text = "$ \(salePrice)"
                        }
                    }else {
                        cell.lblPrice.text = "$ \(price.formatPrice())"
                    }
                }
            }
            else{
                if let producttype = objet.price_type_name{
                    cell.lblPrice.text = "\(producttype.formatPrice())"
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
        //        viewController.postId = String(self.searchData[indexPath.item].id ?? 0)
        //        viewController.indexpath = indexPath
        //        viewController.likeDeleget = self
        //        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.postId = String(self.searchData[indexPath.item].id ?? 0)
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.searchData.count - 1 && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callGlobalSearch(searchtext: self.SearchItemAndMembers.text ?? "", searchType: self.searchType)
        }
    }
    
}

extension SearchItemAndMembersViewController: LikeDelegate{
    
    func Like(like: Bool, indexpath: IndexPath) {
        self.searchData[indexpath.item].is_favourite = like
        self.CVProducts.reloadItems(at: [indexpath])
    }
}

extension SearchItemAndMembersViewController: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2.0
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        //        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        //        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        //        let widthPerItem = availableWidth / itemsPerRow
        //        return CGSize(width: widthPerItem, height: 222)
        return CGSize(width: (self.CVProducts.frame.size.width / 2) - 20, height: 230)
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

extension SearchItemAndMembersViewController : ShortByDelegate{
    
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
    }
}
