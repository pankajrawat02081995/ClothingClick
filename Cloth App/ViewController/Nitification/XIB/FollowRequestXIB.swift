//
//  FollowRequestXIB.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 11/07/24.
//

import UIKit
import IBAnimatable
class FollowRequestXIB: UITableViewCell {

    @IBOutlet weak var btnDelete: AnimatableButton!
    @IBOutlet weak var btnConfirm: AnimatableButton!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUser: CustomImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
