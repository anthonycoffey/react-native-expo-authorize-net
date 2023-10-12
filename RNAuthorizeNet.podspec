require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = "RNAuthorizeNet"
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = "https://github.com/anthonycoffey/react-native-expo-authorize-net"

  s.requires_arc = true
  s.platform     = :ios, "11.0"

  s.source       = { :git => "https://github.com/anthonycoffey/react-native-expo-authorize-net.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/*.{h,m}"

  s.pod_target_xcconfig = {
    "ONLY_ACTIVE_ARCH" => "YES"
  }

  s.dependency "React"
  s.dependency "AuthorizeNetAccept", "~> 0.5.0"
end