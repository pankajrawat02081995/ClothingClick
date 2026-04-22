//
//  ReviewXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 08/06/24.
//

import UIKit
import IBAnimatable

class ReviewXIB: UITableViewCell {

    @IBOutlet weak var imgProduct: AnimatableImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
