//
//  OrderHistoryVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 13/06/24.
//

import UIKit

class OrderHistoryVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let customTransitioningDelegate = CustomTransitioningDelegate()
    var sort_by = "date"
    var sort_value = "desc"
    
    var viewModel : OrderHistoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = OrderHistoryViewModel()
        self.viewModel?.view = self
        self.viewModel?.callGetOrderList()
        self.setupTableView()
    }
    
    func setupTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "OrderHistoryXIB", bundle: nil), forCellReuseIdentifier: "OrderHistoryXIB")
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func filterOnPress(_ sender: UIButton) {
        let viewController = ShortByViewController.instantiate(fromStoryboard: .Main)
        viewController.sort_by = self.sort_by
        viewController.sort_value = self.sort_value
        viewController.shortByDeleget = self
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = customTransitioningDelegate
        self.present(viewController, animated: true, completion: nil)
    }
    
}

extension OrderHistoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.modelData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryXIB", for: indexPath) as! OrderHistoryXIB
        let indexData = self.viewModel?.modelData[indexPath.row]
        cell.imgPost.setImageFast(with: indexData?.product?.images?.first?.image ?? "")
        
        cell.lblSellerName.text = indexData?.sellerDetails?.name ?? ""
        cell.imgSeller.setImageFast(with: indexData?.sellerDetails?.image ?? "")
        
        cell.lblSize.text = "\(indexData?.product?.sizes?.first ?? "") . $\(indexData?.product?.price ?? "")"
        cell.lblName.text = indexData?.product?.title ?? ""
        cell.lblStatus.text = indexData?.oderDetails?.status ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = OrderProductDetailsVC.instantiate(fromStoryboard: .Sell)
        vc.orderID = self.viewModel?.modelData[indexPath.row].oderDetails?.id ?? 0
        debugPrint(self.viewModel?.modelData[indexPath.row].oderDetails?.type_of_order)
        vc.isShip = self.viewModel?.modelData[indexPath.row].oderDetails?.type_of_order ?? "" == "1" ? true : false
        self.pushViewController(vc: vc)
    }
}

extension OrderHistoryVC : ShortByDelegate{
    
    func selectShortBy(sort_by: String, sort_value: String) {
        self.sort_by = sort_by
        self.sort_value = sort_value
        
    }
}
