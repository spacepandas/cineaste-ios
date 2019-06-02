# Changelog

# 1.9.0

* New: Update your username in the settings
* Fixed: Display movie titles in search in full length and not trimmed when they are too long. 

# 1.8.4

* Improved: Make description in movie lists bigger
* Improved: Higher contrast in tab bar
* Improved: Update wording in...
    * empty lists
    * import and export description
    * button in MovieMatch View Controller
    * permissions
    * ask for username alert
* Improved: Fix scrolling in settings
* Improved: Add configuration for username input textfield

# 1.8.3

* Improved: Update some wording
* Improved: Add minimum width for vote view

# 1.8.2

* Fixed: Correctly complete Swipe Action after a swipe

# 1.8.1

* Fixed: Correct behaviour when deleting a movie in Movie Detail

## 1.8.0

[PR #82](https://github.com/spacepandas/cineaste-ios/pull/82)

* Improved: Renew Layout in Movie Detail
* Fixed: Let voting information resize correctly in Movie Detail

## 1.7.0

[PR #79](https://github.com/spacepandas/cineaste-ios/pull/79)

* Improved: Update app to support Accessibility Features like Dynamic Type and Voice Over.

## 1.6.1

[PR #76](https://github.com/spacepandas/cineaste-ios/pull/76)

* Fixed: Allow shrinking of Hint Label
* Fixed: Use nonbreaking Space in voting information

## 1.6.0

[PR #75](https://github.com/spacepandas/cineaste-ios/pull/75)

* New: Show a hint for swipe actions in search

## 1.5.0 

[PR #74](https://github.com/spacepandas/cineaste-ios/pull/74)

* New: Update Search with a new layout, like an indicator about a movies watch state.

## 1.4.0

[PR #67](https://github.com/spacepandas/cineaste-ios/pull/67)

* New: Reload Movie Details with Pull To Refresh on Movie Lists

## 1.3.4

* Fixed: We all know smartphones nowadays perform so well! But we don't want to exaggerate it that much, so we fixed an infinite loop which used a bit too much of the memory - with only three lines of code. Yay!
* Improved: When you start a movie night, you can now see detailed information for a movie from watchlist of a friend as well.

## 1.3.3

* Fixed: Update the localizable key for unknown release date
* Fixed: Layout on smaller devices when nearby permission is denied
* Fixed: Update localized description when nearby permission is denied
* Improved: Only animate title when nearby permission is granted
* Improved: Resize large title in MovieNightVC

## 1.3.2

* Fixed: An error when importing a movie without a release date 
* Improved: Movie night screens, like handling permission of nearby and displaying a live update of used resources of nearby

## 1.3.1

* Fixed: Fix 3D touch preview in search
* Improved: Layout, icons, colors, wording

## 1.3.0

* New: The poster can now be dismissed with a swipe
* New: You can hide and show the toolbar with a tap in the poster view
* Improved: When highlighting a cell the orange separator won't change its color anymore.

## 1.2.1 

* Improved: Add shadow in poster mask in movie detail, especially useful for posters with large white areas

## 1.2.0

* Fixed: When you pressed very hard on a movie in your search results, you could see a preview of the first movie of the list. This now works as expected. So you see the preview of the movie, on which you pressed very hard. Watch out, this is only available for Force Touch compatible iPhones. ;)
* New: You can search for a specific movie in your movie lists. 
* New: There is a link in the settings tab, where you can rate the app on the App Store.
* Improved: Without searching for a specific movie, you now see more movies, which you can discover in the search, this is due to "pagination".

## 1.1.0

* Fixed: A crash is fixed, when more than one friend left the list of members for a movie night.
* New: The release date of the movies is now customized to the region your phone is set to.
* Improved: The poster in the movie detail is now displayed in original size
* Improved: The correct poster will be displayed within the search controller even with bad network connection.
* Improved: When starting a movie night for the first time, there is now an explanation about what is happening.

## 1.0.0

* New: Everything - First release
