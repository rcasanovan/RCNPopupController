#
# Be sure to run `pod lib lint RCNPopupController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
  spec.name             = 'RCNPopupController'
  spec.version          = '1.0.3'
  spec.summary          = 'A versatile Swift popup for iOS'

  spec.description      = <<-DESC
  RCNPopupController is a simple Swift class to show a custom popup in a different ways with different effects. You can customise where the popup will appear and which effect you want to apply.
  
  The class is based on CNPPopupController.
                       DESC

  spec.homepage               = 'https://github.com/rcasanovan/RCNPopupController'
  spec.license                = { :type => 'MIT', :file => 'LICENSE' }
  spec.author                 = { "Ricardo Casanova" => "ricardo.casanova@outlook.com" }
  spec.ios.deployment_target  = '9.3'
  spec.swift_version          = '5.0'
  spec.source                 = { :git => "https://github.com/rcasanovan/RCNPopupController.git", :tag => "#{spec.version}" }
  spec.source_files           = "RCNPopupController/**/*.{h,m,swift}"
end
