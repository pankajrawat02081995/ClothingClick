//
//  UserNameVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/02/25.
//

import Foundation
import IBAnimatable

class UserNameVC: BaseViewController {

    @IBOutlet weak var txtUserName: AnimatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        self.dismiss(animated: true){
            
        }
    }
    
}
