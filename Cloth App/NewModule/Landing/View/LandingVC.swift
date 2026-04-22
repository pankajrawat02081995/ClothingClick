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
        let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
        vc.selectGengerIndex = 0
        appDelegate.selectGenderId = "0"
        FilterSingleton.share.genderSelection = 0
        self.pushViewController(vc: vc)
//        self.navigateToLoginScreen()
    }
    
    @IBAction func womenswearOnPress(_ sender: UIButton) {
        let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
        vc.selectGengerIndex = 1
        appDelegate.selectGenderId = "1"
        FilterSingleton.share.genderSelection = 1
        self.pushViewController(vc: vc)
//        self.navigateToLoginScreen()
    }
    
    @IBAction func bothOnPress(_ sender: UIButton) {
        let vc = ClothPreferencesViewController.instantiate(fromStoryboard: .Main)
        FilterSingleton.share.genderSelection = nil
        appDelegate.selectGenderId = ""
        self.pushViewController(vc: vc)
    }
}

extension LandingVC{
    func callGeneralSettingWithAccessCodeScreenAPI() {

        // Check network without touching UI
        guard appDelegate.reachable.connection != .none else {
            print("⚠️ No internet connection.")
            return
        }

        // Background thread—never blocks UI
        DispatchQueue.global(qos: .background).async { [weak self] in

            APIManager().apiCall(
                of: GeneralSettingModel.self,
                isShowHud: false,
                URL: BASE_URL,
                apiName: APINAME.GET_GENERAL_DATA.rawValue,
                method: .get,
                parameters: [:]
            ) { response, error in

                // Return to background to avoid UI operations
                DispatchQueue.global(qos: .background).async {

                    if let error = error {
                        print("❌ General settings API error → \(error.domain)")
                        return
                    }

                    guard
                        let general = response?.dictData,
                        let strongSelf = self
                    else {
                        print("⚠️ No data returned or VC deallocated.")
                        return
                    }

                    // Safe background save
                    strongSelf.saveGeneralSetting(generalSetting: general)

                    print("✅ General setting saved successfully.")
                }
            }
        }
    }

}
