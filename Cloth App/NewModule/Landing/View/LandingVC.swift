//
//  LandingVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 07/06/24.
//

import UIKit
import IBAnimatable

class LandingVC: BaseViewController {

    @IBOutlet weak var imgBranding: UIImageView!
    @IBOutlet weak var btnMenWear: AnimatableButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.callGeneralSettingWithAccessCodeScreenAPI()
    }

    @IBAction func menswearOnPress(_ sender: UIButton) {
//        let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
//        self.pushViewController(vc: vc)
        self.navigateToLoginScreen()
    }
    
    @IBAction func womenswearOnPress(_ sender: UIButton) {
//        let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
//        self.pushViewController(vc: vc)
        self.navigateToLoginScreen()
    }
    
    @IBAction func bothOnPress(_ sender: UIButton) {
        let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
        self.pushViewController(vc: vc)
        self.navigateToLoginScreen()
//        let vc = LoginVC.instantiate(fromStoryboard: .Auth)
//        self.present(vc, animated: true)
    }
}

extension LandingVC{
    func callGeneralSettingWithAccessCodeScreenAPI() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: GeneralSettingModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.GET_GENERAL_DATA.rawValue, method: .get, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let generalSettingDetails = response.dictData {
                            self.saveGeneralSetting(generalSetting: generalSettingDetails)
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}
