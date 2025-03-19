//
//  ManageAccountViewController.swift
//  Cloth App
//
//  Created by Apple on 18/06/21.
//

import UIKit

class ManageAccountViewController: BaseViewController {

    @IBOutlet weak var tblUser: UITableView!
    
    var userList = [[String:Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if defaults.value(forKey: kLoginUserList) != nil {
            if let arr = defaults.value(forKey: kLoginUserList) as? [[String:Any]], arr.count > 0 {
                self.userList = arr
            }
        }
        self.tblUser.reloadData()
    }
    
}

extension ManageAccountViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageAccountCell", for: indexPath) as! ManageAccountCell
        
        let dict = self.userList[indexPath.row]
        if let name = dict["name"] as? String {
            cell.lblUserName.text = name
        }
        if let roleid = dict["role_id"] as? Int {
            if roleid == 1{
                cell.lblStoreName.text = "User"
            }else if roleid == 2{
                cell.lblStoreName.text = "Store"
            }else{
                cell.lblStoreName.text = "Brand"
            }
        }
        
        if let url = dict["photo"] as? String {
            cell.imgUser.setImageFast(with: url)
        }
        cell.btnRemove.isHidden = true
        cell.lblLoggedIn.isHidden = true
        if let id = dict["id"] as? Int, id == appDelegate.userDetails?.id {
            cell.btnRemove.isHidden = true
            cell.lblLoggedIn.isHidden = false
        }
        else{
            cell.btnRemove.isHidden = false
            cell.lblLoggedIn.isHidden = true
        }
        
        cell.btnRemove.addTarget(self, action: #selector(btnRemove_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func btnRemove_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.tblUser)
        if let indexPath = self.tblUser.indexPathForRow(at: buttonPosition) {
            self.userList.remove(at: indexPath.row)
            defaults.set(self.userList, forKey: kLoginUserList)
            defaults.synchronize()
            self.tblUser.reloadData()
        }
    }
}

class ManageAccountCell : UITableViewCell {
    @IBOutlet weak var imgUser: CustomImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblLoggedIn: UILabel!
    @IBOutlet weak var btnRemove: CustomButton!
}

