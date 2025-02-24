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
    func updateUserName(){
        var dictGeneral = [String:Any]()
        var address = [[String:Any]]()
        dictGeneral["name"] = appDelegate.userDetails?.name ?? ""
        dictGeneral["email"] = appDelegate.userDetails?.email ?? ""
        dictGeneral["username"] = self.txtUserName.text ?? ""
        dictGeneral["phone"] = appDelegate.userDetails?.phone ?? ""
        dictGeneral["country_code"] = appDelegate.userDetails?.country_code ?? ""
        dictGeneral["country_prefix"] = appDelegate.userDetails?.country_prefix ?? ""
        for i in appDelegate.userDetails?.locations ?? []{
            var dict = [String:Any]()
            dict["id"] = "\(i.id ?? 0)"
            dict["address"] = "\(i.address ?? "")"
            dict["postal_code"] = "\(i.postal_code ?? "")"
            dict["latitude"] = "\(i.latitude ?? "")"
            dict["longitude"] = "\(i.longitude ?? "")"
            dict["city"] = "\(i.city ?? "")"
            dict["area"] = "\(i.area ?? "")"
            address.append(dict)
            print(address)
            dictGeneral["locations"] = self.json(from: address)
            
            APIManager().apiCall(of: UserDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.UPDATE_PROFILE.rawValue, method: .post, parameters: dictGeneral) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let userDetails = response.dictData {
                            self.saveUserDetails(userDetails: userDetails)
                            self.dismiss(animated: true){
                                self.isLoginDone?()
                            }
                        }else{
                            self.dismiss(animated: true)
                        }
                        
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
            
        }
    }
}
