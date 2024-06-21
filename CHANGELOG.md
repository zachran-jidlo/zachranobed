# Changelog

This is a changelog for **ZachranObed** application.

## [1.2.0]
### Added

### Fixed

### Changed
- **ZOB-199** Update notification package to 17.1.2.

### Removed

## [1.1.0]
### Fixed
- **ZOB-98** Change how info banner content is displayed.
- **ZOB-99** Refactor statistics table to support smaller screen sizes.
- **ZOB-100** Add scroll to error manager for food donation form.
- **ZOB-123** Change observation of delivery for displaying the banner for courier arrival.
- **ZOB-158** Hide list header on overview screen when list is empty.

### Changed
- **ZOB-96** Move FAB to overview screen, add button on empty page.
- **ZOB-122** Use Ticker for more precision countdown timer.

## [1.0.1]
### Fixed
- **ZOB-155** Fix notification icon for android.
- **ZOB-155** Fix notification icon color for android.
- **ZOB-178** Fix the issue with wrong layout borders on donated food list.

### Changed
- **ZOB-176** Move 'moveBoxes' logic to frontend.

## [1.0.0]
### Added
- **ZOB-91** Add user info item.
- **ZOB-36** Add "Empty page" for the boxes and meal section.
- **ZOB-48** Connected app terms link in menu screen.
- **ZOB-53** Connected partners link in menu screen.
- **ZOB-54** Connected app privacy link in menu screen.

### Changed
- **ZOB-92** Update toolbar in Profile screen.
- **ZOB-105** Add non-prod firebase projects.
- **ZOB-114** Fetch used data from entities and entity pairs collections.
- **ZOB-125** Change FCM tokens location in Firestore.
- **ZOB-114** Fetch user data from entities and entity pairs collections.
- **ZOB-126** Fetch data for dashboard cards.
- **ZOB-129** Fetch data for food boxes table.
- **ZOB-133** Fetch data for offered food.
- **ZOB-134** Write data to deliveries collection.
- **ZOB-135** Fetch data for box movements.
- **ZOB-139** Added domain logic and data connection for app terms.
- **ZOB-150** Update pickup config time from 35min to 45min.
- **ZOB-155** Update notification icon.
- **ZOB-167** Update Android production application ID.
- **ZOB-169** Limiting the donation and shipping history of a box to 1 month.

### Removed
- **ZOB-97** Remove icons from dialog widget.
- **ZOB-147** Remove footer consent from offer food screen.

## [0.3.0]
### Added
- **ZOB-83** Rebuild Home screen after return to application.

### Changed
- **ZOB-80** InfoBanner background color customisation and set to success color.
- **ZOB-90** Update simple menu item with app version by design.

## [0.2.0]
### Added
- **ZOB-45** Debug screen with option to test logger
- **ZOB-88** Build flavors both for Android and iOS

### Changed
- **ZOB-47** Locked screen orientation to portrait mode only
- **ZOB-82** Changed localization for courier timetable
- **ZOB-94** Changed menu icon from `menu` to `person_outline`

## [0.1.0]
### Added
- **ZOB-29** Setup Firebase crashlytics.
- **ZOB-27** New ZOLogger utility for application logging to console and Firebase.
- **ZOB-61** Add visibility property for menu_item widget and hide rate menu item.

### Changed
- **ZOB-86** Minimum date on offer_food_screen is actual date now. Date_time_picker widged now support settings of minimalDate.

## [1.0.0]
### Added
- Initial release of version 1.0.0 for testing
