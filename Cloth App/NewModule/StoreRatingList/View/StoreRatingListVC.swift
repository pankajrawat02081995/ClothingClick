//
//  StoreRatingListVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 27/04/25.
//

import UIKit
import IBAnimatable

class StoreRatingListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var rateView: AnimatableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableVew()
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
//        let viewController = NewRatingViewController.instantiate(fromStoryboard: .Setting)
//        //        viewController.userId = "\(object.seller_id ?? 0)"
//        //        viewController.postId = "\(object.post_id ?? 0)"
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension StoreRatingListVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewXIB", for: indexPath) as! ReviewXIB
        return cell
    }
    
}
