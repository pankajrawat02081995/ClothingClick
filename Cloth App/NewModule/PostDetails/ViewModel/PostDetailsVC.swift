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
            
            self.setData()
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
    
    func setData() {
        guard let postDetails = self.postDetails else { return }
        
        // Set brand details
        let brandID = Int(postDetails.brand_id ?? 0)
        let brandDict: [String: Any] = [
            "brand_id": brandID,
            "name": postDetails.brand_name ?? ""
        ]
        self.brandSearchList = BrandeSearchModel(JSON: brandDict)
        self.txtBrandDesignerName.text = self.brandSearchList?.name ?? ""
        
        // Set text fields
        self.txtModelTitle.text = postDetails.title ?? ""
        self.txtDescription.text = postDetails.description ?? ""
        
        // Process images
        self.productImage = postDetails.images?.compactMap { ["image_url": $0.image ?? ""] } ?? []
        
        // Process videos
        self.productVideo = postDetails.videos?.compactMap { ["video_url": $0.video ?? ""] } ?? []
        
        // Combine images & videos
        self.combineMediaArrays()
        
        // Enable drag interaction for images
        self.CVAddProductImage.dragInteractionEnabled = self.productImage.count > 1
        
        // Set price details
        self.priceId = String(postDetails.price_type ?? "0")
        if let price = postDetails.price {
            self.txtCADPrice.text = "\(price)"
        }
        
        // Set brand designer name
        if let brandName = self.brandSearchList?.name {
            self.txtBrandDesignerName.text = brandName
        }
        
        // Set address
        if appDelegate.userDetails?.role_id == 1 {
            self.txtLocation.text = self.selectAddress.first??.address ?? ""
        } else {
            self.txtLocation.text = "\(self.selectAddress.count) select location"
        }
        
        // Toggle visibility of product image section
        let hasMedia = !self.productImage.isEmpty || !self.productVideo.isEmpty
        self.CVAddProductImage.isHidden = !hasMedia
        self.btnAddImage.isHidden = hasMedia
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
        mediaItems.removeAll()
        
        Task {
            let imageUrls = productImage.compactMap { $0["image_url"] as? String }
            let images = await fetchImages(from: imageUrls)
            print("Fetched \(images.count) images successfully.")
            
            var newMediaItems: [MediaItem] = []
            
            // Add images
            newMediaItems.append(contentsOf: zip(images, imageUrls).map { image, url in
                .photo(image: image, imageString: url)
            })
            
            // Add videos
            newMediaItems.append(contentsOf: productVideo.compactMap { dict in
                guard let url = dict["video_url"] as? String,
                      let thumbnail = dict["thumbnail"] as? UIImage else { return nil }
                return .video(url: url, thumbnail: thumbnail)
            })
            
            // Update mediaItems and reload collection view on main thread
            DispatchQueue.main.async {
                self.mediaItems = newMediaItems
                self.CVAddProductImage.reloadData()
            }
        }
    }

    
    func fetchImages(from urls: [String]) async -> [UIImage] {
        await withTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            
            for urlString in urls {
                group.addTask {
                    guard let url = URL(string: urlString),
                          let data = try? Data(contentsOf: url),
                          let image = UIImage(data: data) else {
                        return nil
                    }
                    return image
                }
            }
            
            for await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
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
    
    func apiCallWithImageVideoList<T: Mappable>(
        of type: T.Type = T.self,
        isShowHud: Bool,
        URL: String,
        apiName: String,
        parameters: [String: Any],
        images: [UIImage],
        imageParameterName: String,
        imageName: String,
        video: [URL?],
        videoParameterName: String,
        videoName: String,
        completion: @escaping (_ dict: BaseResponseModel<T>?, _ error: NSError?) -> Void
    ) {
        let api_url = URL + apiName
        print("API URL = \(api_url) parameters = \(parameters)")
        
        var headers: HTTPHeaders? = nil
        if !appDelegate.headerToken.isEmpty {
            headers = ["Authorization": "Bearer \(appDelegate.headerToken)"]
        }
        
        if isShowHud {
            KRProgressHUD.show()
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index, image) in images.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 1.0) {
                    multipartFormData.append(imageData, withName: "\(imageParameterName)[\(index)]", fileName: "\(imageName)\(index).png", mimeType: "image/png")
                }
            }
            
            for (index, url) in video.compactMap({ $0 }).enumerated() {
                multipartFormData.append(url, withName: "\(videoParameterName)[\(index)]", fileName: "\(videoName)\(index).mp4", mimeType: "video/mp4")
            }
            
            for (key, value) in parameters {
                if let valueData = "\(value)".data(using: .utf8) {
                    multipartFormData.append(valueData, withName: key)
                }
            }
        }, usingThreshold: 1, to: api_url, method: .post, headers: headers) { encodingResult in
            if isShowHud {
                KRProgressHUD.dismiss()
            }
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        do {
                            guard let responseData = response.data else {
                                completion(nil, NSError(domain: "Empty response data", code: 0, userInfo: nil))
                                return
                            }
                            let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any]
                            let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json ?? [:])
                            
                            if let dataResponse = dataResponse {
                                if dataResponse.status == kIsSuccess {
                                    completion(dataResponse, nil)
                                } else if dataResponse.status == kUserNotFound {
                                    let alert = UIAlertController(title: AlertViewTitle, message: dataResponse.message, preferredStyle: .alert)
                                    alert.setAlertButtonColor()
                                    let hideAction = UIAlertAction(title: kOk, style: .default) { _ in
                                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                    }
                                    alert.addAction(hideAction)
                                    sceneDelegate.window?.rootViewController?.present(alert, animated: true)
                                } else {
                                    completion(nil, NSError(domain: dataResponse.message ?? "Unknown Error", code: dataResponse.status ?? -1, userInfo: nil))
                                }
                            } else {
                                completion(nil, NSError(domain: "Invalid response format", code: 0, userInfo: nil))
                            }
                        } catch {
                            completion(nil, NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil))
                        }
                    
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil, NSError(domain: error.localizedDescription, code: 0, userInfo: nil))
                    @unknown default:
                        completion(nil, NSError(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                }
            
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                completion(nil, NSError(domain: encodingError.localizedDescription, code: 0, userInfo: nil))
            }
        }
    }

    
    func callAddProduct() {
        self.sendproductImage.removeAll()
        var videoURLs = [URL]()
        
        // Extract images and video URLs
        for item in self.mediaItems {
            switch item {
            case .photo(let image, _):
                self.sendproductImage.append(image)
            case .video(let url, _):
                if let validURL = URL(string: url) {
                    videoURLs.append(validURL)
                }
            }
        }
        
        // Collect selected color IDs
        let colorIDs = self.selectColor.compactMap { $0?.id }.map(String.init).joined(separator: ",")
        
        // Collect category and subcategory IDs
        let categoryIDs: String
        if self.edit {
            categoryIDs = self.categorysAndSubCategory.compactMap { $0.category_id }.map(String.init).joined(separator: ",")
        } else {
            categoryIDs = [self.selectCategory?.category_id, self.selectSubcategory?.id]
                .compactMap { $0 }
                .map(String.init)
                .joined(separator: ",")
        }
        
        // Determine price
        let price: String
        if let text = self.txtCADPrice.text {
            price = ["Free", "Best offer", "Trade/Swap"].contains(text) || text.isEmpty ? "0.00" : text
        } else {
            price = "0.00"
        }

        // Extract location details
        var address = "", postalCode = "", latitude = "", longitude = "", city = "", area = ""
        var location = self.addressIdLIst.joined(separator: ",")
        
        if location.contains("\(appDelegate.userDetails?.id ?? 0)") {
            location = ""
            if let selectedAddress = self.selectAddress.first {
                address = selectedAddress?.address ?? ""
                postalCode = selectedAddress?.postal_code ?? ""
                latitude = selectedAddress?.latitude ?? ""
                longitude = selectedAddress?.longitude ?? ""
                city = selectedAddress?.city ?? ""
                area = selectedAddress?.area ?? ""
            }
        }
        
        // Prepare API parameters
        let params: [String: Any] = [
            "brand_id": String(self.brandSearchList?.brand_id ?? 0),
            "gender_id": String(self.savegenderId?.gender_id ?? 0),
            "categories": categoryIDs,
            "sizes": String(self.selectSize?.id ?? 0),
            "condition_id": String(self.selectCondiction?.id ?? 0),
            "colors": colorIDs,
            "title": self.removeBrandName(from: self.txtModelTitle.text ?? "", brand: self.brandSearchList?.name ?? ""),
            "description": self.txtDescription.text ?? "",
            "locations": location,
            "price_type": "1",
            "product_url": self.Producturl,
            "style": self.selectedStyleID ?? 0,
            "price": price,
            "city": city,
            "area": area,
            "longitude": longitude,
            "latitude": latitude,
            "postal_code": postalCode,
            "address": address
        ]
        
        // Check internet connection
        guard appDelegate.reachable.connection != .none else {
            UIAlertController().alertViewWithNoInternet(self)
            return
        }
        
        // Call API
        self.apiCallWithImageVideoList(
            of: PostDetailsModel.self,
            isShowHud: true,
            URL: BASE_URL,
            apiName: APINAME.POST_CREATE.rawValue,
            parameters: params,
            images: self.sendproductImage,
            imageParameterName: "image",
            imageName: "ProductImage",
            video: videoURLs,
            videoParameterName: "video",
            videoName: "ProductVideo"
        ) { response, error in
            guard error == nil, let response = response, let _ = response.dictData else {
                UIAlertController().alertViewWithTitleAndMessage(self, message: error?.domain ?? ErrorMessage)
                return
            }
            
            let alert = UIAlertController(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
            alert.setAlertButtonColor()
            
            let hideAction = UIAlertAction(title: kOk, style: .default) { _ in
                self.tabBarController?.selectedIndex = 4
            }
            alert.addAction(hideAction)
            self.present(alert, animated: true)
        }
    }

    
    func callEditProduct() {
        self.sendproductImage.removeAll()
        var arrVideoList = [URL]()
        
        for item in self.mediaItems {
            switch item {
            case .photo(image: let image, _):
                self.sendproductImage.append(image)
            case .video(url: let url, _):
                if let videoURL = URL(string: url) {
                    arrVideoList.append(videoURL)
                }
            }
        }
        
        let colorArre = self.selectColor.compactMap { $0?.id.map(String.init) }
        
        var categorySubCategoryId = [String]()
        if self.edit {
            categorySubCategoryId = self.categorysAndSubCategory.compactMap { String($0.category_id ?? 0) }
        } else {
            categorySubCategoryId.append(String(self.selectCategory?.category_id ?? 0))
            categorySubCategoryId.append(String(self.selectSubcategory?.id ?? 0))
        }
        
        let category = categorySubCategoryId.joined(separator: ",")
        let colorIdString = colorArre.joined(separator: ",")
        var location = self.addressIdLIst.joined(separator: ",")
        let deletedImage = self.deleteImageId.joined(separator: ",")
        let deletedVideo = self.deleteVideoId.joined(separator: ",")
        
        var address = "", postalcode = "", latitude = "", longitude = "", city = "", area = ""
        
        if location.contains("\(appDelegate.userDetails?.id ?? 0)") {
            location = ""
            if let firstAddress = self.selectAddress.first {
                address = firstAddress?.address ?? ""
                postalcode = firstAddress?.postal_code ?? ""
                latitude = firstAddress?.latitude ?? ""
                longitude = firstAddress?.longitude ?? ""
                area = firstAddress?.city ?? ""
                city = firstAddress?.area ?? ""
            }
        }
        
        let price = (self.txtCADPrice.text?.isEmpty == true || ["Free", "Best offer", "Trade/Swap"].contains(self.txtCADPrice.text)) ? "0.00" : (self.txtCADPrice.text ?? "0")
        
        guard appDelegate.reachable.connection != .none else {
            UIAlertController().alertViewWithNoInternet(self)
            return
        }
        
        let param: [String: Any] = [
            "post_id": "\(self.postDetails?.id ?? 0)",
            "brand_id": "\(self.brandSearchList?.brand_id ?? 0)",
            "gender_id": "\(self.savegenderId?.gender_id ?? 0)",
            "categories": category,
            "sizes": "\(self.selectSize?.id ?? 0)",
            "condition_id": "\(self.selectCondiction?.id ?? 0)",
            "colors": colorIdString,
            "title": self.removeBrandName(from: self.txtModelTitle.text ?? "", brand: self.brandSearchList?.name ?? ""),
            "description": self.txtDescription.text ?? "",
            "locations": location,
            "price_type": "1",
            "style": self.selectedStyleID ?? 0,
            "price": price,
            "deleted_image_ids": deletedImage,
            "deleted_video_ids": deletedVideo,
            "product_url": self.Producturl,
            "city": city,
            "area": area,
            "longitude": longitude,
            "latitude": latitude,
            "postal_code": postalcode,
            "address": address
        ]
        
        print(param)
        
        self.apiCallWithImageVideoList(
            of: PostDetailsModel.self,
            isShowHud: true,
            URL: BASE_URL,
            apiName: APINAME.POSE_EDIT.rawValue,
            parameters: param,
            images: self.sendproductImage,
            imageParameterName: "image",
            imageName: "Productimge",
            video: arrVideoList,
            videoParameterName: "video",
            videoName: "ProductVideo"
        ) { (response, error) in
            if let error = error {
                UIAlertController().alertViewWithTitleAndMessage(self, message: error.domain ?? ErrorMessage)
                return
            }
            
            if let response = response, let data = response.dictData {
                self.postDetails = data
                
                let alert = UIAlertController(title: AlertViewTitle, message: response.message, preferredStyle: .alert)
                alert.setAlertButtonColor()
                
                let hideAction = UIAlertAction(title: kOk, style: .default) { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
                alert.addAction(hideAction)
                sceneDelegate.window?.rootViewController?.present(alert, animated: true)
            }
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
