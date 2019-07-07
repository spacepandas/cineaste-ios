platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

# Workaround for duplicate output file, which results in build error in Xcode 11: 
# https://github.com/CocoaPods/CocoaPods/issues/8122#issuecomment-502613963
install! 'cocoapods', :disable_input_output_paths => true

target 'Cineaste App' do
  pod 'SwiftLint'
  pod 'NearbyMessages'
  pod 'Kingfisher'
  pod 'ReSwift'

  target 'CineasteTests' do
    inherit! :search_paths
  end
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods-Cineaste App/Pods-Cineaste App-acknowledgements.plist',
    'Cineaste/Settings.bundle/Acknowledgements.plist',
    :remove_destination => true
  )
end
