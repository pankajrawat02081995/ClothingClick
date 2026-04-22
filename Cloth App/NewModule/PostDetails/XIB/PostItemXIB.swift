//
//  PostItemXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 01/06/24.
//

import UIKit
import IBAnimatable
class PostItemXIB: UICollectionViewCell {

    @IBOutlet weak var lblCoverPhoto: AnimatableLabel!
    @IBOutlet weak var btnDelete: AnimatableButton!
    @IBOutlet weak var imgProduct: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
