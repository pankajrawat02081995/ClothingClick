//
//  OrderHistoryXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/06/24.
//

import UIKit
import IBAnimatable

class OrderHistoryXIB: UITableViewCell {

    @IBOutlet weak var imgTruck: UIImageView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var imgSeller: UIImageView!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPost: AnimatableImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
