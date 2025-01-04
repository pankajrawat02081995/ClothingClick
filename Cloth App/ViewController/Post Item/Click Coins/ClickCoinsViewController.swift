//
//  ClickCoinsViewController.swift
//  ClothApp
//
//  Created by Apple on 19/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

class ClickCoinsViewController: BaseViewController {
    
    @IBOutlet weak var lblCoinCount: UILabel!
    @IBOutlet weak var btnFreeTrial: UIButton!
    @IBOutlet weak var CVCoin: UICollectionView!
    @IBOutlet weak var constHightForCVCoin: NSLayoutConstraint!
    @IBOutlet weak var tblEarnClickCoins: UITableView!
    @IBOutlet weak var constHightFortblEarnClickCoins: NSLayoutConstraint!
    
    @IBOutlet weak var btnCoin: UIButton!
    
    @IBOutlet weak var viewTrial: UIView!
    @IBOutlet weak var lblTrialMessage: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnTrialViewHide: UIButton!
    @IBOutlet weak var btnStartFreeTrial: CustomButton!
    
    var coinInfoData : EarnCoinModel?
    var earnCoinsInfo = [Earn_coin_info]()
    var coinsList = [CoinsInfo]()
    var userCoin = ""
    var fromPushNotification:Bool = false
    var openpremium:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblCoinCount.text = "\(String(describing: appDelegate.userDetails?.coins ?? 0))"
        self.viewTrial.isHidden = true
        let image = UIImage(named: "close_ic_white")?.imageWithColor(color1: UIColor.init(hex: "000000"))
        self.btnClose.setImage(image, for: .normal)
        self.callEarnCoinsInfoList()
        
        if self.openpremium == true{
            self.btnFreeTrial_Clicked(self)
        }
        
        if appDelegate.userDetails?.is_premium_user == 1 {
            if let date = appDelegate.userDetails?.premium_end_at {
                let Date = self.convertStringToDate(format: dateFormateForDisplayForPremun, strDate: date)
                let strDate = self.convertDateToString(format: dateFormateForDisplayForPremun, date: Date)
                self.btnFreeTrial.titleLabel?.textAlignment = .center
                self.btnFreeTrial.setTitle("You premium plan expire on \n\(strDate)", for: .normal)
            }
        }
        else
        {
            if appDelegate.userDetails?.is_premium_activated == 0 {
                if let freeDay = self.coinInfoData?.pREMIUM_FREE_TRAIL_DAYS {
                    self.btnFreeTrial.setTitle("\(freeDay ) day free premium trial", for: .normal)
                }
            }
            else {
                self.btnFreeTrial.setTitle("By premium", for: .normal)
            }
        }
    }
//    view
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.CVCoin.reloadData()
//        self.CVCoin.layoutIfNeeded()
//        self.constHightForCVCoin.constant = self.CVCoin.contentSize.height
//        self.tblEarnClickCoins.reloadData()
//        self.tblEarnClickCoins.layoutIfNeeded()
//        self.constHightFortblEarnClickCoins.constant = self.tblEarnClickCoins.contentSize.height
//    }
    
    @IBAction func btnFreeTrial_Clicked(_ sender: Any) {
        
        self.lblTrialMessage.text = "Upgrade to premium for only $ \(self.coinInfoData?.pREMIUM_PRICE ?? 0)/month"
        if appDelegate.userDetails?.is_premium_activated == 0 {
            if let freeDay = self.coinInfoData?.pREMIUM_FREE_TRAIL_DAYS {
                self.btnStartFreeTrial.setTitle("\(freeDay ) day free premium trial", for: .normal)
            }
            self.viewTrial.isHidden = false
        }
        else {
            self.btnStartFreeTrial.setTitle("By premium", for: .normal)
        }
        
    }
    
    @IBAction func btnClose_Clicked(_ button: UIButton) {
        self.viewTrial.isHidden = true
    }
    
    @IBAction func btnStartFreeTrial_Clicked(_ button: UIButton) {
        if appDelegate.userDetails?.is_premium_user == 1 {
            if let strdate = appDelegate.userDetails?.premium_end_at {
                let date = convertStringToDate(format: dateFormateForGet, strDate: strdate)
                if date.timeIntervalSince1970 > Date().timeIntervalSince1970{
                    let strDate = self.convertStringToDate(format: dateFormateForDisplayForPremun, strDate: strdate)
                    self.btnFreeTrial.titleLabel?.textAlignment = .center
                    self.btnFreeTrial.setTitle("You premium plan expire on \n\(strDate)", for: .normal)
                }
                else {
                    if appDelegate.userDetails?.is_premium_activated == 0 {
                        if let freeDay = self.coinInfoData?.pREMIUM_FREE_TRAIL_DAYS {
                            self.btnFreeTrial.setTitle("\(freeDay ) day free premium trial", for: .normal)
                        }
                        let viewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
                        viewController.isPremium = true
                        viewController.isTrial = "\(0)"
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                    else {
                        self.btnFreeTrial.setTitle("By premium", for: .normal)
                        let viewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
                        viewController.isPremium = true
                        viewController.isTrial = "\(1)"
                        self.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
            }
        }
        else
        {
            if appDelegate.userDetails?.is_premium_activated == 0 {
                if let freeDay = self.coinInfoData?.pREMIUM_FREE_TRAIL_DAYS {
                    self.btnFreeTrial.setTitle("\(freeDay ) day free premium trial", for: .normal)
                }
                let viewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
                viewController.isPremium = true
                viewController.isTrial = "\(0)"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            else {
                self.btnFreeTrial.setTitle("By premium", for: .normal)
                let viewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
                viewController.isPremium = true
                viewController.isTrial = "\(1)"
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        if appDelegate.userDetails?.is_premium_activated == 0 {
            self.btnStartFreeTrial.setTitle("By premium", for: .normal)
            
        }
        else
        {
            if let date = appDelegate.userDetails?.premium_end_at {
                let strDate = self.convertStringToDate(format: dateFormateForDisplayForPremun, strDate: date)
                self.btnStartFreeTrial.titleLabel?.textAlignment = .center
                self.btnStartFreeTrial.setTitle("You premium plan expire on \(strDate)", for: .normal)
            }
            self.viewTrial.isHidden = true
        }
    }
    
    @IBAction func btnTrialViewHide_Clicked(_ button: UIButton) {
        self.viewTrial.isHidden = true
    }
    @IBAction func onBtnBack_Clicked(_ sender: Any) {
        if fromPushNotification == false{
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
        }else{
            self.navigateToHomeScreen()
        }
    }
}

extension ClickCoinsViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.coinsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinImagesCell", for: indexPath) as! CoinImagesCell
        let object = self.coinsList[indexPath.item]
        cell.lblHowManyCoin.text = object.name
        if let url = object.photo {
            if let image = URL.init(string: url){
                cell.imgCoin.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
        
        if let prise = object.price {
            cell.lblCoinPeice.text = "$ \( String(format: "%.2f", prise))"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "PaymentMethodViewController") as! PaymentMethodViewController
        viewController.isBuyCoin = true
        viewController.coinId = "\(String(describing: self.coinsList[indexPath.item].id ?? 0))"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ClickCoinsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earnCoinsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EarnClickCoinsCell", for: indexPath) as! EarnClickCoinsCell
        let object = earnCoinsInfo[indexPath.row]
        cell.lblEarnCoinTitle.text = object.title
        cell.lblEarnCoinCount.text = "\(object.price ?? 0)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let viewController = self.storyboard?.instantiateViewController(identifier: "PromoteViewController") as! PromoteViewController
                self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

class EarnClickCoinsCell : UITableViewCell {
    @IBOutlet weak var lblEarnCoinTitle: UILabel!
    @IBOutlet weak var lblEarnCoinCount: UILabel!
}
class CoinImagesCell : UICollectionViewCell {
    @IBOutlet weak var lblHowManyCoin: UILabel!
    @IBOutlet weak var lblCoinPeice: UILabel!
    @IBOutlet weak var imgCoin: UIImageView!
}

extension ClickCoinsViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
                            indexPath: IndexPath) -> CGSize {
        let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
        let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
        let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interitemSpace
    }
}

extension ClickCoinsViewController {
    func callEarnCoinsInfoList() {
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: EarnCoinModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.EARN_COINS_INFO.rawValue, method: .post, parameters: [:]) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.coinInfoData = data
                            self.earnCoinsInfo = (self.coinInfoData?.earn_coin_info)!
                            self.coinsList = (self.coinInfoData?.coins!)!
                            //                            if let freeDay = self.coinInfoData?.pREMIUM_FREE_TRAIL_DAYS {
                            //                                self.btnFreeTrial.setTitle("\(freeDay ) day free premium trial", for: .normal)
                            //                            }
//                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                self.CVCoin.reloadData()
                                self.CVCoin.layoutIfNeeded()
                                self.constHightForCVCoin.constant = self.CVCoin.contentSize.height
//                            })
//                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                                self.tblEarnClickCoins.reloadData()
                                self.tblEarnClickCoins.layoutIfNeeded()
                                self.constHightFortblEarnClickCoins.constant = self.tblEarnClickCoins.contentSize.height + 100
//                            })`
                            
                        }
                        
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
//    func callPrimunUser() {
//        if appDelegate.reachable.connection != .none {
//            APIManager().apiCall(of: EarnCoinModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.EARN_COINS_INFO.rawValue, method: .post, parameters: [:]) { (response, error) in
//                if error == nil {
//                    if let response = response {
//                        if let data = response.dictData {
//                            //                            self.coinInfoData = data
//                            //                            self.earnCoinsInfo = (self.coinInfoData?.earn_coin_info)!
//                            //                            self.coinsList = (self.coinInfoData?.coins!)!
//                            //                            if let freeDay = self.coinInfoData?.pREMIUM_FREE_TRAIL_DAYS {
//                            //                                self.btnFreeTrial.setTitle("\(freeDay ) day free premium trial", for: .normal)
//                            //                            }
//                            //                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//                            //                                self.CVCoin.reloadData()
//                            //                                self.CVCoin.layoutIfNeeded()
//                            //                                self.constHightForCVCoin.constant = self.CVCoin.contentSize.height
//                            //                            })
//                            //                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
//                            //                                self.tblEarnClickCoins.reloadData()
//                            //                                self.tblEarnClickCoins.layoutIfNeeded()
//                            //                                self.constHightFortblEarnClickCoins.constant = self.tblEarnClickCoins.contentSize.height
//                            //                            })
//
//                        }
//
//                    }
//                }
//                else {
//                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
//                }
//            }
//        }
//    }
}
