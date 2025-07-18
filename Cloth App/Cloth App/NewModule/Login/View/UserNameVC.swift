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
    var userName : String?
    var isLoginDone : (()-> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtUserName.text = self.userName ?? ""
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.dismiss(animated: true){
            self.isLoginDone?()
        }
    }
    
    @IBAction func saveOnPress(_ sender: UIButton) {
        self.updateUserName()
    }
    
}

extension UserNameVC{
    func updateUserName() {
        guard let userDetails = appDelegate.userDetails else {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "User details not available")
            return
        }

        var dictGeneral = [String: Any]()
        dictGeneral["name"] = userDetails.name ?? ""
        dictGeneral["email"] = userDetails.email ?? ""
        dictGeneral["username"] = txtUserName.text ?? ""
        dictGeneral["phone"] = userDetails.phone ?? ""
        dictGeneral["country_code"] = userDetails.country_code ?? ""
        dictGeneral["country_prefix"] = userDetails.country_prefix ?? ""

        var addressArray = [[String: Any]]()
        for location in userDetails.locations ?? [] {
            let addressDict: [String: Any] = [
                "id": "\(location.id ?? 0)",
                "address": location.address ?? "",
                "postal_code": location.postal_code ?? "",
                "latitude": location.latitude ?? "",
                "longitude": location.longitude ?? "",
                "city": location.city ?? "",
                "area": location.area ?? ""
            ]
            addressArray.append(addressDict)
        }

        dictGeneral["locations"] = json(from: addressArray)

        APIManager().apiCall(
            of: UserDetailsModel.self,
            isShowHud: true,
            URL: BASE_URL,
            apiName: APINAME.UPDATE_PROFILE.rawValue,
            method: .post,
            parameters: dictGeneral
        ) { response, error in
            if let error = error {
                UIAlertController().alertViewWithTitleAndMessage(self, message: error.domain ?? ErrorMessage)
                return
            }

            if let response = response, let userDetails = response.dictData {
                self.saveUserDetails(userDetails: userDetails)
                self.dismiss(animated: true) {
                    self.isLoginDone?()
                }
            } else {
                self.dismiss(animated: true)
            }
        }
    }

}
