# Uncomment the next line to define a global platform for your project

platform :ios, '13.0'

workspace 'iOSBuildUp.xcworkspace'
inhibit_all_warnings!

target 'App' do
  use_frameworks!
  inherit! :search_paths
  project 'App/App.xcodeproj'

  pod 'SwiftGen'
  pod 'SwiftLint'
  pod 'XCoordinator', '~> 2.0'
  pod 'RxSwift', '6.2.0'
  pod 'RxCocoa', '6.2.0'
  pod 'RxOptional'
  pod 'ReactorKit'
  pod 'RxViewController'
  pod 'GoogleSignIn'
  
  pod 'SwiftyBeaver'
  pod 'SnapKit', '~> 5.0.0'
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'

  
  post_install do |installer|
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end

