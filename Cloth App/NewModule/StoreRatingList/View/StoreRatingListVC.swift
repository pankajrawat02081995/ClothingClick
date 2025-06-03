//
//  StoreRatingListVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 27/04/25.
//

import UIKit
import IBAnimatable

class StoreRatingListVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var rateView: AnimatableView!
    
    var viewModel : StoreRatingViewModel?
    var userId : String?
    var otherUserDetailsData : UserDetailsModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = StoreRatingViewModel(view: self)
        self.setupTableVew()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.callGetReviews(userId: userId ?? "")
    }
    
    func setupData(){
        lblStoreName.text = otherUserDetailsData?.name ?? ""
    }
    
    func setupTableVew(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "ReviewXIB", bundle: nil), forCellReuseIdentifier: "ReviewXIB")
        
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func leaveOnPress(_ sender: UIButton) {
        if appDelegate.userDetails == nil {
            self.showLogIn()
            return
        }
        let viewController = StoreRateVC.instantiate(fromStoryboard: .Store)
        viewController.otherUserDetailsData = self.otherUserDetailsData
        self.pushViewController(vc: viewController)
    }
    
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else { return }
        let index = imageView.tag

        guard
            let review = viewModel?.reviews[index],
            let imageUrl = review.photo?.first?.image,
            !imageUrl.isEmpty
        else {
            return
        }

        let imageData = ImagesVideoModel(JSON: [
            "type": "Image",
            "image": imageUrl
        ])

        guard let imageModel = imageData else { return }

        let viewController = PhotosViewController.instantiate(fromStoryboard: .Main)
        viewController.imagesList = [imageModel]
        viewController.visibleIndex = 0 // Only one image shown, so 0 is safe

        self.navigationController?.present(viewController, animated: true, completion: nil)
    }

    
}

extension StoreRatingListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.reviews.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewXIB", for: indexPath) as! ReviewXIB
        let object = self.viewModel?.reviews[indexPath.row]
        cell.lblDesc.text = object?.review ?? ""
        cell.rateView.rating = Double(object?.rating ?? 0)
        cell.rateView.isUserInteractionEnabled = false
        cell.lblTitle.text = object?.review_by_name ?? ""
        
        let date = self.convertWebStringToDate(strDate: object?.created_at ?? "").toLocalTime()

        cell.lblTime.text = Date().offset(from: date)
        cell.imgProduct.setImageFast(with: object?.photo?.first?.image ?? "")
        cell.imgProduct.contentMode = .scaleAspectFill
        
        cell.imgProduct.tag = indexPath.row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.imgProduct.isUserInteractionEnabled = true
        cell.imgProduct.addGestureRecognizer(tapGesture)
        return cell
    }
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.item == (self.viewModel?.reviews.count ?? 0) - 1 && self.viewModel?.hasMorePages == true {
            self.viewModel?.currentPage = (self.viewModel?.currentPage ?? 0) + 1
            viewModel?.callGetReviews(userId: userId ?? "")
        }
    }
}
