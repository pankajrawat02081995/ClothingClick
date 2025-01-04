//
//  SuccessfullySignupViewController.swift
//  ClothApp
//
//  Created by Apple on 15/12/20.
//  Copyright © 2020 YellowPanther. All rights reserved.
//

import UIKit

class SuccessfullySignupViewController: BaseViewController {

    @IBOutlet weak var imgSuccessRegister: UIImageView!
    @IBOutlet weak var lblAlmostThere: UILabel!
    @IBOutlet weak var lblEmailSent: UILabel!
    @IBOutlet weak var btnLogin: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnLogin_clicked(_ sender: Any) {
        self.navigateToLoginScreen()
    }
}
