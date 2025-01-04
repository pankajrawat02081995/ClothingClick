//
//  RecommendedTableXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 19/12/24.
//

import UIKit

class RecommendedTableXIB: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var posts = [List]()
    var view : UIViewController?
    var likeProduct: ((UIButton) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCollectionView(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
    }
    
    func setupData(posts: [List],view:UIViewController){
        self.posts = posts
        self.view = view
        self.collectionView.reloadData()
    }
    
    @objc func btnWatch_Clicked(_ sender: UIButton) {
        likeProduct?(sender)
    }
}

extension RecommendedTableXIB:CollectionViewDelegateAndDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as! HomePageBrowserXIB
        let objet = self.posts[indexPath.item]
        if let url = objet.image?.first?.image {
            if let image = URL.init(string: url){
                cell.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collectionView.frame.size.width / 2.1) - 20, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.postId = "\(self.posts[indexPath.item].id ?? 0)"
        vc.hidesBottomBarWhenPushed =  self.posts[indexPath.item].user_id ?? 0 == appDelegate.userDetails?.id
        self.view?.pushViewController(vc: vc)
    }
    
}
