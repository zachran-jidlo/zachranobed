/// A utility class containing app-wide constant values.
class Constants {
  Constants._();

  /// The offset in minutes for "consume-by" field.
  static const foodConsumeByMinutesOffset = 30;

  // ZOB-305 Food temperature related constants
  static const foodTemperatureMin = 50;
  static const foodTemperatureMax = 100;
  static const foodTemperatureInitial = 68;

  // ZOB-324 Food boxes checkup related constants (in days)
  static const foodBoxesCheckupMaxDelay = 4;
  static const foodBoxesVerifiedThreshold = 3;

  // Email related constants
  static const emailFeedback = 'aplikace.zo@zachranjidlo.cz';

  // URL related constants
  static const urlHomepage = 'https://zachranobed.cz';
  static const urlAppTerms = 'https://zachranobed.cz/wp-content/uploads/2025/07/Podminky_Zachran-jidlo_v.1.1.pdf';
  static const urlAppPrivacy = 'https://docs.google.com/document/d/1NhEGlrN4TgS49HviLkhcF4zCBU3i8w3ITkVQJhtMz-Q/edit';
}
