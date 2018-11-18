#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name                = 'flutter_appnext'
  s.version             = '0.0.1'
  s.summary             = 'Flutter Appnext support'
  s.description         = <<-DESC
Flutter Appnext support
                       DESC
  s.homepage            = 'http://example.com'
  s.license             = { :file => '../LICENSE' }
  s.author              = { 'Your Company' => 'email@example.com' }
  s.source              = { :path => '.' }
  s.source_files        = 'Classes/**/*', 'AppnextIOSSDK/**/*.h'
  s.public_header_files = 'Classes/**/*.h'
  s.header_mappings_dir = 'Classes'
  s.dependency 'Flutter'
  s.vendored_libraries  = [
    'Libs/libAppnextLib.a',
    'Libs/libAppnextSDKCore.a',
    'Libs/libAppnextNativeAdsSDK.a'
  ]
  s.ios.deployment_target = '8.0'
end
