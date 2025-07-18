//
//  HomeViewController.swift
//  ClothApp
//
//  Created by Apple on 16/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit
import Auk
import moa
import AVFoundation

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var btnUserLocations: UIButton!
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var bgViewSearch: CustomView!
    
    @IBOutlet weak var btnSearchEngine: UIButton!
    @IBOutlet weak var btnCreateSavedSearch: CustomButton!
    @IBOutlet weak var btnViewAll: CustomButton!
    @IBOutlet weak var btnSearchItemMembers: UIButton!
    @IBOutlet weak var imgSearch: UIImageView!
    
    
    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var txtSearchEngine: UITextField!
    
    @IBOutlet weak var constHeightForTblHome: NSLayoutConstraint!
    
    let titleList = ["Recommended", "Following", "Top picks", "Recently Posted", "Local stores", "Under $50", "Popular Brands", "Ads Nearby", "Saved Searches"]
    
    var homeListData = [HomeModel?]()
    var userData : UserDetailsModel?
    var loginType = ["User","Brand"]
    
    //Auto scroll timer
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblHome.contentInsetAdjustmentBehavior = .never
        
        //        let imageSearch = UIImage(named: "search_ic")?.imageWithColor(color1: UIColor.init(hex: "606060"))
        //        self.imgSearch.image = imageSearch
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.deepLinkNavigate(_:)), name: NSNotification.Name(rawValue: "deeplinknavigate"), object: nil)
    }
    @objc func deepLinkNavigate(_ notification: NSNotification) {
        DeepLinknaviget()
    }
//    func DeepLinknaviget(){
//        if appDelegate.deeplinkurltype != "" && appDelegate.deeplinkid != "" {
//            if appDelegate.deeplinkurltype == "post"{
//                let Login = self.storyBoard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as?  ProductDetailsViewController
//                Login!.postId = appDelegate.deeplinkid
//                self.navigationController?.pushViewController(Login!, animated: true)
//            }else{ //user side
//                if appDelegate.deeplinkid == String(appDelegate.userDetails?.username ?? "") {
//                    self.navigateToHomeScreen(selIndex: 4)
//                    self.deeplinkClear()
//                }
//                else {
//                    self.callGetOtherUserDetails(userId: appDelegate.deeplinkid)
//                }
//                
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.callHomeList()
        if let locations = appDelegate.userDetails?.locations
        {
            let Location = locations.filter {
                $0.is_default == 1
            }
            print(Location)
            if Location.count>0{
                let data = Location[0]
                self.btnUserLocations.setTitle(data.city, for: .normal)
                //                = data.city
                print("City default \(data.city)")
            }
        }
        
    }
    
    
    @IBAction func btnUserLocations_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "UserLocationSetDefaultViewController") as! UserLocationSetDefaultViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnNotification_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnCreateSavedSearch_Clicked(_ button: UIButton) {
        
        //        let date = Date()
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = dateFormateForGet
        //        let stringdate = formatter.string(from: date)
        //        let premiumdate = self.convertStringToDate(format: dateFormateForGet, strDate:  (appDelegate.userDetails?.premium_end_at)!)
        //        let Todaydate = self.convertStringToDate(format: dateFormateForGet, strDate:  stringdate)
        //
        //        if appDelegate.userDetails?.is_premium_user == 0 {
        //            for i in 0..<self.homeListData.count{
        //            if self.homeListData[i]?.name == "Saved Searches" {
        //               let count = self.homeListData[i]?.list?.count ?? 0
        //
        //                if count > 2 {
        //                    let ViewController = storyboard?.instantiateViewController(identifier: "ClickCoinsViewController") as! ClickCoinsViewController
        //                    ViewController.userCoin = "\(appDelegate.userDetails?.coins ?? 0)"
        //                    ViewController.openpremium = true
        //                    self.navigationController?.pushViewController(ViewController, animated: true)
        //                }else{
        //                    let viewController = self.storyboard?.instantiateViewController(identifier: "SaveSearchViewController") as! SaveSearchViewController
        //                    viewController.saveSearch = true
        //                    self.navigationController?.pushViewController(viewController, animated: true)
        //                }
        //            }
        //            }
        //        }else{
        let viewController = self.storyboard?.instantiateViewController(identifier: "SaveSearchViewController") as! SaveSearchViewController
        viewController.saveSearch = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
        // }
    }
    
    @IBAction func btnViewAll_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "ExistingSavedSearchsViewController") as! ExistingSavedSearchsViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnSearchEngine_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "SearchEngineViewController") as! SearchEngineViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        // self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func btnSearchItemMembers_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "SearchItemAndMembersViewController") as! SearchItemAndMembersViewController
        self.navigationController?.pushViewController(viewController, animated: true)
        // self.present(viewController, animated: true, completion: nil)
    }
    
    
    
    
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.homeListData.count//self.titleList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.homeListData[section]?.name == "Saved Searches" {
            //            if self.homeListData[section]?.list?.count ?? 0 > 5 {
            //               return 5
            //            }
            //            else{
            //                return self.homeListData[section]?.list?.count ?? 0
            //            }
            return self.homeListData[section]?.list?.count ?? 0
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.homeListData[indexPath.section]?.name == "Banners"{
            return tableView.estimatedRowHeight
        }
        else if self.homeListData[indexPath.section]?.name == "Saved Searches"{
            return tableView.estimatedRowHeight
        }
        else {
            if homeListData[indexPath.section]?.list?.count != 0 {
                return tableView.estimatedRowHeight
            }
            else
            {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.homeListData[section]?.name == "Banners"{
            return 0
        }
        else if self.homeListData[section]?.name == "Saved Searches"{
            return tableView.estimatedSectionHeaderHeight
        }
        else {
            if homeListData[section]?.list?.count != 0 {
                return tableView.estimatedSectionHeaderHeight
            }
            else
            {
                return 0
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.homeListData[section]?.name == "Saved Searches" {//self.titleList[section] == "Saved Searches" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderSavedSearchTblCell") as! HomeHeaderSavedSearchTblCell
            cell.lblTitle.text = self.homeListData[section]?.name
            
            return cell.contentView
        }
        else{
            if self.homeListData[section]?.name != "Banners"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTblCell") as! HomeHeaderTblCell
                if self.homeListData[section]?.list?.count != 0{
                    let objet = self.homeListData[section]
                    cell.lblTitle.isHidden = false
                    cell.btnViewAll.isHidden = false
                    cell.lblTitle.text = objet?.name//self.titleList[section]
                    cell.btnViewAll.tag = section
                    cell.btnViewAll.addTarget(self, action: #selector(self.btnViewAll_clicked), for: .touchUpInside)
                    return cell.contentView
                }
                else{
                    cell.lblTitle.isHidden = true
                    cell.btnViewAll.isHidden = true
                    //                    cell.btnViewAll.addTarget(self, action: #selector(self.btnViewAll_clicked), for: .touchUpInside)
                    return cell
                }
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTblCell") as! HomeHeaderTblCell
                cell.lblTitle.isHidden = true
                cell.btnViewAll.isHidden = true
                cell.btnViewAll.addTarget(self, action: #selector(self.btnViewAll_clicked), for: .touchUpInside)
                return cell
            }
        }
    }
    
    @objc func btnViewAll_clicked(sender: UIButton) {
        if self.homeListData[sender.tag]?.name == "Recommended" || self.homeListData[sender.tag]?.name == "Following" || self.homeListData[sender.tag]?.name == "Top Picks" || self.homeListData[sender.tag]?.name == "Recently Posted" || self.homeListData[sender.tag]?.name == "Under $50" || self.homeListData[sender.tag]?.name == "Ads Nearby" {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "AllProductViewController") as! AllProductViewController
            viewController.titleStr = self.homeListData[sender.tag]?.name ?? ""
            viewController.typeId = String(self.homeListData[sender.tag]?.type_id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[sender.tag]?.name == "Local Stores" || self.homeListData[sender.tag]?.name == "Popular Brands" {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "AllBrandViewController") as! AllBrandViewController
            viewController.titleStr = self.homeListData[sender.tag]?.name ?? ""
            viewController.typeId = String(self.homeListData[sender.tag]?.type_id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.homeListData[indexPath.section]?.name == "Banners" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeRowBannersTblCell", for: indexPath) as! HomeRowBannersTblCell
            cell.bannerScrollView.auk.settings.placeholderImage = #imageLiteral(resourceName: "img_placeholder")
            cell.bannerScrollView.auk.settings.contentMode = .scaleAspectFill
            cell.bannerScrollView.auk.settings.pagingEnabled = true
            cell.bannerScrollView.auk.settings.pageControl.backgroundColor = .clear
            cell.bannerScrollView.auk.settings.pageControl.pageIndicatorTintColor = .white
            cell.bannerScrollView.auk.settings.pageControl.currentPageIndicatorTintColor = .gray
            cell.bannerScrollView.auk.startAutoScroll(delaySeconds: 2.0)
            
            cell.bannerScrollView.auk.removeAll()
            if self.homeListData.count > 0 {
                if let bannerData = self.homeListData[0]?.list {
                    for j in 0..<bannerData.count {
                        if let image = bannerData[j].photo {
                            cell.bannerScrollView.auk.show(url: image)
                        }
                    }
                }
            }
            
            return cell
        }
        else if self.homeListData[indexPath.section]?.name == "Saved Searches" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeRowSavedSearchTblCell", for: indexPath) as! HomeRowSavedSearchTblCell
            let objet = self.homeListData[indexPath.section]?.list
            cell.lblTitle.text = objet?[indexPath.row].name
            cell.btnEdit.addTarget(self, action: #selector(btnEdit_Clicked), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(btnDelete_Clicked(sender:)), for: .touchUpInside)
            cell.btnView.addTarget(self, action: #selector(btnView_Clicked(sender:)), for: .touchUpInside)
            return cell
        }
        else if self.homeListData[indexPath.section]?.name == "Local Stores" || self.homeListData[indexPath.section]?.name == "Popular Brands" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeRowBrandTblCell", for: indexPath) as! HomeRowBrandTblCell
            cell.CVBrands.tag = indexPath.section
            cell.CVBrands.dataSource = self
            cell.CVBrands.delegate = self
            cell.CVBrands.reloadData()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeRowTblCell", for: indexPath) as! HomeRowTblCell
            cell.CVCloths.tag = indexPath.section
            cell.CVCloths.dataSource = self
            cell.CVCloths.delegate = self
            cell.CVCloths.reloadData()
            return cell
        }
    }
    
    @objc func btnEdit_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblHome)
        if let indexPath = self.tblHome.indexPathForRow(at: buttonPosition) {
            let objet = self.homeListData[indexPath.section]?.list
            let viewController = self.storyboard?.instantiateViewController(identifier: "SaveSearchViewController") as! SaveSearchViewController
            viewController.saveSearchId = String(objet?[indexPath.row].id ?? 0)
            viewController.saveSearch = true
            viewController.edit = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func btnDelete_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblHome)
        if let indexPath = self.tblHome.indexPathForRow(at: buttonPosition) {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to delete?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let objet = self.homeListData[indexPath.section]?.list
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Delete", style: .default, handler: { (action) in
                self.callDeleteSaveSearch(saveSearchId: String(objet?[indexPath.row].id ?? 0), index: indexPath.row, section: indexPath.section)
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func btnView_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblHome)
        if let indexPath = self.tblHome.indexPathForRow(at: buttonPosition) {
            let objet = self.homeListData[indexPath.section]?.list
            let viewController = self.storyboard?.instantiateViewController(identifier: "PopularBrandsViewController") as! PopularBrandsViewController
            viewController.headerTitel = "Search Results"
            viewController.isSaveSearch = true
            viewController.saveSearchID = String(objet?[indexPath.row].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeListData[collectionView.tag]?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let objet = self.homeListData[collectionView.tag]?.list
        //        if self.homeListData[collectionView.tag]?.name == "Local Stores" || self.homeListData[collectionView.tag]?.name == "Popular Brands" {
        
        
        if self.homeListData[collectionView.tag]?.name == "Local Stores" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCVCell", for: indexPath) as! BrandCVCell
            
            cell.imgBrand.setImageFast(with: objet?[indexPath.item].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

            cell.imgBrand.cornerRadius = cell.imgBrand.frame.height / 2
            cell.imgBrand.borderColor = UIColor().grayColor
            cell.lblTitle.text = objet?[indexPath.item].name
            return cell
        }
        else if self.homeListData[collectionView.tag]?.name == "Popular Brands"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCVCell", for: indexPath) as! BrandCVCell
            cell.imgBrand.setImageFast(with: objet?[indexPath.item].user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

            cell.imgBrand.cornerRadius = 0
            cell.imgBrand.borderColor = UIColor().lightGrayColor
            cell.lblTitle.text = objet?[indexPath.item].name
            return cell
        }
        
        // }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
            
            cell.lblSale.backgroundColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
            }
            cell.lblSelePrice.isHidden = objet?[indexPath.item].isLblSaleHidden() ?? true
            cell.lblSale.isHidden = objet?[indexPath.item].isLblSaleHidden() ?? true
            cell.viewSale.isHidden = objet?[indexPath.item].isViewSaleHidden() ?? true
            // cell.imgPromteTopPick.isHidden = objet?[indexPath.item].isTopPickHidden() ?? true
            if let color = objet?[indexPath.item].getBackgroundColor() {
                self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
                cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
            }
            if let strDate = objet?[indexPath.item].created_at{
                let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
                cell.lblDayAgo.text = Date().offset(from: date)
            }
            cell.imgBrand.setImageFast(with: objet?[indexPath.item].image?[0].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

            
            if let brandName = objet?[indexPath.item].brand_name {
                cell.lblBrand.text = brandName
            }
            if let title = objet?[indexPath.item].title {
                cell.lblModelItem.text = title
            }
            
            if let producttype = objet?[indexPath.item].price_type{
                if producttype == "1"{
                    if let price = objet?[indexPath.item].price {
                        if !(objet?[indexPath.item].isLblSaleHidden() ?? true ) {
                            if let salePrice = objet?[indexPath.item].sale_price {
                                cell.lblPrice.text = "$ \(salePrice)"
                            }
                            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price.formatPrice())")
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                            cell.lblSelePrice.attributedText = attributeString
                            cell.constLeadingForlblPrice.constant = 2
                        }
                        else {
                            cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                            cell.lblPrice.text = "$ \(price)"
                        }
                    }
                }else{
                    if let pricetypename = objet?[indexPath.item].price_type_name {
                        cell.lblPrice.text = pricetypename
                        cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                    }
                }
            }
            if let size = objet?[indexPath.item].size_name {
                cell.lblSize.text = size
            }
            if let favrit = objet?[indexPath.item].is_favourite {
                cell.btnWatch.isSelected = favrit
            }
            cell.btnWatch.tag = indexPath.row
            cell.btnWatch.addTarget(self, action: #selector(self.btnWatch_Clicked(_:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    @objc func btnWatch_Clicked(_ sender: AnyObject){
        
        let poston = sender.convert(CGPoint.zero, to: self.tblHome)
        if let indexPath = self.tblHome.indexPathForRow(at: poston) {
            let objet = self.homeListData[indexPath.section]?.list
            let cell = self.tblHome.cellForRow(at: indexPath) as! HomeRowTblCell
            
            let Cposton = sender.convert(CGPoint.zero, to: cell.CVCloths)
            if let indexPaths = cell.CVCloths.indexPathForItem(at: Cposton) {
                //   let cells = cell.CVCloths.cellForItem(at: indexPaths)
                
                if objet?[indexPaths.item].is_favourite == true {
                    if  let postId = objet?[indexPath.item].id {
                        self.callPostFavourite(action_type: "0", postId: String(postId) , tableindex: indexPath.section,collectionindet: indexPaths.item)
                    }
                }
                else {
                    if  let postId = objet?[indexPaths.item].id {
                        self.callPostFavourite(action_type: "1", postId: String(postId) , tableindex: indexPath.section,collectionindet: indexPaths.item)
                    }
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.homeListData[collectionView.tag]?.name == "Recommended"{
            if let postUserId = self.homeListData[collectionView.tag]?.list?[indexPath.item].user_id {
                if postUserId == appDelegate.userDetails?.id {
                    let viewController = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
                    //                    viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                else{
                    let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
                    viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            }
        }
        else if self.homeListData[collectionView.tag]?.name == "Following"{
            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[collectionView.tag]?.name == "Top Picks"{
            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[collectionView.tag]?.name == "Recently Posted"{
            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[collectionView.tag]?.name == "Popular Brands"{
            //            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandProfileViewController") as! BrandProfileViewController
            //            viewController.userId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            //            self.navigationController?.pushViewController(viewController, animated: true)
            let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
            viewController.isMySize = "1"
            viewController.BarndName = "\(self.homeListData[collectionView.tag]?.list?[indexPath.item].name ?? "")"
            viewController.titleStr = "\(self.homeListData[collectionView.tag]?.list?[indexPath.item].name ?? "")"
            viewController.selectGenderId = ""
            viewController.selectBrandId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[collectionView.tag]?.name == "Local Stores"{
            
            let viewController = self.storyboard?.instantiateViewController(identifier: "StoreProfileViewController") as! StoreProfileViewController
            viewController.userId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[collectionView.tag]?.name == "Under $50"{
            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if self.homeListData[collectionView.tag]?.name == "Ads Nearby"{
            let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            viewController.postId = String(self.homeListData[collectionView.tag]?.list?[indexPath.item].id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2.5
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
        
        if self.homeListData[collectionView.tag]?.name == "Banners" {
            return CGSize(width: collectionView.bounds.width, height: 250)
        }
        else if self.homeListData[collectionView.tag]?.name == "Local Stores" || self.homeListData[collectionView.tag]?.name == "Popular Brands" {
            return CGSize(width: widthPerItem, height: 150)
        }
        else{
            return CGSize(width: widthPerItem, height: 230)
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
        if self.homeListData[collectionView.tag]?.name == "Banners" {
            return 5
        }
        else if self.homeListData[collectionView.tag]?.name == "Local Stores" || self.homeListData[collectionView.tag]?.name == "Popular Brands" {
            return 15
        }
        return interitemSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.homeListData[collectionView.tag]?.name == "Banners" {
            return 5
        }
        else if self.titleList[collectionView.tag] == "Local Stores" || self.titleList[collectionView.tag] == "Popular Brands" {
            return 15
        }
        return interitemSpace
    }
}

class HomeRowBannersTblCell : UITableViewCell {
    @IBOutlet weak var bannerScrollView: UIScrollView!
    
}

class HomeHeaderTblCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
}
class HomeHeaderSavedSearchTblCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
}

class HomeRowSavedSearchTblCell : UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
}

class HomeRowTblCell : UITableViewCell {
    @IBOutlet weak var CVCloths: UICollectionView!
}

class HomeRowBrandTblCell : UITableViewCell {
    @IBOutlet weak var CVBrands: UICollectionView!
}

class BannersCVCell : UICollectionViewCell {
    
}

class BrandCVCell : UICollectionViewCell {
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgBrand: CustomImageView!
}

class HomeCVCell : UICollectionViewCell {
    @IBOutlet weak var bgView: CustomView!
    @IBOutlet weak var imgBrand: CustomImageView!
    @IBOutlet weak var imgPromteTopPick: UIImageView!
    @IBOutlet weak var lblDayAgo: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblModelItem: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var constLeadingForlblPrice: NSLayoutConstraint!
    @IBOutlet weak var lblSelePrice: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var btnWatch: UIButton!
    @IBOutlet weak var viewSale: UIView!
    @IBOutlet weak var lblSale: UILabel!
}

extension HomeViewController {
    func callPostFavourite(action_type : String,postId : String,tableindex: Int,collectionindet:Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
            ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    self.callHomeList()
                    //                    if action_type == "1"{
                    //                        let Tablepath = IndexPath(row: 0, section: tableindex)
                    //                        let cell = self.tblHome.cellForRow(at: Tablepath) as! HomeRowTblCell
                    //                        let collpath = IndexPath(row: collectionindet, section: 0)
                    //                        var objet = self.homeListData[tableindex]?.list
                    //                        objet?[collectionindet].is_favourite = true
                    //                        cell.CVCloths.reloadData()
                    //                      //  cell.CVCloths.reloadItems(at: [IndexPath.init(row: collectionindet, section: 0)])
                    //                    }
                    //                    else {
                    //                        let Tablepath = IndexPath(row: 0, section: tableindex)
                    //                        let cell = self.tblHome.cellForRow(at: Tablepath) as! HomeRowTblCell
                    //                        let collpath = IndexPath(row: collectionindet, section: 0)
                    //                        var objet = self.homeListData[tableindex]?.list
                    //                        objet?[collectionindet].is_favourite = false
                    //                        cell.CVCloths.reloadData()
                    //                        //cell.CVCloths.reloadItems(at: [IndexPath.init(row: collectionindet, section: 0)])
                    //                    }
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
    
    func callHomeList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: HomeModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.HOME_PAGE.rawValue, method: .post, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.arrayData {
                            self.homeListData = data
                            
                            if self.homeListData.count  > 0  {
                                var popup = true
                                for i in 0..<self.homeListData.count{
                                    if  self.homeListData[i]?.list?.count ?? 0  > 0{
                                        if self.homeListData[i]?.name == "Banners"{
                                        }
                                        else if self.homeListData[i]?.name == "Saved Searches"{
                                            
                                        }
                                        else{
                                            popup = false
                                            break;
                                        }
                                    }else{
                                        
                                    }
                                }
                                if popup ==  false{
                                    self.tblHome.isHidden = false
                                    self.tblHome.reloadData()
                                    self.tblHome.layoutIfNeeded()
                                    self.constHeightForTblHome.constant = self.tblHome.contentSize.height
                                }else{
                                    self.tblHome.isHidden = true
                                    let viewController = self.storyboard?.instantiateViewController(identifier: "PopViewViewController") as! PopViewViewController
                                    viewController.modalPresentationStyle = .overFullScreen
                                    self.present(viewController, animated: true, completion: nil)
                                }
                            }else{
                                self.tblHome.isHidden = true
                                let viewController = self.storyboard?.instantiateViewController(identifier: "PopViewViewController") as! PopViewViewController
                                viewController.modalPresentationStyle = .overFullScreen
                                self.present(viewController, animated: true, completion: nil)
                            }
                        }
                        self.getUserDetails()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callDeleteSaveSearch(saveSearchId : String, index: Int , section : Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["save_search_id":  saveSearchId
            ]
            
            APIManager().apiCallWithMultipart(of: SaveSearchListMOdel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SERCH_DELETE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    //                    self.tblHome.deleteRows(at: [IndexPath.init(row: index, section: section)], with: UITableView.RowAnimation.automatic)
                    //                    self.homeListData.remove(at: [IndexPath.init(row: index, section: section)])
                    self.homeListData[section]?.list?.remove(at: index)
                    self.tblHome.reloadData()
                    self.tblHome.layoutIfNeeded()
                    self.constHeightForTblHome.constant = self.tblHome.contentSize.height
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
            
            let param = ["username":  userId
            ]
            APIManager().apiCall(of:OtherUserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.OTHER_USER_DETAILS.rawValue, method: .post, parameters: param) { [self] (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            let otherUserDetailsData = data
                            if let seller = otherUserDetailsData.role_id {
                                if seller == 1 {
                                    let viewController = self.storyBoard.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
                                    viewController.userId = String(otherUserDetailsData.id ?? 0)
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                                else if seller == 2{
                                    let viewController = self.storyBoard.instantiateViewController(withIdentifier: "StoreProfileViewController") as! StoreProfileViewController
                                    viewController.userId = String(otherUserDetailsData.id ?? 0)
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                                else {
                                    let viewController = self.storyBoard.instantiateViewController(withIdentifier: "BrandProfileViewController") as! BrandProfileViewController
                                    viewController.userId = String(otherUserDetailsData.id ?? 0)
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                            }
                            self.deeplinkClear()
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
    
    func getUserDetails() {
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.AUTOLOGIN.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.userData = userDetails
                            self.DeepLinknaviget()
                            if let UnreadnotificationCount = self.userData?.total_unread_notifications{
                                if UnreadnotificationCount == 0 {
                                    self.btnNotification.setTitle("", for: .normal)
                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                }
                                else {
                                    if UnreadnotificationCount > 99 {
                                        self.btnNotification.setTitle("99+", for: .normal)
                                        UIApplication.shared.applicationIconBadgeNumber = UnreadnotificationCount
                                    }
                                    else {
                                        self.btnNotification.setTitle("\(UnreadnotificationCount)", for: .normal)
                                        UIApplication.shared.applicationIconBadgeNumber = UnreadnotificationCount
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
}
