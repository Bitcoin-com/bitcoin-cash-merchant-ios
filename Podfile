def shared_pods
  pod 'EFQRCode',       '~> 4.3.0'
end

target 'AirWallet' do
  platform :ios, '10.0'

  use_frameworks!

  shared_pods

  # Pods for AirWallet
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'BitcoinKit',      '~> 1.0.2'
  pod 'RxSwift',        '~> 4.0'
  pod 'RxCocoa',        '~> 4.0'
  pod 'Moya/RxSwift',   '~> 11.0'
  pod 'lottie-ios'
  pod 'RealmSwift'
  pod 'FSPagerView'
  pod 'IGIdenticon'
end

target 'AirWallet Watch Extension' do
  platform :watchos, '4.0'
  
  use_frameworks!

  shared_pods
end


