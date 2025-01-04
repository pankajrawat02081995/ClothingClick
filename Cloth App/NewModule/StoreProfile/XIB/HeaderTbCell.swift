//
//  HeaderTbCell.swift
//  SearchVC
//
//  Created by Pankaj Rawat on 03/09/24.
//

import UIKit

class HeaderTbCell: UITableViewCell {

    @IBOutlet weak var lblSelling: UILabel!
    @IBOutlet weak var sellingBottomLine: UIView!
    @IBOutlet weak var btnSelling: UIButton!
    @IBOutlet weak var soldBottomLine: UIView!
    @IBOutlet weak var lblSold: UILabel!
    @IBOutlet weak var btnSold: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
