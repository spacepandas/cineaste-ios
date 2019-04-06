platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'Cineaste App' do
  pod 'SwiftLint'
  pod 'NearbyMessages'
  pod 'Kingfisher'
  pod 'SwiftMonkeyPaws', '~> 2.1.0', :configuration => 'Debug'
end

target 'CineasteTests' do
  inherit! :search_paths
end

target 'CineasteUITests' do
  pod 'SwiftMonkey', '~> 2.1.0'
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods-Cineaste App/Pods-Cineaste App-acknowledgements.plist',
    'Cineaste/Settings.bundle/Acknowledgements.plist',
    :remove_destination => true
  )
end
