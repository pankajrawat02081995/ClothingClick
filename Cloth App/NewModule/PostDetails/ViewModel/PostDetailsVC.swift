//
//  PostDetailsVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 31/05/24.
//

import UIKit
import ObjectMapper
import Alamofire
import KRProgressHUD
import IBAnimatable
import YPImagePicker
import AVFoundation
import Photos

enum MediaItem {
    case photo(image: UIImage,imageString:String)
    case video(url: String, thumbnail: UIImage)
}

class PostDetailsVC: BaseViewController {
    @IBOutlet weak var styleCollection: DynamicHeightCollectionView!
    @IBOutlet weak var btnAddImage: AnimatableButton!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var styleCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var txtBrandDesignerName: UITextField!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtDescription: AnimatableTextView!
    
    @IBOutlet weak var txtModelTitle: AnimatableTextField!
    //    @IBOutlet weak var txtFixedpricee: AnimatableTextField!
    //    @IBOutlet weak var btnSelectPrise: UIButton!
    
    @IBOutlet weak var txtCADPrice: AnimatableTextField!
    @IBOutlet weak var txtLocation: AnimatableTextField!
    
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
    
    var styles : [Styles]?
    
    var productImage = [[String:Any]]()
    var productVideo = [[String:Any]]()
    var sendproductImage = [UIImage]()
    var productVideoThumnilImge = UIImage()
    
    var mediaItems = [MediaItem]()
    
    var selectindex = 0
    var titleImageVideo = ""
    var isCamera = true
    var edit = false
    var postDetails : PostDetailsModel?
    var editpostImageVideo = [ImagesVideoModel]()
    var categorysAndSubCategory = [Categorie]()
    var deleteImageId = [String]()
    var deleteVideoId = [String]()
    
    var selectedStyleID : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtBrandDesignerName.delegate = self
        self.txtModelTitle.delegate = self
        self.txtLocation.delegate = self
        self.txtCADPrice.delegate = self
        
        self.CVAddProductImage.delegate = self
        self.CVAddProductImage.dataSource = self
        self.CVAddProductImage.dragDelegate = self
        self.CVAddProductImage.dropDelegate = self
        self.CVAddProductImage.registerCell(nib: UINib(nibName: "PostItemXIB", bundle: nil), identifier: "PostItemXIB")
        self.CVAddProductImage.registerCell(nib: UINib(nibName: "AddImgXIB", bundle: nil), identifier: "AddImgXIB")
        
        self.styleCollection.delegate = self
        self.styleCollection.dataSource = self
        //        self.styleCollection.registerCell(nib: UINib(nibName: "ClothPrefCVCell", bundle: nil), identifier: "ClothPrefCVCell")
        
        if self.edit {
            self.btnCancel.setImage(UIImage.init(named: "ic_delete_red"), for: .normal)
            self.selectedStyleID = self.postDetails?.style_id ?? 0
            self.styleCollection.reloadData()
            let objectModel = appDelegate.userDetails?.locations
            if appDelegate.userDetails?.role_id == 1 {
                self.selectAddress = objectModel ?? []
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
        } else {
            if let subcategory = self.selectSubcategory?.name {
                self.txtModelTitle.text = "\(brandSearchList?.name ?? "") \(subcategory)"
            }
            let objectModel = appDelegate.userDetails?.locations
            self.addresslist = []
            for i in 0..<(objectModel?.count ?? 0) {
                if objectModel?[i].isPayAddress() ?? false  || objectModel?[i].isSelectedAddress() ?? false {
                    //                    print("is pay \(self.addresslist[i]?.isPayAddress())","id : \(self.addresslist[i]?.id)")
                    self.addresslist.append(objectModel?[i])
                }
            }
            if self.addresslist.count > 0 {
                self.txtLocation.text = "\(self.addresslist.first??.address ?? "")"
                self.selectAddress = self.addresslist
                self.addressIdLIst.append("\(self.addresslist.first??.id ?? 0)")
            }
            else {
                self.txtLocation.text = "\(self.addresslist.count) select location"
            }
            //            self.txtFixedpricee.text = self.priceList.first??.name
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.CVAddProductImage.reloadData()
        self.CVAddProductImage.layoutIfNeeded()
        self.collectionViewHeight.constant = self.CVAddProductImage.contentSize.height
        
        self.styleCollection.reloadData()
        self.styleCollection.layoutIfNeeded()
        self.styleCollectionHeight.constant = self.styleCollection.contentSize.height
    }
    
    func setDeta () {
        let id = Int(self.postDetails?.brand_id ?? "0")
        let dict = ["brand_id": id ?? 0,
                    "name": self.postDetails?.brand_name ?? ""] as [String : Any]
        let brandObjCat = BrandeSearchModel.init(JSON: dict)
        self.brandSearchList = brandObjCat
        self.txtBrandDesignerName.text = brandSearchList?.name
        self.txtModelTitle.text = self.postDetails?.title ?? ""
        //        self.txtModelTitle.text = "\(brandSearchList?.name ?? "") \(self.postDetails?.title ?? "")"
        
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
        self.combineMediaArrays()
        if self.productImage.count > 1{
            self.CVAddProductImage.dragInteractionEnabled = true
        }else{
            self.CVAddProductImage.dragInteractionEnabled = false
        }
        self.priceId = String(self.postDetails?.price_type ?? "0")
        //        self.txtFixedpricee.text = self.postDetails?.price_type_name
        
        //        if self.txtFixedpricee.text == "Price"{
        if let price = self.postDetails?.price{
            self.txtCADPrice.text = "\(price)"
        }
        //        }else{
        //            self.txtCADPrice.text = self.postDetails?.price_type_name
        //        }
        
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
        
        if self.productVideo.isEmpty == false || self.productImage.isEmpty == false{
            self.CVAddProductImage.isHidden = false
            self.btnAddImage.isHidden = true
        }else{
            self.CVAddProductImage.isHidden = true
            self.btnAddImage.isHidden = false
        }
        
    }
    
    @IBAction func photoGuiedOnPress(_ sender: UIButton) {
        let vc = PhotoGuide.instantiate(fromStoryboard: .Sell)
        self.pushViewController(vc: vc)
    }
    @IBAction func addImageOnPress(_ sender: UIButton) {
        self.imagePicker()
    }
    
    @IBAction func cancelOnPress(_ sender: UIButton) {
        if self.edit{
            let vc = DeletePostVC.instantiate(fromStoryboard: .Sell)
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.isCancelHide = false
            vc.deleteTitle = "Delete"
            vc.deleteBgColor = .red
            vc.titleMain = "Are you sure?"
            vc.subTitle = "By clicking delete, you will not be able to recover your listing"
            vc.imgMain = UIImage(named: "ic_delete_big")
            vc.deleteOnTap = {
                DeleteProduct.share.delete(postId: "\(self.postDetails?.id ?? 0)", view: self) { status in
                    self.navigationController?.popToRootViewController(animated: false)
                }
            }
            self.present(vc, animated: true)
            
        }else{
            self.navigateToHomeScreen(selIndex: 0)
        }
    }
    
    func requestPhotoLibraryAccess(completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized)
                }
            }
        @unknown default:
            completion(false)
        }
    }
    
    func imagePicker() {
        requestPhotoLibraryAccess { granted in
            guard granted else {
                // Handle the case where access is not granted
                print("Access to photo library not granted")
                return
            }
            
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = 9 - (self.productImage.count + self.productVideo.count)
            
            //            if self.productVideo.count < 2 && self.productImage.count < 7 {
            //                config.library.mediaType = .photoAndVideo
            //            } else if self.productVideo.count < 2 && self.productImage.count >= 7 {
            //                config.library.mediaType = .video
            //            } else {
            //                config.library.mediaType = .photo
            //            }
            
            config.library.mediaType = .photo
            
            config.library.skipSelectionsGallery = true
            config.wordings.libraryTitle = "Gallery"
            config.wordings.cameraTitle = "Camera"
            config.targetImageSize = YPImageSize.original
            config.showsVideoTrimmer = true
            config.showsPhotoFilters = false
            config.library.defaultMultipleSelection = true
            config.startOnScreen = YPPickerScreen.library
            config.video.compression = AVAssetExportPresetHighestQuality
            config.video.fileType = .mov
            config.video.recordingTimeLimit = 30.0
            config.video.libraryTimeLimit = 300.0
            config.video.minimumTimeLimit = 3.0
            config.video.trimmerMaxDuration = 30.0
            config.video.trimmerMinDuration = 3.0
            config.screens = [.library, .photo]
            
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking { [unowned picker] items, cancelled in
                if cancelled {
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                
                var newProductImage = self.productImage
                var newProductVideo = self.productVideo
                
                for item in items {
                    switch item {
                    case .photo(let photo):
                        if newProductImage.count < 9 {
                            var dict = [String: Any]()
                            dict["image_url"] = photo.originalImage
                            newProductImage.append(dict)
                        } else {
                            print("Cannot select more than 7 images")
                        }
                    case .video(let video):
                        if newProductVideo.count < 2 {
                            var dict = [String: Any]()
                            dict["video_url"] = video.url.absoluteString
                            dict["thumbnail"] = video.thumbnail
                            newProductVideo.append(dict)
                        } else {
                            print("Cannot select more than 2 videos")
                        }
                    }
                }
                
                // Update the instance variables only if the selections are within the limits
                if newProductImage.count <= 9 /*&& newProductVideo.count <= 2 */{
                    self.productImage = newProductImage
                    self.productVideo = newProductVideo
                } else {
                    print("Selection exceeded limits")
                }
                
                self.btnAddImage.isHidden = true
                self.CVAddProductImage.isHidden = false
                self.combineMediaArrays()
                
                picker.dismiss(animated: true, completion: nil)
            }
            
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func combineMediaArrays() {
        mediaItems = []
        
        // Add images to mediaItems
        for imageDict in productImage {
            let image = imageDict["image_url"] as? UIImage ?? UIImage()
            let imageString = imageDict["image_url"] as? String ?? ""
            mediaItems.append(.photo(image: image, imageString: imageString))
        }
        
        // Add videos to mediaItems
        for videoDict in productVideo {
            if let url = videoDict["video_url"] as? String, let thumbnail = videoDict["thumbnail"] as? UIImage {
                mediaItems.append(.video(url: url, thumbnail: thumbnail))
            }
        }
        self.CVAddProductImage.reloadData()
    }
    
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
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
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
        let ViewController = PostPreviewVC.instantiate(fromStoryboard: .Sell) //AddProductPreviewViewController.instantiate(fromStoryboard: .Main)
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
        //        ViewController.priceType = self.txtFixedpricee.text ?? ""
        ViewController.selectColor = self.selectColor
        ViewController.mediaItems = self.mediaItems
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
        
        if self.txtCADPrice.text?.trim().count == 0 {
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter CADprice")
            return
        }
        
        //        }
        if self.selectAddress.count == 0{
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please enter location")
            return
        }
        
        if self.selectedStyleID == nil{
            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select style")
            return
        }
        
        if self.edit {
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
}


extension PostDetailsVC{
    
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
                    print("image size: \(imagedata.count)")
                    multipartFormData.append(imagedata, withName: "\(imageParameterName)[\(index)]", fileName: "\(imageName)\(index).png", mimeType: "image/png")
                    
                    
                }
            }
            if video.count > 0 {
                for index in 0...video.count - 1 {
                    multipartFormData.append(video[index]!, withName: "\(videoParameterName)[\(index)]", fileName: "\(videoName)\(index).mp4", mimeType: "video/mp4")
                }
            }
            for (key, value) in parameters {
                //                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                multipartFormData.append("\(value)".data(using: .utf8) ?? Data(), withName: key)
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
        //        for i in 0..<self.productImage.count {
        //            if let image = self.productImage[i]["image_url"] as? UIImage {
        //                self.sendproductImage.append(image)
        //            }
        //            //            self.sendproductImage.append(self.productImage[i]["image_url"] as! UIImage)
        //        }
        var arrVideoList = [URL]()
        for i in self.mediaItems {
            
            switch i{
            case .photo(image: let image, imageString: let imgString):
                self.sendproductImage.append(image)
            case .video(url: let url, thumbnail: let thumbnail):
                if let url = URL(string: url){
                    arrVideoList.append(url)
                }
            }
        }
        
        //        for i in 0..<self.productVideo.count {
        //            if let url = productVideo[i]["video_url"] as? URL {
        //                arrVideoList.append(url)
        //            }
        //        }
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
        
        if self.txtCADPrice.text == "Free" || self.txtCADPrice.text == "Best offer" || self.txtCADPrice.text == "Trade/Swap" {
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
                         "title" : self.removeBrandName(from: self.txtModelTitle.text ?? "", brand: self.brandSearchList?.name ?? ""),
                         "description" : self.txtDescription.text ?? "",
                         "locations" : location ,
                         "price_type" : "1" ,
                         "product_url" : self.Producturl ,
                         "style" : self.selectedStyleID ?? 0 ,
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
                                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                                alert.setAlertButtonColor()
                                
                                let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                    if let tabBarController = self.tabBarController {
                                        tabBarController.selectedIndex = 4
                                    }
                                })
                                alert.addAction(hideAction)
                                self.present(alert, animated: true)                            }
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
                                
                                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                                alert.setAlertButtonColor()
                                
                                let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                    //                                    self.navigationController?.setViewControllers([], animated: false)
                                    
                                    // Navigate to a specific tab index (e.g., index 4)
                                    if let tabBarController = self.tabBarController {
                                        tabBarController.selectedIndex = 4
                                    }
                                })
                                alert.addAction(hideAction)
                                self.present(alert, animated: true)
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
        //        if self.txtCADPrice.text == self.txtFixedpricee.text {
        //            price = "0.00"//self.txtCADPrice.text ?? "0"
        //        }
        //        else
        if self.txtCADPrice.text == "Free" || self.txtCADPrice.text == "Best offer" || self.txtCADPrice.text == "Trade/Swap" {
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
                         "title" : self.removeBrandName(from: self.txtModelTitle.text ?? "", brand: self.brandSearchList?.name ?? "") ,
                         "description" : self.txtDescription.text ?? "",
                         "locations" : location ,
                         "price_type" : "1" ,
                         "style" : self.selectedStyleID ?? 0 ,
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
                                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                                alert.setAlertButtonColor()
                                
                                let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                    //                                    self.navigationController?.setViewControllers([], animated: false)
                                    
                                    // Navigate to a specific tab index (e.g., index 4)
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                                alert.addAction(hideAction)
                                sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
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
                                let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                                alert.setAlertButtonColor()
                                
                                let hideAction: UIAlertAction = UIAlertAction.init(title: kOk, style: .default, handler: { (action) in
                                    //                                    self.navigationController?.setViewControllers([], animated: false)
                                    
                                    // Navigate to a specific tab index (e.g., index 4)
                                    //                                    if let tabBarController = self.tabBarController {
                                    //                                        tabBarController.selectedIndex = 4
                                    //                                    }
                                    self.navigationController?.popToRootViewController(animated: true)
                                })
                                alert.addAction(hideAction)
                                sceneDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
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


extension PostDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.styleCollection{
            return self.styles?.count ?? 0
        }else{
            if mediaItems.count < 9{
                return mediaItems.count + 1
            }else{
                return mediaItems.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        if indexPath.item == 7 {
        //            if self.productVideo.count != 0 {
        //                if let stringurl = self.productVideo[0]["video_url"] as? String {
        //                    if let url = URL.init(string: stringurl) {
        //                        self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
        //                            cell.imgProduct.contentMode = .scaleAspectFill
        //                            cell.imgProduct.image = thumbImage
        ////                          cell.lblProdustTitel.text = "Video"
        //                        }
        //                    }
        //                }
        //                if let url = self.productVideo[0]["video_url"] as? URL {
        //                    self.getThumbnailImageFromVideoUrl(url: url) { (thumbImage) in
        //                        cell.imgProduct.image = thumbImage
        ////                        cell.lblProdustTitel.text = "Video"
        //                    }
        //                }
        ////                cell.btnRemoveImage.isHidden = false
        //                cell.btnDelete.addTarget(self, action: #selector(btnRemoveImage_Clicked(sender:)), for: .touchUpInside)
        //            }
        //            else{
        //
        //                cell.imgProduct.contentMode = .scaleAspectFit
        //                cell.imgProduct.image = UIImage.init(named: "video-ic")
        ////                cell.lblProdustTitel.text = "Video"
        //            }
        //        }
        //        else {
        if collectionView == self.styleCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClothPrefCVCell", for: indexPath) as! ClothPrefCVCell
            let indexData = self.styles?[indexPath.item]
            cell.lblTitle.text = indexData?.name ?? ""
            if self.selectedStyleID == indexData?.id ?? 0{
                cell.bgView.backgroundColor = .customBlack
                cell.lblTitle.textColor = .customWhite
                cell.lblTitle.text = indexData?.name
                
            }else {
                cell.bgView.backgroundColor = .customWhite
                cell.lblTitle.textColor = .customBlack
                cell.lblTitle.text = indexData?.name
            }
            return cell
        }else{
            if indexPath.item == self.mediaItems.count && self.mediaItems.count < 9{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImgXIB", for: indexPath) as! AddImgXIB
                
                return cell
            }else{
                let item = mediaItems[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemXIB", for: indexPath) as! PostItemXIB
                
                cell.lblCoverPhoto.isHidden = indexPath.item != 0
                
                cell.btnDelete.tag = indexPath.item
                cell.btnDelete.addTarget(self, action: #selector(btnRemoveImage_Clicked(sender:)), for: .touchUpInside)
                switch item {
                case .photo(let image,let imageString ):
                    if imageString.isEmpty == false{
                        cell.imgProduct.kf.setImage(with: URL(string: imageString),placeholder: PlaceHolderImage)
                    }else{
                        cell.imgProduct.image = image
                    }
                    return cell
                    
                case .video(let image, let thumbnail):
                    cell.imgProduct.image = thumbnail
                    return cell
                }
                //            if indexPath.item < (self.productImage.count + self.productVideo.count)  {
                //                cell.lblCoverPhoto.isHidden = indexPath.item != 0
                //                cell.imgProduct.contentMode = .scaleAspectFill
                //
                //                if let url = self.productImage[indexPath.item]["image_url"] as? String {
                //                    if let image  = URL.init(string: url){
                //
                //                        cell.imgProduct.kf.setImage(with: image,placeholder: PlaceHolderImage)
                //                    }
                //                }
                //                if let image = self.productImage[indexPath.item]["image_url"] as? UIImage {
                //                    cell.imgProduct.image = image
                //                }
                //
                //                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if indexPath.item == 7 {
        //            self.titleImageVideo = "Choose Existing Video"
        //            self.isCamera = false
        //            //                self.showActionSheet()
        //            self.selectindex = indexPath.item
        //        }
        //        else{
        //            self.titleImageVideo = "Choose Existing Photo"
        //            self.isCamera = true
        //            //                self.showActionSheet()
        //            self.selectindex = indexPath.item
        //        }
        if collectionView == self.styleCollection{
            let indexData = self.styles?[indexPath.item]
            self.selectedStyleID = indexData?.id ?? 0
            self.styleCollection.reloadData()
        }else{
            self.selectindex = indexPath.item
            if indexPath.item == self.mediaItems.count{
                self.imagePicker()
            }
            self.CVAddProductImage.reloadItems(at: [indexPath])
        }
    }
    
    @objc func btnRemoveImage_Clicked(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint(x: 0, y: 0), to: self.CVAddProductImage)
        let item = mediaItems[sender.tag]
        var msg = ""
        switch item {
        case .photo(let image,let imageString ):
            msg = "Are you sure you want to remove image?"
            
        case .video(let image, let thumbnail):
            msg = "Are you sure you want to remove video?"
            
        }
        if let indexPath = self.CVAddProductImage.indexPathForItem(at: buttonPosition) {
            let alert: UIAlertController = UIAlertController.init(title: AlertViewTitle, message: msg, preferredStyle: .alert)
            alert.setAlertButtonColor()
            let yesAction: UIAlertAction = UIAlertAction.init(title: "Remove", style: .default, handler: { (action) in
                //                self.productImage.remove(at: indexPath.item)
                //                let object = self.postDetails?.images
                //                self.deleteImageId.append(String(object?[indexPath.item].id ?? 0))
                self.mediaItems.remove(at: sender.tag)
                if self.mediaItems.isEmpty{
                    self.btnAddImage.isHidden = false
                    self.CVAddProductImage.isHidden = true
                }
                self.CVAddProductImage.reloadData()
            })
            let noAction: UIAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: { (action) in
            })
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension PostDetailsVC : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtBrandDesignerName {
            let viewController = FavouriteBrandSearchViewController.instantiate(fromStoryboard: .Main)
            viewController.favouriteBrandDeleget = self
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true, completion: nil)
            return false
        }else if textField == txtLocation{
            self.btnLocation_Clicked()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtModelTitle {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // This dismisses the keyboard
        return true
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

extension PostDetailsVC : FavouriteBrandSearchDelegate {
    func FavouriteBrandSearchAddd( brand: BrandeSearchModel) {
        self.brandSearchList = brand
        self.txtBrandDesignerName.text = self.brandSearchList?.name
        self.txtModelTitle.text = "\(self.txtBrandDesignerName.text ?? "") \(self.selectSubcategory?.name ?? "")"
    }
}

extension PostDetailsVC : BrandLocationDelegate ,StorePostLocationDelegate,UserLocationDelegate{
    
    func btnLocation_Clicked() {
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
            //            let viewController = UserLocationViewController.instantiate(fromStoryboard: .Main)
            //            if edit {
            //                viewController.edit = edit
            //                if appDelegate.userDetails?.role_id == 1 {
            //                    viewController.addresslist = self.selectAddress
            //                }else{
            //                    viewController.addresslist = self.addresslist
            //                }
            //            }
            //            else {
            //                viewController.addresslist = payaddress
            //            }
            //
            //            viewController.locationdelegate = self
            //            viewController.isPost = true
            //            self.navigationController?.pushViewController(viewController, animated: true)
            let viewController = MapLocationVC.instantiate(fromStoryboard: .Dashboard)
            self.pushViewController(vc: viewController)
        }
        else if appDelegate.userDetails?.role_id == 2 {
            
            let viewController = StorePostAddLocationViewController.instantiate(fromStoryboard: .Main)
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
            let viewController = BrandLocationViewController.instantiate(fromStoryboard: .Main)
            
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

extension PostDetailsVC: UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    // MARK: UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.item != self.mediaItems.count{
            let item = self.mediaItems[indexPath.item]
            let itemProvider: NSItemProvider
            
            switch item {
            case .photo(_, let imageString):
                itemProvider = NSItemProvider(object: imageString as NSString)
            case .video(let urlString, _):
                if let url = URL(string: urlString) {
                    itemProvider = NSItemProvider(object: url as NSURL)
                } else {
                    return [] // If the URL conversion fails, return an empty array to avoid a crash
                }
            }
            
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }else{
            return []
        }
    }
    
    // MARK: UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        // Ensure only local drag items are handled
        if coordinator.proposal.operation == .move {
            var correctedDestinationIndex = destinationIndexPath.item
            let itemCount = collectionView.numberOfItems(inSection: destinationIndexPath.section)
            
            if correctedDestinationIndex >= itemCount {
                correctedDestinationIndex = itemCount - 1
            }
            
            for item in coordinator.items {
                if let sourceIndexPath = item.sourceIndexPath {
                    collectionView.performBatchUpdates({
                        let movedItem = self.mediaItems.remove(at: sourceIndexPath.item)
                        
                        if correctedDestinationIndex > sourceIndexPath.item {
                            correctedDestinationIndex -= 1
                        }
                        
                        self.mediaItems.insert(movedItem, at: correctedDestinationIndex)
                        collectionView.moveItem(at: sourceIndexPath, to: IndexPath(item: correctedDestinationIndex, section: destinationIndexPath.section))
                    })
                    
                    coordinator.drop(item.dragItem, toItemAt: IndexPath(item: correctedDestinationIndex, section: destinationIndexPath.section))
                }
            }
            
            // Refresh the cells at affected indices
            collectionView.reloadItems(at: [IndexPath(item: correctedDestinationIndex, section: destinationIndexPath.section), destinationIndexPath])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.localDragSession != nil
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}


extension PostDetailsVC{
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
}
extension PostDetailsVC: UICollectionViewDelegateFlowLayout {
    
    fileprivate var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate var itemsPerRow: CGFloat {
        return 2
    }
    
    fileprivate var itemsPerStyleRow: CGFloat {
        return 3
    }
    
    fileprivate var interitemSpace: CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //
        if collectionView == self.styleCollection {
            let sectionPadding = sectionInsets.left * (itemsPerStyleRow + 1)
            let interitemPadding = max(0.0, itemsPerStyleRow - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / itemsPerStyleRow
            return CGSize(width: widthPerItem, height: 55)
        }
        else{
            let sectionPadding = sectionInsets.left * (5 + 1)
            let interitemPadding = max(0.0, 5 - 1) * interitemSpace
            let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
            let widthPerItem = availableWidth / 3
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
        
        
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

extension PostDetailsVC{
    func removeBrandName(from text: String, brand: String) -> String {
        return text //.replacingOccurrences(of: brand, with: "", options: .caseInsensitive)
    }
    
}
