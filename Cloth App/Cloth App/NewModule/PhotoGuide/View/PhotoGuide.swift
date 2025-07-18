//
//  PhotoGuide.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 02/06/24.
//

import UIKit

class PhotoGuide: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func action_btnGotIt(_ sender: UIButton) {
        self.popViewController()
    }
    
}
