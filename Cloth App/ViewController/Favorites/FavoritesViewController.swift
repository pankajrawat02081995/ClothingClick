//
//  FavoritesViewController.swift
//  ClothApp
//
//  Created by Apple on 05/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class FavoritesViewController: BaseViewController {

    @IBOutlet weak var btnShort: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var CVFavorites: UICollectionView!
    
    var currentPage = 1
    var hasMorePages = false
    var postList = [Posts?]()
    var sort_by = "date"
    var sort_value = "desc"
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.CVFavorites.delegate = self
        self.CVFavorites.dataSource = self
        self.CVFavorites.contentInset = UIEdgeInsets(top: 20, left: 14, bottom: 10, right: 14)
        self.CVFavorites.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentPage = 1
        self.sort_by = "date"
        self.sort_value = "desc"
        self.lblNoData.isHidden = true
        if self.selectedIndex == 0 {
            self.callFavoritesPost(isShowHud: true, sort_by: self.sort_by, sort_value: self.sort_value)
        }else{
            self.selectedIndex = 0
        }
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnShort_Clicked(_ button: UIButton) {
        
        let vc = FilterProductVC.instantiate(fromStoryboard: .Dashboard)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = customTransitioningDelegate
        vc.callBack = {
            self.callFavoritesPost(isShowHud: true, sort_by: self.sort_by, sort_value: self.sort_value)
        }
        vc.isJustFilter = true
        let root = UINavigationController(rootViewController: vc)
        self.present(root, animated: true, completion: nil)
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVFavorites)
        if let indexPath = self.CVFavorites.indexPathForItem(at: poston) {
            let postId = self.postList[indexPath.item]?.id ?? 0
            self.callPostFavourite(action_type: "0", postId: String(postId) , index: indexPath.item)
        }
    }
}

extension FavoritesViewController : UICollisionBehaviorDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
        //        let objet = self.postList[indexPath.item]
        //        cell.lblSale.backgroundColor = .red
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
        //            cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
        //        }
        //        cell.lblSale.isHidden = objet?.isLblSaleHidden() ?? true
        //        cell.lblSelePrice.isHidden = objet?.isLblSaleHidden() ?? true
        //        cell.viewSale.isHidden = objet?.isViewSaleHidden() ?? true
        //      //  cell.imgPromteTopPick.isHidden = objet?.isTopPickHidden() ?? true
        //        if let color = objet?.getBackgroundColor() {
        //            self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
        //            cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
        //        }
        //
        //        if let strDate = objet?.created_at{
        ////            let date = self.convertStringToDate(format: "yyyy-MM-dd HH:mm:ss", strDate: strDate)
        //            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
        ////            let days = Date().days(from: date)
        //            cell.lblDayAgo.text = Date().offset(from: date)
        //        }
        //
        //        if let brande = objet?.brand_name{
        //            cell.lblBrand.text = brande
        //        }
        //        if let title = objet?.title {
        //            cell.lblModelItem.text = title
        //        }
        //        if let producttype = objet?.price_type{
        //            if producttype == "1"{
        //        if let price = objet?.price{
        ////            print(price)
        //            if !(objet?.isLblSaleHidden() ?? true) {
        //                if let salePrice = objet?.sale_price {
        //                    cell.lblPrice.text = "$ \(salePrice)"
        //                }
        //                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price)")
        //                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        //                cell.constLeadingForlblPrice.constant = 2
        ////                cell.lblPrice.text = "$ \(price)"
        //                cell.lblSelePrice.attributedText = attributeString
        //            }
        //            else {
        //                cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
        //                cell.lblPrice.text = "$ \(price)"
        //            }
        //        }
        //            }else{
        //                if let producttype = objet?.price_type_name{
        //                cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
        //                cell.lblPrice.text = "\(producttype)"
        //                }
        //            }
        //        }
        //        if let size = objet?.size_name{
        //            cell.lblSize.text = size
        //        }
        //        if let is_favourite = objet?.is_favourite{
        //            cell.btnWatch.isSelected = is_favourite
        //        }
        //        if let url = objet?.image?[0].image {
        //            if let imgUrl = URL.init(string: url){
        //                cell.imgBrand.kf.setImage(with: imgUrl, placeholder: PlaceHolderImage)
        //            }
        //        }
        //
        //        cell.btnWatch.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
        let objet = self.postList[indexPath.item]
        if let url = objet?.image?.first?.image {
            cell.imgProduct.setImageFast(with: url)
        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
        if let is_favourite = objet?.is_favourite {
            cell.btnLike.isSelected = is_favourite
        }
        if let title = objet?.title {
            cell.lblProductName.text = title
        }
        
        if let producttype = objet?.price_type{
            if producttype == "1"{
                if let price = objet?.price {
                    if ((objet?.isLblSaleHidden()) == nil) {
                        if let salePrice = objet?.sale_price {
                            cell.lblPrice.text = "$ \(salePrice)"
                        }
                    }else {
                        cell.lblPrice.text = "$ \(price.formatPrice())"
                    }
                }
            }
            else{
                if let producttype = objet?.price_type_name{
                    cell.lblPrice.text = "\(producttype)"
                }
            }
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
//        let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        viewController.postId = String(self.postList[indexPath.item]?.id ?? 0)
//        viewController.likeDeleget = self
//        viewController.indexpath = indexPath
//        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.postId = String(self.postList[indexPath.item]?.id ?? 0)
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.postList.count - 1 && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callFavoritesPost(isShowHud: false, sort_by: self.sort_by, sort_value: self.sort_value)
           
        }
    }
}
extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
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
//        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
//        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
//        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
//        let widthPerItem = availableWidth / itemsPerRow
//        return CGSize(width: widthPerItem, height: 300)
        return CGSize(width: (self.CVFavorites.frame.size.width / 2) - 20, height: 222)

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

extension FavoritesViewController {
    
    func callFavoritesPost(isShowHud : Bool,sort_by :String, sort_value: String) {
        
//        let param = ["sort_by":  sort_by,
//                     "sort_value": sort_value,
//                     "page" : "\(self.currentPage)" ]
        
        var param = FilterSingleton.share.filter.toDictionary()
        param?.removeValue(forKey: "is_only_count")
        param?["page"] = "\(self.currentPage)"
        param?.removeValue(forKey: "slectedCategories")
        
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.postList.removeAll()
                            }
                            
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            
                            if let post = data.posts {
                                for temp in post {
                                    self.postList.append(temp)
                                }
                            }
                        }
                        if self.postList.count == 0 {
                            self.lblNoData.isHidden = true
                            if sort_by != "size"  {
//                                self.btnShort.isHidden = true
                            }
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                            self.btnShort.isHidden = false
                        }
                        self.CVFavorites.setBackGroundLabel(count: self.postList.count)
                        self.CVFavorites.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
    
    func callPostFavourite(action_type : String,postId : String,index: Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
                        ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    self.postList.remove(at: index)
                    if self.postList.count == 0 {
                        self.lblNoData.isHidden = true
//                        self.btnShort.isHidden = true
                    }
                    else
                    {
                        self.lblNoData.isHidden = true
                        self.btnShort.isHidden = false
                    }
                    self.CVFavorites.setBackGroundLabel(count: self.postList.count)
                    self.CVFavorites.reloadData()
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

extension FavoritesViewController : ShortByDelegate,LikeDelegate{
    
    func Like(like: Bool, indexpath: IndexPath) {
        if like == false {
            self.postList.remove(at: indexpath.row)
            self.CVFavorites.reloadData()
        }
        else {
            self.CVFavorites.scrollToItem(at: indexpath, at: .centeredVertically, animated: false)
        }
    }
    
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        print("SORT_BY\(sort_by)")
        self.sort_value = sort_value
        print("SORT_VALUE\(sort_value)")
        self.currentPage = 1
        self.callFavoritesPost(isShowHud: true, sort_by: self.sort_by, sort_value: self.sort_value)
    }
}
