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
        
        guard let userLocations = appDelegate.userDetails?.locations else { return }
        
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
        
        guard let userLocations = appDelegate.userDetails?.locations else { return }
        
        addresslist = userLocations.filter { $0.isPayAddress() || $0.isSelectedAddress() }
        
        if let firstAddress = addresslist.first {
            txtLocation.text = firstAddress?.address ?? ""
            selectAddress = addresslist
            addressIdLIst.append("\(firstAddress?.id ?? 0)")
        } else {
            txtLocation.text = "\(addresslist.count) select location"
        }
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
        self.productImage = postDetails.images?.compactMap { ["image_url": $0.image ?? "","isLocal":false] } ?? []
        
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
            
            // Configure image picker for photos only
            config.library.maxNumberOfItems = remainingSlots
            config.library.mediaType = .photo
            config.library.skipSelectionsGallery = true
            config.library.defaultMultipleSelection = true
            config.wordings.libraryTitle = "Gallery"
            config.wordings.cameraTitle = "Camera"
            config.targetImageSize = YPImageSize.original
            config.showsVideoTrimmer = false  // Disable video-related options
            config.showsPhotoFilters = false
            config.startOnScreen = YPPickerScreen.library
            config.screens = [.library, .photo]
            
            let picker = YPImagePicker(configuration: config)
            
            picker.didFinishPicking { [unowned picker] items, cancelled in
                guard !cancelled else {
                    picker.dismiss(animated: true)
                    return
                }
                
                // Update images array
                var updatedImages = self.productImage
                for item in items {
                    switch item {
                    case .photo(p: let image):
                        updatedImages.append(["image_url": image.originalImage, "isLocal": true])
                    case .video(v: let v):
                        break
                    @unknown default:
                        break
                    }
                    
                }
                
                self.productImage = updatedImages
                self.btnAddImage.isHidden = true
                self.CVAddProductImage.isHidden = false
                self.CVAddProductImage.reloadData()
                self.viewDidLayoutSubviews()
                // self.combineMediaArrays()  // Uncomment if needed for additional processing
                
                picker.dismiss(animated: true)
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
        let fetchedImages = await fetchImages(from: imageUrls)
        images.append(contentsOf: fetchedImages)
        
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
                //                KRProgressHUD.dismiss()
            }
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    switch response.result {
                    case .success:
                        do {
                            guard let responseData = response.data else {
                                KRProgressHUD.dismiss()
                                completion(nil, NSError(domain: "Empty response data", code: 0, userInfo: nil))
                                return
                            }
                            let json = try JSONSerialization.jsonObject(with: responseData) as? [String: Any]
                            let dataResponse = Mapper<BaseResponseModel<T>>().map(JSON: json ?? [:])
                            
                            if let dataResponse = dataResponse {
                                if dataResponse.status == kIsSuccess {
                                    KRProgressHUD.dismiss()
                                    completion(dataResponse, nil)
                                } else if dataResponse.status == kUserNotFound {
                                    let alert = UIAlertController(title: AlertViewTitle, message: dataResponse.message, preferredStyle: .alert)
                                    alert.setAlertButtonColor()
                                    let hideAction = UIAlertAction(title: kOk, style: .default) { _ in
                                        BaseViewController.sharedInstance.clearAllUserDataFromPreference()
                                    }
                                    alert.addAction(hideAction)
                                    KRProgressHUD.dismiss()
                                    sceneDelegate.window?.rootViewController?.present(alert, animated: true)
                                } else {
                                    KRProgressHUD.dismiss()
                                    completion(nil, NSError(domain: dataResponse.message ?? "Unknown Error", code: dataResponse.status ?? -1, userInfo: nil))
                                }
                            } else {
                                KRProgressHUD.dismiss()
                                completion(nil, NSError(domain: "Invalid response format", code: 0, userInfo: nil))
                            }
                        } catch {
                            KRProgressHUD.dismiss()
                            completion(nil, NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil))
                        }
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        KRProgressHUD.dismiss()
                        completion(nil, NSError(domain: error.localizedDescription, code: 0, userInfo: nil))
                    @unknown default:
                        KRProgressHUD.dismiss()
                        completion(nil, NSError(domain: ErrorMessage, code: 0, userInfo: nil))
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription)
                KRProgressHUD.dismiss()
                completion(nil, NSError(domain: encodingError.localizedDescription, code: 0, userInfo: nil))
            @unknown default:
                KRProgressHUD.dismiss()
            }
        }
    }
    
    
    func callAddProduct() async {
        KRProgressHUD.show()
        self.sendproductImage.removeAll()
        self.sendproductImage = await self.convertToUIImageArray(from: self.productImage)
        
        
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
                self.tabBarController?.selectedIndex = 4
            }
            alert.addAction(hideAction)
            self.present(alert, animated: true)
        }
    }
    
    
    func callEditProduct() async {
        KRProgressHUD.show()
        // Clear previous images
        self.sendproductImage.removeAll()
        self.sendproductImage = await self.convertToUIImageArray(from: self.productImage)
        
        // Prepare color array
        let colorArre = self.selectColor.compactMap { $0?.id.map(String.init) }
        
        // Prepare category and subcategory IDs
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
        
        // Prepare address-related fields
        var address = "", postalcode = "", latitude = "", longitude = "", city = "", area = ""
//        if location.contains("\(appDelegate.userDetails?.id ?? 0)") {
            location = ""
            if let firstAddress = self.selectAddress.first {
                address = firstAddress?.address ?? ""
                postalcode = firstAddress?.postal_code ?? ""
                latitude = firstAddress?.latitude ?? ""
                longitude = firstAddress?.longitude ?? ""
                area = firstAddress?.city ?? ""
                city = firstAddress?.area ?? ""
            }
//        }
        
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
        
        // Debug: print the parameters being sent
        print(param)
        
        // Call API to update product with images and videos
        self.apiCallWithImageVideoList(
            of: PostDetailsModel.self,
            isShowHud: true,
            URL: BASE_URL,
            apiName: APINAME.POSE_EDIT.rawValue,
            parameters: param,
            images: self.sendproductImage,
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
            if indexPath.item == self.productImage.count && self.productImage.count < 9{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImgXIB", for: indexPath) as! AddImgXIB
                
                return cell
            }else{
                let item = self.productImage[indexPath.item]
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostItemXIB", for: indexPath) as! PostItemXIB
                
                cell.lblCoverPhoto.isHidden = indexPath.item != 0
                
                cell.btnDelete.tag = indexPath.item
                cell.btnDelete.addTarget(self, action: #selector(btnRemoveImage_Clicked(sender:)), for: .touchUpInside)
                //                switch item {
                //                case .photo(let image,let imageString ):
                //                    if imageString.trim().isEmpty == true{
                //                        cell.imgProduct.image = image
                //                    }else{
                //                        cell.imgProduct.kf.setImage(with: URL(string: imageString),placeholder: PlaceHolderImage)
                //                    }
                //                    return cell
                //
                //                case .video(let image, let thumbnail):
                //                    cell.imgProduct.image = thumbnail
                //                    return cell
                //                }
                if item["isLocal"] as? Bool == true{
                    cell.imgProduct.image = item["image_url"] as? UIImage
                }else{
                    cell.imgProduct.kf.setImage(with: URL(string: item["image_url"] as? String ?? ""),placeholder: PlaceHolderImage)
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
        let buttonPosition = sender.convert(CGPoint.zero, to: self.CVAddProductImage)
        
        guard sender.tag < self.productImage.count, let indexPath = self.CVAddProductImage.indexPathForItem(at: buttonPosition) else { return }
        
        let item = self.productImage[sender.tag]
        let msg: String
        //
        //        switch item {
        //        case .photo:
        msg = "Are you sure you want to remove image?"
        //        case .video:
        //            msg = "Are you sure you want to remove video?"
        //        }
        
        let alert = UIAlertController(title: AlertViewTitle, message: msg, preferredStyle: .alert)
        alert.setAlertButtonColor()
        
        let yesAction = UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            if sender.tag < self.productImage.count {
                self.productImage.remove(at: sender.tag)
            }
            
            self.btnAddImage.isHidden = !self.productImage.isEmpty
            self.CVAddProductImage.isHidden = self.productImage.isEmpty
            self.CVAddProductImage.reloadData()
            self.viewDidLayoutSubviews()
        }
        
        let noAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true)
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
            viewController.addresslist = self.selectAddress
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


extension PostDetailsVC: UICollectionViewDropDelegate, UICollectionViewDragDelegate {
    // MARK: UICollectionViewDragDelegate
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.productImage[indexPath.item]
        let itemProvider = NSItemProvider(object: item as! NSItemProviderWriting )
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
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
                        let movedItem = self.productImage.remove(at: sourceIndexPath.item)
                        
                        if correctedDestinationIndex > sourceIndexPath.item {
                            correctedDestinationIndex -= 1
                        }
                        
                        self.productImage.insert(movedItem, at: correctedDestinationIndex)
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
