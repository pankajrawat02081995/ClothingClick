import UIKit

class ItemTbCell: UITableViewCell {
    
    @IBOutlet weak var lblNoDataAvailable: UILabel!
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCon: NSLayoutConstraint!
    var posts = [Posts]()
    var view : UIViewController?
    var likeOnPress :((AnyObject) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCell(nib: UINib(nibName: "HomePageBrowserXIB", bundle: nil), identifier: "HomePageBrowserXIB")
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            
            if self.posts.count > 0 {
                if let newValue = change?[.newKey] as? CGSize {
                    heightCon.constant = newValue.height + 50
                    // Notify table view to update its layout
                    UIView.setAnimationsEnabled(false) // Disable animations for smoother updates
                    self.superview?.layoutIfNeeded()
                    UIView.setAnimationsEnabled(true)
                }
            }else {
                heightCon.constant = 80
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func setPostData(post:[Posts]){
        self.posts = post
        self.lblNoDataAvailable.isHidden =  self.posts.count != 0
        self.collectionView.reloadData()
    }
    
    func calculateCollectionViewHeight() -> CGFloat {
            collectionView.layoutIfNeeded()
            return collectionView.contentSize.height
        }
    @objc func likeOnPress(sender:UIButton){
        self.likeOnPress?(sender)
    }
    
}

extension ItemTbCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomePageBrowserXIB", for: indexPath) as? HomePageBrowserXIB else {
            return UICollectionViewCell()
        }
        let objet = self.posts[indexPath.item]
        if let url = objet.image?.first?.image {
            if let image = URL.init(string: url){
                cell.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(likeOnPress(sender:)), for: .touchUpInside)
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
        return CGSize(width: ((self.collectionView.frame.size.width / 2) - 40 ), height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = OtherPostDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.postId = "\(self.posts[indexPath.item].id ?? 0)"
        vc.hidesBottomBarWhenPushed =  self.posts[indexPath.item].user_id ?? 0 == appDelegate.userDetails?.id
        self.view?.pushViewController(vc: vc)
    }
}
