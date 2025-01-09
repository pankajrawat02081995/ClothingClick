//
//  DiscoveTableCellXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 20/06/24.
//

import UIKit

class DiscoveTableCellXIB: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    var modelData = [List]()
    var type: String?
    weak var view: UIViewController?
    var likeProduct: ((AnyObject) -> Void)?
    var typeID: String?
    var isMensware: Bool?
    var scrollIndex: ((Int) -> Void)?
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    // MARK: - Setup Methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MensAndWomensWareXIB", bundle: nil), forCellWithReuseIdentifier: "MensAndWomensWareXIB")
        collectionView.layoutIfNeeded()
    }
    
    // MARK: - Public Methods
    func setData(list: [List], type: String, view: UIViewController, isMensware: Bool = false) {
        DispatchQueue.main.async {
            self.modelData = list
            self.type = type
            self.view = view
            self.isMensware = isMensware
            self.updateCollectionViewHeight()
        }
    }
    
    // MARK: - Private Methods
    private func updateCollectionViewHeight() {
        let layout = UICollectionViewFlowLayout()
        
        switch type {
        case "categories":
            layout.scrollDirection = .vertical
            let width = (collectionView.frame.size.width / 3) - 20
            layout.itemSize = CGSize(width: width, height: width + 30)
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
            
            DispatchQueue.main.async {
                let rows = self.isMensware == true ? 2 : 3
                let additionalSpacing: CGFloat = self.isMensware == true ? 48 : 72
                let totalHeight = (CGFloat(rows) * (width + 30)) + additionalSpacing
                self.collectionViewHeight.constant = totalHeight
                self.collectionView.collectionViewLayout = layout
            }
            
        default:
            break
        }
        
        // collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = false
        collectionView.reloadData()
    }
    
    @objc private func btnWatch_Clicked(_ sender: AnyObject) {
        likeProduct?(sender)
    }
    
    // MARK: - Selection Handling
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension DiscoveTableCellXIB: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = modelData[indexPath.item]
        
        switch type {
        case "categories":
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MensAndWomensWareXIB", for: indexPath) as? MensAndWomensWareXIB else {
                return UICollectionViewCell()
            }
            
            if let url = object.icon, let imgUrl = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
                cell.imgGender.kf.setImage(with: imgUrl, placeholder: PlaceHolderImage)
            }
            cell.bgView.layer.borderColor = UIColor.customBorderColor?.cgColor
            cell.bgView.layer.borderWidth = 1
            cell.lblName.text = object.name
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = modelData[indexPath.item]
        
        switch type {
        case "categories":
            let vc = AllProductViewController.instantiate(fromStoryboard: .Main)
            vc.isMySize = "1"
            vc.cat_id = "\(object.category_id ?? 0)"
            vc.selectBrandId = String(object.id ?? 0)
            vc.titleStr = object.name ?? ""
            vc.typeId = typeID ?? ""
            
            FilterSingleton.share.filter = Filters()
            FilterSingleton.share.selectedFilter = FiltersSelectedData()
            FilterSingleton.share.filter.categories = "\(object.category_id ?? 0)"
            FilterSingleton.share.selectedFilter.categories = object.name ?? ""
            
            vc.isShowFilter = false
            view?.pushViewController(vc: vc)
            
        default:
            break
        }
    }
}

// MARK: - Helper Methods
extension DiscoveTableCellXIB {
    func getCenterCellIndexPath() -> IndexPath? {
        let visibleCells = collectionView.visibleCells
        let centerPoint = CGPoint(x: collectionView.bounds.midX + collectionView.contentOffset.x,
                                  y: collectionView.bounds.midY + collectionView.contentOffset.y)
        
        var closestCell: UICollectionViewCell?
        var closestDistance: CGFloat = .greatestFiniteMagnitude
        
        for cell in visibleCells {
            let cellCenter = cell.center
            let distance = sqrt(pow(cellCenter.x - centerPoint.x, 2) + pow(cellCenter.y - centerPoint.y, 2))
            
            if distance < closestDistance {
                closestDistance = distance
                closestCell = cell
            }
        }
        
        if let closestCell = closestCell {
            return collectionView.indexPath(for: closestCell)
        }
        
        return nil
    }
}
