
Pod::Spec.new do |spec|

  spec.name         = "SoraUIKit"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of SoraUIKit."
  spec.description  = "Soramitsu Swift UI framework"
  spec.homepage     = ""

  spec.license      = "MIT"
  spec.author    = "Ivan Shlyapkin"
  spec.platform     = :ios, "14.0"
  spec.ios.deployment_target  = '14.0'
  spec.swift_version = '5.0'
  spec.source       = { :git => "https://github.com/soramitsu/ios-ui.git", :tag => "1.0.0" }

  spec.source_files  = "SoraUIKit", "SoraUIKit/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"
end
