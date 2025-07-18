//
//  TableXIBForCollectionView.swift
//  Demo
//
//  Created by Bhoomi on 01/06/24.
//

import UIKit

class TableXIBForCollectionView: UITableViewCell {
    
    @IBOutlet weak var collectioView: UICollectionView!
    
    var numberOfCell: Int = 1
    var cellSizes: [CGSize] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectioView.delegate = self
        collectioView.dataSource = self
        
        let cellNib = UINib(nibName: "CollectionImageXIB", bundle: nil)
        collectioView.register(cellNib, forCellWithReuseIdentifier: "CollectionImageXIB")
    }
    
    func configure(numberOfCells: Int, sizes: [CGSize]) {
        self.numberOfCell = numberOfCells
        self.cellSizes = sizes
        collectioView.reloadData()
    }
}

extension TableXIBForCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfCell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionImageXIB", for: indexPath) as! CollectionImageXIB
        if self.numberOfCell == 1{
            cell.imageProduct.image = UIImage(named: "combine")
            cell.imageProduct.layer.cornerRadius = 5
        }else{
            cell.imageProduct.image = UIImage(named: "\(indexPath.item)")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row < cellSizes.count {
            return cellSizes[indexPath.row]
        }
        return CGSize(width: 100, height: 100)  
    }
}
