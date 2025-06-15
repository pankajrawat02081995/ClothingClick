//
//  FavouriteBrandSearchViewController.swift
//  ClothApp
//
//  Created by Apple on 13/05/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit

protocol FavouriteBrandSearchDelegate {
    func FavouriteBrandSearchAddd(brand: BrandeSearchModel )
}

class FavouriteBrandSearchViewController: BaseViewController {

    
    @IBOutlet weak var txtSearchBrand: CustomTextField!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnAddBrand: UIButton!
    @IBOutlet weak var tblBrand: UITableView!
    
    @IBOutlet weak var viewBrand: UIView!
    @IBOutlet weak var btnSaveBrand: UIButton!
    @IBOutlet weak var btnAddBrandImage: UIButton!
    @IBOutlet weak var txtBrandName: UITextField!
    @IBOutlet weak var imgBrand: UIImageView!
    var selectedImage: UIImage!
    let placeholder = "Search Brand"
    var  brandSearchList = [BrandeSearchModel?]()
    var brandmodel : BrandeSearchModel?
    var favouriteBrandDeleget : FavouriteBrandSearchDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtSearchBrand.placeholder = "Search Designers & Brand Names"
        self.txtSearchBrand.delegate = self
    }
    @IBAction func btnAddBrand_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.txtBrandName.text = self.txtSearchBrand.text
        self.viewBrand.isHidden = false
        
    }
    @IBAction func btnAddBrandCancel_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.txtBrandName.text = ""
        self.viewBrand.isHidden = true
        
    }
    @IBAction func btnSaveBrand_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.viewBrand.isHidden = true
        if self.txtBrandName.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter Brand Name")
        }else{
            self.callAddBrandName()
        }
        
    }
    @IBAction func btnAddBrandImage_Clicked(_ button: UIButton) {
        self.view.endEditing(true)
        self.showActionSheet()
    }
    @IBAction func btnCancle_clicked(_ sender: Any) {
        self.view.endEditing(true)
        self.txtBrandName.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.setAlertButtonColor()
        
        actionSheet.addAction(UIAlertAction(title: "Using Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Existing Photo", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.allowsEditing = false
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self //as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = false
        myPickerController.modalPresentationStyle = .overCurrentContext
        myPickerController.addStatusBarBackgroundView()
        myPickerController.view.tintColor = UIColor().alertButtonColor
        self.present(myPickerController, animated: true, completion: nil)
        
    }
}
extension FavouriteBrandSearchViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgBrand.image = image
            self.selectedImage = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension FavouriteBrandSearchViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.brandSearchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BrandsCell", for: indexPath) as! BrandsCell
        let objet = self.brandSearchList[indexPath.row]
        cell.lblBrandName.text = objet?.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bsrnds = self.brandSearchList[indexPath.row]
        if self.favouriteBrandDeleget != nil {
            self.favouriteBrandDeleget.FavouriteBrandSearchAddd(brand: bsrnds!)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}

extension FavouriteBrandSearchViewController {
    func callBrandSearchList(searchtext : String,isShowHud : Bool) {
            if appDelegate.reachable.connection != .none {
                let param = ["name": searchtext]
                APIManager().apiCall(of: BrandeSearchModel.self, isShowHud: isShowHud, URL: BASE_URL, apiName: APINAME.BRAND_SEARCH.rawValue, method: .post, parameters: param) { (response, error) in
                    if error == nil {
                        if let response = response {
                            if let data = response.arrayData {
                                self.brandSearchList = data
                                self.tblBrand.reloadData()
                            }
                        }
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

extension FavouriteBrandSearchViewController : UITextFieldDelegate {
    private func textFieldDidChangeSelection(_ textField: UITextView) {
        if self.txtSearchBrand.text == "" {
            self.txtSearchBrand.text = self.placeholder
        }
        else {
          
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        if textField == self.txtSearchBrand {
            
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString != "" && newString.length >= 2 {
                self.callBrandSearchList(searchtext: (newString) as String, isShowHud: false )
            }
            else {
                self.brandSearchList.removeAll()
                self.tblBrand.reloadData()
            }
            return true
        }
        else {
            return true
        }
    }
}

extension FavouriteBrandSearchViewController{
    func callAddBrandName() {
        if appDelegate.reachable.connection != .none {
            let param = ["name": self.txtBrandName.text! ]
           
            if self.selectedImage == nil {

                APIManager().apiCall(of: BrandeSearchModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.BRAND_ADD.rawValue, method: .post, parameters: param) { (response, error) in
                    if error == nil {
                        if let response = response {
                           if let dicdata = response.dictData{
                               self.brandmodel = dicdata
                            self.txtBrandName.text = ""
                            if self.favouriteBrandDeleget != nil {
                                self.favouriteBrandDeleget.FavouriteBrandSearchAddd(brand: self.brandmodel!)
                            }
                            self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
            else {
                APIManager().apiCallWithImage(of: BrandeSearchModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.BRAND_ADD.rawValue, parameters: param, images: [self.selectedImage], imageParameterName: "photo", imageName: "user.png"){  (response, error) in
                    if error == nil {
                        if let response = response {
                          if let dicdata = response.dictData{
                              self.brandmodel = dicdata
                            self.txtBrandName.text = ""
                            if self.favouriteBrandDeleget != nil {
                                self.favouriteBrandDeleget.FavouriteBrandSearchAddd(brand: self.brandmodel!)
                            }
                            self.dismiss(animated: true, completion: nil)
                            
                            }
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
            
        }
        else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
}
