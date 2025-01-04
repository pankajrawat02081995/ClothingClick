//
//  NewPasswordVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 17/06/24.
//

import UIKit
import IBAnimatable

class NewPasswordVC: UIViewController {

    @IBOutlet weak var btnNext: CustomButton!
    @IBOutlet weak var txtNewPassowrd: AnimatableTextField!
    @IBOutlet weak var txtConfirmPassword: AnimatableTextField!
    
    var viewModel = NewPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.view = self
    }
    
    @IBAction func eyeNewPasswordOnPress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtNewPassowrd.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func eyeConfirmPasswordOnPress(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtConfirmPassword.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }

    @IBAction func nextOnPress(_ sender: UIButton) {
        self.viewModel.callChangePassword()
    }
}
