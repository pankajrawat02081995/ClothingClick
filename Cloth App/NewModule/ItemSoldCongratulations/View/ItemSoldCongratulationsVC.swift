//
//  ItemSoldCongratulationsVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 08/09/24.
//

import UIKit

class ItemSoldCongratulationsVC: BaseViewController {
    
    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSoldInTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var postId = ""
    var postDetal : Post?
    var userList = [User_list]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.SetupTableView()
        self.callGetItemSoldList(postId: self.postId)
    }
    
    func SetupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "UserListXIB", bundle: nil), forCellReuseIdentifier: "UserListXIB")
    }
    
    @IBAction func soldOnPress(_ sender: UIButton) {
        self.navigateToHomeScreen(selIndex: 4)
    }
    
}


extension ItemSoldCongratulationsVC{
    func callGetItemSoldList(postId : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["post_id":  postId
            ]
            APIManager().apiCall(of:ItemSlodListModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.POST_SOLD_USER_LIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.postDetal = data.post
                            
                            self.lblName.text = self.postDetal?.name ?? ""
                            self.lblPrice.text = "$\(self.postDetal?.price ?? 0)"
                            
                            if let url = self.postDetal?.photo?.first?.image{
                                if let image = URL.init(string: url){
                                    self.imgProduct?.kf.setImage(with: image,placeholder: PlaceHolderImage)
                                }
                            }
                            else{
                                self.imgProduct.setImage(PlaceHolderImage ?? UIImage())
                            }
                            
                            self.userList = data.user_list ?? []
                            if let itemSoldCount = data.total_sold_items {
                                //                                self.lblItemSoldCount.text = "\(itemSoldCount) Items Sold"
                            }
                        }
                        if self.userList.count == 0 {
                            //self.lblNodata.isHidden = false
                        }
                        else {
                            //self.lblNodata.isHidden = true
                        }
                        self.tableView.setBackGroundLabel(count: self.userList.count)
                        self.tableView.reloadData()
                        //                        self.constHightFortblItemSoldeUserLiset.constant = self.tblItemSoldeUserLiset.contentSize.height + 100
                    }
                }
                else {
                    BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: ErrorMessage)
                }
            }
        }
        else {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: NoInternet)
        }
    }
}

extension ItemSoldCongratulationsVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListXIB", for: indexPath) as! UserListXIB
        let object = self.userList[indexPath.row]
        if let url = object.photo{
            if let image = URL.init(string: url){
                cell.imgUser?.kf.setImage(with: image,placeholder: PlaceHolderImage)
            }
        }
        else{
            cell.imgUser.setImage(ProfileHolderImage!)
        }
        
        if let name = object.name {
            cell.lblName.text = name
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = NewRatingViewController.instantiate(fromStoryboard: .Setting)
        viewController.isBuyerSeller = true
        viewController.postId = "\(self.postDetal?.id ?? 0)"
        viewController.userId = "\(self.userList[indexPath.row].id ?? 0)"
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}
