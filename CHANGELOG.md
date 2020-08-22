# Changelog

# Upcoming Release

## New
* 

## Fixed
* 

## Improved
* 

# 1.21.0

## New
* Drop Support for iOS 11

# 1.20.1

## Improved
* Fix Size of WatchState Badge to be proportional to Width

# 1.20.0

## New
* Remove Google Nearby and the Movie Night Feature ([#137](https://github.com/spacepandas/cineaste-ios/pull/137))

## Improved
* Extract DataSource in SearchViewController

# 1.19.0

## Improved
* Move Search into own Tab ([#134](https://github.com/spacepandas/cineaste-ios/pull/134))

# 1.18.2

## Fixed
* Save selected movie with updated information from network to not load information from the network again when a back navigation was triggered but not completed. 

## Improved
* Display cached poster instead of placeholder image

# 1.18.1

## Fixed
* Fix Shortcut Action when settings tab was selected

# 1.18.0

## New
* Add "Discover Movies" Shortcut on AppIcon to quicker search for currently popular movies

## Improved
* Rename Placeholder for Search Textfield in Watchlist and History

# 1.17.0

## New
* Display Genre in MovieDetail
* Add Spotlight Search for own Movies

# 1.16.0

## New
* Add Support for High Contrast Mode

# 1.15.5

## Fixed
* Show correct Contextual Actions in MovieMatch
* Count Movies in MovieNight correctly

## Improved
* Show existing Movie Information in Movie Detail
* Reload Movie Data when saving a movie

# 1.15.4

## Fixed
* Fix Date Formatter Issues on Import and History for import and export (now really, hopefully)

# 1.15.3

## Improved
* Add LocalizedDescription in ErrorAlert

# 1.15.2

## Fixed
* Fix Date Formatter Issues on Import and History
* Filter Movies in MoviesVC correctly

## Improved
* Add more Contact Information

# 1.15.1

## New
* Add `ReSwiftThunk` to perform side effects

## Fixed
* Import with formatting of WatchedDate
* Styling of SegmentedControl with DynamicType

# 1.15.0

## New
* Add Contextual Menus for iOS 13 devices without 3D Touch ([#121](https://github.com/spacepandas/cineaste-ios/pull/121))

# 1.14.0 

## New
* Introduce ReSwift for easy and testable State Management ([#88](https://github.com/spacepandas/cineaste-ios/pull/88))
* Save movies as json in documents directory instead of using Core Data ([#88](https://github.com/spacepandas/cineaste-ios/pull/88))
* Introduce `SnapshotTesting` as new Dependency with two sample Snapshot Tests ([#115](https://github.com/spacepandas/cineaste-ios/pull/115))

## Fixed
* When using "Invert Colors", posters shouldn't be inverted

# 1.13.1

## Fixed
* Prevent a Crash with handling App Review Prompts and UI Tests differently

# 1.13.0

## New
* Add Dark Mode ([#114](https://github.com/spacepandas/cineaste-ios/pull/114))

## Fixed
* Fix a wrong BackgroundColor for iOS 11.4

## Improved
* Disable Parallax Effect when "Reduce Motion" is enabled

# 1.12.1

## Fixed
* Fix Crash when starting Movie Night: Add Bluetooth Permission Description
* Add Spacing between Disclosure Indicator and Text in Movie Night Screen

# 1.12.0

## Improved
* Update for iOS 13 ([#112](https://github.com/spacepandas/cineaste-ios/pull/112))

# 1.11.0

## Fixed

* Don't change status bar style when tapping "Search" key ([#101](https://github.com/spacepandas/cineaste-ios/pull/101) by @wtimme)
* Disable Smart Quotes in Search Bar ([#102](https://github.com/spacepandas/cineaste-ios/pull/102) by @wtimme)
* Reload Username Row without Animation ([#106](https://github.com/spacepandas/cineaste-ios/pull/106) by @wtimme)

## Improved

* Show "Swipe Action" Hint only three times ([#104](https://github.com/spacepandas/cineaste-ios/pull/104) by @wtimme)
* Reword to indicate a Movie was added, not "watched" ([#108](https://github.com/spacepandas/cineaste-ios/pull/108) by @wtimme)

# 1.10.0

## New

* Add "Add Movie" Button in empty lists

## Improved

* Make TextViews selectable to use accessibility features like "Speak" or "Look up"
* Add two missing accessibility labels

# 1.9.0

## New

* Update your username in the settings

## Fixed

* Display movie titles in search in full length and not trimmed when they are too long

# 1.8.4

## Fixed

* Scroll table view to top when tapping on the tab bar ([#84](https://github.com/spacepandas/cineaste-ios/pull/84) by @xavierLowmiller)

## Improved

* Make description in movie lists bigger
* Higher contrast in tab bar
* Update wording in...
    * empty lists
    * import and export description
    * button in MovieMatch View Controller
    * permissions
    * ask for username alert
* Fix scrolling in settings
* Add configuration for username input textfield

# 1.8.3

## Improved

* Update some wording
* Add minimum width for vote view

# 1.8.2

## Fixed

* Correctly complete Swipe Action after a swipe

# 1.8.1

## Fixed

* Correct behaviour when deleting a movie in Movie Detail

# 1.8.0

## Fixed 

* Let voting information resize correctly in Movie Detail

## Improved

* Renew Layout in Movie Detail ([#82](https://github.com/spacepandas/cineaste-ios/pull/82))

# 1.7.0

## Improved

* Update app to support Accessibility Features like Dynamic Type and Voice Over ([#79](https://github.com/spacepandas/cineaste-ios/pull/79))

# 1.6.1

## Fixed

* Allow shrinking of Hint Label and use nonbreaking Space in voting information ([#76](https://github.com/spacepandas/cineaste-ios/pull/76))

# 1.6.0

## New

* Show a hint for swipe actions in search ([#75](https://github.com/spacepandas/cineaste-ios/pull/75))

# 1.5.0 

## New

* Update Search with a new layout, like an indicator about a movies watch state([#74](https://github.com/spacepandas/cineaste-ios/pull/74))

# 1.4.0

## New

* Reload Movie Details with Pull To Refresh on Movie Lists 
([#67](https://github.com/spacepandas/cineaste-ios/pull/67))

# 1.3.4

## Fixed

* We all know smartphones nowadays perform so well! But we don't want to exaggerate it that much, so we fixed an infinite loop which used a bit too much of the memory - with only three lines of code. Yay!

## Improved

* When you start a movie night, you can now see detailed information for a movie from watchlist of a friend as well.

# 1.3.3

## Fixed

* Update the localizable key for unknown release date
* Layout on smaller devices when nearby permission is denied
* Update localized description when nearby permission is denied

## Improved

* Only animate title when nearby permission is granted
* Resize large title in MovieNightVC

# 1.3.2

## Fixed

* An error when importing a movie without a release date 

## Improved

* Movie night screens, like handling permission of nearby and displaying a live update of used resources of nearby

# 1.3.1

## Fixed

* Fix 3D touch preview in search

## Improved

* Layout, icons, colors, wording

# 1.3.0

## New

* The poster can now be dismissed with a swipe
* You can hide and show the toolbar with a tap in the poster view

## Improved

* When highlighting a cell the orange separator won't change its color anymore.

# 1.2.1 

## Improved

* Add shadow in poster mask in movie detail, especially useful for posters with large white areas

# 1.2.0

## New

* You can search for a specific movie in your movie lists. 
* There is a link in the settings tab, where you can rate the app on the App Store.

## Fixed

* When you pressed very hard on a movie in your search results, you could see a preview of the first movie of the list. This now works as expected. So you see the preview of the movie, on which you pressed very hard. Watch out, this is only available for Force Touch compatible iPhones. ;)

## Improved

* Without searching for a specific movie, you now see more movies, which you can discover in the search, this is due to "pagination".

# 1.1.0

## New

* The release date of the movies is now customized to the region your phone is set to.

## Fixed

* A crash is fixed, when more than one friend left the list of members for a movie night.

## Improved

* The poster in the movie detail is now displayed in original size
* The correct poster will be displayed within the search controller even with bad network connection.
* When starting a movie night for the first time, there is now an explanation about what is happening.

# 1.0.0

## New

* Everything - First release
