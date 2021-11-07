# Uncomment the next line to define a global platform for your project

platform :ios, '12.0'

workspace 'iOSBuildUp.xcworkspace'
inhibit_all_warnings!

target 'App' do
  use_frameworks!
  inherit! :search_paths
  project 'App/App.xcodeproj'

  pod 'SwiftGen'
  pod 'SwiftLint'

  post_install do |installer|
    
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end

