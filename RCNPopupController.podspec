#
# Be sure to run `pod lib lint RCNPopupController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RCNPopupController'
  s.version          = '1.0.0'
  s.summary          = 'A versatile Swift popup for iOS'

  s.description      = <<-DESC
  RCNPopupController is a simple Swift class to show a custom popup in a different ways with different effects. You can customise where the popup will appear and which effect you want to apply.
  
  The class is based on CNPPopupController.
                       DESC

  s.homepage         = 'https://github.com/rcasanovan/RCNPopupController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Ricardo Casanova'
  s.source           = { :git => 'https://github.com/rcasanovan/RCNPopupController.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/rcasanovan'
  s.ios.deployment_target = '8.0'
  s.source_files = 'RCNPopupController/Classes'
  s.frameworks = 'UIKit'
  s.swift_version = '5.0'
end
