#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_upgrade.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'app_upgrade'
  s.version          = '0.0.1'
  s.summary          = 'app upgrade'
  s.description      = <<-DESC
app upgrade
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'app_upgrade/Sources/app_upgrade/**/*.swift'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
