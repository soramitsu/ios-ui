
Pod::Spec.new do |spec|

  spec.name         = "SoraUIKit"
  spec.version      = "1.1.9"
  spec.summary      = "A short description of SoraUIKit."
  spec.description  = "Soramitsu UI framework"
  spec.homepage     = "https://soramitsu.co.jp/"

  spec.license      = "MIT"
  spec.author    = "Ivan Shlyapkin"
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target  = '13.0'
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/soramitsu/ios-ui.git", :tag => "1.1.9" }

  spec.source_files  = "SoraUIKit/SoraUIKit/**/*.{h,m,swift}"
  spec.exclude_files = "SoraUIKitTests"
end
