#!/usr/bin/env bash

update-license-plist() {
    if which license-plist >/dev/null; then
        license-plist \
            --output-path Cineaste/Settings.bundle \
            --package-path Cineaste.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.swift \
            --prefix Acknowledgements \
            --single-page \
            --force
    else
        echo "warning: LicensePlist not installed, download from https://github.com/mono0926/LicensePlist"
        exit -1
    fi
}

bundle update
bundle exec fastlane snapshot update --force
update-license-plist 
