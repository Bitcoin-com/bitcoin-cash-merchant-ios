Pod::Spec.new do |spec|
  spec.name = 'BitcoinKit'
  spec.version = '1.1.0'
  spec.summary = 'Bitcoin(BCH/BTC) protocol toolkit for Swift'
  spec.description = <<-DESC
                       The BitcoinKit library is a Swift implementation of the Bitcoin(BCH/BTC) protocol. This library was originally made by Katsumi Kishikawa, and now is maintained by Yenom Inc. It allows maintaining a wallet and sending/receiving transactions without needing a full blockchain node. It comes with a simple wallet app showing how to use it.
                       ```
                    DESC
  spec.homepage = 'https://github.com/yenom/BitcoinKit'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'BitcoinKit developers' => 'usatie@yenom.tech' }

  spec.requires_arc = true
  spec.source = { git: 'https://github.com/yenom/BitcoinKit.git', tag: "v#{spec.version}" }
  spec.source_files = 'BitcoinKit/**/*.{h,m,swift}', 'Sources/BitcoinKit/**/*.{h,m,swift}'
  spec.private_header_files = 'BitcoinKit/**/BitcoinKitPrivate.h'
  spec.exclude_files = 'Sources/**/LinuxSupport.swift'
  spec.module_map = 'BitcoinKit/BitcoinKit.modulemap'
  spec.ios.deployment_target = '12.0'
  spec.swift_version = '5.0'

  # Prebuilt secp256k1 + OpenSSL (libcrypto), packaged as XCFrameworks containing
  # device (ios-arm64) and simulator (ios-arm64) slices. Built via
  # `sh setup/build_xcframeworks.sh`. CocoaPods auto-selects the correct slice
  # and wires up header + library search paths, so no prepare_command is needed.
  spec.vendored_frameworks = 'Libraries/secp256k1.xcframework', 'Libraries/openssl.xcframework'

  # `import secp256k1` (in BitcoinKitPrivateSwift.swift) resolves to the Clang
  # module declared in Libraries/secp256k1/module.modulemap. The actual library
  # is linked from secp256k1.xcframework above; this just exposes the C API to Swift.
  #
  # Because `secp256k1` is a transitive module dependency of the BitcoinKit module,
  # the app target ALSO needs the module map on its SWIFT_INCLUDE_PATHS when it
  # imports BitcoinKit. So the path must be valid in the app's build context too:
  # ${PODS_TARGET_SRCROOT} is undefined there, so use a ${PODS_ROOT}-relative path
  # and apply it via BOTH pod_target_xcconfig (building the pod) and
  # user_target_xcconfig (building the app). Same string in both → one canonical
  # module map location for Clang.
  secp256k1_dir = '"${PODS_ROOT}/../LocalPods/BitcoinKit/Libraries/secp256k1"'
  spec.pod_target_xcconfig = { 'SWIFT_WHOLE_MODULE_OPTIMIZATION' => 'YES',
                               'APPLICATION_EXTENSION_API_ONLY' => 'YES',
                               'SWIFT_INCLUDE_PATHS' => secp256k1_dir,
                               'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/../LocalPods/BitcoinKit/Libraries/openssl/include" "${PODS_ROOT}/../LocalPods/BitcoinKit/Libraries/secp256k1/include"',
                               'OTHER_SWIFT_FLAGS' => '-D BitcoinKitXcode' }
  spec.user_target_xcconfig = { 'SWIFT_INCLUDE_PATHS' => secp256k1_dir }
  spec.preserve_paths = ['setup', 'Libraries']
end
