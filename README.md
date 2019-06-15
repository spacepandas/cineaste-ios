# Cineaste App (iOS)

[![Build Status](https://travis-ci.com/spacepandas/cineaste-ios.svg?branch=master)](https://travis-ci.org/spacepandas/cineaste-ios.svg?branch=master)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)](https://swift.org)
[![license](https://img.shields.io/badge/license-Apache-lightgrey.svg)](https://github.com/spacepandas/cineaste-ios/blob/master/LICENSE)
[![platform](https://img.shields.io/badge/platform-iOS_11+-lightgrey.svg)](https://img.shields.io/badge/platform-iOS_11+-lightgrey.svg)
[![languages](https://img.shields.io/badge/languages-en,_de-lightgrey.svg)](https://img.shields.io/badge/languages-en,_de-lightgrey.svg)

An iOS (and Android) application to manage movies you would like to see and movies you have seen.
You can also start movie nights with your friends. There is no need to register or to add friends.

<a href='https://itunes.apple.com/us/app/cineaste-app/id1402748020'><img alt='Download on the App Store' img src='https://linkmaker.itunes.apple.com/assets/shared/badges/en-us/appstore-lrg.svg' width="152" height="45"/></a>

Check out the [Android client](https://github.com/spacepandas/cineaste-android) on github. It is available on Google Play.

<a href='https://play.google.com/store/apps/details?id=de.cineaste.android&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/apps/en-play-badge.png' height="45px"/></a>

## Screenshots

| Movie Detail      | Search      | Watchlist      | History   | Movie Night      |
|:-----------------:|:-----------:|:--------------:|:---------:|:----------------:|
| All the information you need | Discover new movies | Add movies you want to see to your watchlist | Remember movies you have seen | Find a movie for your movie night with your friends |
| ![movie-detail][] | ![search][] | ![watchlist][] | ![seen][] | ![movie-night][] |

## Dependencies

You can start a movie night via [Nearby][nearbyLink]. Nearby searches for nearby devices and matches their watchlist with yours.
As a result you can see which movie is the most interested one by you and your friends.

We are using [theMovieDb][theMovieDb] to get access to the big movie data universe.

A list of all dependencies can be found in [DEPENDENCIES.md](https://github.com/spacepandas/cineaste-ios/blob/master/DEPENDENCIES.md).

## How to build

0. Run `pod install` in cineaste-ios folder to install all used CocoaPods.
1. Open `Cineaste.xcworkspace` in Xcode (10.2).
2. Get a [theMovieDb][theMovieDb] key and a [Nearby][nearbyLink] key and add them to the ApiKeys data set in the asset catalog under the following path: `Cineaste/Keys.xcassets/ApiKeys.dataset/apikey.plist`.

```xml 
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>MOVIEDB_KEY</key>
	<string>XXXX</string>
	<key>NEARBY_KEY</key>
	<string>XXXX</string>
</dict>
</plist>
```

3. To run the app on one of your devices, you have to navigate to the project settings under targets to the general tab and choose a team to one you are member of. Change the bundle identifier to an identifier linked to your Apple developer account in order to run.
4. Build and run the project.

## License

Cineaste is released under the **Apache License**. Please see the [LICENSE](https://github.com/spacepandas/cineaste-ios/blob/master/LICENSE) file for more information.

[nearbyLink]: https://developers.google.com/nearby/messages/overview
[theMovieDb]: https://www.themoviedb.org/
[Kingfisher]: https://github.com/onevcat/Kingfisher
[movie-detail]: /assets/iPhone%20X-01_watchlist_detail_framed.png
[search]: /assets/iPhone%20X-02_search_framed.png
[watchlist]: /assets/iPhone%20X-03_watchlist_framed.png
[seen]: /assets/iPhone%20X-04_seenList_framed.png
[movie-night]: /assets/iPhone%20X-05_startMovieNight_friendsFound_framed.png
