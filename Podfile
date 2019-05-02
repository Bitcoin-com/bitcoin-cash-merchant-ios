source 'https://github.com/Bitcoin-com/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'

def testing
  # Pods for testing
  pod 'RxBlocking'
  pod 'RxTest'
  pod 'Quick'
  pod 'Nimble'
end

abstract_target 'All' do
    use_frameworks!

    # Pods for all targets
    pod 'BDCKit',           :git => 'https://github.com/bitcoin-com/bdc-kit-ios', :branch => 'master'
    pod 'RxSwift',          '~> 4.0'
    pod 'RxCocoa',          '~> 4.0'
    pod 'Moya/RxSwift',     '~> 11.0'
    pod 'BitcoinKit',       '~> 1.1.1'
    pod 'lottie-ios',       '~> 2.5.2'
    pod 'RealmSwift'
    pod 'RxRealm'
    pod 'SwiftWebSocket',   :git => 'https://github.com/tidwall/SwiftWebSocket.git', :branch => 'swift/4.0'

    target 'Merchant' do
        
        target 'MerchantTests' do
            inherit! :search_paths
            testing
        end
    end
end

target 'MerchantUITests' do
    inherit! :search_paths
    testing
end
