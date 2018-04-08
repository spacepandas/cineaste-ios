# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Cineaste' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'SwiftLint'
  pod 'NearbyMessages'

  # Pods for Cineaste

  target 'CineasteTests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['SwiftLint'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.1'
            end
        end
    end
end

end
