/// ترجمات التطبيق - عربي / إنجليزي
class AppStrings {
  final bool isArabic;

  AppStrings(this.isArabic);

  String get loadingItinerary =>
      isArabic ? 'جاري بناء جدول رحلتك...' : 'Building your itinerary...';

  String get exploreJeddah => isArabic ? 'استكشف جدة' : 'Explore Jeddah';

  String get welcomeToJeddah =>
      isArabic ? 'مرحباً بك في جدة' : 'Welcome to Jeddah';

  String get interestsQuestion =>
      isArabic
          ? 'ما هي اهتماماتك السياحية في جدة؟'
          : 'What are your interests in Jeddah?';

  String get selectOneOrMore =>
      isArabic ? 'اختر واحدة أو أكثر للمتابعة' : 'Select one or more to continue';

  String get continueBtn => isArabic ? 'متابعة' : 'Continue';

  String get daysQuestion =>
      isArabic ? 'كم عدد أيام إقامتك؟' : 'How many days will you stay?';

  String get selectDuration =>
      isArabic ? 'اختر المدة المناسبة لرحلتك' : 'Choose the right duration for your trip';

  String get day => isArabic ? 'يوم' : 'day';

  String get days => isArabic ? 'أيام' : 'days';

  String get confirmAndBuild =>
      isArabic ? 'تأكيد وبناء الجدول' : 'Confirm & Build Itinerary';

  String get yourItinerary => isArabic ? 'خطة رحلتك' : 'Your Itinerary';

  String get tipOfDay => isArabic ? 'نصيحة اليوم' : 'Tip of the Day';

  String get placesOfDay => isArabic ? 'أماكن اليوم' : 'Places of the Day';

  String get nextDistance => isArabic ? 'المسافة التالية' : 'Next distance';

  String get km => isArabic ? 'كم' : 'km';

  String get settings => isArabic ? 'الإعدادات' : 'Settings';

  String get editItinerary => isArabic ? 'تعديل خطة الرحلة' : 'Edit Itinerary';

  String get editItineraryDesc =>
      isArabic
          ? 'يمكنك تغيير اهتماماتك أو مدة الإقامة لإنشاء جدول جديد'
          : 'You can change your interests or trip duration to create a new schedule';

  String get editInterests => isArabic ? 'تعديل الاهتمامات' : 'Edit Interests';

  String get editInterestsDesc =>
      isArabic ? 'اختر الفئات السياحية المفضلة لديك' : 'Choose your preferred tourist categories';

  String get changeDays => isArabic ? 'تغيير عدد الأيام' : 'Change Days';

  String get changeDaysDesc =>
      isArabic ? 'حدد مدة إقامتك من 1 إلى 7 أيام' : 'Set your stay duration from 1 to 7 days';

  String get replanFromStart =>
      isArabic ? 'إعادة التخطيط من البداية' : 'Replan from Scratch';

  String get description => isArabic ? 'الوصف' : 'Description';

  String get location => isArabic ? 'الموقع' : 'Location';

  String get openingHours => isArabic ? 'أوقات العمل' : 'Opening Hours';

  String get visitorTips => isArabic ? 'نصيحة للزوار' : 'Visitor Tips';

  String get distanceToNext =>
      isArabic ? 'المسافة للمكان التالي' : 'Distance to next place';

  String get noCoordinates =>
      isArabic ? 'لا توجد إحداثيات للأماكن' : 'No coordinates for places';

  String get dayNum => isArabic ? 'اليوم' : 'Day';

  // Interests
  String get restaurants => isArabic ? 'مطاعم' : 'Restaurants';

  String get hotels => isArabic ? 'فنادق' : 'Hotels';

  String get landmarks => isArabic ? 'معالم سياحية' : 'Landmarks';

  String get events => isArabic ? 'فعاليات' : 'Events';

  String get entertainment => isArabic ? 'أماكن ترفيهية' : 'Entertainment';

  String get nature => isArabic ? 'طبيعة' : 'Nature';

  String get shopping => isArabic ? 'تسوق' : 'Shopping';

  String get language => isArabic ? 'اللغة' : 'Language';

  String get chooseLanguageTitle =>
      isArabic ? 'اختر لغة التطبيق' : 'Choose app language';

  String get chooseLanguageHint =>
      isArabic
          ? 'يمكنك تغييرها لاحقاً من الإعدادات'
          : 'You can change this later in Settings';

  String get arabic => isArabic ? 'العربية' : 'Arabic';

  String get english => isArabic ? 'English' : 'English';

  String interestKey(String key) {
    final map = {
      'مطاعم': restaurants,
      'فنادق': hotels,
      'معالم سياحية': landmarks,
      'فعاليات': events,
      'أماكن ترفيهية': entertainment,
      'طبيعة': nature,
      'تسوق': shopping,
    };
    return map[key] ?? key;
  }

  /// ترجمة نص من قاعدة البيانات (مفتاح الفئة)
  String categoryKey(String arCategory) {
    switch (arCategory) {
      case 'مطاعم':
        return restaurants;
      case 'فنادق':
        return hotels;
      case 'معالم سياحية':
        return landmarks;
      case 'فعاليات':
        return events;
      case 'أماكن ترفيهية':
        return entertainment;
      case 'طبيعة':
        return nature;
      case 'تسوق':
        return shopping;
      default:
        return arCategory;
    }
  }

  /// نصائح عامة (ليست للأماكن)
  List<String> get generalTips => isArabic
      ? [
          'احرص على شرب الماء بشكل مستمر، خصوصاً في الصيف',
          'استخدم الكريم الواقي من الشمس عند التنزه في الخارج',
          'احفظ أرقام الطوارئ السعودية: 911',
          'جرب المأكولات الحجازية التقليدية في جدة البلد',
          'أفضل أوقات التصوير: الفجر والغروب على الكورنيش',
        ]
      : [
          'Stay hydrated, especially in summer',
          'Use sunscreen when outdoors',
          'Save Saudi emergency number: 911',
          'Try traditional Hejazi food in Al-Balad',
          'Best photography times: sunrise and sunset at the corniche',
        ];
}
