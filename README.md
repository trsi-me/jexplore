# JExplore — مرشد سياحي ذكي لجدة

تطبيق **Flutter** أكاديمي (مشروع تخرج) يبني **جدولاً سياحياً مخصصاً** لمدينة جدة من خلال اختيار اهتمامات المستخدم ومدة الإقامة، مع دعم **العربية والإنجليزية**، و**خريطة تفاعلية**، وبيانات أماكن منظمة عبر **SQLite** على المنصات الأصلية أو **بيانات مضمّنة** على الويب.

---

## فهرس المحتويات

> روابط ثابتة (`#sec-…`) لتعمل بشكل موثوق على GitHub.

| # | القسم | الوصف |
|---|--------|--------|
| 1 | [نظرة عامة](#sec-overview) | الهدف، الجمهور، نطاق المشروع |
| 2 | [الميزات التقنية](#sec-features) | البرمجة، الواجهة، الخريطة، التدويل |
| 3 | [بنية المشروع](#sec-structure) | شجرة المجلدات والطبقات |
| 4 | [تدفق المستخدم](#sec-flow) | من الافتتاح حتى الخطة |
| 5 | [البيانات: SQLite والويب](#sec-data) | استيراد شرطي ومصدر الأماكن |
| 6 | [قاعدة البيانات](#sec-db) | الجداول، الإصدارات، الإعدادات |
| 7 | [بناء جدول الرحلة](#sec-itinerary) | الفئات، Haversine، الأيام |
| 8 | [الترجمة واللغة](#sec-l10n) | النصوص، الأماكن، التخزين |
| 9 | [الحزم](#sec-deps) | `pubspec` والاعتماديات |
| 10 | [التشغيل المحلي](#sec-run) | أوامر التطوير |
| 11 | [الويب و Render](#sec-render) | البناء والنشر الثابت |
| 12 | [الاختبار والجودة](#sec-quality) | `analyze` و `test` |
| 13 | [مصطلحات تقنية للمبتدئين](#sec-glossary) | شرح مبسّط لكل مصطلح مستخدم |
| 14 | [دليل `main.dart` بالكامل](#sec-main-deep) | `main`، التطبيق، المنزل، الـSplash |
| 15 | [نماذج البيانات](#sec-models) | `Place`، `DayPlan`، الحقول والدوال |
| 16 | [واجهة برمجة `DatabaseHelper`](#sec-db-api) | كل الدوال العامة وجدول الإصدارات |
| 17 | [`ItineraryService` سطراً بسطر](#sec-service-deep) | ترتيب الفئات، العشوائية، المسافة |
| 18 | [الشاشات](#sec-screens-api) | معاملات كل شاشة وسلوكها |
| 19 | [الودجات](#sec-widgets-api) | الخريطة، التفاصيل، النصائح، الشعار |
| 20 | [الثيم `AppTheme` و `AppColors`](#sec-theme-deep) | ألوان وخطوط ومكوّنات Material |
| 21 | [النصوص `AppStrings` و `PlaceTranslations`](#sec-strings-deep) | قائمة الخصائص ودوال الترجمة |
| 22 | [مفاتيح التخزين](#sec-storage-keys) | SQLite مقابل المتصفح |
| 23 | [أمثلة عملية](#sec-examples) | سيناريوهات «ماذا يحدث لو…» |
| 24 | [ملفات إضافية](#sec-misc) | `test`، `render.yaml`، الأصول |

---

<h2 id="sec-overview">1. نظرة عامة</h2>

**JExplore** يوجّه الزائر خطوة بخطوة لاختيار **فئات سياحية** (مطاعم، فنادق، معالم، فعاليات، ترفيه، طبيعة، تسوق)، ثم **عدد أيام الإقامة** (1–7)، فيقوم المحرك الداخلي بـ:

- جلب الأماكن المطابقة للفئات من مصدر البيانات المناسب للمنصة.
- **توزيع الأماكن على الأيام** مع محاولة **تقليل تنقلات غير المنطقية** باستخدام المسافة التقريبية بين الإحداثيات (صيغة Haversine).
- عرض **خطة يوم بيوم** مع خريطة، تفاصيل المكان، ونصائح وزمنية.

المشروع **غير تجاري** ومصمم كأساس تعليمي يوضح: فصل الطبقات، دعم منصات متعددة، تدويل بسيط، وتخزين محلي.

---

<h2 id="sec-features">2. الميزات التقنية</h2>

- **واجهة ثنائية الاتجاه (RTL/LTR)** حسب اللغة المختارة، مع `Directionality` و`MaterialApp` موجهين للعربية السعودية أو الإنجليزية.
- **شاشة اختيار لغة** بعد شاشة الافتتاح (مرة واحدة للمستخدم الجديد)، مع إمكانية تغيير اللغة لاحقاً من لوحة التحكم.
- **مزود نصوص مركزي** (`AppStrings`) + **ترجمات أسماء ووصف الأماكن** (`PlaceTranslations`) عند عرض الواجهة بالإنجليزية مع بقاء المفتاح العربي في قاعدة البيانات.
- **خريطة** عبر `flutter_map` و`latlong2` لعرض مواقع اليوم الحالي.
- **فصل مصدر البيانات** بين **IO** (ملف SQLite على الجهاز) و**Web** (قائمة `Place` مضمّنة في الكود) باستخدام **استيراد شرطي** في Dart.

---

<h2 id="sec-structure">3. بنية المشروع</h2>

```
jexplore/
├── lib/
│   ├── main.dart                 # نقطة الدخول، التطبيق، شاشة الافتتاح، تدفق الشاشات
│   └── src/
│       ├── database/
│       │   └── database_helper.dart   # SQLite، الجداول، الإصدارات، الإعدادات
│       ├── data/
│       │   ├── places_data_source.dart      # واجهة + استيراد شرطي
│       │   ├── places_data_source_io.dart   # تنفيذ SQLite
│       │   ├── places_data_source_web.dart  # تنفيذ مضمّن
│       │   └── embedded_places_data.dart    # نسخة الويب من الأماكن
│       ├── l10n/
│       │   ├── app_strings.dart
│       │   ├── place_translations.dart
│       │   ├── locale_provider.dart
│       │   ├── locale_storage.dart          # واجهة موحّدة
│       │   ├── locale_storage_io.dart       # SQLite + ترحيل من SharedPreferences
│       │   └── locale_storage_web.dart      # SharedPreferences فقط
│       ├── models/
│       │   ├── place.dart
│       │   └── day_plan.dart
│       ├── services/
│       │   └── itinerary_service.dart       # منطق بناء الجدول والمسافات
│       ├── screens/                         # الشاشات الكاملة
│       ├── widgets/                         # مكوّنات قابلة لإعادة الاستخدام
│       └── theme/
│           └── app_theme.dart
├── assets/
├── web/
├── pubspec.yaml
├── render.yaml                 # نشر Static Site على Render
└── README.md
```

**ملخص الطبقات:**

| الطبقة | الملفات النموذجية | المسؤولية |
|--------|-------------------|-----------|
| عرض (UI) | `screens/*`, `widgets/*` | بناء الواجهات والتفاعل |
| تطبيق | `main.dart` | `MaterialApp`، التوجيه البسيط، حالة الجلسة |
| نطاق | `itinerary_service.dart` | قواعد بناء الرحلة |
| بيانات | `database_helper.dart`, `places_data_source_*.dart` | تخزين وقراءة الأماكن |
| تدويل | `app_strings.dart`, `locale_storage_*.dart` | لغة الواجهة والحفظ |

---

<h2 id="sec-flow">4. تدفق المستخدم</h2>

1. **تحميل اللغة المحفوظة** ثم عرض `MaterialApp` مع `LocaleProvider`.
2. **شاشة الافتتاح** (أنيميشن شعار ونص ترحيبي).
3. **شاشة اختيار اللغة** (للمستخدم الذي لم يكملها سابقاً): اختيار عربي/إنجليزي ثم «متابعة».
4. **تفضيلات الاهتمامات** ثم **شاشة المدة** ثم بناء الجدول (مؤشر تحميل).
5. **شاشة الخطة**: أيام، أماكن، خريطة، تفاصيل، ونصائح.
6. **لوحة التحكم** لإعادة التخطيط أو تغيير اللغة.

هذا التسلسل يُدار في `main.dart` داخل `_AppHome` عبر حالات `_showSplash`، `_languageGateCompleted`، `_plans`، و`_loading`.

---

<h2 id="sec-data">5. البيانات: SQLite مقابل الويب</h2>

Dart يسمح بـ **استيراد شرطي** حسب توفر `dart.library.html`. المشروع يختار التنفيذ المناسب دون تكرار منطق الواجهة:

```dart
import 'places_data_source_io.dart'
    if (dart.library.html) 'places_data_source_web.dart' as impl;

abstract class PlacesDataSource {
  Future<List<Place>> getPlacesByCategories(List<String> categories);
}

PlacesDataSource getPlacesDataSource() => impl.getPlacesDataSource();
```

- **Android / iOS / Desktop:** `DatabaseHelper` + `sqflite` يقرآن جدول `places` ويُرجعان `List<Place>`.
- **Web:** لا يُشغَّل `sqflite`؛ يُستخدم `embeddedPlaces` مع نفس واجهة `getPlacesByCategories` لضمان عمل **نفس** `ItineraryService` على كل المنصات.

---

<h2 id="sec-db">6. قاعدة البيانات والإصدارات</h2>

قاعدة **`jexplore.db`** تحتوي جدول **`places`** (الأماكن مع إحداثيات وفئات ونصوص عربية) وجدول **`app_settings`** (مفاتيح مثل لغة التطبيق وإكمال شاشة اللغة). يُدار الإصدار عبر `openDatabase(..., version: 3, onUpgrade: _onUpgrade)`.

مثال مبسّط لإنشاء الجداول (مقتطف مفهومي):

```dart
await db.execute('''
  CREATE TABLE app_settings (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL
  )
''');

await db.execute('''
  CREATE TABLE places (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    address TEXT,
    opening_hours TEXT,
    tips TEXT,
    latitude REAL,
    longitude REAL,
    distance_to_next REAL
  )
''');
```

عند الترقية من إصدارات أقدم يُنفَّذ منطق مثل إنشاء `app_settings` إن لم يكن موجوداً، وتحديث أسماء أماكن قديمة (مثل توحيد تسمية **مول العرب**). التفاصيل الكاملة في `lib/src/database/database_helper.dart`.

---

<h2 id="sec-itinerary">7. بناء جدول الرحلة</h2>

`ItineraryService`:

1. يجلب الأماكن للفئات المختارة.
2. يرتّب الفئات حسب **`_categoryOrder`** (فنادق ثم معالم ثم مطاعم… إلخ) ليكون اليوم متوازناً من ناحية نوع النشاط.
3. لكل مكان جديد في اليوم، إن وُجد مكان سابق بإحداثيات، يختار من نفس الفئة **الأقرب** جغرافياً باستخدام **Haversine** لتقليل القفزات العشوائية.

```dart
double _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0;
  final dLat = _toRad(lat2 - lat1);
  final dLon = _toRad(lon2 - lon1);
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}
```

النتيجة: قائمة **`DayPlan`** (يوم ← قائمة `Place` + مسافات تقريبية حيث تُحسب).

---

<h2 id="sec-l10n">8. الترجمة واللغة</h2>

- **`AppStrings`:** كل النصوص الثابتة للواجهة (أزرار، عناوين، إعدادات) كدوال `get` تعتمد على `isArabic`.
- **`PlaceTranslations`:** قاموس من **الاسم العربي** (مفتاح من قاعدة البيانات) إلى حقول بالإنجليزية للاسم والوصف والعنوان وغيرها.
- **`LocaleProvider`:** `InheritedWidget` يمرّر `AppStrings` ودالة `setLocale` للأبناء.
- **التخزين:**
  - على **IO:** اللغة ومفتاح «أكملت شاشة اللغة» في **`app_settings`** داخل SQLite؛ مع **ترحيل لمرة واحدة** من `SharedPreferences` إن وُجدت قيمة قديمة.
  - على **الويب:** نفس المفاتيح عبر `SharedPreferences` (تخزين المتصفح).

الملف الموحّد للاستدعاء:

```dart
import 'locale_storage_io.dart'
    if (dart.library.html) 'locale_storage_web.dart' as impl;

Future<bool> loadIsArabic() => impl.loadIsArabic();
Future<void> saveIsArabic(bool isArabic) => impl.saveIsArabic(isArabic);
```

---

<h2 id="sec-deps">9. الحزم الرئيسية</h2>

من `pubspec.yaml`:

| الحزمة | الاستخدام |
|--------|-----------|
| `sqflite` | قاعدة SQLite على المنصات الأصلية |
| `path` / `path_provider` | مسار ملف قاعدة البيانات |
| `shared_preferences` | الويب؛ وترحيل قديم على الموبايل |
| `flutter_localizations` | تفويضات `Material` واتجاه النظام |
| `flutter_map` + `latlong2` | الخريطة والإحداثيات |

**بيئة Dart:** `sdk: ^3.8.1` — يُنصح باستخدام **أحدث Flutter stable** المتوافق مع هذا الإصدار.

---

<h2 id="sec-run">10. التشغيل المحلي</h2>

```bash
cd jexplore
flutter pub get
flutter run
```

اختر جهازاً أو محاكياً (Chrome للويب: `flutter run -d chrome`).

**الخط:** يجب أن يوجد الملف `assets/fonts/IBMPlexSansArabic-Bold.ttf` كما هو معرّف في `pubspec.yaml`. إن نقص، قد يتراجع التطبيق لخط النظام دون إيقاف البناء.

---

<h2 id="sec-render">11. بناء الويب و Render</h2>

- بناء إنتاج الويب محلياً:

```bash
flutter build web --release
```

- المخرجات في **`build/web`**.

للنشر على **Render** كـ **Static Site** يوجد **`render.yaml`** في جذر المشروع: يثبّت Flutter من فرع `stable` ثم ينفّذ `flutter build web --release` وينشر مجلد `build/web`. يمكن ربط المستودع كـ **Blueprint** أو نسخ أوامر البناء من الملف إلى إعدادات الموقع الثابت.

---

<h2 id="sec-quality">12. الاختبار والجودة</h2>

```bash
flutter analyze
flutter test
```

المشروع يستخدم **`flutter_lints`** لتوحيد أسلوب الكود.

---

<h2 id="sec-glossary">13. مصطلحات تقنية للمبتدئين</h2>

> جدول مرجعي: **المصطلح** = ما يعنيه في الجملة البسيطة + **أين يظهر في JExplore**.

| المصطلح | شرح مبسّط | مثال في المشروع |
|---------|-------------|------------------|
| **Flutter** | إطار عمل من Google لبناء تطبيق واحد يعمل على موبايل وويب وسطح المكتب بلغة Dart. | مجلد المشروع كامل، `pubspec.yaml` |
| **Dart** | لغة البرمجة التي يُكتب بها كود Flutter. | كل ملفات `.dart` تحت `lib/` |
| **Widget** | أي «قطعة واجهة» (زر، نص، شاشة كاملة). في Flutter كل شيء ويدجت. | `Scaffold`, `LanguageGateScreen`, `PlaceMap` |
| **StatefulWidget** | ويدجت تحفظ **حالة** تتغير مع الوقت (مثل رقم اليوم المختار). | `JExploreApp`, `ItineraryScreen` |
| **StatelessWidget** | ويدجت **لا** تحفظ حالة داخلية؛ تعتمد على ما يُمرَّر لها فقط. | `TipsCard`, `AppLogo` |
| **`setState`** | يخبر Flutter: «غيّرت بيانات؛ أعد رسم الشاشة». | بعد اختيار اهتمام في `PreferencesScreen` |
| **`async` / `Future`** | عمليات تأخذ وقتاً (مثل قراءة قاعدة البيانات) دون تجميد الواجهة. | `buildItinerary`, `getPlacesByCategories` |
| **`MaterialApp`** | الغلاف الرئيسي للتطبيق: ثيم، لغة، شاشة البداية. | في `JExploreApp.build` |
| **`Navigator` / `MaterialPageRoute`** | فتح شاشة فوق شاشة (مكدس صفحات) والرجوع. | من التفضيلات إلى `DurationScreen` |
| **`InheritedWidget`** | آلية لتمرير بيانات لكل الأبناء دون تمرير يدوي لكل مستوى. | `LocaleProvider` ينقل `AppStrings` و`setLocale` |
| **RTL / LTR** | اتجاه النص: من اليمين لليسار (عربي) أو العكس (إنجليزي). | `Directionality` في `JExploreApp` |
| **SQLite** | ملف قاعدة بيانات خفيف على الجهاز، جداول وأعمدة كالإكسل المنظم. | `jexplore.db` على أندرويد/آي أو إس/ديسكتوب |
| **`sqflite`** | حزمة Flutter للتحدث مع SQLite. | `database_helper.dart` (لا تُستورد على الويب) |
| **استيراد شرطي** | ملف مختلف يُحمَّل حسب المنصة (ويب مقابل غير ويب). | `places_data_source.dart` |
| **Haversine** | صيغة رياضية لحساب **مسافة تقريبية** بين نقطتين على الكرة الأرضية. | `_haversineDistance` في `ItineraryService` |
| **OpenStreetMap** | خرائط مفتوحة المصدر؛ التطبيق يعرض **بلاطاً** (صوراً) من الإنترنت. | `TileLayer` في `PlaceMap` |
| **Static Site** | موقع يُرفع كملفات جاهزة (HTML/JS) بلا خادم يشغّل لغة خلفية. | نشر `build/web` على Render |
| **`SharedPreferences`** | تخزين مفاتيح بسيطة (مثل إعدادات) — على الويب يعادل تخزين المتصفح. | `locale_storage_web.dart` |
| **Semantic Versioning للـ DB** | رقم `version` في `openDatabase`؛ عند الزيادة يُستدعى `onUpgrade` لتحديث الجداول. | `version: 3` في `DatabaseHelper` |

---

<h2 id="sec-main-deep">14. دليل `main.dart` بالكامل</h2>

### دالة `main()`

| العنصر | الوظيفة |
|--------|---------|
| `WidgetsFlutterBinding.ensureInitialized()` | يجهّز المحرك قبل أي كود غير متزامن أو إضافات أصلية. |
| `SystemChrome.setSystemUIOverlayStyle(...)` | لون شريط الحالة وشريط التنقل ليتناسق مع التصميم (`AppColors.surface`). |
| `runApp(const JExploreApp())` | تشغيل جذر الواجهة. |

### `JExploreApp` (StatefulWidget)

| الحقل / الدالة | الشرح للمبتدئ |
|----------------|---------------|
| `_isArabic` | هل الواجهة حالياً عربية (`true`) أو إنجليزية (`false`). |
| `_loadingLocale` | أثناء `true` تُعرض شاشة تحميل بسيطة حتى تُقرأ اللغة من التخزين. |
| `_loadLocale()` | تستدعي `loadIsArabic()` ثم `setState` لتحديث `_isArabic` وإيقاف التحميل. |
| `_setLocale(bool)` | تحفظ عبر `saveIsArabic` ثم `setState` — تُستدعى من `LocaleProvider` عند تغيير اللغة. |
| `MaterialApp` | `locale`, `supportedLocales`, `localizationsDelegates` لدعم Material بالعربية/الإنجليزية. |
| `builder` | يلف الشجرة بـ `Directionality` + `LocaleProvider` حتى كل الشاشات ترى نفس اللغة. |
| `home` | `_AppHome` — شاشة الجذر التي تقرر ماذا يظهر الآن. |

### `_AppHome` — «مدير المشهد»

| الحقل | الدور |
|-------|--------|
| `_interests` | قائمة الفئات التي اختارها المستخدم (نصوص عربية ثابتة مثل `'مطاعم'`). |
| `_days` | عدد أيام الإقامة بعد التأكيد. |
| `_plans` | نتيجة `ItineraryService`: قائمة `DayPlan` لكل يوم. |
| `_loading` | أثناء بناء الجدول تُعرض شاشة تحميل زرقاء مع شعار. |
| `_showSplash` | إن `true` تُعرض `_SplashScreen` (مرة في بداية الجلسة عندما لا توجد خطط بعد). |
| `_languageGateLoaded` | حتى تنتهي `loadLanguageGateCompleted()` من القراءة. |
| `_languageGateCompleted` | إن `false` تُعرض `LanguageGateScreen` (مرة واحدة للمستخدم الجديد تقريباً). |

| الدالة | ماذا تفعل |
|--------|-----------|
| `_loadLanguageGateFlag()` | تقرأ هل المستخدم أنهى شاشة اختيار اللغة مسبقاً. |
| `_buildItinerary(interests, days)` | تضع `_loading = true`، تنادي `ItineraryService().buildItinerary`، ثم تخزن النتيجة في `_plans` أو تُعيد رمي الخطأ بعد إيقاف التحميل. |
| `_openControlPanel` | `Navigator.push` إلى `ControlPanelScreen` مع `onReplan` يعيد استدعاء `_buildItinerary`. |

**ترتيب الشروط في `build` (مهم):** Splash ← انتظار تحميل علم اللغة ← شاشة اللغة ← تحميل الجدول ← تفضيلات فارغة ← `ItineraryScreen`.

### `_SplashScreen`

| العنصر | التفاصيل |
|--------|----------|
| `AnimationController` مدة 1200ms | يحرك التكبير والشفافية. |
| `_scaleAnimation` | من 0.6 إلى 1.0 مع منحنى `easeOutBack`. |
| `_fadeAnimation` | ظهور تدريجي. |
| `Future.delayed(2000ms)` | بعد ثانيتين يستدعي `onComplete` لإخفاء الـSplash. |
| `dispose` | يحرر المتحكم حتى لا تبقى ذاكرة مهدرة. |

---

<h2 id="sec-models">15. نماذج البيانات</h2>

### `Place` (`lib/src/models/place.dart`)

| عضو | النوع | المعنى |
|-----|-------|--------|
| `id` | `int` | المعرف في قاعدة البيانات أو القائمة المضمّنة. |
| `name` | `String` | الاسم العربي (مفتاح لـ `PlaceTranslations`). |
| `category` | `String` | إحدى الفئات السبع (مثل `'تسوق'`). |
| `description` | `String?` | وصف طويل. |
| `address` | `String?` | العنوان النصي. |
| `openingHours` | `String?` | أوقات العمل كنص حر. |
| `tips` | `String?` | نصائح للزائر. |
| `latitude` / `longitude` | `double?` | إحداثيات للخريطة والمسافات. |
| `distanceToNext` | `double?` | كم تبعد عن **المكان السابق في نفس اليوم** (يُملأ عند البناء). |

| الدالة | السلوك |
|--------|--------|
| `Place.fromMap` | يحوّل صفاً من SQLite (`opening_hours` ← `openingHours` إلخ) إلى كائن. |
| `copyWith` | ينسخ المكان مع تغيير `distanceToNext` فقط (يُستخدم عند البناء). |
| `hasCoordinates` | `true` إذا خط العرض والطول كلاهما غير `null`. |

### `DayPlan`

| عضو | المعنى |
|-----|--------|
| `dayNumber` | رقم اليوم (1، 2، …). |
| `places` | ترتيب الأماكن المقترحة ذلك اليوم. |

---

<h2 id="sec-db-api">16. واجهة برمجة `DatabaseHelper`</h2>

الملف: `lib/src/database/database_helper.dart`. النمط **Singleton**: `DatabaseHelper()` يعيد نفس المثيل؛ قاعدة واحدة مفتوحة في `_database`.

| الدالة / الخاصية | الوصف |
|-------------------|--------|
| `database` (getter) | يفتح القاعدة إن لزم ثم يعيد `Database`. |
| `_initDatabase` | مسار `jexplore.db` عبر `getDatabasesPath` + `path.join`. |
| `version` الحالية | **3** |
| `_onCreate` | ينشئ `app_settings` و`places` ثم `_insertInitialData`. |
| `_onUpgrade` | من إصدار &lt; 2: حذف الجداول وإعادة `_onCreate`. من &lt; 3: إنشاء `app_settings` إن لزم + تحديث اسم «مول العرب». |
| `_insertInitialData` | يملأ جدول `places` دفعة واحدة بـ `batch.insert`. |
| `getPlacesByCategories` | استعلام `WHERE category IN (?, ?, …)` ويعيد `List<Place>`. |
| `getAllPlaces` | كل الصفوف (للتوسعات المستقبلية). |
| `getAppSetting` / `setAppSetting` | قراءة/كتابة صف في `app_settings` (`REPLACE` عند التعارض). |
| `close` | يغلق الاتصال ويصفّر `_database`. |

**مفاتيح `app_settings` المستخدمة في المشروع:** `locale` (`ar`/`en`)، `language_gate_done` (`1` عند الإكمال).

---

<h2 id="sec-service-deep">17. `ItineraryService` سطراً بسطر</h2>

| الخطوة | الشرح |
|--------|--------|
| 1 | إذا `interests` فارغة أو `daysCount < 1` → قائمة فارغة. |
| 2 | `getPlacesByCategories(interests)` من مصدر البيانات المناسب للمنصة. |
| 3 | تجميع الأماكن في `Map<String, List<Place>>` حسب `category`. |
| 4 | `Random(42)` — بذرة ثابتة: **نفس الإدخال يعطي نفس التوزيع** (سهولة التجربة والتصحيح). |
| 5 | `usedPlaceIds` — لا يُعاد استخدام نفس المكان في الرحلة كلها. |
| 6 | لكل يوم من 1 إلى `daysCount`: مسار فارغ `dayPlaces`، `prevPlace` بداية `null`. |
| 7 | لكل فئة بالترتيب `_categoryOrder`: إن كانت ضمن `interests`، يُؤخذ مكان واحد من تلك الفئة إن أمكن. |
| 8 | اختيار المكان: إن وُجد `prevPlace` بإحداثيات → **أقرب** مكان في القائمة؛ وإلا → عشوائي من القائمة. |
| 9 | يُحسب `distanceToNext` بين `prevPlace` والمكان الجديد عند توفر الإحداثيات. |
| 10 | إن `dayPlaces` ليس فارغاً يُضاف `DayPlan(dayNumber: day, places: dayPlaces)`. |

**ترتيب الفئات داخل اليوم الواحد:** فنادق → معالم سياحية → مطاعم → أماكن ترفيهية → تسوق → طبيعة → فعاليات. هذا يغيّر «إيقاع» اليوم وليس ترتيب أيام الرحلة.

---

<h2 id="sec-screens-api">18. الشاشات — خصائص ودوال</h2>

### `LanguageGateScreen`

| المعامل / الدالة | الوصف |
|------------------|--------|
| `onDone` | يُستدعى بعد حفظ اللغة وإكمال الشاشة. |
| `_continue` | `setLocale` + `saveLanguageGateCompleted` + `onDone`. |
| `_LangCard` | بطاقة اختيار (راديو بصري). |

### `PreferencesScreen`

| المعامل | الوصف |
|---------|--------|
| `initialInterests` | اختياري؛ لملء الاختيارات مسبقاً (من لوحة التحكم). |
| `onComplete(List<String>)` | يُنادى بقائمة الفئات المختارة (على الأقل واحدة). |
| `_toggle` | يضيف/يزيل فئة من `Set` محلي. |
| `_next` | لا يعمل إن `_selected.isEmpty`. |
| قائمة `_interests` الثابتة | ترتيب العرض في الواجهة؛ القيم **عربية** لتطابق قاعدة البيانات. |

### `DurationScreen`

| المعامل | الوصف |
|---------|--------|
| `interests` | يُمرَّر للتنقل فقط (يمكن لشاشات مستقبلية استخدامه). |
| `onConfirm(int)` | عدد الأيام 1–7. |
| `_selectedDays` | افتراضياً 1؛ شبكة 7 خلايا. |

### `ItineraryScreen`

| المعامل | الوصف |
|---------|--------|
| `plans` | خطط كل الأيام. |
| `onOpenControlPanel` | فتح الإعدادات. |
| `_selectedDayIndex` | أي يوم تُعرض خريطته وقائمته. |
| `_selectedPlaceIndex` | تمييز على الخريطة والبطاقة. |
| `_DayChip` | تبويب أفقي لأيام الرحلة. |
| `_PlaceCard` | بطاقة مكان مع أيقونة فئة، وصف مختصر، شارة فئة، مسافة للتالي. |
| `showPlaceDetailSheet` | عند الضغط على بطاقة. |

### `ControlPanelScreen`

| المعامل | الوصف |
|---------|--------|
| `currentInterests` / `currentDays` | القيم الحالية للرحلة. |
| `onReplan` | يستدعي إعادة البناء باهتمامات/أيام جديدة. |
| `_openPreferences` | يفتح `PreferencesScreen` مع `initialInterests` ثم `onReplan` ويغلق اللوحة. |
| `_openDuration` | يغيّر الأيام فقط. |
| `_openFullReplan` | يبدأ من اهتمامات فارغة ثم مدة، ثم `popUntil` للجذر و`onReplan`. |
| `_LanguageCard` / `_OptionCard` | مكوّنات بصرية للبطاقات. |

---

<h2 id="sec-widgets-api">19. الودجات</h2>

### `AppLogo`

| المعامل | الوصف |
|---------|--------|
| `height` | ارتفاع الصورة. |
| `colorFilter` | إن وُجد يُستخدم `BlendMode.srcIn` لتلوين الشعار. |
| `showOnError` | إن فشل تحميل الأصل يعرض نص `JExplore`. |

### `PlaceMap`

| المعامل | الوصف |
|---------|--------|
| `places` | أماكن اليوم الحالي. |
| `selectedIndex` | فهرس المحدد في **قائمة اليوم الكاملة** (ليس فقط ذوي الإحداثيات). |
| `onPlaceSelected` | عند النقر على Marker يُحوَّل الفهرس عبر `indexWhere` على `id`. |
| بدون إحداثيات | يعرض placeholder بنص `noCoordinates`. |
| `_calculateCenter` | متوسط خطوط العرض والطول لمركز الخريطة. |

### `showPlaceDetailSheet` + `_SectionTitle`

| السلوك | الوصف |
|---------|--------|
| `DraggableScrollableSheet` | ورقة سفلية قابلة للسحب (40%–95% من الشاشة). |
| أقسام شرطية | الوصف، العنوان، الأوقات، النصائح، المسافة للتالي إن وُجدت. |

### `TipsCard`

| السلوك | الوصف |
|---------|--------|
| `generalTips` من `AppStrings` | 5 نصائح عامة. |
| `tipIndex` | `(dayNumber - 1) % tips.length` — تتبدل النصيحة حسب رقم اليوم. |

---

<h2 id="sec-theme-deep">20. الثيم `AppTheme` و `AppColors`</h2>

### `AppColors`

| الثابت | الاستخدام |
|--------|-----------|
| `primaryBlue` | لون أساسي (شريط علوي، أزرار، خريطة). |
| `secondaryTeal` | لون ثانوي (أزرار مميزة، شارات). |
| `background` | خلفية الصفحات الفاتحة. |
| `surface` | بطاقات وحقول. |
| `textPrimary` / `textSecondary` | تباين النصوص. |

### `AppTheme.light`

- **Material 3** (`useMaterial3: true`).
- **خط:** `IBMPlexSansArabic` لكل `textTheme` و`AppBar` والأزرار.
- **بطاقات:** زوايا 16، ظل خفيف.
- **أزرار:** `ElevatedButton` و`FilledButton` بألوان متناسقة.

---

<h2 id="sec-strings-deep">21. `AppStrings` و `PlaceTranslations`</h2>

### قائمة خصائص `AppStrings` (كلها `String` ما عدا `generalTips`)

`loadingItinerary`, `exploreJeddah`, `welcomeToJeddah`, `interestsQuestion`, `selectOneOrMore`, `continueBtn`, `daysQuestion`, `selectDuration`, `day`, `days`, `confirmAndBuild`, `yourItinerary`, `tipOfDay`, `placesOfDay`, `nextDistance`, `km`, `settings`, `editItinerary`, `editItineraryDesc`, `editInterests`, `editInterestsDesc`, `changeDays`, `changeDaysDesc`, `replanFromStart`, `description`, `location`, `openingHours`, `visitorTips`, `distanceToNext`, `noCoordinates`, `dayNum`, أسماء الفئات (`restaurants` … `shopping`), `language`, `chooseLanguageTitle`, `chooseLanguageHint`, `arabic`, `english`.

### دوال `AppStrings`

| الدالة | الغرض |
|--------|--------|
| `interestKey` | يطابق مفتاح اهتمام قديم بنص معروض (نفس منطق الفئات). |
| `categoryKey` | ترجمة **اسم الفئة العربي** من قاعدة البيانات لعرض الواجهة. |

### `PlaceTranslations`

| دالة | عند `isArabic == true` | عند الإنجليزية |
|------|------------------------|------------------|
| `name` | يعيد الاسم بعد **تطبيع** الأسماء القديمة (مثل مول العرب). | يعيد الاسم الإنجليزي من القاموس أو الاحتياطي. |
| `description`, `address`, `openingHours`, `tips` | غالباً `null` — تُستخدم النصوص العربية من `Place`. | ترجمة من القاموس إن وُجدت. |
| `_normalizeArName` | داخلية؛ توحّد المفاتيح القديمة. | — |

### `LocaleProvider` (`locale_provider.dart`)

| العنصر | الشرح |
|--------|--------|
| **نوع الويدجت** | `InheritedWidget` — يسمح لأي `BuildContext` تحت الشجرة بقراءة اللغة الحالية. |
| **`strings`** | كائن `AppStrings` يحمل كل النصوص حسب `isArabic`. |
| **`setLocale(bool isArabic)`** | دالة يمررها `JExploreApp`؛ عند الاستدعاء تُحدَّث الحالة في الأب ويُعاد بناء التطبيق. |
| **`LocaleProvider.of(context)`** | يعيد `AppStrings`؛ يفترض وجود المزود (يستخدمه معظم الشاشات). |
| **`LocaleProvider.maybeOf(context)`** | يعيد `LocaleProvider?`؛ مفيد عندما قد لا يكون المزود مُلحقاً (نادر؛ يُستخدم مع `setLocale` من شاشة اللغة). |
| **`updateShouldNotify`** | يعيد `true` إذا تغيّر `strings.isArabic` حتى تُحدَّث الشاشات الفرعية. |

---

<h2 id="sec-storage-keys">22. مفاتيح التخزين (لغة وشاشة البوابة)</h2>

| المفتاح | منصة IO (`locale_storage_io`) | منصة Web (`locale_storage_web`) |
|---------|----------------------------------|-----------------------------------|
| اللغة | `app_settings`: المفتاح `locale` والقيمة النصية `ar` أو `en`. إن لم يوجد شيء في SQLite يُقرأ مفتاح **`app_locale`** من `SharedPreferences` كـ **bool** (ترحيل لمرة واحدة ثم الحفظ في SQLite). | `SharedPreferences`: المفتاح **`app_locale`** كـ **bool** (`true` = عربي، `false` = إنجليزي)، الافتراضي **`true`**. |
| إكمال شاشة اللغة | `app_settings.language_gate_done` = النص **`1`** | المفتاح **`language_gate_done`** كـ **bool** (`true` بعد الإكمال)، الافتراضي **`false`**. |

الملف الموحّد `locale_storage.dart` يصدّر أربع دوال تستدعي التنفيذ المناسب للمنصة: `loadIsArabic`, `saveIsArabic`, `loadLanguageGateCompleted`, `saveLanguageGateCompleted`.

---

<h2 id="sec-examples">23. أمثلة عملية (مبتدئ)</h2>

**مثال 1 — المستخدم يختار مطاعم + تسوق لمدة يومين:**  
التطبيق يجلب كل الأماكن في هاتين الفئتين، يوزّع لكل يوم «قطعة» من كل فئة حسب الترتيب والتوفر، ويحسب المسافات بين المكان السابق والحالي داخل **نفس اليوم**.

**مثال 2 — تغيير اللغة من الإعدادات:**  
`ControlPanel` يستدعي `provider.setLocale(false)` → `_setLocale` في `JExploreApp` يحفظ ويعيد بناء `MaterialApp` بـ `AppStrings(false)` واتجاه LTR.

**مثال 3 — فتح التطبيق على الويب:**  
لا يُفتح ملف SQLite؛ `getPlacesDataSource()` يعيد `_EmbeddedPlacesDataSource`؛ نفس `ItineraryService` يعمل على القائمة المضمّنة.

**مثال 4 — نقرة على Marker في الخريطة:**  
`PlaceMap` يجد فهرس المكان في `places` بمطابقة `id`، فيستدعي `onPlaceSelected` فيُحدَّد `_selectedPlaceIndex` في `ItineraryScreen` ويظهر اللون المميز على الدائرة.

**مثال 5 — ترقية قاعدة قديمة:**  
عند أول تشغيل بعد تحديث التطبيق إلى إصدار قاعدة 3، يُنشأ `app_settings` إن لزم ويُحدَّث اسم المول في الجدول دون إعادة تثبيت التطبيق.

---

<h2 id="sec-misc">24. ملفات إضافية</h2>

| الملف | الدور |
|-------|--------|
| `test/widget_test.dart` | اختبار ويدجت افتراضي يمكن توسيعه. |
| `render.yaml` | تعريف Static Site: استنساخ Flutter stable، `pub get`، `build web`، نشر `build/web`. |
| `assets/images/Logo2.png` | شعار التطبيق. |
| `assets/fonts/IBMPlexSansArabic-Bold.ttf` | خط عربي للثيم. |
| `web/index.html` | نقطة دخول الويب (`flutter_bootstrap.js`). |

### طبقة `data/` (مصدر الأماكن)

| الملف | الدالة / الكلاس | ماذا يفعل باختصار |
|-------|------------------|---------------------|
| `places_data_source.dart` | `PlacesDataSource` (abstract) | يعرّف عقداً واحداً: `getPlacesByCategories`. |
| | `getPlacesDataSource()` | يستدعي التنفيذ الفعلي حسب المنصة (`impl`). |
| `places_data_source_io.dart` | `_SqlitePlacesDataSource` | ينفّذ الطلب عبر `DatabaseHelper().getPlacesByCategories`. |
| `places_data_source_web.dart` | `_EmbeddedPlacesDataSource` | يصفّي `embeddedPlaces` حيث `category` ضمن القائمة المطلوبة. |
| `embedded_places_data.dart` | `embeddedPlaces` | قائمة `Place` ثابتة في الكود (نسخة ويب من بيانات جدة؛ يجب أن تبقى الفئات والأسماء متوافقة مع المنطق و`PlaceTranslations`). |

---

## خلاصة

**JExplore** يجمع بين واجهة عربية/إنجليزية منظمة، وتخزين أماكن **حقيقي على الجهاز** عبر SQLite للموبايل ونسخة **ويب** تعتمد بيانات مضمّنة مع نفس منطق الرحلة، ما يجعله مناسباً كمشروع تخرج يوضح **Flutter متعدد المنصات** من دون خادم خلفي إلزامي.

