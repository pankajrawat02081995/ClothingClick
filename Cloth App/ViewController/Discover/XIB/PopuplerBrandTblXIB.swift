//
//  PopuplerBrandTblXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 29/06/24.
//

import UIKit

class PopuplerBrandTblXIB: UITableViewCell {

    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    var modelData = [List]()
    var type: String?
    weak var view: UIViewController?
    var likeProduct: ((AnyObject) -> Void)?
    var typeID : String?
    let layout = UICollectionViewFlowLayout()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        collectionView.register(UINib(nibName: "BrandXIB", bundle: nil), forCellWithReuseIdentifier: "BrandXIB")
        layout.scrollDirection = .horizontal
        
    }
    func setData(list: [List], type: String, view: UIViewController) {
        self.modelData = list
        self.type = type
        if type == "stores"{
            self.collectionViewHeight.constant = 140
        }else{
            self.collectionViewHeight.constant = 120
        }
        if type == "stores"{
            layout.itemSize = CGSize(width: 100, height: 140)
        }else{
            layout.itemSize = CGSize(width: 100, height: 120)
        }
        collectionView.collectionViewLayout = layout

        self.view = view
        collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension PopuplerBrandTblXIB: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = modelData[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandXIB", for: indexPath) as! BrandXIB
        
        if self.type == "brands"{
            cell.imgBrand.setImageFast(with: object.user_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            
            cell.lblName.text = ""
        }else{
            cell.imgBrand.setImageFast(with: object.profile_image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

            cell.lblName.text = object.name ?? ""
        }
        cell.imgBrand.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = modelData[indexPath.item]
        
        switch type {
        case "posts":
            let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
            vc.postId = "\(self.modelData[indexPath.item].id ?? 0)"
            vc.hidesBottomBarWhenPushed =  self.modelData[indexPath.item].user_id ?? 0 == appDelegate.userDetails?.id
            self.view?.pushViewController(vc: vc)
            
        case "brands":
            let vc = AllProductViewController.instantiate(fromStoryboard: .Main)
            vc.isMySize = "1"
                vc.BarndName = "\(modelData[indexPath.item].name ?? "")"
                vc.titleStr = "\(modelData[indexPath.item].name ?? "")"
                vc.selectBrandId = String(modelData[indexPath.item].id ?? 0)
            vc.selectGenderId = ""
            vc.isShowFilter = false
            FilterSingleton.share.filter = Filters()
            FilterSingleton.share.selectedFilter = FiltersSelectedData()
            FilterSingleton.share.filter.brand_id = String(modelData[indexPath.item].id ?? 0)
            FilterSingleton.share.selectedFilter.brand_id = "\(modelData[indexPath.item].name ?? "")"
            view?.pushViewController(vc: vc)
        case "stores" :
            let vc = StoreProfileVC.instantiate(fromStoryboard: .Store)
            vc.viewModel.userID = "\(self.modelData[indexPath.item].id ?? 0)"
            view?.pushViewController(vc: vc)
        default:
            break
        }
    }
}
