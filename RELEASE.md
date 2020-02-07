# How to Release?

* Add new version in `CHANGELOG.md` with keywords `New, Fixed, Improved`
* Update version number in `Fastfile` 
* Run `bundle exec fastlane release` which will automatically...
    * set version and build number
    * commit the changes 
    * tag the commit with version number
* Push latest commit with tag to origin which will automatically...
    * trigger GitHub Actions to create a GitHub release with changelog

## TestFlight

* Run `bundle exec fastlane beta`

## AppStore

* Add new version in AppStoreConnect
* (optional) Add new keywords
* (optional) Update screenshots, generate them with `bundle exec fastlane screenshots`
* Add build from TestFlight to new version and submit to review
