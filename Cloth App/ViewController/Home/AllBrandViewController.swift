//
//  AllBrandViewController.swift
//  ClothApp
//
//  Created by Apple on 27/03/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class AllBrandViewController: BaseViewController {
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var CVBrand: UICollectionView!
    
    var titleStr = ""
    var typeId = ""
    var currentPage = 1
    var hasMorePages = false
    var postList = [Posts?]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = self.titleStr
        self.callHomeListDetails(isShowHud: true, listType: typeId, page: "\(self.currentPage)")
        self.CVBrand.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
}

extension AllBrandViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCVCell", for: indexPath) as! BrandCVCell
        let objet = self .postList[indexPath.item]
        if self.titleStr == "Local Stores" {

            cell.imgBrand.setImageFast(with: objet?.user_image ?? "")
            cell.imgBrand.borderColor = UIColor().grayColor
            cell.lblTitle.text = objet?.name
        }
        else{
            cell.imgBrand.setImageFast(with: objet?.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            cell.imgBrand.cornerRadius = 0
            cell.imgBrand.borderColor = UIColor().lightGrayColor
            cell.lblTitle.text = objet?.name
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.titleStr == "Local Stores" {
            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "StoreProfileViewController") as! StoreProfileViewController
            viewController.userId = "\(postList[indexPath.item]?.id ?? 0)"
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            //            let viewController = self.storyBoard.instantiateViewController(withIdentifier: "BrandProfileViewController") as! BrandProfileViewController
            //            viewController.userId = "\(postList[indexPath.item]?.id ?? 0)"
            //            self.navigationController?.pushViewController(viewController, animated: true)
            let viewController = self.storyboard?.instantiateViewController(identifier: "AllProductViewController") as! AllProductViewController
            viewController.isMySize = "1"
            viewController.BarndName = "\(postList[indexPath.item]?.name ?? "")"
            viewController.titleStr = "\(postList[indexPath.item]?.name ?? "")"
            viewController.selectGenderId = ""
            viewController.selectBrandId = String(postList[indexPath.item]?.id ?? 0)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.postList.count && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callHomeListDetails(isShowHud: false, listType: self.typeId, page: "\(self.currentPage)")
        }
    }
}

extension AllBrandViewController: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 3.0
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
        
        if self.titleStr == "Local Stores" {
            return CGSize(width: widthPerItem, height: 150)
        }
        else{
            return CGSize(width: widthPerItem, height: 180)
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

extension AllBrandViewController {
    func callHomeListDetails(isShowHud : Bool,listType :String, page: String) {
        let param = ["list_type":  listType,
                     "page": "-1"
        ] as [String : Any]
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.HOME_LIST_POSTLIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.postList.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages{
                                //                                if hasMorePages == 1 {
                                self.hasMorePages = hasMorePages
                                //                                }
                                //                                else {
                                //                                    self.hasMorePages = false
                                //                                }
                            }
                            if let post = data.posts {
                                for temp in post {
                                    self.postList.append(temp)
                                }
                            }
                        }
                        if self.postList.count == 0 {
                            self.lblNoData.isHidden = false
                        }
                        else
                        {
                            self.lblNoData.isHidden = true
                        }
                        self.CVBrand.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}
