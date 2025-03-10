//
//  PopulerBrandVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 23/06/24.
//

import UIKit

class PopulerBrandVC: UIViewController {

    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var titleStr = ""
    var typeId = ""
    var currentPage = 1
    var hasMorePages = false
    var postList = [Posts?]()
    var isShowFilter : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.lblTitle.text = self.titleStr
        self.lblHeaderTitle.text = self.titleStr
        
        self.callHomeListDetails(isShowHud: true, listType: typeId, page: "\(self.currentPage)")
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "UserProfileListXIB", bundle: nil), forCellReuseIdentifier: "UserProfileListXIB")
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    

}

extension PopulerBrandVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let objet = self.postList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileListXIB", for: indexPath) as! UserProfileListXIB
        cell.imgUser.contentMode = .scaleAspectFit
        cell.imgUser.setImageFast(with: objet?.user_image ?? "")
        
        if let name = objet?.name {
            cell.lblName.text = name.capitalized
        }
        if let total_post = objet?.total_post{
            cell.lblFollowerCount.text = "\(total_post)" + "\(total_post > 1 ? " Listings" : " Listing")"
        }
        if let total_post = objet?.total_posts{
            cell.lblFollowerCount.text = "\(total_post)" + "\((Int(total_post) ?? 0) > 1 ? " Listings" : " Listing")"
        }
        
        cell.lblFollowerCount.textColor = .customBlack
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.postList.count - 1 && hasMorePages == true {
            self.currentPage = self.currentPage + 1
            self.callHomeListDetails(isShowHud: false, listType: self.typeId, page: "\(self.currentPage)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.typeId == "6" {
            let vc = StoreProfileVC.instantiate(fromStoryboard: .Store)
            vc.viewModel.userID = "\(self.postList[indexPath.item]?.id ?? 0)"
            self.pushViewController(vc: vc)
        }
        else {
            let vc = AllProductViewController.instantiate(fromStoryboard: .Main)
            
            vc.BarndName = "\(postList[indexPath.item]?.name ?? "")"
            vc.titleStr = "\(postList[indexPath.item]?.name ?? "")"
            vc.selectGenderId = ""
            vc.selectBrandId = String(postList[indexPath.item]?.id ?? 0)
            FilterSingleton.share.filter = Filters()
            FilterSingleton.share.selectedFilter = FiltersSelectedData()
            FilterSingleton.share.filter.is_mysize = "1"
            FilterSingleton.share.selectedFilter.is_mysize = "1"
            FilterSingleton.share.filter.brand_id = String(postList[indexPath.item]?.id ?? 0)
            FilterSingleton.share.selectedFilter.brand_id = "\(postList[indexPath.item]?.name ?? "")"
            self.pushViewController(vc: vc)
        }
    }
}

extension PopulerBrandVC{
    func callHomeListDetails(isShowHud : Bool,listType :String, page: String) {
//        let param = ["list_type":  listType,
//                     "page": self.currentPage
//        ] as [String : Any]
        var param = FilterSingleton.share.filter.toDictionary()
        param?.removeValue(forKey: "is_only_count")
        param?.removeValue(forKey: "notification_item_counter")
        param?["page"] = "\(self.currentPage)"
        param?["list_type"] = listType
        param?.removeValue(forKey: "slectedCategories")
        param?.removeValue(forKey: "categories")
        
        if appDelegate.reachable.connection != .none {
            APIManager().apiCall(of: HomeListDetailsModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.HOME_LIST_POSTLIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            if self.currentPage == 1 {
                                self.postList.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages{
//                                if hasMorePages == 1 {
                                    self.hasMorePages = hasMorePages
//                                }
//                                else {
//                                    self.hasMorePages = false
//                                }
                            }
                            if let post = data.posts {
                                for temp in post {
                                    self.postList.append(temp)
                                }
                            }
                        }
                        
                        self.tableView.setBackGroundLabel(count: self.postList.count)
                        self.tableView.reloadData()
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                }
            }
        }
    }
}
