#!/usr/bin/env bash

update-license-plist() {
    if brew ls --versions "license-plist" >/dev/null; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "license-plist"
    else
        echo "warning: LicensePlist not installed, download from https://github.com/mono0926/LicensePlist"
        exit -1
    fi
}

generate-new-license-plist() {
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

update-swiftlint() {
    if brew ls --versions "swiftlint" >/dev/null; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "swiftlint"
    else
        echo "warning: Swiftlint not installed, download from https://github.com/realm/SwiftLint"
        exit -1
    fi
}

bundle update
bundle exec fastlane snapshot update --force
update-swiftlint
update-license-plist 
generate-new-license-plist
