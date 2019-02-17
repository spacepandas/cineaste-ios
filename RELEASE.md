# How to Release?

## TestFlight

* Update `CHANGELOG.md` with keywords `Fixed, New, Improved`
* Update version number in `Fastfile` 
* Set update text in `Fastfile`
* Run `bundle exec fastlane beta`
* Push latest commit to origin

## AppStore

* Add new version in AppStoreConnect
* (optional) Add new keywords
* (optional) Update screenshots, generate them with `bundle exec fastlane screenshots`
* Add build from TestFlight to new version and submit to review
