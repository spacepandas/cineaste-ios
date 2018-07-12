# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

abstract_target 'Cineaste' do
  target 'Cineaste App-Dev'
  target 'Cineaste App'

  pod 'SwiftLint'
  pod 'NearbyMessages'

  target 'CineasteTests' do
    inherit! :search_paths
  end
end

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r(
    'Pods/Target Support Files/Pods-Cineaste-Cineaste App/Pods-Cineaste-Cineaste App-acknowledgements.plist',
    'Cineaste/Settings.bundle/Acknowledgements.plist',
    :remove_destination => true
  )
end
