platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'Cineaste App' do
  pod 'SwiftLint'
  pod 'Kingfisher'
  pod 'ReSwift'
  pod 'ReSwiftThunk'

  target 'CineasteTests' do
    inherit! :search_paths
  end

  target 'CineasteSnapshotTests' do
    inherit! :search_paths
    pod 'SnapshotTesting', '~> 1.0'
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
