//
//  HomePageBrowserXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 21/05/24.
//

import UIKit

class HomePageBrowserXIB: UICollectionViewCell {

    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
//    {
//        didSet{
//            imgProduct.contentMode = imgProduct.preferredContentMode()
//        }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
