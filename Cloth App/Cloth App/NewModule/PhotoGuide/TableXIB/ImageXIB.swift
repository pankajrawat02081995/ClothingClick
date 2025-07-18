//
//  ImageXIB.swift
//  Demo
//
//  Created by Bhoomi on 01/06/24.
//

import UIKit

class ImageXIB: UITableViewCell {
 
    @IBOutlet weak var cellImageView: UIImageView!
     @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     }
    
    func configureImageViewWidth(width: CGFloat) {
           imageViewWidthConstraint.constant = width
           layoutIfNeeded()
       }
}
