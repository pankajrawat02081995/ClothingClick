//
//  FaqVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 12/06/24.
//

import UIKit

class FaqVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = FaqViewModel()
    var selectedIndex = [Int]()
    var faqData = [["questions":"Q. Whats Clothing Clicks mission?","ans":"A. Clothing Click's mission is to positively transform the fashion industry for people and the planet. Our goal is to offer the community an easy-to-use platform for buying and selling fashion locally. We are committed to providing a space for you to earn money, save money, and contribute to sustainable fashion. "],["questions":"Q. Why choose Clothing Click","ans":"A. Clothing Click is a fashion-only marketplace optimized for both buyers and sellers. It’s a platform that eliminates shipping costs and waiting times by focusing on local transactions. We prioritize safety with phone number verification, accountability through social media links, and an in-app rating system, all within a completely free-to-use platform."],["questions":"Q. How do I sell my clothing on Clothing Click?","ans":"A. To sell on Clothing Click, create an account, select 'Sell', and follow our easy posting guide. After posting, your item becomes available to local shoppers. Interested buyers will reach out to you via an in-app chat, where you can negotiate the price and decide on a meeting location to complete your transaction."],["questions":"Q. How do transactions work?","ans":"A. After agreeing on price and meeting location, buyers and sellers can swap item and payment in person. We suggest secure payment methods, however, the final choice is yours."],["questions":"Q. How can I verify the trustworthiness of a user?","ans":"A. Examine the seller's profile for their ratings, reviews, and transaction history. You may additionally verify that the account is linked to a credible Facebook or Instagram profile for an additional layer of assurance."],["questions":"Q. Can I negotiate the price with sellers?","ans":"A. Yes, our app allows buyers and sellers to communicate directly, so you can discuss and negotiate prices."],["questions":"Q. How do I edit or delete my listing?","ans":"A. At this time, direct listing edits are not accommodated. However, it’s easy to remove a post by navigating to your account page, selecting your post, marking it as ‘Sold,’ and selecting 'Sold item elsewhere'. This action enables you to delete your post, allowing you to create a new one with the necessary updates."],["questions":"Q. What should I do if an item I received is not as described?","ans":"A. In the unfortunate event of a dispute, we request  that there is an initial attempt at resolution between the buyer and the seller. The responsibility for dispute resolution lies primarily with our users, who have come together in good faith. Should the matter remain unresolved, you are welcome to report the issue to us for further assistance."],["questions":"Q. Does Clothing Click offer shipping?","ans":"A. No, we do not provide shipping via the app. However, you may contact the seller for inquires with shipping on your own terms."]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    func setupTableView(){
        self.viewModel.view = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: "FaqXIB", bundle: nil), forCellReuseIdentifier: "FaqXIB")
        self.viewModel.getAllFaq()
    }
   
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
}


extension FaqVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaqXIB", for: indexPath) as! FaqXIB
        let indexData = self.viewModel.model[indexPath.row]
        cell.lblTitle.text = "Q. \(indexData.question ?? "")"
        if self.selectedIndex.contains(indexPath.row){
            cell.lblSubtitle.text = "A. \(indexData.answer ?? "")"
            cell.imgDropDown.image = UIImage(named: "ic_dropup")
        }else{
            cell.lblSubtitle.text = ""
            cell.imgDropDown.image = UIImage(named: "ic_dropdown")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectedIndex.contains(indexPath.row){
            let index = self.selectedIndex.firstIndex(of: indexPath.row) ?? 0
            self.selectedIndex.remove(at: index)
        }else{
            self.selectedIndex.append(indexPath.row)
        }
        self.tableView.reloadData()
    }
}
