# Changelog

This is a changelog for **ZachranObed** application.

## [1.8.0]
### Added
- **ZOB-51** Add a generic offline detection and screen.

### Fixed

### Changed
- **ZOB-364** Update Flutter SDK version, Android target & compile SDK and iOS minimum deployment target.

### Removed

## [1.7.0]
### Added
- **ZOB-285** Add and use centralized component for app bar.
- **ZOB-343** Add notifications screen.

### Fixed
- **ZOB-352** Fix logout behavior on Web.
- **ZOB-361** Refresh boxes when switching entity pair.
- **ZOB-362** Fix UI bug on the contacts screen.

### Changed
- **ZOB-313** Remove FCM token after user signs out.

### Removed
- **ZOB-357** Remove `carrierId` property from delivery DTO.

## [1.6.1]
### Fixed
- **ZOB-350** Fix delivery banner logic when food boxes checkup is needed.

## [1.6.0]
### Added
- **ZOB-338** Add new features to deliveries report.

### Changed
- **ZOB-330** Migrate from AppCenter to Firebase App Distribution
- **ZOB-340** Change offer food flow process.
- **ZOB-346** Implement dynamic confirmation time for deliveries.

## [1.5.0]
### Added
- **ZOB-211** Add allergens info bottom sheet on the detail screen.
- **ZOB-318** Add ForceUpdate screen functionality.
- **ZOB-324** Add food boxes checkup flow.
- **ZOB-326** Add a tooltip for allergens.

### Changed
- **ZOB-174** Update date picker to only show calendar view.
- **ZOB-292** Update form layout.
- **ZOB-337** Change copy of the packaged food category.

### Removed
- **ZOB-209** Remove time from detail footer.

## [1.4.0]
### Added
- **ZOB-278** Add web navigation drawer.
- **ZOB-308** Add packaged food category.

### Fixed
- **ZOB-275** Fix error when there are more than 30 meals in delivery.
- **ZOB-321** Fix exception in counter.

### Changed
- **ZOB-273** Adjust web layout for login screen.
- **ZOB-286** Adjust web layout for delivery info banner.
- **ZOB-287** Update image for login background.
- **ZOB-288** Adjust web layout for profile, contacts, change password and debug screens.
- **ZOB-289** Adjust web layout for detail and form screens.
- **ZOB-290** Adjust web layout for thank you screen.
- **ZOB-291** Adjust web layout for app terms screen.
- **ZOB-306** Update UI in box shipping form.
- **ZOB-307** Update web metadata.

## [1.3.0]
### Added
- **ZOB-189** Add multi-pair support for Charity.

### Fixed
- **ZOB-72** Add scroll padding for password field.
- **ZOB-113** Lock Android for portrait screen orientation in Manifest.
- **ZOB-219** Add validation for consume-by date.
- **ZOB-305** Add temperature field for warm meals.

### Changed
- **ZOB-161** Update e-mail address for feedback.
- **ZOB-296** Update allergens UI in food offer form.
- **ZOB-298** Update food categories and box types UI in food offer form.
- **ZOB-300** Update consume-by UI in food offer form.
- **ZOB-301** Add "prepared-at" field for cooled meals.
- **ZOB-302** Add counter field for number of servings and number of boxes.
- **ZOB-304** Update assist chip and error UI.

### Removed
- **ZOB-295** Remove updating delivery state to NOT_USED from application.

## [1.2.1]
### Changed
- **ZOB-283** Update strings related to shipping boxes from charity.

### Fixed
- **ZOB-284** Fix scrolling on food offer overview screen.

## [1.2.0]
### Added
- **ZOB-218** Add reusable contact row. 
- **ZOB-225** Add contacts screen with mocked values. 
- **ZOB-226** Add loading and error states for contacts screen. 
- **ZOB-229** Add banner widget with text.
- **ZOB-230** Add row widget with trailing icon.
- **ZOB-231** Add food offer overview screen and feature.
- **ZOB-258** Add signOut button to home screen when user is not loaded.

### Fixed
- **ZOB-84** Fix display of duplicated messages on allergens field.
- **ZOB-148** Enable / disable ZO logger based in build variant.
- **ZOB-200** Fix the issue with wrong layout borders on food boxes list.
- **ZOB-239** Fix NOT_USED state usage.
- **ZOB-270** Fix food offer overview banner max lines. 

### Changed
- **ZOB-38** Update dashboard visuals.
- **ZOB-40** Update change password validations.
- **ZOB-101** Disable auto-correct for login fields.
- **ZOB-157** Update error fields visuals and error messages.
- **ZOB-181** Change texts and food box icon.
- **ZOB-199** Update notification package to 17.1.2.
- **ZOB-206** Allow to set 0 for allergens.
- **ZOB-214** Change Android launcher icon to rounded.
- **ZOB-223** Use real data for contacts screen.
- **ZOB-237** Change pickup confirmation time for personal delivery.
- **ZOB-260** Change app terms link.
- **ZOB-265** Change current delivery search conditions.
- **ZOB-272** Add position field to contacts.

### Removed
- **ZOB-170** Remove limit in donation and shipping history.

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
