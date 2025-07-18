//
//  StoreRateVC.swift
//  Cloth App
//
//  Created by Pankaj Rawat on 22/05/25.
//

import UIKit
import IBAnimatable
import Photos
import YPImagePicker
import TOCropViewController
import Cosmos

class StoreRateVC: UIViewController {
    
    @IBOutlet weak var rateVIew: CosmosView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var imgStore: AnimatableImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtDescription: CustomTextView!
    
    var isNewImage : Bool?
    var otherUserDetailsData : UserDetailsModel?
    private var selectedImagesToCrop: UIImage = UIImage()
    
    private var viewModel : StoreRateViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StoreRateViewModel(view: self)
        setupData()
        addTapOnImage()
    }
    
    func addTapOnImage(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTappedMethod(_:)))
        imgProduct.isUserInteractionEnabled = true
        imgProduct.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setupData(){
        guard let otherUserDetailsData = otherUserDetailsData else { return }
        lblStoreName.text = otherUserDetailsData.name ?? ""
        lblTitle.text = otherUserDetailsData.username ?? ""
        imgStore.setImageFast(with: otherUserDetailsData.photo ?? "")
    }
    
    @objc func cellTappedMethod(_ sender:AnyObject){
        requestPhotoLibraryAccess { [weak self] isAccess in
            if isAccess{
                self?.presentImagePicker()
            }
        }
    }
    
    @IBAction func reviewOnPress(_ sender: UIButton) {
        if rateVIew.rating < 1 {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: "Please provide a rating before submitting your review.")
        } else if txtDescription.text.trim().isEmpty {
            BaseViewController.sharedInstance.showAlertWithTitleAndMessage(title: AlertViewTitle, message: "Please enter a review description.")
        } else {
            viewModel?.callAddReview()
        }
    }
    
    
    @IBAction func backOnPress(_ sender: UIButton) {
        self.popViewController()
    }
    
}

extension StoreRateVC {
    
    // MARK: - Photo Library Access
    
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
    
    // MARK: - Image Picker
    
    func presentImagePicker() {
        requestPhotoLibraryAccess { [weak self] granted in
            guard granted else {
                print("Access to photo library not granted.")
                return
            }
            guard let self = self else { return }
            
            var config = YPImagePickerConfiguration()

            config.library.mediaType = .photo
            config.library.maxNumberOfItems = 1
            config.library.defaultMultipleSelection = false // ✅ KEY LINE
            config.library.skipSelectionsGallery = true
            config.wordings.libraryTitle = "Gallery"
            config.wordings.cameraTitle = "Camera"
            config.targetImageSize = .original
            config.showsVideoTrimmer = false
            config.showsPhotoFilters = false
            config.startOnScreen = .library
            config.screens = [.library, .photo]
            config.library.preselectedItems = [] // ✅ Safe, but not needed once auto-selection is off

            let picker = YPImagePicker(configuration: config)

            
            picker.didFinishPicking { [weak self, weak picker] items, cancelled in
                guard let self = self, let picker = picker else { return }
                
                picker.dismiss(animated: true) {
                    guard !cancelled else { return }
                    
                    if let image = items.compactMap({ item in
                        if case let .photo(photo) = item {
                            return photo.originalImage
                        }
                        return nil
                    }).first {
                        self.presentCropper(with: image)
                    }
                }
            }
            
            self.present(picker, animated: true)
        }
    }
    
    // MARK: - Crop Flow
    
    func presentCropper(with image: UIImage) {
        let cropVC = TOCropViewController(croppingStyle: .default, image: image)
        cropVC.aspectRatioPreset = .presetSquare
        cropVC.aspectRatioLockEnabled = true
        cropVC.delegate = self
        self.present(cropVC, animated: true)
    }
}

// MARK: - TOCropViewControllerDelegate

extension StoreRateVC: TOCropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: TOCropViewController,
                            didCropTo image: UIImage,
                            with cropRect: CGRect,
                            angle: Int) {
        self.selectedImagesToCrop = image
        self.imgProduct.image = image
        self.imgProduct.contentMode = .scaleAspectFit
        self.isNewImage = true
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController,
                            didFinishCancelled cancelled: Bool) {
        self.isNewImage = false
        cropViewController.dismiss(animated: true)
    }
}


