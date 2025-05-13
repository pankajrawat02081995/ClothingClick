//
//  RatePopup.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/05/25.
//

import UIKit

class RatePopup: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func skipOnPress(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func rateOnPress(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "isRate")
        self.dismiss(animated: true){
            let appId = "1605715607" // your app ID
            if let url = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review") {
                UIApplication.shared.open(url)
            }

        }
    }
    
}
