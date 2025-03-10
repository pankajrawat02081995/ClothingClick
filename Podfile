# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'Cloth App' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Cloth App
  pod 'Alamofire', '~> 4.0'
  
  pod 'AlamofireObjectMapper', '~> 5.2'
  
  pod 'SwiftyJSON'
  
  pod 'Firebase'
  
  pod 'FirebaseMessaging'
  
  pod 'Firebase/Analytics'
  
  pod 'Firebase/Crashlytics', '~> 10.5'
  #pod 'Firebase/Core'
  
  #pod 'Firebase/Analytics'
  
  #pod 'FacebookCore'
  
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
  
  pod "TTRangeSlider"
  
  #pod 'TwitterKit'
  
  #pod 'TwitterCore'
  
  pod 'GrowingTextView'
  #  pod 'StripePaymentSheet'
  pod 'StripePaymentSheet', '~> 24.3.0' # 23.17.1
  
  
  pod "AlignedCollectionViewFlowLayout"
  
  pod 'GooglePlaces'
  
  pod 'GooglePlacePicker'
  
  pod 'CHIPageControl', '~> 0.1.3'
  
  pod 'MercariQRScanner'
  
  pod 'Google-Mobile-Ads-SDK'
  
  pod 'IBAnimatable'
  
  pod 'OTPFieldView'
  
  pod 'YPImagePicker'
  pod 'Cosmos'
  
  pod 'libPhoneNumber-iOS'
  pod 'SDWebImage'

  
  post_install do |installer|
    installer.generated_projects.each do |project|
      project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
          config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
      end
    end
  end
  
  
end
