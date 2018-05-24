# Cineaste

[![Build Status](https://travis-ci.org/ChristianNorbertBraun/Cineaste.svg?branch=master)](https://travis-ci.org/ChristianNorbertBraun/Cineaste)
[![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org)
[![license](https://img.shields.io/badge/license-Apache-lightgrey.svg)](https://github.com/ChristianNorbertBraun/Cineaste/blob/master/LICENSE)
[![platform](https://img.shields.io/badge/platform-iOS_10+-lightgrey.svg)](https://img.shields.io/badge/platform-iOS_10+-lightgrey.svg)

An iOS (and Android) application to manage movies you would like to see and movies you have seen.
You can also start movie nights with your friends. There is no need to register or to add friends.

Check out the [Android client](https://github.com/marcelgross90/Cineaste) on github. It is available on Google Play.

<a href='https://play.google.com/store/apps/details?id=de.cineaste.android&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/apps/en-play-badge.png' height="45px"/></a>

## Dependencies

You can start a movie night via [Nearby][nearbyLink]. Nearby searches for nearby devices and matches their watchlist with yours.
As a result you can see which movie is the most interested one by you and your friends.

We are using [theMovieDb][theMovieDb] to get access to the big movie data universe.

To enforce swift style and convention and to constantly check our code style, we use [Swiftlint](https://github.com/realm/SwiftLint), which runs on every build phase.

## How to build

0. Run `pod install` in cineaste-ios folder to install all used cocoa pods. 
1. Open `Cineaste.xcworkspace` in Xcode.
2. Get a [theMovieDb][theMovieDb] key and a [Nearby][nearbyLink] key and add it to the `apikey.plist`.
3. To run the app on one of your devices, you have to navigate to the project settings under targets to the general tab and choose a team to one you are member of. Change the bundle identifier to an identifier linked to your Apple developer account in order to run.
4. Build and run the project.

## Open tasks

You can have a look at open [issues](https://github.com/ChristianNorbertBraun/Cineaste/issues).

## License

Cineaste is released under the **Apache License**. Please see the [LICENSE](https://github.com/ChristianNorbertBraun/Cineaste/blob/master/LICENSE) file for more information.

[nearbyLink]: https://developers.google.com/nearby/messages/overview
[theMovieDb]: https://www.themoviedb.org/
