platform :ios, '12.0'

target 'Merchant' do
  use_frameworks!

  # Pods for Merchant
  pod 'RealmSwift'
  pod 'BitcoinKit', :path => 'LocalPods/BitcoinKit'
  pod 'OpenSslKit.swift'
  pod 'Amplitude-iOS'
  pod 'RxSwift',          '~> 5'
  pod 'RxCocoa',          '~> 5'
  pod 'Moya/RxSwift',     '~> 14.0.0'

  target 'MerchantTests' do
    inherit! :search_paths
  end

  target 'MerchantUITests' do
  end

end

# Force every pod to build with a modern minimum deployment target. Older pods
# (e.g. Realm 4.3.2) default to iOS 8.0, and anything below iOS 11 tries to link
# `libarclite_*.a`, which was removed in Xcode 15+ ("SDK does not contain
# 'libarclite'"). Bumping to 12.0 (matches the Podfile platform) avoids that.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
