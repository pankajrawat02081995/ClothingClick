//
//  PopularBrandsViewController.swift
//  ClothApp
//
//  Created by Apple on 12/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class PopularBrandsViewController: BaseViewController {

    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var headerView: CustomView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnBookMark: UIButton!
    @IBOutlet weak var CVCProduct: UICollectionView!
    @IBOutlet weak var constHeightForHeadeView: NSLayoutConstraint!

    
    @IBOutlet weak var btnSort: UIButton!
    
    var isSaveSearch = false
    var headerTitel = ""
    var saveSearchID = ""
    var currentPage = 1
    var hasMorePages = false
    var sort_by = "date"
    var sort_value = "desc"
    var postList = [Posts]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constHeightForHeadeView.constant = 44
        self.lblHeaderTitle.isHidden = false
        self.lblHeaderTitle.text = self.headerTitel
        self.btnBookMark.isHidden = false
        self.CVCProduct.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 60, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callSaveSearchPost(saveSearchId: self.saveSearchID, page: self.currentPage, isShowHud: true, sort_by: self.sort_by, sort_value: self.sort_value)
    }
    
    @IBAction func btnBookMark_Clicked(_ button: UIButton) {
//        let objet = self.homeListData[indexPath.section]?.list
        let viewController = self.storyboard?.instantiateViewController(identifier: "SaveSearchViewController") as! SaveSearchViewController
        viewController.saveSearchId = self.saveSearchID//String(objet?[indexPath.row].id ?? 0)
        viewController.edit = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func btnShort_Clicked(_ button: UIButton) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "ShortByViewController") as! ShortByViewController
        viewController.sort_by = self.sort_by
        viewController.sort_value = self.sort_value
        viewController.shortByDeleget = self
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension PopularBrandsViewController : UICollisionBehaviorDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
//        cell.lblSale.backgroundColor = .red
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
//        }
//        cell.lblSale.isHidden = objet.isLblSaleHidden() ?? true
//        cell.viewSale.isHidden = objet.isViewSaleHidden() ?? true
//        cell.imgPromteTopPick.isHidden = objet.isTopPickHidden() ?? true
//        if let color = objet.getBackgroundColor() {
//            self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
//            cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
//        }
        let objet = self.postList[indexPath.item]
        cell.lblSale.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            cell.lblSale.roundCorners([.topLeft,.topRight], radius: 10)
        }
        cell.lblSale.isHidden = objet.isLblSaleHidden()
        cell.lblSelePrice.isHidden = objet.isLblSaleHidden()
        cell.viewSale.isHidden = objet.isViewSaleHidden()
    //    cell.imgPromteTopPick.isHidden = objet.isTopPickHidden()
        if let color = objet.getBackgroundColor() {
            self.setBorderAndRadius(radius: 10, view: cell.viewSale, borderWidth: 1, borderColor: color)
            cell.viewSale.backgroundColor = color.withAlphaComponent(0.29)
        }
        
        if let strDate = objet.created_at{
            let date = self.convertWebStringToDate(strDate: strDate).toLocalTime()
            cell.lblDayAgo.text = Date().offset(from: date)
        }
        
        if let brande = objet.brand_name{
            cell.lblBrand.text = brande
        }
        if let title = objet.title {
            cell.lblModelItem.text = title
        }
        if let price = objet.price{
            if !(objet.isLblSaleHidden() ) {
                if let salePrice = objet.sale_price {
                    cell.lblPrice.text = "$ \(salePrice)"
                }
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "$ \(price.formatPrice())")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.constLeadingForlblPrice.constant = 2
                cell.lblSelePrice.attributedText = attributeString
            }
            else {
                cell.constLeadingForlblPrice.constant = -cell.lblSelePrice.frame.width
                cell.lblPrice.text = "$ \(price.formatPrice())"
            }
        }
        if let size = objet.size_name{
            cell.lblSize.text = size
        }
        if let is_favourite = objet.is_favourite{
            print(is_favourite)
            cell.btnWatch.isSelected = is_favourite
        }
        if let url = objet.image?[0].image {
            cell.imgBrand.setImageFast(with: url)
        }
    
        cell.btnWatch.addTarget(self, action: #selector(btnWatch_Clicked(_:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objet = self.postList[indexPath.item]
//        let viewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//        viewController.postId = "\(objet.id ?? 0)"
//        self.navigationController?.pushViewController(viewController, animated: true)
        let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.postId = "\(objet.id ?? 0)"
        vc.hidesBottomBarWhenPushed = true
        self.pushViewController(vc: vc)
    }
    
    @objc func btnWatch_Clicked(_ sender: AnyObject) {
        let poston = sender.convert(CGPoint.zero, to: self.CVCProduct)
        if let indexPath = self.CVCProduct.indexPathForItem(at: poston) {
            let objet = self.postList[indexPath.item]
            let postId = self.postList[indexPath.item].id ?? 0
            if objet.is_favourite == true {
                    self.callPostFavourite(action_type: "0", postId: String(postId) , index: indexPath)
            }
            else {
                    self.callPostFavourite(action_type: "1", postId: String(postId) , index: indexPath)
            }
        }
    }
}
extension PopularBrandsViewController: UICollectionViewDelegateFlowLayout {
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
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 300)
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
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.postList.count - 2 && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callSaveSearchPost(saveSearchId: self.saveSearchID, page: self.currentPage, isShowHud: false, sort_by: self.sort_by, sort_value: self.sort_value)
        }
    }
}

extension PopularBrandsViewController {
    func callSaveSearchPost(saveSearchId : String,page: Int,isShowHud : Bool,sort_by :String, sort_value: String) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["save_search_id":  saveSearchId,
                         "page": "\(self.currentPage)",
                         "sort_by":  sort_by,
                         "sort_value": sort_value
            ] as [String : Any]

            APIManager().apiCallWithMultipart(of: SaveSearchListMOdel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.SAVE_SEARCH_POSTS.rawValue, parameters: param) { (response, error) in
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
                            self.lblNoData.isHidden = false
                            if sort_by == "size" {
                                self.btnSort.isHidden = true
                            }
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                            self.btnSort.isHidden = false
                        }
                        self.CVCProduct.reloadData()
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
    func callPostFavourite(action_type : String,postId : String,index: IndexPath) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["post_id" : postId,
                         "action_type":  action_type
                        ]
            APIManager().apiCallWithMultipart(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.FAVOURITE_POST_MANAGE.rawValue, parameters: param) { (response, error) in
                if error == nil {
                    if self.postList.count == 0 {
                        self.lblNoData.isHidden = false
                        self.btnSort.isHidden = true
                    }
                    else
                    {
                        self.lblNoData.isHidden = true
                        self.btnSort.isHidden = false
                        if action_type == "1" {
                            self.postList[index.item].is_favourite = true
                        }
                        else{
                            self.postList[index.item].is_favourite = false
                        }
                    }
                    self.CVCProduct.reloadItems(at: [index])

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

extension PopularBrandsViewController : ShortByDelegate{
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        self.currentPage = 1
        self.callSaveSearchPost(saveSearchId: self.saveSearchID, page: self.currentPage, isShowHud: true, sort_by: self.sort_by, sort_value: self.sort_value)
    }
}
