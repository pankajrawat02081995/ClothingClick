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
import TOCropViewController

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
    
    var selectedImagesToCrop: [UIImage] = []
    var croppedImages: [[String: Any]] = []
    var currentImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        registerCollectionViewCells()
        
        if edit {
            setupEditMode()
        } else {
            setupNewMode()
        }
    }
    
    private func setupDelegates() {
        [txtBrandDesignerName, txtModelTitle, txtLocation, txtCADPrice].forEach { $0?.delegate = self }
        
        CVAddProductImage.delegate = self
        CVAddProductImage.dataSource = self
        CVAddProductImage.dragDelegate = self
        CVAddProductImage.dropDelegate = self
        CVAddProductImage.dragInteractionEnabled = true
        
        styleCollection.delegate = self
        styleCollection.dataSource = self
    }
    
    private func registerCollectionViewCells() {
        CVAddProductImage.registerCell(nib: UINib(nibName: "PostItemXIB", bundle: nil), identifier: "PostItemXIB")
        CVAddProductImage.registerCell(nib: UINib(nibName: "AddImgXIB", bundle: nil), identifier: "AddImgXIB")
    }
    
    private func setupEditMode() {
        btnCancel.setImage(UIImage(named: "ic_delete_red"), for: .normal)
        selectedStyleID = postDetails?.style_id ?? 0
        styleCollection.reloadData()
        
        guard let userLocations = postDetails?.locations else { return }
        
        if appDelegate.userDetails?.role_id == 1 {
            selectAddress = userLocations
            addressIdLIst = userLocations.compactMap { "\($0.id ?? 0)" }
        } else {
            addressIdLIst = userLocations.filter { userLocation in
                selectAddress.contains { $0?.id == userLocation.id }
            }.compactMap { "\($0.id ?? 0)" }
        }
        
        setData()
    }
    
    private func setupNewMode() {
        if let subcategoryName = selectSubcategory?.name {
            txtModelTitle.text = "\(brandSearchList?.name ?? "") \(subcategoryName)"
        }
        
        let json = ["address": appDelegate.userLocation?.address ?? "",
                    "latitude" : appDelegate.userLocation?.latitude ?? "",
                    "longitude" : appDelegate.userLocation?.longitude ?? "",
                    "location_ids" : "0",
                    "city" : appDelegate.userLocation?.city ?? "",
                    "postal_code" : appDelegate.userLocation?.postal_code ?? "",
                    "area" : appDelegate.userLocation?.area ?? "",
                    "id" : appDelegate.userDetails?.id ?? 0] as [String : Any]
        let objet = Locations.init(JSON: json)
        selectAddress.removeAll()
        selectAddress.append(objet)
        txtLocation.text = appDelegate.userLocation?.address ?? ""
        
        //        guard let userLocations = appDelegate.userDetails?.locations else { return }
        //
        //        addresslist = userLocations.filter { $0.isPayAddress() || $0.isSelectedAddress() }
        //
        //        if let firstAddress = addresslist.first {
        //            txtLocation.text = firstAddress?.address ?? ""
        //            selectAddress = addresslist
        //            addressIdLIst.append("\(firstAddress?.id ?? 0)")
        //        } else {
        //            txtLocation.text = appDelegate.userLocation?.address == nil ? "\(addresslist.count) select location" : appDelegate.userLocation?.address
        //        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Reload and layout CVAddProductImage
        CVAddProductImage.reloadData()
        CVAddProductImage.layoutIfNeeded()
        collectionViewHeight.constant = CVAddProductImage.contentSize.height
        
        // Reload and layout styleCollection
        styleCollection.reloadData()
        styleCollection.layoutIfNeeded()
        styleCollectionHeight.constant = styleCollection.contentSize.height
        
        self.view.layoutIfNeeded()
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
        self.productImage = postDetails.images?.compactMap { ["image_url": $0.image ?? "","isLocal":false,"id":$0.id ?? 0] } ?? []
        
        // Process videos
        //        self.productVideo = postDetails.videos?.compactMap { ["video_url": $0.video ?? ""] } ?? []
        
        // Combine images & videos
        //        self.combineMediaArrays()
        
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
                print("Access to photo library not granted")
                return
            }
            
            var config = YPImagePickerConfiguration()
            let remainingSlots = 9 - (self.productImage.count + self.productVideo.count)
            
            config.library.maxNumberOfItems = remainingSlots
            config.library.mediaType = .photo
            config.library.defaultMultipleSelection = true
            config.library.preSelectItemOnMultipleSelection = false
            config.library.skipSelectionsGallery = true
            config.wordings.libraryTitle = "Gallery"
            config.wordings.cameraTitle = "Camera"
            config.targetImageSize = YPImageSize.original
            config.showsVideoTrimmer = false
            config.showsPhotoFilters = false
            config.startOnScreen = .library
            config.screens = [.library, .photo]
            
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking { [unowned self, unowned picker] items, cancelled in
                guard !cancelled else {
                    picker.dismiss(animated: true)
                    return
                }
                
                picker.dismiss(animated: true) {
                    self.selectedImagesToCrop = items.compactMap {
                        if case let .photo(p) = $0 {
                            return p.originalImage
                        }
                        return nil
                    }
                    self.croppedImages = []
                    self.currentImageIndex = 0
                    self.presentNextCropper()
                }
            }
            
            self.present(picker, animated: true)
        }
    }
    
    
    
    func combineMediaArrays() {
        mediaItems.removeAll()
        
        Task {
            var newMediaItems: [MediaItem] = []
            
            // Separate local images (UIImage) and remote image URLs (String)
            let localImages = productImage.compactMap { $0["image_url"] as? UIImage }
            let imageUrls = productImage.compactMap { $0["image_url"] as? String }
            
            // Fetch remote images concurrently
            let fetchedImages = await fetchImages(from: imageUrls)
            print("Fetched \(fetchedImages.count) images successfully.")
            
            // Add local images
            newMediaItems.append(contentsOf: localImages.map { .photo(image: $0, imageString: "") })
            
            // Add fetched images with their URLs
            newMediaItems.append(contentsOf: zip(fetchedImages, imageUrls).map { .photo(image: $0, imageString: $1) })
            
            //            // Add videos
            //            newMediaItems.append(contentsOf: productVideo.compactMap { dict in
            //                guard let url = dict["video_url"] as? String,
            //                      let thumbnail = dict["thumbnail"] as? UIImage else { return nil }
            //                return .video(url: url, thumbnail: thumbnail)
            //            })
            
            // Update UI on main thread
            await MainActor.run {
                self.mediaItems = newMediaItems
                self.CVAddProductImage.reloadData()
            }
        }
    }
    
    func convertToUIImageArray(from productImages: [[String: Any]]) async -> [UIImage] {
        var images: [UIImage] = []
        
        // Separate local images (UIImage) and URLs (String)
        let localImages = productImages.compactMap { $0["image_url"] as? UIImage }
        let imageUrls = productImages.compactMap { $0["image_url"] as? String }
        
        // Append local images directly
        images.append(contentsOf: localImages)
        
        // Fetch images for URLs asynchronously
        //        let fetchedImages = await fetchImages(from: imageUrls)
        //        images.append(contentsOf: fetchedImages)
        
        return images
    }
    
    func fetchImages(from urls: [String]) async -> [UIImage] {
        await withTaskGroup(of: UIImage?.self) { group in
            var images = Array<UIImage?>(repeating: nil, count: urls.count)
            
            // Add download tasks to the group
            for (index, urlString) in urls.enumerated() {
                group.addTask {
                    return await self.downloadImage(from: urlString)
                }
            }
            
            // Collect the results from the task group
            var index = 0
            for await image in group {
                if let image = image {
                    images[index] = image
                }
                index += 1
            }
            
            return images.compactMap { $0 }
        }
    }
    
    private func downloadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error downloading image from \(urlString): \(error)")
            return nil
        }
    }
    
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
    @IBAction func btnPreview_Clicked(_ button: UIButton) {
        
        let viewController = PostPreviewVC.instantiate(fromStoryboard: .Sell)
        viewController.brandSearchList = brandSearchList
        if edit{
            viewController.selectCategorySubCategory = categorysAndSubCategory
        }else{
            viewController.selectSubcategory = selectSubcategory
        }
        
        viewController.addresslist = selectAddress //edit ? selectAddress : addresslist
        viewController.savegenderId = savegenderId
        
        viewController.price = (txtCADPrice.text?.isEmpty ?? true) || txtCADPrice.text == "0" ? "0.00" : txtCADPrice.text!
        viewController.selectColor = selectColor
        viewController.mediaItems = mediaItems
        viewController.selectSize = selectSize
        viewController.discripction = txtDescription.text ?? ""
        viewController.productModelItem = txtModelTitle.text ?? ""
        viewController.edit = edit
        viewController.productImage = self.productImage
        viewController.selectCondiction = selectCondiction
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func btnPost_Clicked(_ button: UIButton) {
        
        //        if self.txtBrandDesignerName.text?.trim().count == 0 {
        //            UIAlertController().alertViewWithTitleAndMessage(self, message: "Please select brand name")
        //            return
        //        }
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
            do {
                // Call the async method using await
                Task{
                    await self.callEditProduct()
                }
            } catch {
                // Handle any errors
                print("Error: \(error)")
            }
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
            do {
                // Call the async method using await
                Task{
                    await self.callAddProduct()
                }
            } catch {
                // Handle any errors
                print("Error: \(error)")
            }
        }
        print("don")
    }
    
    
}


extension PostDetailsVC{
    
    func removeImage(index:Int){
        debugPrint(self.productImage[index]["id"] as? Int ?? 0)
        let param =  ["image_id":self.productImage[index]["id"] as? Int ?? 0,"post_id":self.postDetails?.id ?? 0]
        
        if appDelegate.reachable.connection != .unavailable {
            APIManager().apiCall(of: FaqModel.self, isShowHud: true, URL: BASE_URL, apiName: APINAME.REMOVE_IMAGE.rawValue, method: .post, parameters: param) { (response, error) in
                if error == nil {
                    if let response = response {
                        UIAlertController().alertViewWithTitleAndMessage(self, message: response.message ?? ""){
                            self.productImage.remove(at: index)
                            self.CVAddProductImage.reloadData()
                        }
                    }
                }
                else {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error!.domain)
                }
            }
        }
    }
    
    func apiCallWithImageVideoList<T: Mappable>(
        of type: T.Type = T.self,
        isShowHud: Bool,
        URL: String,
        apiName: String,
        parameters: [String: Any],
        images: [Data],
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
            //        KRProgressHUD.show()
            LoaderManager.shared.show()
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (index, image) in images.enumerated() {
                multipartFormData.append(image, withName: "\(imageParameterName)[\(index)]", fileName: "\(imageName)\(index).png", mimeType: "image/png")
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
            
            debugPrint("test : \(encodingResult)")
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        do {
                            guard let responseData = response.data else {
                                //            KRProgressHUD.dismiss()
                                LoaderManager.shared.hide()
                                completion(nil, NSError(domain: "Empty response data", code: 0, userInfo: nil))
                                return
                            }
                            let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any]
                            let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json ?? [:])
                            
                            if let dataResponse = dataResponse {
                                if dataResponse.status == kIsSuccess {
                                    //            KRProgressHUD.dismiss()
                                    LoaderManager.shared.hide()
                                    completion(dataResponse, nil)
                                } else if dataResponse.status == kUserNotFound {
                                    let alert = UIAlertController(title: AlertViewTitle, message: dataResponse.message, preferredStyle: .alert)
                                    alert.setAlertButtonColor()
                                    let hideAction = UIAlertAction(title: kOk, style: .default) { _ in
                                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                    }
                                    alert.addAction(hideAction)
                                    //            KRProgressHUD.dismiss()
                                    LoaderManager.shared.hide()
                                    sceneDelegate.window?.rootViewController?.present(alert, animated: true)
                                } else {
                                    //            KRProgressHUD.dismiss()
                                    LoaderManager.shared.hide()
                                    completion(nil, NSError(domain: dataResponse.message ?? "Unknown Error", code: dataResponse.status ?? -1, userInfo: nil))
                                }
                            } else {
                                //            KRProgressHUD.dismiss()
                                LoaderManager.shared.hide()
                                completion(nil, NSError(domain: "Invalid response format", code: 0, userInfo: nil))
                            }
                        } catch {
                            //            KRProgressHUD.dismiss()
                            LoaderManager.shared.hide()
                            completion(nil, NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        //            KRProgressHUD.dismiss()
                        LoaderManager.shared.hide()
                        completion(nil, NSError(domain: error.localizedDescription, code: 0, userInfo: nil))
                    @unknown default:
                        //            KRProgressHUD.dismiss()
                        LoaderManager.shared.hide()
                        completion(nil, NSError(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                //            KRProgressHUD.dismiss()
                LoaderManager.shared.hide()
                
                completion(nil, NSError(domain: encodingError.localizedDescription, code: 0, userInfo: nil))
            @unknown default:
                //            KRProgressHUD.dismiss()
                LoaderManager.shared.hide()
            }
        }
    }
    
    /// Resize and compress images efficiently
    func resizeAndCompressImages(
        _ images: [UIImage],
        maxSizeKB: Int = 500,
        targetWidth: CGFloat = 1024,
        completion: @escaping ([Data]) -> Void
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            var compressedImages: [Data] = []
            
            for image in images {
                if let compressedData = image.compressImage(maxSizeKB: maxSizeKB, targetWidth: targetWidth) {
                    compressedImages.append(compressedData)
                }
            }
            
            DispatchQueue.main.async {
                completion(compressedImages)
            }
        }
    }

    
    func callAddProduct() async {
        //        KRProgressHUD.show()
        LoaderManager.shared.show()
        self.sendproductImage.removeAll()
        self.sendproductImage = await self.convertToUIImageArray(from: self.productImage)
        
        resizeAndCompressImages(self.sendproductImage, maxSizeKB: 500) { compressedDataArray in
            // Now upload compressedDataArray (contains reduced-size images)
            
            // Collect selected color IDs
            let colorIDs = self.selectColor.compactMap { $0?.id }.map(String.init).joined(separator: ",")
            
            // Collect category and subcategory IDs
            let categoryIDs: String
            if self.edit {
                categoryIDs = self.categorysAndSubCategory.compactMap { $0.category_id }.map(String.init).joined(separator: ",")
            } else {
                categoryIDs = [self.selectCategory?.category_id, self.selectSubcategory?.category_id]
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
            //            var location = [String:Any]() // self.addressIdLIst.joined(separator: ",")
            if let selectedAddress = self.selectAddress.first {
                //                location["longitude"] = selectedAddress?.longitude ?? ""
                //                location["city"] = selectedAddress?.city ?? ""
                //                location["address"] = selectedAddress?.address ?? ""
                //
                //                location["postal_code"] = selectedAddress?.postal_code ?? ""
                //                location["latitude"] = selectedAddress?.latitude ?? ""
                //                location["area"]  = selectedAddress?.area ?? ""
                
                address = selectedAddress?.address ?? ""
                postalCode = selectedAddress?.postal_code ?? ""
                latitude = selectedAddress?.latitude ?? ""
                longitude = selectedAddress?.longitude ?? ""
                city = selectedAddress?.city ?? ""
                area = selectedAddress?.area ?? ""
                //                location[""]
            }else{
                if let selectedAddress = self.addresslist.first {
                    //                    location["longitude"] = selectedAddress?.longitude ?? ""
                    //                    location["city"] = selectedAddress?.city ?? ""
                    //                    location["address"] = selectedAddress?.address ?? ""
                    //
                    //                    location["postal_code"] = selectedAddress?.postal_code ?? ""
                    //                    location["latitude"] = selectedAddress?.latitude ?? ""
                    //                    location["area"]  = selectedAddress?.area ?? ""
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
                //                "locations": [location],//dictionaryToJsonString(location) ?? "",
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
                images: compressedDataArray,
                imageParameterName: "image",
                imageName: "ProductImage",
                video: [],
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
                    let homeViewController = TabbarViewController.instantiate(fromStoryboard: .Main)
                    homeViewController.selectedIndex = 4
                    homeViewController.hidesBottomBarWhenPushed = true
                    self.navigationController?.setViewControllers([homeViewController], animated: true)
                }
                alert.addAction(hideAction)
                self.present(alert, animated: true)
            }
        }
    }
    
    
    func callEditProduct() async {
        //        KRProgressHUD.show()
        LoaderManager.shared.show()
        // Clear previous images
        self.sendproductImage.removeAll()
        self.sendproductImage = await self.convertToUIImageArray(from: self.productImage)
        
        resizeAndCompressImages(self.sendproductImage, maxSizeKB: 500) { compressedDataArray in
            // Prepare color array
            let colorArre = self.selectColor.compactMap { $0?.id.map(String.init) }
            
            // Prepare category and subcategory IDs
            var categorySubCategoryId = [String]()
            if self.edit {
                categorySubCategoryId = self.categorysAndSubCategory.compactMap { String($0.category_id ?? 0) }
            } else {
                categorySubCategoryId.append(String(self.selectCategory?.category_id ?? 0))
                categorySubCategoryId.append(String(self.selectSubcategory?.category_id ?? 0))
            }
            
            let category = categorySubCategoryId.joined(separator: ",")
            let colorIdString = colorArre.joined(separator: ",")
            //            var location = self.addressIdLIst.joined(separator: ",")
            let deletedImage = self.deleteImageId.joined(separator: ",")
            let deletedVideo = self.deleteVideoId.joined(separator: ",")
            
            // Prepare address-related fields
            var address = "", postalcode = "", latitude = "", longitude = "", city = "", area = ""
            //        if location.contains("\(appDelegate.userDetails?.id ?? 0)") {
            var location = [String:Any]() // self.addressIdLIst.joined(separator: ",")
            if let selectedAddress = self.selectAddress.first {
                //                location["longitude"] = selectedAddress?.longitude ?? ""
                //                location["city"] = selectedAddress?.city ?? ""
                //                location["address"] = selectedAddress?.address ?? ""
                //
                //                location["postal_code"] = selectedAddress?.postal_code ?? ""
                //                location["latitude"] = selectedAddress?.latitude ?? ""
                //                location["area"]  = selectedAddress?.area ?? ""
                
                address = selectedAddress?.address ?? ""
                postalcode = selectedAddress?.postal_code ?? ""
                latitude = selectedAddress?.latitude ?? ""
                longitude = selectedAddress?.longitude ?? ""
                city = selectedAddress?.city ?? ""
                area = selectedAddress?.area ?? ""
                //                location[""]
            }else{
                if let selectedAddress = self.addresslist.first {
                    //                    location["longitude"] = selectedAddress?.longitude ?? ""
                    //                    location["city"] = selectedAddress?.city ?? ""
                    //                    location["address"] = selectedAddress?.address ?? ""
                    //
                    //                    location["postal_code"] = selectedAddress?.postal_code ?? ""
                    //                    location["latitude"] = selectedAddress?.latitude ?? ""
                    //                    location["area"]  = selectedAddress?.area ?? ""
                    address = selectedAddress?.address ?? ""
                    postalcode = selectedAddress?.postal_code ?? ""
                    latitude = selectedAddress?.latitude ?? ""
                    longitude = selectedAddress?.longitude ?? ""
                    city = selectedAddress?.city ?? ""
                    area = selectedAddress?.area ?? ""
                }
            }
            
            // Prepare API parameters
            
            
            // Validate price input
            let price = (self.txtCADPrice.text?.isEmpty == true || ["Free", "Best offer", "Trade/Swap"].contains(self.txtCADPrice.text)) ? "0.00" : (self.txtCADPrice.text ?? "0")
            
            // Check internet connection before proceeding
            guard appDelegate.reachable.connection != .unavailable else {
                UIAlertController().alertViewWithNoInternet(self)
                return
            }
            
            // Prepare parameters for the API request
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
                //                "locations": [location],//dictionaryToJsonString(location) ?? "",
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
            
            // Debug: print the parameters being sent
            print(param)
            
            // Call API to update product with images and videos
            self.apiCallWithImageVideoList(
                of: PostDetailsModel.self,
                isShowHud: true,
                URL: BASE_URL,
                apiName: APINAME.POSE_EDIT.rawValue,
                parameters: param,
                images: compressedDataArray,
                imageParameterName: "image",
                imageName: "Productimge",
                video: [],
                videoParameterName: "video",
                videoName: "ProductVideo"
            ) { (response, error) in
                // Error handling
                if let error = error {
                    UIAlertController().alertViewWithTitleAndMessage(self, message: error.domain ?? ErrorMessage)
                    return
                }
                
                // Handle the response
                if let response = response, let data = response.dictData {
                    self.postDetails = data
                    
                    // Display success alert
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
    
    
}


extension PostDetailsVC: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.styleCollection{
            return self.styles?.count ?? 0
        }else{
            if self.productImage.count < 9{
                return self.productImage.count + 1
            }else{
                return self.productImage.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
            if indexPath.item == self.productImage.count && self.productImage.count < 9 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImgXIB", for: indexPath) as! AddImgXIB
                return cell
            } else {
                let item = self.productImage[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemXIB", for: indexPath) as! PostItemXIB
                
                // ✅ Only show label if this is the first image in the data model
                DispatchQueue.main.async {
                    if indexPath.item == 0 {
                        cell.lblCoverPhoto.isHidden = false
                    } else {
                        cell.lblCoverPhoto.isHidden = true
                    }
                }
                
                
                cell.btnDelete.tag = indexPath.item
                cell.btnDelete.addTarget(self, action: #selector(btnRemoveImage_Clicked(sender:)), for: .touchUpInside)
                
                if item["isLocal"] as? Bool == true {
                    cell.imgProduct.image = item["image_url"] as? UIImage
                } else {
                    cell.imgProduct.setImageFast(with: item["image_url"] as? String ?? "")
                }
                
                return cell
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.styleCollection{
            let indexData = self.styles?[indexPath.item]
            self.selectedStyleID = indexData?.id ?? 0
            self.styleCollection.reloadData()
        }else{
            self.selectindex = indexPath.item
            if indexPath.item == self.productImage.count{
                self.imagePicker()
            }
            //            self.CVAddProductImage.reloadItems(at: [indexPath])
        }
    }
    
    @objc func btnRemoveImage_Clicked(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: CVAddProductImage)
        
        guard let indexPath = CVAddProductImage.indexPathForItem(at: buttonPosition),
              indexPath.item < productImage.count else { return }
        
        let msg = "Are you sure you want to remove image?"
        
        let alert = UIAlertController(title: AlertViewTitle, message: msg, preferredStyle: .alert)
        alert.setAlertButtonColor()
        
        let yesAction = UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            let item = self.productImage[indexPath.item]
            
            if let isLocal = item["isLocal"] as? Bool, !isLocal {
                self.removeImage(index: indexPath.item)
            } else {
                self.productImage.remove(at: indexPath.item)
            }
            
            self.btnAddImage.isHidden = !self.productImage.isEmpty
            self.CVAddProductImage.isHidden = self.productImage.isEmpty
            self.CVAddProductImage.reloadData()
            
            // Optional: If using height constraint
            DispatchQueue.main.async {
                self.CVAddProductImage.layoutIfNeeded()
                self.collectionViewHeight.constant = self.CVAddProductImage.collectionViewLayout.collectionViewContentSize.height
            }
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true)
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

extension PostDetailsVC: BrandLocationDelegate, StorePostLocationDelegate, UserLocationDelegate {
    
    func btnLocation_Clicked() {
        var payaddress = [Locations]()
        
        if edit {
            self.addresslist = self.addresslist.map { address in
                guard let address = address else { return nil }
                var mutableAddress = address // Create a mutable copy
                mutableAddress.is_Selected = self.selectAddress.contains { $0?.id == address.id }
                return mutableAddress
            }
        } else {
            payaddress = self.addresslist.compactMap { ($0?.isPayAddress() == true || $0?.isSelectedAddress() == true) ? $0 : nil }
        }
        
        guard let roleID = appDelegate.userDetails?.role_id else { return }
        
        switch roleID {
        case 1:
            let viewController = MapLocationVC.instantiate(fromStoryboard: .Dashboard)
            viewController.newLocation = { [weak self] location in
                self?.selectAddress.removeAll()
                self?.selectAddress.append(location)
                self?.txtLocation.text = location?.address ?? ""
            }
            viewController.isFromPostDetails = true
            viewController.addressList = self.selectAddress
            self.pushViewController(vc: viewController)
            
        case 2:
            let viewController = StorePostAddLocationViewController.instantiate(fromStoryboard: .Main)
            viewController.addresslist = edit ? self.selectAddress : payaddress
            viewController.storePostlocationdelegate = self
            viewController.selectedAddressList = self.selectAddress
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case 3:
            let viewController = BrandLocationViewController.instantiate(fromStoryboard: .Main)
            if edit { viewController.edit = true } else { viewController.addresslist = payaddress }
            viewController.post = true
            viewController.brandlocationdelegate = self
            viewController.addressId = self.addressIdLIst
            self.navigationController?.pushViewController(viewController, animated: true)
            
        default:
            break
        }
    }
    
    func LocationFormAdddLocation(address: [Locations?]) {
        updateSelectedAddresses(with: address)
        self.txtLocation.text = formattedLocationText()
    }
    
    func LocationFormStorePostLocationAdd(addressLists: [Locations?]) {
        updateSelectedAddresses(with: addressLists)
        self.txtLocation.text = formattedLocationText()
    }
    
    func LocationFormBrandLocationAdd(addressLists: [Locations?]) {
        updateSelectedAddresses(with: addressLists)
        self.txtLocation.text = self.selectAddress.count == 1 ? self.selectAddress.first??.city ?? "" : "\(self.selectAddress.count) Add location"
    }
    
    private func updateSelectedAddresses(with addresses: [Locations?]) {
        self.selectAddress = addresses.compactMap { $0 }
        self.addressIdLIst = self.selectAddress.map { "\($0?.id ?? 0)" }
    }
    
    private func formattedLocationText() -> String {
        guard let firstAddress = self.selectAddress.first else {
            return "\(self.selectAddress.count) Add location"
        }
        
        if let address = firstAddress?.address, let postcode = firstAddress?.postal_code {
            return "\(address) , \(postcode)"
        }
        
        return "\(self.selectAddress.count) Add location"
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

extension PostDetailsVC: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    // MARK: - UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let imageDict = productImage[indexPath.item]
        
        if let isLocal = imageDict["isLocal"] as? Bool, isLocal,
           let image = imageDict["image_url"] as? UIImage {
            let provider = NSItemProvider(object: image)
            let item = UIDragItem(itemProvider: provider)
            item.localObject = imageDict
            return [item]
        } else if let url = imageDict["image_url"] as? String {
            let provider = NSItemProvider(object: url as NSString)
            let item = UIDragItem(itemProvider: provider)
            item.localObject = imageDict
            return [item]
        }
        
        return []
    }
    
    
    // MARK: - UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // Use the default value if destinationIndexPath is nil
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: productImage.count - 1, section: 0)
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                var toIndex = destinationIndexPath.item
                
                // Prevent index out of bounds
                toIndex = min(toIndex, productImage.count - 1)
                
                // If dropping at the same index, no-op
                if sourceIndexPath.item == toIndex {
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    return
                }
                
                // Move the item in the data source and update collection view
                collectionView.performBatchUpdates({
                    let movedItem = productImage.remove(at: sourceIndexPath.item)
                    productImage.insert(movedItem, at: toIndex)
                    collectionView.moveItem(at: sourceIndexPath, to: IndexPath(item: toIndex, section: 0))
                }, completion: { _ in
                    // Reload only affected items after the update
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                })
                
                coordinator.drop(item.dragItem, toItemAt: IndexPath(item: toIndex, section: 0))
            }
        }
    }
    
    
    // MARK: - Helper Method to Calculate Items to Reload
    
    private func getIndexesToReload(from sourceIndex: Int, to toIndex: Int) -> [IndexPath] {
        let maxIndex = productImage.count - 1
        var indexesToReload = [0, sourceIndex, toIndex].filter { $0 <= maxIndex }
        return indexesToReload.map { IndexPath(item: $0, section: 0) }
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        // Optionally hide or adjust the item when drag starts
        if let indexPath = session.items.first?.localObject as? IndexPath {
            collectionView.cellForItem(at: indexPath)?.alpha = 0.0  // Hide the cell temporarily
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        // Optionally show the item again when drag ends
        if let indexPath = session.items.first?.localObject as? IndexPath {
            collectionView.cellForItem(at: indexPath)?.alpha = 1.0  // Show the cell again
        }
    }
    
    
    // MARK: - UICollectionViewDropDelegate: Can Handle Drop
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    // MARK: - UICollectionViewDropDelegate: Handle Drop Feedback
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
}


extension UIImage {
    
    /// Compresses an image to a specific max size while maintaining quality and 4:3 ratio
    func compressImage(maxSizeKB: Int, targetWidth: CGFloat = 1024) -> Data? {
        let maxSizeBytes = maxSizeKB * 1024
        var compressionQuality: CGFloat = 1.0
        
        // ✅ Calculate target height for 4:3 ratio
        let targetHeight = (targetWidth / 4) * 3
        let targetSize = CGSize(width: targetWidth, height: targetHeight)
        
        // ✅ Resize maintaining aspect fit inside 4:3 frame
        let resizedImage = resizeToAspectFit(targetSize: targetSize)
        
        // Compress
        guard let imageData = resizedImage.jpegData(compressionQuality: compressionQuality) else { return nil }
        
        var compressedData = imageData
        
        while compressedData.count > maxSizeBytes && compressionQuality > 0.1 {
            compressionQuality -= 0.1
            if let newData = resizedImage.jpegData(compressionQuality: compressionQuality) {
                compressedData = newData
            }
        }
        
        return compressedData
    }
    
    /// Resizes an image to fit inside a 4:3 box without stretching
    func resizeToAspectFit(targetSize: CGSize) -> UIImage {
        let aspectWidth = targetSize.width / size.width
        let aspectHeight = targetSize.height / size.height
        let aspectRatio = min(aspectWidth, aspectHeight) // ✅ fit
        
        let newSize = CGSize(width: size.width * aspectRatio, height: size.height * aspectRatio)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            // Center the image inside the 4:3 box
            let x = (targetSize.width - newSize.width) / 2
            let y = (targetSize.height - newSize.height) / 2
            draw(in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
        }
    }
}


func dictionaryToJsonString(_ dict: [String: Any]) -> String? {
    guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
        return nil
    }
    return String(data: jsonData, encoding: .utf8)
}

extension PostDetailsVC: TOCropViewControllerDelegate {
    
    // MARK: - Crop Flow
    func presentNextCropper() {
        guard currentImageIndex < selectedImagesToCrop.count else {
            // All images cropped – update data and UI
            DispatchQueue.main.async {
                self.productImage += self.croppedImages
                self.btnAddImage.isHidden = true
                self.CVAddProductImage.isHidden = false
                
                self.CVAddProductImage.reloadData()
                self.CVAddProductImage.layoutIfNeeded()
                self.collectionViewHeight.constant = self.CVAddProductImage.collectionViewLayout.collectionViewContentSize.height
                
                if self.productImage.count > 1 {
                    self.CVAddProductImage.dragInteractionEnabled = true
                }
            }
            return
        }
        
        let image = selectedImagesToCrop[currentImageIndex]
        let cropVC = TOCropViewController(croppingStyle: .default, image: image)
        cropVC.aspectRatioPreset = .preset4x3
        cropVC.aspectRatioLockEnabled = true
        cropVC.delegate = self
        self.present(cropVC, animated: true)
    }
    
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        // Append without triggering UI changes yet
        self.croppedImages.append(["image_url": image, "isLocal": true])
        
        cropViewController.dismiss(animated: true) {
            self.currentImageIndex += 1
            self.presentNextCropper()
        }
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            self.currentImageIndex += 1
            self.presentNextCropper()
        }
    }
}
