<p align="center"><a href="https://itunes.apple.com/us/app/cineaste-app/id1402748020"><img src="assets/logo.png" width="250" /></a></p>

<p align="center"><a href="https://itunes.apple.com/us/app/cineaste-app/id1402748020"><img alt='Download on the App Store' src="https://linkmaker.itunes.apple.com/assets/shared/badges/en-us/appstore-lrg.svg" width="150" /></a></p>

# Cineaste App (iOS)

[![Build Status](https://github.com/spacepandas/cineaste-ios/workflows/CI/badge.svg)](https://github.com/spacepandas/cineaste-ios/workflows/CI/badge.svg)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg)](https://swift.org)
[![license](https://img.shields.io/badge/license-Apache-lightgrey.svg)](https://github.com/spacepandas/cineaste-ios/blob/master/LICENSE)
[![platform](https://img.shields.io/badge/platform-iOS_12+-lightgrey.svg)](https://img.shields.io/badge/platform-iOS_12+-lightgrey.svg)
[![languages](https://img.shields.io/badge/languages-en,_de-lightgrey.svg)](https://img.shields.io/badge/languages-en,_de-lightgrey.svg)
[![testflight](https://img.shields.io/badge/Join-TestFlight-blue.svg)](https://testflight.apple.com/join/sAfD3j8m)

Cineaste App is an iOS application to add movies to your watchlist, remember movies you have seen and discover new movies you find interesting.

- Support for all device sizes and device rotation
- Add Countdown Widgets to your home screen
- Use in Dark or Light Mode
- Support for many Accessibility Features, like Voice Over, Dynamic Type, Increase Contrast

![presentation][]

## Dependencies

We are using [theMovieDb][theMovieDb] to get access to the big movie data universe.

A list of all dependencies can be found in [DEPENDENCIES.md](https://github.com/spacepandas/cineaste-ios/blob/master/DEPENDENCIES.md).

## Contribute

- Please report bugs or feature requests with GitHub [issues](https://github.com/spacepandas/cineaste-ios/issues).
- Feel free to submit a Pull Request for bug fixes or new features.

### How to build

1. Open `Cineaste.xcodeproj` in Xcode.
2. Get a [theMovieDb][theMovieDb] key and add it to the ApiKeys data set in the asset catalog under the following path: `Cineaste/Keys.xcassets/ApiKeys.dataset/apikey.plist`.

```xml 
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>MOVIEDB_KEY</key>
	<string>XXXX</string>
</dict>
</plist>
```

3. To run the app on one of your devices, you have to navigate to the project settings under targets to the general tab and choose a team to one you are member of. Change the bundle identifier to an identifier linked to your Apple developer account in order to run.
4. Build and run the project.

## Is there an app for Android?

Yes! You can check out the [Android client](https://github.com/spacepandas/cineaste-android) on GitHub. It's available on Google Play.

<a href='https://play.google.com/store/apps/details?id=de.cineaste.android&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/apps/en-play-badge.png' height="45px"/></a>

## License

Cineaste App is released under the **Apache License**. Please see the [LICENSE](https://github.com/spacepandas/cineaste-ios/blob/master/LICENSE) file for more information.

[theMovieDb]: https://www.themoviedb.org/
[Kingfisher]: https://github.com/onevcat/Kingfisher
[presentation]: /assets/presentation.jpg
