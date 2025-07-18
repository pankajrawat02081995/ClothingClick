//
//  PaymentMethodViewController.swift
//  ClothApp
//
//  Created by Apple on 09/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class PaymentMethodViewController: BaseViewController {

    
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var btnApplePay: CustomButton!
//    @IBOutlet weak var btnCreditCard: CustomButton!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//
//    @IBAction func btnApplePay_Clicked(_ button: UIButton) {}
//
//    @IBAction func btnCreditCard_Clicked(_ button: UIButton) {
//        let ViewController = self.storyboard?.instantiateViewController(identifier: "AddCreditCardViewController") as! AddCreditCardViewController
//        self.navigationController?.pushViewController(ViewController, animated: true)
//    }

        // MARK: - IBOutlets -
        @IBOutlet weak var headerView: UIView!
        @IBOutlet weak var lblHeaderTitle: UILabel!
        @IBOutlet weak var btnAddCard: UIButton!
        @IBOutlet weak var btnBack: UIButton!
        
        @IBOutlet weak var btnNext: CustomButton!

        @IBOutlet weak var tblCardList: UITableView!
        
        // MARK: - Variables -
        var cardList = [CreditCardModel]()
//        var selcard : CreditCardModel?
        var isFromAccountVC:Bool = false
        var isPremium = false
        var isBuyCoin = false
        var isSetting = false
        var isTrial = ""
        var coinId = ""
        var locationId = ""
        var selCardDictIndex = -1
        
        // MARK: - ViewController LifeCycle -
        override func viewDidLoad() {
            super.viewDidLoad()
            if self.isSetting {
                self.btnNext.isHidden = true
            }
            else{
                self.btnNext.isHidden = false
            }
            self.listAllCardAPI(isShowHud: true)
            
//            NotificationCenter.default.addObserver(self, selector: #selector(self.passCreditCardList(_:)), name: NSNotification.Name(rawValue: "passCreditCardList"), object: nil)

        }
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if self.isSetting {
                self.btnNext.isHidden = true
            }
            else{
                self.btnNext.isHidden = false
            }
            self.listAllCardAPI(isShowHud: false)
        }
        // handle notification
//        @objc func passCreditCardList(_ notification: NSNotification) {
//
//            if let arrCards = notification.userInfo?["arrCards"] as? [[String:Any]] {
//                self.cardList = arrCards
//                self.tblCardList.reloadData()
//            }
//        }
//        func setUpLocalizationText(){
//            self.lblHeaderTitle.text = "Manage Cards"
//            self.btnNext.setTitle(self.getLocalizeTextForKey(keyName: "Next"), for: .normal)
//        }
        
        // MARK: - IBActions -
        @IBAction func btnAddCard(_ sender: Any) {
            let ViewController = self.storyboard?.instantiateViewController(identifier: "AddCreditCardViewController") as! AddCreditCardViewController
            self.navigationController?.pushViewController(ViewController, animated: true)
        }
    
        @IBAction func btnNext_Clicked(_ sender: Any) {
            if self.isPremium {
                if self.selCardDictIndex != -1 {
                    self.CallAddPremiumAPI(isShowHud: true, index: self.selCardDictIndex)
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Select a credit card"))
                }
                
            }
            else if self.isBuyCoin {
                if self.selCardDictIndex != -1 {
                    self.CallBuyCoinAPI(isShowHud: true, index: self.selCardDictIndex)
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Select a credit card"))
                }
            }
            else {
                if self.selCardDictIndex != -1 {
                    self.callPayLocation(isShowHud: true, index: self.selCardDictIndex)
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Select a credit card"))
                }
            }
//            if self.selCardDictIndex != -1 && !self.isFromAccountVC {
//                var dict = [String:Any]()
//                dict["selCardID"] = self.cardList[selCardDictIndex]["id"]
//                // post a notification
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "selectedCreditCardID"), object: nil, userInfo: dict)
//                self.navigationController?.popViewController(animated: true)
//            }
//            else{
//                UIAlertController().alertViewWithTitleAndMessage(self, message: self.getLocalizeTextForKey(keyName: "Validation_Select_Card"))
//            }
            
        }
    
}


// MARK: - TableView Delegate and DataSource -
extension PaymentMethodViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "manageCardCell") as! manageCardCell
        cell.lblPrimary.isHidden = true
        let ObjModel = self.cardList[indexPath.row]
        if let lastfourdigit = ObjModel.last_four {
            cell.lblCardNumber.text = "**** **** **** \(lastfourdigit)"
        }
        if let exp_year = ObjModel.exp_year {
            if let exp_mounth = ObjModel.exp_month {
                cell.lblDateExpire.text = "Expires : \(exp_mounth)/\(exp_year)"
            }
        }
//        if (dict["default_source"] as! String) == "Y"{
//            cell.lblPrimary.isHidden = false
//        }
//        else{
//            cell.lblPrimary.isHidden = true
//        }
        if self.isSetting {
            cell.imgViewDefaultCard.isHidden = true
        }
        else {
            cell.imgViewDefaultCard.isHidden = false
        }
        if self.selCardDictIndex == indexPath.row && !self.isSetting {
            cell.imgViewDefaultCard.image = UIImage(named: "radio_on")
        }
        else{
            cell.imgViewDefaultCard.image = UIImage(named: "radio_off")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            self.deleterCardAPI(isShowHud: true, index: indexPath.row)
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSetting {}
        else {
            self.selCardDictIndex = indexPath.row
            self.tblCardList.reloadData()
        }
        
//        self.selcard = self.cardList[indexPath.row]

//        if !self.isFromAccountVC {
//            self.tblCardList.reloadData()
//        }
//        else {
//            if (self.cardList[selCardDictIndex]["default_source"] as! String) == "N"{
//                let refreshAlert = UIAlertController(title: AlertViewTitle, message: self.getLocalizeTextForKey(keyName: "Message_Primary_Card"), preferredStyle: UIAlertController.Style.alert)
//
//                refreshAlert.addAction(UIAlertAction(title: self.getLocalizeTextForKey(keyName: "btn_Ok"), style: .default, handler: { (action: UIAlertAction!) in
//                    self.defaultCardAPI(isShowHud: true, index: indexPath.row)
//                }))
//
//                refreshAlert.addAction(UIAlertAction(title: self.getLocalizeTextForKey(keyName: "btn_Cancel"), style: .cancel, handler: { (action: UIAlertAction!) in
//                }))
//
//                present(refreshAlert, animated: true, completion: nil)
//            }
//        }
        
    }
}

// MARK: - API Method -
extension PaymentMethodViewController {
    func listAllCardAPI(isShowHud: Bool) {
        if appDelegate.reachable.connection != .none {
            
            APIManager().apiCall(of:CreditCardModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.PAYMENT_METHOD.rawValue, method: .get, parameters: [:]) { (response, error) in
//            APIManager().apiCall(isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.LISTALLCARD.rawValue, method: .post, parameters: [:]) { (response, error) in
                if error == nil {

                    let responseData = response

                    if let data = responseData?.arrayData {
                        self.cardList = data
                    }
                    self.tblCardList.reloadData()

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
    
    func deleterCardAPI(isShowHud: Bool,index:Int) {
        if appDelegate.reachable.connection != .none {

            let param = ["card_id": self.cardList[index].id] as [String : Any]

            APIManager().apiCall(of:CreditCardModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.PAYMENT_METHOD_DELETE.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {

                    let responseData = response

                    if let message = responseData?.message {
                        print(message)
                        UIAlertController().alertViewWithTitleAndMessage(self, message: message)
                        self.cardList.remove(at: index)
                        self.tblCardList.reloadData()
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
    func defaultCardAPI(isShowHud: Bool,index:Int) {
//        if appDelegate.reachable.connection != .none {
//
//            let param = ["card_id": self.cardList[index]["id"]!] as [String : Any]
//
//            APIManager().apiCall(isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.DEFAULTCARD.rawValue, method: .post, parameters: param) { (response, error) in
//                if error == nil {
//
//                    let responseData = response as! [String : Any]
//
//                    if let data = responseData[kData] as? [[String : Any]] {
//
//                        self.cardList = data
//
//                        self.tblCardList.reloadData()
//                    }
//
//                    if let message = responseData[kMessage] as? String {
//                        UIAlertController().alertViewWithTitleAndMessage(self, message: message)
//                    }
//
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
//                }
//            }
//        }
//        else {
//            UIAlertController().alertViewWithNoInternet(self)
//        }
    }
    func CallAddPremiumAPI(isShowHud: Bool,index:Int) {
        if appDelegate.reachable.connection != .none {

            let param = ["card_id": self.cardList[index].id ?? 0,
                         "is_trial" : self.isTrial ] as [String : Any]

            APIManager().apiCall(of:CreditCardModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.PREMIUM_BUY.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {

                    self.navigateToHomeScreen(selIndex: 4)
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
    func CallBuyCoinAPI(isShowHud: Bool,index:Int) {
        if appDelegate.reachable.connection != .none {

            let param = ["card_id": self.cardList[index].id ?? 0,
                         "coin_id" : self.coinId ] as [String : Any]

            APIManager().apiCall(of:CreditCardModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.COINS_BUY.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.navigateToHomeScreen(selIndex: 4)
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
    
    func callPayLocation(isShowHud: Bool,index:Int) {
        if appDelegate.reachable.connection != .none {
            
            let param = ["card_id": self.cardList[index].id ?? 0,
                         "location_id" : self.locationId ] as [String : Any]
//            APIManager().apiCallWithMultipart(of: UserDetailsModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.LOCATION_PAY.rawValue, parameters: param) { (response, error) in
                APIManager().apiCall(of:CreditCardModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.LOCATION_PAY.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    self.navigationController?.popViewController(animated: true)
//                    if let userDetails = response?.dictData {
//                        self.addressList.removeAll()
//                        for i in 0..<userDetails.locations!.count {
//                            self.addressList.append(userDetails.locations?[i])
//                        }
//                        self.saveUserDetails(userDetails: userDetails)
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//                        self.setDefaultLocation()
//                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}

// MARK: - TableViewCell -
class manageCardCell: UITableViewCell {
    
    @IBOutlet weak var cellView: CustomView!
    @IBOutlet weak var imgVisa: UIImageView!
    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var imgViewDefaultCard: UIImageView!
    @IBOutlet weak var lblDateExpire: UILabel!
    @IBOutlet weak var lblPrimary: UILabel!
    
}
