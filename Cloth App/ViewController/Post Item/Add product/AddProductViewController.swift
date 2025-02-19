//
//  AddProductViewController.swift
//  ClothApp
//
//  Created by Apple on 15/04/21.
//  Copyright © 2021 YellowPanther. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import MobileCoreServices
import AVKit
import KRProgressHUD
import ObjectMapper

class AddProductViewController: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtBrandDesignerName: CustomTextField!
    @IBOutlet weak var txtModelTitle: CustomTextField!
    @IBOutlet weak var txtDescription: CustomTextView!
    @IBOutlet weak var btnSelectPrise: UIButton!
    @IBOutlet weak var txtFixedpricee: CustomTextField!
    @IBOutlet weak var txtCADPrice : CustomTextField!
    @IBOutlet weak var txtLocation : CustomTextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnPreview : CustomButton!
    @IBOutlet weak var btnPost: CustomButton!

    @IBOutlet weak var CVAddProductImage: UICollectionView!

    var savegenderId : CategoryModel?
    var selectSubcategory : ChildCategories?
    var selectCategory : Categorie?
    var priceList = [Price_types?]()
    var addresslist = [Locations?]()
    var selectAddress = [Locations?]()
    var addressIdLIst = [String]()
    var brandSearchList : BrandeSearchModel?
    var selectSize : Size?
    var selectCondiction : Conditions?
    var selectColor = [Colors?]()
    var priceId = "1"
    var Producturl = ""
    var postImageVideo = [ImagesVideoModel]()


    var productImage = [[String:Any]]()
    var sendproductImage = [UIImage]()
    var productVideoThumnilImge = UIImage()
    var productVideo = [[String:Any]]()
    var selectindex = 0
    var titleImageVideo = ""
    var isCamera = true
    var edit = false
    var postDetails : PostDetailsModel?
    var editpostImageVideo = [ImagesVideoModel]()
    var categorysAndSubCategory = [Categorie]()
    var deleteImageId = [String]()
    var deleteVideoId = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.edit {
            let objectModel = appDelegate.userDetails?.locations
            if appDelegate.userDetails?.role_id == 1 {
                for j in 0..<self.selectAddress.count{
                    if let id = self.selectAddress[j]?.id {
                            self.addressIdLIst.append(String(id))
                        }
                }
            }else{
            for i in 0..<(objectModel?.count ?? 0) {
                for j in 0..<self.selectAddress.count{
                    if objectModel?[i].id == self.selectAddress[j]?.id {
                        if let id = objectModel?[i].id {
                            self.addressIdLIst.append(String(id))
                        }
                    }
                }
            }
            }
            self.setDeta()
        }
        else {
            if let subcategory = self.selectSubcategory?.name {
                self.txtModelTitle.text =  "\(subcategory)"
            }
            let objectModel = appDelegate.userDetails?.locations
            for i in 0..<(objectModel?.count ?? 0) {
                if objectModel?[i].isPayAddress() ?? false  || objectModel?[i].isSelectedAddress() ?? false {
//                    print("is pay \(self.addresslist[i]?.isPayAddress())","id : \(self.addresslist[i]?.id)")
                    self.addresslist.append(objectModel?[i])
                }
            }
            if self.addresslist.count > 0 {
                self.txtLocation.text = "\(self.addresslist[0]?.address ?? "")"
                self.selectAddress = self.addresslist
                self.addressIdLIst.append("\(self.addresslist[0]?.id ?? 0)")
            }
            else {
                self.txtLocation.text = "\(self.addresslist.count) select location"
            }
            self.txtFixedpricee.text = self.priceList[0]?.name
        }
    }
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancel_Clicked(_ button: UIButton) {
        self.navigateToHomeScreen(selIndex: 0)
    }
    
    @IBAction func btnSelectPrise_Clicked(_ button: UIButton) {
        let objet = self.priceList.map{$0?.name}
        RPicker.selectOption(title: "Select price type", cancelText: "Cancel", dataArray: objet as? [String], selectedIndex: 0) {[weak self] (selctedText, atIndex) in
            if selctedText == "Free" {
                self?.txtCADPrice.text = selctedText
                self?.txtCADPrice.isUserInteractionEnabled = false
            }
            else if selctedText == "Best offer" {
                self?.txtCADPrice.text = selctedText
                self?.txtCADPrice.isUserInteractionEnabled = false
            }
            else if selctedText == "Trade/Swap" {
                self?.txtCADPrice.text = selctedText
                self?.txtCADPrice.isUserInteractionEnabled = false
            }
            else{
                self?.txtCADPrice.text = ""
                self?.txtCADPrice.isUserInteractionEnabled = true
            }
            if let tital = objet[atIndex]{
                self?.txtFixedpricee.text = "\(tital)"
            }
            if let id = self?.priceList[atIndex]?.id {
                self?.priceId = "\(id)"
                
            }
        }
    }
    
    @IBAction func btnPreview_Clicked(_ button: UIButton) {
        var productImageUrl = [[String:Any]]()
        for i in 0..<self.productImage.count {
            if let stringUrl = self.productImage[i]["image_url"] as? String{
//                let url = URL.init(string: stringUrl )!
                var dict = [String:Any]()
                dict["image_url"] = stringUrl
                productImageUrl.append(dict)
                
            }
            else {
//                self.sendproductImage.append(self.productImage[i]["image_url"] as! UIImage )
                var dict = [String:Any]()
                dict["image_url"] = self.productImage[i]["image_url"]as! UIImage
                productImageUrl.append(dict)
            }

        }
        let ViewController = PostPreviewVC.instantiate(fromStoryboard: .Sell) //storyboard?.instantiateViewController(identifier: "AddProductPreviewViewController") as! AddProductPreviewViewController
        ViewController.brandSearchList = self.brandSearchList
        if self.edit {
            ViewController.selectCategorySubCategory = self.categorysAndSubCategory //self.selectCategory
            ViewController.addresslist = self.selectAddress
        }
        else {
            ViewController.selectCategory = self.selectCategory
            ViewController.addresslist = self.addresslist
        }
       // ViewController.addresslist = self.selectAddress
        ViewController.savegenderId = self.savegenderId
        ViewController.selectSubcategory = self.selectSubcategory
        if txtCADPrice.text == ""  || txtCADPrice.text == "0"{
            ViewController.price = "0.00"
        }
        else {
            ViewController.price = self.txtCADPrice.text ?? "0.00"
        }
//         = self.txtCADPrice.text ?? ""
        ViewController.priceType = self.txtFixedpricee.text ?? ""
        ViewController.selectColor = self.selectColor
        ViewController.selectSize = self.selectSize
        ViewController.discripction = self.txtDescription.text ?? ""
        ViewController.productModelItem = txtModelTitle.text ?? ""
//        ViewController.productImage = self.sendproductImage
        ViewController.edit = self.edit
        ViewController.productImageUrl = productImageUrl
        ViewController.selectCondiction = self.selectCondiction
        for i in 0..<self.productVideo.count {
            if let stringUrl = self.productVideo[i]["video_url"] as? String {
                let url = URL.init(string: stringUrl)
                ViewController.postImageVideo.append(url!)
            }
            else {
                ViewController.postImageVideo.append((self.productVideo[i]["video_url"] as? URL)!)
            }
        }
        self.navigationController?.pushViewController(ViewController, animated: true)
    }
    
    @IBAction func btnPost_Clicked(_ button: UIButton) {
       
        if self.txtBrandDesignerName.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select brand name")
            return
        }
        if self.productImage.count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please take a product photo")
            return
        }
        if self.txtFixedpricee.text == "Price"{
            if Double(self.txtCADPrice.text!) ?? 0.0 <= 0.0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter valid price")
                return
            }
            else if self.txtCADPrice.text?.trim().count == 0 {
                UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter CADprice")
                return
            }
        }
        if self.selectAddress.count == 0{
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter location")
            return
        }
        if edit {
            self.callEditProduct()
        }
        else{
            if self.txtModelTitle.text?.trim().count == 0{
                if let title = selectCategory?.name{
                    self.txtModelTitle.text = title
                }
                else{
                    if let title = selectSubcategory?.name {
                        self.txtModelTitle.text = title
                    }
                }
            }
            self.callAddProduct()
        }
        print("don")
    }
    @IBAction func btnLocation_Clicked(_ button: UIButton) {
        var payaddress = [Locations]()
        
        if edit {
            for i in 0..<self.addresslist.count {
                for j in 0..<(self.selectAddress.count ?? 0){
                    if self.addresslist[i]?.id == self.selectAddress[j]?.id {
                        self.addresslist[i]?.is_Selected = true
                    }
                    else {
                        self.addresslist[i]?.is_Selected = false
                    }
                }
            }
        }
        else {
            for i in 0..<self.addresslist.count {
                if self.addresslist[i]?.isPayAddress() ?? false  || self.addresslist[i]?.isSelectedAddress() ?? false {
                    print("is pay \(self.addresslist[i]?.isPayAddress() )","id : \(self.addresslist[i]?.id)")
//                    self.addresslist[i]?.is_Selected = true
                    payaddress.append(self.addresslist[i]!)
                }
            }
        }
    
        
        if appDelegate.userDetails?.role_id == 1 {
            let viewController = self.storyboard?.instantiateViewController(identifier: "UserLocationViewController") as! UserLocationViewController
            if edit {
                viewController.edit = edit
                if appDelegate.userDetails?.role_id == 1 {
                    viewController.addresslist = self.selectAddress
                }else{
                viewController.addresslist = self.addresslist
                }
            }
            else {
                viewController.addresslist = payaddress
            }
            
            viewController.locationdelegate = self
            viewController.isPost = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if appDelegate.userDetails?.role_id == 2 {
            let viewController = self.storyboard?.instantiateViewController(identifier: "StorePostAddLocationViewController") as! StorePostAddLocationViewController
            if edit {
                viewController.addresslist = self.selectAddress
            }
            else {
                viewController.addresslist = payaddress
            }
               
            viewController.storePostlocationdelegate = self
            viewController.selectedAddressList = self.selectAddress
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if appDelegate.userDetails?.role_id == 3 {
            let viewController = self.storyboard?.instantiateViewController(identifier: "BrandLocationViewController") as! BrandLocationViewController
            if edit {
                viewController.edit = self.edit
            }
            else {
                viewController.addresslist = payaddress
            }
            viewController.post = true
            viewController.brandlocationdelegate = self
            viewController.addressId = self.addressIdLIst
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func checkImagePermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            self.camera()
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        default:
            // Not determined fill fall here - after first use, when is't neither authorized, nor denied
            // we try to use camera, because system will ask itself for camera permissions
            self.camera()
        }
    }
    func checkVideoPermissions() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            self.videoCamera()
        case .denied:
            alertPromptToAllowCameraAccessViaSetting()
        default:
            // Not determined fill fall here - after first use, when is't neither authorized, nor denied
            // we try to use camera, because system will ask itself for camera permissions
            self.videoCamera()
        }
    }
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: AlertViewTitle, message: "Camera access required", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        })

        present(alert, animated: true)
    }
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.setAlertButtonColor()
        
        actionSheet.addAction(UIAlertAction(title: "Using Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            if self.isCamera {
                self.checkImagePermissions()
            }else {
                self.checkVideoPermissions()
            }
        }))
        actionSheet.addAction(UIAlertAction(title: self.titleImageVideo, style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            if self.isCamera {
                self.photoLibrary()
            }else {
                self.videoLibrary()
            }
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
        myPickerController.toolbar.isMultipleTouchEnabled = true
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = false
        myPickerController.modalPresentationStyle = .overCurrentContext
        myPickerController.addStatusBarBackgroundView()
        myPickerController.view.tintColor = UIColor().alertButtonColor
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func videoCamera() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .camera
        myPickerController.mediaTypes = [kUTTypeMovie as String]
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func videoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController .delegate = self
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
        myPickerController.modalPresentationStyle = .overCurrentContext
        myPickerController.mediaTypes = [kUTTypeMovie as String]
        myPickerController.addStatusBarBackgroundView()
        myPickerController.view.tintColor = UIColor().alertButtonColor
        present(myPickerController, animated: true, completion: nil)
    }
    
    @objc func btnRemoveImage_Clicked(sender: AnyObject) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.CVAddProductImage)
        if let indexPath = self.CVAddProductImage.indexPathForItem(at: buttonPosition) {
            
            if indexPath.item == 7 {
                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to remove video?", preferredStyle: .alert)
                alert.setAlertButtonColor()
                let yesAction: UIAlertAction = UIAlertAction.init(title: "Remove", style: .default, handler: { (action) in
                    self.productVideo.remove(at: 0)
                    let videos = self.postDetails?.videos
                    self.deleteVideoId.append(String(videos?[0].id ?? 0))
                    self.CVAddProductImage.reloadData()
                })
                let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
                })
                
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            }
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: "Are you sure you want to remove image?", preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Remove", style: .default, handler: { (action) in
                self.productImage.remove(at: indexPath.item)
                let object = self.postDetails?.images
                self.deleteImageId.append(String(object?[indexPath.item].id ?? 0))
                self.CVAddProductImage.reloadData()
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setDeta () {
        let id = Int(self.postDetails?.brand_id ?? 0) 
        let dict = ["brand_id": id ?? 0,
                    "name": self.postDetails?.brand_name ?? ""] as [String : Any]
        let brandObjCat = BrandeSearchModel.init(JSON: dict)
        self.brandSearchList = brandObjCat
        self.txtBrandDesignerName.text = brandSearchList?.name
        self.txtModelTitle.text = self.postDetails?.title ?? ""
        self.txtDescription.text = self.postDetails?.description ?? ""
        for i in 0..<(self.postDetails?.images!.count ?? 0)! {
            var dict = [String:Any]()
            dict["image_url"] = self.postDetails?.images![i].image
            self.productImage.append(dict)
        }
        for i in 0..<(self.postDetails?.videos!.count ?? 0)!  {
            var dict = [String:Any]()
            dict["video_url"] = self.postDetails?.videos?[i].video ?? ""
            self.productVideo.append(dict)
            
        }
        if self.productImage.count > 1{
            self.CVAddProductImage.dragInteractionEnabled = true
        }else{
            self.CVAddProductImage.dragInteractionEnabled = false
        }
        self.priceId = String(self.postDetails?.price_type ?? "0")
        self.txtFixedpricee.text = self.postDetails?.price_type_name
        
        if self.txtFixedpricee.text == "Price"{
            if let price = self.postDetails?.price{
                self.txtCADPrice.text = "\(price)"
            }
        }else{
            self.txtCADPrice.text = self.postDetails?.price_type_name
        }
        
        if let brnsdName = self.brandSearchList?.name{
            self.txtBrandDesignerName.text = brnsdName
        }
       // selectAddress
        if appDelegate.userDetails?.role_id == 1 {
            if self.selectAddress.count != 0 {
                self.txtLocation.text = "\(self.selectAddress[0]?.address ?? "")"
            }
        }else{
        self.txtLocation.text = "\(self.selectAddress.count) select location"
        }

    }
}

extension AddProductViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductImageCell", for: indexPath) as! AddProductImageCell
        if indexPath.item == 7 {
            if self.productVideo.count != 0 {
                if let stringurl = self.productVideo[0]["video_url"] as? String {
                    if let url = URL.init(string: stringurl) {
                        self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                            cell.imgProduct.contentMode = .scaleAspectFill
                            cell.imgProduct.image = thumbImage
                            cell.lblProdustTitel.text = "Video"
                        }
                    }
                }
                if let url = self.productVideo[0]["video_url"] as? URL {
                    self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
                        cell.imgProduct.image = thumbImage
                        cell.lblProdustTitel.text = "Video"
                    }
                }
                cell.btnRemoveImage.isHidden = false
                cell.btnRemoveImage.addTarget(self, action: #selector(btnRemoveImage_Clicked(sender:)), for: .touchUpInside)
            }
            else{
                cell.btnRemoveImage.isHidden = true
                cell.imgProduct.contentMode = .scaleAspectFit
                cell.imgProduct.image = UIImage.init(named: "video-ic")
                cell.lblProdustTitel.text = "Video"
            }
        }
        else {
            if self.productImage.count > indexPath.item {
                cell.imgProduct.contentMode = .scaleAspectFill
                if let url = self.productImage[indexPath.item]["image_url"] as? String {
                    if let image  = URL.init(string: url){
                        
                        cell.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
                    }
                }
                if let image = self.productImage[indexPath.item]["image_url"] as? UIImage {
                    cell.imgProduct.image = image
                }
                cell.btnRemoveImage.isHidden = false
                cell.lblProdustTitel.text = "Photo"
                cell.btnRemoveImage.addTarget(self, action: #selector(btnRemoveImage_Clicked(sender:)), for: .touchUpInside)
            }
            else {
                cell.imgProduct.contentMode = .scaleAspectFit
                cell.imgProduct.image = UIImage.init(named: "Camera-Black-ic")
                cell.lblProdustTitel.text = "Photo"
                cell.btnRemoveImage.isHidden = true
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 7 {
            self.titleImageVideo = "Choose Existing Video"
            self.isCamera = false
            self.showActionSheet()
            self.selectindex = indexPath.item
        }
        else{
            self.titleImageVideo = "Choose Existing Photo"
            self.isCamera = true
            self.showActionSheet()
            self.selectindex = indexPath.item
        }
        self.CVAddProductImage.reloadItems(at: [indexPath])
    }
}

class AddProductImageCell : UICollectionViewCell {
    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var lblProdustTitel: UILabel!
    @IBOutlet weak var btnRemoveImage: UIButton!
}

extension AddProductViewController: UICollectionViewDragDelegate {

    // Get dragItem from the indexpath
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
       
        if self.productImage.count >= 1{
            if indexPath.item < self.productImage.count{
                if let urls = self.productImage[indexPath.item]["image_url"] as? String {
                    let itemProvider = NSItemProvider(object: urls as NSItemProviderWriting)
                    let dragItem = UIDragItem(itemProvider: itemProvider)
                    dragItem.localObject = urls
                    return [dragItem]
                }
                else if let urlii = self.productImage[indexPath.item]["image_url"] as? UIImage {
                    let itemProvider = NSItemProvider(object: urlii )
                    let dragItem = UIDragItem(itemProvider: itemProvider)
                    dragItem.localObject = urlii
                    return [dragItem]
                }
                return []
               // let itemPrice = self.productImage[indexPath.item]["image_url"]
                
            }else{
                return []
            }
        }else{
            return []
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
      
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProductImageCell", for: indexPath) as! AddProductImageCell
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: cell.imgProduct.frame.minX, y: cell.imgProduct.frame.minY, width: cell.imgProduct.frame.width , height: cell.imgProduct.frame.height ), cornerRadius: 20)
            return previewParameters
        
    }
}

extension AddProductViewController: UICollectionViewDropDelegate {
    
    // Called when the user initiates the drop operation
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move{
            copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
                        
        }
    }
    
    // Get the position of the dragged data over the collection view changed
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath {
            
            print("current index\(indexPath)")
           
//            users.indices.forEach { users[$0].isHighlighted = false }
//            users[indexPath.item].isHighlighted = true
//            collectionView.reloadData()
        }
        return UICollectionViewDropProposal(operation: .move)
    }
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath{
            
            collectionView.performBatchUpdates {
                print("destination index\(destinationIndexPath)")
                if  destinationIndexPath.item < self.productImage.count {
                    self.productImage.remove(at: sourceIndexPath.item)
                    var dict = [String:Any]()
                    dict["image_url"] = item.dragItem.localObject
                    self.productImage.insert(dict , at: destinationIndexPath.item)
                    
                    self.CVAddProductImage.deleteItems(at: [sourceIndexPath])
                    self.CVAddProductImage.insertItems(at: [destinationIndexPath])
                    self.CVAddProductImage.reloadData()
                }
            }
        }
    }
}

extension AddProductViewController: UICollectionViewDelegateFlowLayout {
    fileprivate var sectionInsets: UIEdgeInsets {
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      }
      
      fileprivate var itemsPerRow: CGFloat {
        return 4
      }
      
      fileprivate var interitemSpace: CGFloat {
            return 0.0
      }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
            let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 90)
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

extension AddProductViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtBrandDesignerName {
            let viewController = self.storyboard?.instantiateViewController(identifier: "FavouriteBrandSearchViewController") as! FavouriteBrandSearchViewController
            viewController.favouriteBrandDeleget = self
            self.present(viewController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtModelTitle{
            if self.txtModelTitle.text?.trim().count == 0 {
                if let categoty = self.selectCategory?.name {
                    self.txtModelTitle.text = categoty
                }
                else {
                    if let categoty = self.selectSubcategory?.name {
                        self.txtModelTitle.text = categoty
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtCADPrice {
            let maxLength = 5
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else {
            return true
        }
    }
}

extension AddProductViewController : BrandLocationDelegate ,StorePostLocationDelegate,UserLocationDelegate{
    func LocationFormAdddLocation(address: [Locations?]) {
        self.selectAddress.removeAll()
        for temp in address {
            self.selectAddress.append(temp)
            self.addressIdLIst.append(String((temp?.id)!))
        }
        if selectAddress.count == 1 {
            if let address = self.selectAddress[0]?.address {
                if let  postlcode = selectAddress[0]?.postal_code  {
                    self.txtLocation.text = "\(address) , \(postlcode)"
                }
            }
        }
        else
        {
            self.txtLocation.text = "\(self.selectAddress.count) Add location"
        }
    }
    
    func LocationFormStorePostLocationAdd(addressLists: [Locations?]) {
        self.selectAddress.removeAll()
        for temp in addressLists {
            self.selectAddress.append(temp)
            self.addressIdLIst.append(String((temp?.id)!))
        }
        if selectAddress.count == 1 {
            if let address = self.selectAddress[0]?.address {
                if let  postlcode = selectAddress[0]?.postal_code  {
                    self.txtLocation.text = "\(address) , \(postlcode)"
                }
            }
        }
        else
        {
            self.txtLocation.text = "\(self.selectAddress.count) Add location"
        }
    }
    
    func LocationFormBrandLocationAdd(addressLists: [Locations?]) {
        self.selectAddress.removeAll()
        for temp in addressLists {
            self.selectAddress.append(temp)
            self.addressIdLIst.append(String((temp?.id)!))
        }
        if self.selectAddress.count == 1 {
            if let address = self.selectAddress[0]?.city {
                self.txtLocation.text = "\(address)"
            }
        }
        else
        {
            let count  = self.selectAddress.count
            self.txtLocation.text = "\(count) Add location"
        }
    }
}
extension AddProductViewController : FavouriteBrandSearchDelegate {
    func FavouriteBrandSearchAddd( brand: BrandeSearchModel) {
        self.brandSearchList = brand
        self.txtBrandDesignerName.text = self.brandSearchList?.name
    }
}

extension AddProductViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func videoConvert(videoURL: URL)  {
        let avAsset = AVURLAsset(url: videoURL as URL, options: nil)
        let startDate = NSDate()
        //Create Export session
        
        let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
        // exportSession = AVAssetExportSession(asset: composition, presetName: mp4Quality)
        
        //Creating temp path to save the converted video
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let myDocumentPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("temp.mp4")?.absoluteString
        let url = NSURL(fileURLWithPath: myDocumentPath!)
        
        let documentsDirectory2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let filePath = documentsDirectory2.appendingPathComponent("VideoConvert.mp4")
        deleteFile(filePath: filePath!)
        
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: myDocumentPath!) {
            do {
                try FileManager.default.removeItem(atPath: myDocumentPath!)
            }
            catch let error {
                print(error)
            }
        }
        //URL
        print(filePath!.absoluteString)
        exportSession!.outputURL = filePath
        exportSession!.outputFileType = AVFileType.mp4
        exportSession!.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession!.timeRange = range
        exportSession!.exportAsynchronously(completionHandler: {() -> Void in
            switch exportSession!.status {
            case .failed:
                print("%@",exportSession!.error ?? "Failed to get error")
            case .cancelled:
                print("Export canceled")
            case .completed:
                //Video conversion finished
                let endDate = NSDate()
                let time = endDate.timeIntervalSince(startDate as Date)
                print(time)
                print("Successful!")
                print(exportSession!.outputURL!)
                var dict = [String:Any]()
                dict["video_url"] = exportSession!.outputURL!
                self.productVideo.append(dict)
                DispatchQueue.main.async {
                    self.CVAddProductImage.reloadData()
                }
                
            default:
                break
            }
        })
    }
    
    func deleteFile(filePath:URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        }catch{
            fatalError("Unable to delete file: \(error)")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            var dict = [String:Any]()
            dict["image_url"] = image.makeFixOrientation()
            self.productImage.append(dict)
        }
        
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            if mediaType == "public.movie" {
                let outputFileURL = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                self.videoConvert(videoURL: outputFileURL)
                self.CVAddProductImage.reloadData()
            }
        }
        if self.productImage.count >= 1{
            self.CVAddProductImage.dragInteractionEnabled = true
            self.CVAddProductImage.dropDelegate = self
        }else{
            self.CVAddProductImage.dragInteractionEnabled = false
        }
        self.CVAddProductImage.reloadData()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddProductViewController {
    func apiCallWithImageVideoList<T:Mappable>(of type: T.Type = T.self,isShowHud: Bool, URL : String, apiName : String, parameters : [String : Any], images: [UIImage], imageParameterName: String, imageName: String, video: [URL?], videoParameterName: String, videoName: String, completion:@escaping (_ dict: BaseResponseModel<T>?,_ error: NSError?) -> ()){
        
        let api_url = URL + apiName
        print("API URL = \(api_url) parameters = \(parameters)")
        
        var headers: HTTPHeaders? = nil
        if appDelegate.headerToken != "" {
            headers = ["Authorization": "Bearer \(appDelegate.headerToken)"]
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            if images.count > 0{
                for index in 0...images.count - 1 {

                    let imagedata = images[index].resize(images[index])
                    print("image size: \(imagedata?.count)")
                    multipartFormData.append(imagedata ?? Data(), withName: "\(imageParameterName)[\(index)]", fileName: "\(imageName)\(index).png", mimeType: "image/png")
                          
                    
                }
            }
            if video.count > 0 {
                for index in 0...video.count - 1 {
                    multipartFormData.append(video[index]!, withName: "\(videoParameterName)[\(index)]", fileName: "\(videoName)\(index).mp4", mimeType: "video/mp4")
                }
            }
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, usingThreshold: 1, to: api_url, method: .post, headers: headers, encodingCompletion: {
            encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: {
                    response in
                    if isShowHud {
                        KRProgressHUD.dismiss()
                    }
                    switch response.result {
                    case .success:
                        let json = try! JSONSerialization.jsonObject(with: response.data!)
                        print(response)
                        let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json as! [String : Any])
                        
                        if dataResponse?.status == kIsSuccess {
                            completion(dataResponse!, nil)
                        }
                        else if dataResponse?.status == kUserNotFound {
                            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: dataResponse?.message, preferredStyle: .alert)
                            alert.setAlertButtonColor()
                            
                            let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                            })
                            alert.addAction(hideAction)
                            sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else{
                            completion(nil, NSError.init(domain: (dataResponse?.message)!, code: (dataResponse?.status)!, userInfo: nil))
                        }
                    case .failure(let error):
                        print (error)
                        completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                })
            case .failure(let encodingError):
                if isShowHud {
                    KRProgressHUD.dismiss()
                }
               print (encodingError)
                completion(nil, NSError.init(domain: ErrorMessage, code: 0, userInfo: nil))
            }
        })
    }
    
    func callAddProduct() {
        self.sendproductImage.removeAll()
        for i in 0..<self.productImage.count {
            if let image = self.productImage[i]["image_url"] as? UIImage {
                self.sendproductImage.append(image)
            }
            //            self.sendproductImage.append(self.productImage[i]["image_url"] as! UIImage)
        }
        var arrVideoList = [URL]()
        for i in 0..<self.productVideo.count {
            if let url = productVideo[i]["video_url"] as? URL {
                arrVideoList.append(url)
            }
        }
        var colorArre = [String]()
        for i in 0..<self.selectColor.count {
            if let colorId = self.selectColor[i]?.id {
                colorArre.append(String(colorId))
            }
        }
        var categorySubCategoryId = [String]()
        if self.edit {
            for i in 0..<self.categorysAndSubCategory.count {
                categorySubCategoryId.append(String(self.categorysAndSubCategory[i].category_id ?? 0))
            }
        }
        else {
            categorySubCategoryId.append(String(self.selectCategory?.category_id ?? 0))
            categorySubCategoryId.append(String(self.selectSubcategory?.id ?? 0))
        }
        let category = String(categorySubCategoryId.joined(separator: ","))
        let colorIdString = colorArre.joined(separator: ",")
        var usersideproductlocation = ""
        var location  = self.addressIdLIst.joined(separator: ",")
        var price = ""
        if self.txtCADPrice.text == self.txtFixedpricee.text {
            price = "0.00"//self.txtCADPrice.text ?? "0"
        }
        else if self.txtCADPrice.text == "Free" || self.txtCADPrice.text == "Best offer" || self.txtCADPrice.text == "Trade/Swap" {
            price = "0.00"//self.txtCADPrice.text ?? "0"
        }
        else {
            if txtCADPrice.text == "" {
                price = "0.00"
            }
            else {
                price = self.txtCADPrice.text ?? "0"
            }
        }
        var address = ""
        var postalcode = ""
        var latitude = ""
        var longitude = ""
        var city = ""
        var area = ""
        if location.contains("\(appDelegate.userDetails?.id ?? 0)"){
            print(location)
            location = ""
            for i in 0..<(self.selectAddress.count)  {
                
                address = self.selectAddress[i]?.address ?? ""
                postalcode = self.selectAddress[i]?.postal_code ?? ""
                latitude = self.selectAddress[i]?.latitude ?? ""
                longitude = self.selectAddress[i]?.longitude ?? ""
                city = self.selectAddress[i]?.city ?? ""
                area = self.selectAddress[i]?.area ?? ""
               // address.append(dict)
               // print(address)
            }
           // self.selectAddress
            
           // usersideproductlocation = self.json(from: address) ?? ""
        }
        
        
        if appDelegate.reachable.connection != .none{
            let param = ["brand_id" : String(self.brandSearchList?.brand_id ?? 0),
                         "gender_id": "\(self.savegenderId?.gender_id ?? 0)" ,
                         "categories" : category ,
                         "sizes" : String(self.selectSize?.id ?? 0),
                         "condition_id" : "\(self.selectCondiction?.id ?? 0)" ,
                         "colors" : colorIdString ,
                         "title" : self.txtModelTitle.text ?? "",
                         "description" : self.txtDescription.text ?? "",
                         "locations" : location ,
                         "price_type" : "1" ,
                         "product_url" : self.Producturl ,
                         "price" : price,
                         "city" : city,
                         "area" : area,
                         "longitude" : longitude,
                         "latitude" : latitude,
                         "postal_code" : postalcode,
                         "address" : address
            ] as [String : Any]
            
            if self.productVideo.count != 0 {
                self.apiCallWithImageVideoList(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_CREATE.rawValue, parameters: param, images: self.sendproductImage, imageParameterName: "image", imageName: "Productimge", video: arrVideoList, videoParameterName: "video", videoName: "ProductVideo") { (response, error) in
                    if error == nil {
                        if let response = response {
                            if let data = response.dictData {
                                print(response)
//                                let viewController = self.storyboard?.instantiateViewController(identifier: "PromoteViewController") as! PromoteViewController
//                                viewController.postDetail = data
//                                viewController.sendproductImage = self.sendproductImage
//                                viewController.isGotoHome = true
//                                self.navigationController?.pushViewController(viewController, animated: true)
//
                                let viewController = self.storyboard?.instantiateViewController(identifier: "CongratulationsViewController") as! CongratulationsViewController
                                viewController.sendproductImage = self.sendproductImage
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                        else {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                        }
                    }
                }
            }
            else {
                self.apiCallWithImageVideoList(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POST_CREATE.rawValue, parameters: param, images: self.sendproductImage, imageParameterName: "image", imageName: "Productimge", video: arrVideoList, videoParameterName: "video", videoName: "ProductVideo") { (response, error) in
                    if error == nil {
                        if let response = response {
                            if let data = response.dictData {
                                print(response)
//                                let viewController = self.storyboard?.instantiateViewController(identifier: "PromoteViewController") as! PromoteViewController
//                                viewController.postDetail = data
//                                viewController.isGotoHome = true
//                                self.navigationController?.pushViewController(viewController, animated: true)
                                
                                let viewController = self.storyboard?.instantiateViewController(identifier: "CongratulationsViewController") as! CongratulationsViewController
                                viewController.sendproductImage = self.sendproductImage
                                viewController.postId = "\(data.id ?? 0)"
                                self.navigationController?.pushViewController(viewController, animated: true)
                            }
                        }
                        else {
                            UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                        }
                    }
                }
            }
        }else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }
    
    func callEditProduct() {
        for i in 0..<self.productImage.count {
            if let image = self.productImage[i]["image_url"] as? UIImage {
                self.sendproductImage.append(image)
            }
            //            self.sendproductImage.append(self.productImage[i]["image_url"] as! UIImage)
        }
        var arrVideoList = [URL]()
        for i in 0..<self.productVideo.count {
            if let url = productVideo[i]["video_url"] as? URL {
                arrVideoList.append(url)
            }
        }
        var colorArre = [String]()
        for i in 0..<self.selectColor.count {
            if let colorId = self.selectColor[i]?.id {
                colorArre.append(String(colorId))
            }
        }
        var categorySubCategoryId = [String]()
        if self.edit {
            for i in 0..<self.categorysAndSubCategory.count {
                categorySubCategoryId.append(String(self.categorysAndSubCategory[i].category_id ?? 0))
            }
        }
        else {
            categorySubCategoryId.append(String(self.selectCategory?.category_id ?? 0))
            categorySubCategoryId.append(String(self.selectSubcategory?.id ?? 0))
        }
        let category = String(categorySubCategoryId.joined(separator: ","))
        let colorIdString = colorArre.joined(separator: ",")
        var location  = self.addressIdLIst.joined(separator: ",")
        let deletedImage = self.deleteImageId.joined(separator: ",")
        let deletedVideo = self.deleteVideoId.joined(separator: ",")
    
       // var usersideproductlocation = ""
        var address = ""
        var postalcode = ""
        var latitude = ""
        var longitude = ""
        var city = ""
        var area = ""
        if location.contains("\(appDelegate.userDetails?.id ?? 0)"){
            print(location)
            location = ""
            for i in 0..<(self.selectAddress.count)  {
                address = self.selectAddress[i]?.address ?? ""
                postalcode = self.selectAddress[i]?.postal_code ?? ""
                latitude = self.selectAddress[i]?.latitude ?? ""
                longitude = self.selectAddress[i]?.longitude ?? ""
                area = self.selectAddress[i]?.city ?? ""
                city = self.selectAddress[i]?.area ?? ""
            }
        }
        var price = ""
        if self.txtCADPrice.text == self.txtFixedpricee.text {
            price = "0.00"//self.txtCADPrice.text ?? "0"
        }
        else if self.txtCADPrice.text == "Free" || self.txtCADPrice.text == "Best offer" || self.txtCADPrice.text == "Trade/Swap" {
            price = "0.00"//self.txtCADPrice.text ?? "0"
        }
        else {
            if txtCADPrice.text == "" {
                price = "0.00"
            }
            else {
                price = self.txtCADPrice.text ?? "0"
            }
        }
           
        if appDelegate.reachable.connection != .none{
            let param = ["post_id" : "\(self.postDetails?.id ?? 0)",
                         "brand_id" : "\(self.brandSearchList?.brand_id ?? 0)" ,
                         "gender_id": "\(self.savegenderId?.gender_id ?? 0)" ,
                         "categories" : category ,
                         "sizes" : String(self.selectSize?.id ?? 0),
                         "condition_id" : "\(self.selectCondiction?.id ?? 0)" ,
                         "colors" : colorIdString ,
                         "title" : self.txtModelTitle.text ?? "",
                         "description" : self.txtDescription.text ?? "",
                         "locations" : location ,
                         "price_type" : "1" ,
                         "price" : price,
                         "deleted_image_ids" : deletedImage,
                         "deleted_video_ids" : deletedVideo,
                         "product_url" : self.Producturl,
                         "city" : city,
                         "area" : area,
                         "longitude" : longitude,
                         "latitude" : latitude,
                         "postal_code" : postalcode,
                         "address" : address
            ] as [String : Any]
            print(param)
            if self.productVideo.count != 0 {
                self.apiCallWithImageVideoList(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POSE_EDIT.rawValue, parameters: param, images: self.sendproductImage, imageParameterName: "image", imageName: "Productimge", video: arrVideoList, videoParameterName: "video", videoName: "ProductVideo") { (response, error) in
                    if error == nil {
                        if let response = response {
                            if let data = response.dictData {
                                self.postDetails = data
                                self.navigateToHomeScreen(selIndex: 4)
                            }
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
            else {
                self.apiCallWithImageVideoList(of: PostDetailsModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.POSE_EDIT.rawValue, parameters: param, images: self.sendproductImage, imageParameterName: "image", imageName: "Productimge", video: arrVideoList, videoParameterName: "video", videoName: "ProductVideo") { (response, error) in
                    if error == nil {
                        if let response = response {
                            if let data = response.dictData {
                                self.postDetails = data
                                self.navigateToHomeScreen(selIndex: 4)
                            }
                        }
                    }
                    else {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                    }
                }
            }
        }else {
            UIAlertController().alertViewWithNoInternet(self)
        }
    }

}
