# Uncomment the next line to define a global platform for your project

platform :ios, '13.0'

workspace 'iOSBuildUp.xcworkspace'
inhibit_all_warnings!

target 'App' do
  use_frameworks!
  inherit! :search_paths
  project 'App/App.xcodeproj'

  pod 'SwiftDictionaryCoding'
  
  # Rx
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  pod 'RxOptional'
  pod 'ReactorKit'
  pod 'RxViewController'
  pod 'RxDataSources'
  pod "RxGesture"
  
  pod 'SwiftGen'
  pod 'SwiftLint'
  
  # Sns
  pod 'GoogleSignIn'
  
  # Logger
  pod 'SwiftyBeaver'
  
  # UI
  pod 'SnapKit', '~> 5.0.0'
  pod 'ReusableKit'
  pod 'ManualLayout'
  pod 'M13Checkbox'
  pod 'SVProgressHUD'
  pod 'TagListView', '~> 1.0'
  pod 'Kingfisher'
  pod 'DropDown'
  pod 'BetterSegmentedControl', '~> 2.0'
  pod 'Toaster'
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/RemoteConfig'

  
  post_install do |installer|
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end

