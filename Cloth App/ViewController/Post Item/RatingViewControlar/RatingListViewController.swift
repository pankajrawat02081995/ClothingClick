//
//  RatingListViewController.swift
//  Cloth App
//
//  Created by Apple on 13/07/21.
//

import UIKit

class RatingListViewController: BaseViewController {

    @IBOutlet weak var lblNoDeta: UILabel!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var CVCategory: UICollectionView!
    @IBOutlet weak var tblReviews: UITableView!
    
    var reviewData : ReviewsListModel?
    var selIndexForCVCategory = 0
    var tabs = [Tabs?]()
    var tabId = ""
    var userId = ""
    var currentPage = 1
    var hasMorePages = false
    var reviews = [Reviews]()
    var categoryList = ["Purchased","Sold"]
    var userName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblHeaderTitle.text = self.userName ?? ""
        self.lblNoDeta.isHidden = true
        for i in 0..<self.categoryList.count {
            let json = ["type" : i + 1,
                          "name" : self.categoryList[i]
            ] as [String : Any]
            let objet = Tabs.init(JSON: json)
            self.tabs.append(objet)
            self.callGetReviews(userId: self.userId, tabId: "1", page: "\(self.currentPage)")
        }
        
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tblReviews.dataSource = self
        self.tblReviews.delegate = self
        self.tblReviews.register(UINib(nibName: "ReviewXIB", bundle: nil), forCellReuseIdentifier: "ReviewXIB")
        self.tblReviews.tableFooterView = UIView()
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
}

extension RatingListViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let objet = self.tabs[indexPath.item]
        if self.selIndexForCVCategory == indexPath.item {
            cell.lblcategory.text = objet?.name
//            cell.lblcategory.textColor = UIColor.customBlack
//            cell.lblcategoryCount.textColor = UIColor.black
            cell.viewLine.isHidden = false
            cell.viewLine.backgroundColor = .customBlack
            cell.lblcategory.font = .RobotoFont(.robotoBold, size: 16)
        }
        else{
            cell.lblcategory.textColor = UIColor.customBlack
            cell.lblcategory.font = .RobotoFont(.robotoRegular, size: 16)
//            cell.lblcategoryCount.textColor = UIColor.init(named: "DarkGrayColor")
            cell.viewLine.isHidden = false
            cell.viewLine.backgroundColor = .customBorderColor
            cell.lblcategory.text = objet?.name
        }
        if objet?.name == "Purchased"{
            cell.lblcategory.text = "Purchased (\(self.reviewData?.total_buyer_review ?? 0))"
        }
        else {
            cell.lblcategory.text = "Sold (\(self.reviewData?.total_seller_review ?? 0))"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = self.tabs[indexPath.item]
        self.selIndexForCVCategory = indexPath.item
        self.tabId = String(object?.type ?? 0)
        self.callGetReviews(userId: self.userId, tabId: self.tabId, page: "\(self.currentPage)")

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.reviews.count - 1 && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callGetReviews(userId: self.userId, tabId: self.tabId, page: "\(self.currentPage)")
        }
    }
}

extension RatingListViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }
      
      fileprivate var itemsPerRow: CGFloat {
          return 2
      }
      
      fileprivate var interitemSpace: CGFloat {
            return 0.0
      }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 50)

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


extension RatingListViewController: UITableViewDelegate,UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewXIB", for: indexPath) as! ReviewXIB
        let object = self.reviews[indexPath.row]
        cell.lblDesc.text = object.review ?? ""
        cell.rateView.rating = Double(object.rating ?? 0)
        cell.lblTitle.text = object.review_by_name ?? ""
        
                        let date = self.convertWebStringToDate(strDate: object.created_at ?? "").toLocalTime()

        cell.lblTime.text = Date().offset(from: date)
        cell.imgProduct.setImageFast(with: object.photo?.first?.image ?? "")
        
//        if object.rating == 5 {
//            cell.imgLikeDislik.image = UIImage.init(named: "thumbs-Up-Unsel")
//            if let datetiem = object.created_at{
//                let date = self.convertWebStringToDate(strDate: datetiem).toLocalTime()
//                cell.lblDate.text  = Date().offset(from: date)
//            }
//            if let review = object.review {
//                cell.lblDiscri.text = review
//            }
//            if let reviewbyname = object.review_by_name {
//                cell.lblName.text = reviewbyname
//            }
//        }
//        else {
//            cell.imgLikeDislik.image = UIImage.init(named: "thumbs-Down-Unsel")
//            if let datetiem = object.created_at{
//                let date = self.convertWebStringToDate(strDate: datetiem).toLocalTime()
//                cell.lblDate.text  = Date().offset(from: date)
//            }
//            if let review = object.review {
//                cell.lblDiscri.text = review
//            }
//            if let reviewbyname = object.review_by_name {
//                cell.lblName.text = reviewbyname
//            }
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == self.reviews.count - 1 && hasMorePages == true {
            currentPage = self.currentPage + 1
            self.callGetReviews(userId: String(appDelegate.userDetails?.id ?? 0), tabId: self.tabId, page: "\(self.currentPage)")
        }
    }
}

class FlotratingCell: UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDiscri: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgLikeDislik: UIImageView!
}

extension RatingListViewController {
    func callGetReviews(userId : String,tabId : String,page : String) {
        if appDelegate.reachable.connection != .none {
            let param = ["user_id":  userId,
                         "type" : tabId,
                         "page" : page
            ]
            APIManager().apiCall(of:ReviewsListModel.self, isShowHud: false, URL: BASE_URL, apiName: APINAME.REVIEWS_LIST.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        if let data = response.dictData {
                            self.reviewData = data
                            if self.currentPage == 1 {
                                self.reviews.removeAll()
                            }
                            if let hasMorePages = data.hasMorePages{
                                self.hasMorePages = hasMorePages
                            }
                            if let reviews = data.reviews {
                                for temp in reviews {
                                    self.reviews.append(temp)
                                }
                            }
                            if self.reviews.count == 0 {
                                self.lblNoDeta.isHidden = false
                            }
                            else {
                                self.lblNoDeta.isHidden = true
                            }
                            self.CVCategory.reloadData()
                            self.tblReviews.reloadData()
                        }
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
