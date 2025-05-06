platform :ios, '13.0'

target 'Cloth App' do
  use_frameworks! :linkage => :static

  # Pods for Cloth App
  pod 'Alamofire', '~> 4.0'
  pod 'AlamofireObjectMapper', '~> 5.2'
  pod 'SwiftyJSON'
  pod 'Firebase'
  pod 'FirebaseMessaging'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics', '~> 10.5'
  pod 'FacebookLogin'
  pod 'FBSDKShareKit'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'IQKeyboardManagerSwift'
  pod 'ReachabilitySwift'
  pod 'KRProgressHUD'
  pod 'Kingfisher'
  pod 'moa'
  pod 'Auk'
  pod 'CarbonKit'
  pod 'TagListView', '~> 1.0'
  pod 'TTRangeSlider'
  pod 'GrowingTextView'
  pod 'StripePaymentSheet', '~> 24.3.0'
  pod 'AlignedCollectionViewFlowLayout'
  pod 'GoogleMaps', :modular_headers => true
  pod 'GooglePlaces', :modular_headers => true
  # ⚠️ Optional: Remove if causing device-only issue
  # pod 'GooglePlacePicker'
  pod 'CHIPageControl', '~> 0.1.3'
  pod 'MercariQRScanner'
  pod 'Google-Mobile-Ads-SDK'
  pod 'IBAnimatable'
  pod 'OTPFieldView'
  pod 'YPImagePicker'
  pod 'Cosmos'
  pod 'libPhoneNumber-iOS'
  pod 'SDWebImage'
  pod 'TOCropViewController'

  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'

          # Fix for Xcode's DT_TOOLCHAIN_DIR issue
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }

          # Exclude arm64 from simulator builds (if needed on Intel Macs)
          config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        end
      end
    end
  end
end
