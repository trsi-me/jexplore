import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/place.dart';

/// مساعد قاعدة البيانات SQLite للتطبيق
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'jexplore.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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

    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS places');
      await db.execute('DROP TABLE IF EXISTS app_settings');
      await _onCreate(db, newVersion);
      return;
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS app_settings (
          key TEXT PRIMARY KEY,
          value TEXT NOT NULL
        )
      ''');
      await db.update(
        'places',
        {'name': 'مول العرب'},
        where: 'name = ?',
        whereArgs: ['مول العربية'],
      );
    }
  }

  /// ضخ البيانات الافتراضية لأماكن جدة بتفاصيل كاملة
  Future<void> _insertInitialData(Database db) async {
    final places = [
      {
        'name': 'نافورة الملك فهد',
        'category': 'معالم سياحية',
        'description': 'أطول نافورة في العالم بارتفاع يصل إلى 312 متراً، تطل على البحر الأحمر وتُضاء بأنوار متحركة ليلاً. من أهم معالم جدة.',
        'address': 'كورنيش جدة، حي الحمراء',
        'opening_hours': 'مفتوح 24 ساعة للمشاهدة من الخارج',
        'tips': '• أفضل وقت للمشاهدة بعد المغرب عند الإضاءة\n• خذ جولة بحرية للاستمتاع بالمشهد',
        'latitude': 21.5089,
        'longitude': 39.1442,
      },
      {
        'name': 'جدة البلد',
        'category': 'معالم سياحية',
        'description': 'المنطقة التاريخية المسجلة في اليونسكو. بيوت قديمة مزخرفة، أزقة ضيقة، وسوق تراثي يعكس روح جدة القديمة.',
        'address': 'وسط جدة التاريخي، قرب الميناء',
        'opening_hours': 'المحلات 10 ص - 10 م',
        'tips': '• ارتدِ ملابس مريحة للمشي\n• تجنب الذهاب في الظهيرة الحارة',
        'latitude': 21.4925,
        'longitude': 39.1972,
      },
      {
        'name': 'واجهة جدة البحرية',
        'category': 'معالم سياحية',
        'description': 'كورنيش حديث يمتد على البحر الأحمر مع مسارات مشي، ملاعب، ومتنزهات. موقع مثالي للعائلات والرياضة.',
        'address': 'كورنيش جدة، من الشاطئ للشمال',
        'opening_hours': 'مفتوح 24 ساعة',
        'tips': '• استأجر دراجة هوائية للمرور\n• شاهد غروب الشمس من الممشى',
        'latitude': 21.5450,
        'longitude': 39.1550,
      },
      {
        'name': 'متحف عبد الرؤوف خليل',
        'category': 'معالم سياحية',
        'description': 'متحف تراثي ضخم يعرض تاريخ جدة والحجاز والفن الإسلامي والتحف النادرة.',
        'address': 'حي الروضة، جدة',
        'opening_hours': 'السبت - الخميس 9 ص - 12 م',
        'tips': '• خصص ساعتين على الأقل للزيارة\n• التصوير مسموح في بعض الأجنحة',
        'latitude': 21.5350,
        'longitude': 39.2150,
      },
      {
        'name': 'بيت نصيف',
        'category': 'معالم سياحية',
        'description': 'قصر تراثي يعود للقرن التاسع عشر، شهد استقبال الملك عبدالعزيز. رواشن خشبية مميزة وتصميم حجازي أصيل.',
        'address': 'جدة البلد، حي اليمامة',
        'opening_hours': 'الأحد - الخميس 9 ص - 5 م',
        'tips': '• جولة إرشادية مجانية\n• التقط صوراً للرواشن الخشبية',
        'latitude': 21.4890,
        'longitude': 39.1950,
      },
      {
        'name': 'مطاعم البيك',
        'category': 'مطاعم',
        'description': 'سلسلة سعودية شهيرة للوجبات السريعة، مشهورة بالدجاج المقلي والمأكولات المحلية.',
        'address': 'فروع متعددة في جدة',
        'opening_hours': 'معظم الفروع 7 ص - 2 ص',
        'tips': '• جرب وجبة البيك الخاصة\n• مناسب للعائلات والأطفال',
        'latitude': 21.5200,
        'longitude': 39.1780,
      },
      {
        'name': 'مطعم فوود لاين',
        'category': 'مطاعم',
        'description': 'مطعم عالمي متنوع في الواجهة البحرية، إطلالة بحرية ومأكولات متنوعة.',
        'address': 'واجهة جدة البحرية',
        'opening_hours': '12 ظ - 12 ص',
        'tips': '• حجز مسبق في العطل\n• اطلب طاولة بإطلالة بحرية',
        'latitude': 21.5420,
        'longitude': 39.1520,
      },
      {
        'name': 'مطعم ماما نورة',
        'category': 'مطاعم',
        'description': 'مطعم تراثي للمأكولات الحجازية الأصيلة. كبسة، مندي، ومرق فريدة بأجواء تقليدية.',
        'address': 'جدة البلد',
        'opening_hours': '12 ظ - 11 م',
        'tips': '• جرب الكبسة الحجازية\n• الأجواء عائلية وهادئة',
        'latitude': 21.4910,
        'longitude': 39.1980,
      },
      {
        'name': 'مطعم تيجر شك',
        'category': 'مطاعم',
        'description': 'مطعم برجر شهير بوصفات مبتكرة وجودة عالية.',
        'address': 'طريق الملك عبدالعزيز',
        'opening_hours': '11 ص - 12 ص',
        'tips': '• جرب البرجر المميز\n• وجبات عائلية متوفرة',
        'latitude': 21.5150,
        'longitude': 39.1850,
      },
      {
        'name': 'مطعم هرفي',
        'category': 'مطاعم',
        'description': 'سلسلة محلية للوجبات السريعة والمشروبات. أسعار مناسبة وخدمة سريعة.',
        'address': 'فروع متعددة',
        'opening_hours': '24 ساعة في معظم الفروع',
        'tips': '• خيار اقتصادي للوجبات\n• مناسب للتوقف السريع',
        'latitude': 21.5080,
        'longitude': 39.1720,
      },
      {
        'name': 'فندق بارك حبسون',
        'category': 'فنادق',
        'description': 'فندق خمس نجوم فاخر على الواجهة البحرية. إطلالات بحرية وخدمة راقية.',
        'address': 'كورنيش جدة',
        'opening_hours': 'استقبال 24 ساعة',
        'tips': '• اطلب غرفة بإطلالة بحر\n• السبا ومسبح راقيان',
        'latitude': 21.5380,
        'longitude': 39.1480,
      },
      {
        'name': 'فندق موفنبيك جدة',
        'category': 'فنادق',
        'description': 'فندق فاخر في وسط جدة، قرب المولات والمعالم.',
        'address': 'طريق الملك فهد',
        'opening_hours': 'استقبال 24 ساعة',
        'tips': '• موقع مركزي للتنقل\n• إفطار متنوع ومميز',
        'latitude': 21.5220,
        'longitude': 39.1920,
      },
      {
        'name': 'فندق روزوود جدة',
        'category': 'فنادق',
        'description': 'فندق راقي بتصميم كلاسيكي، يطل على البحر الأحمر.',
        'address': 'حي الحمراء',
        'opening_hours': 'استقبال 24 ساعة',
        'tips': '• تجربة فندقية فاخرة\n• المطعم الفاخر يستحق الزيارة',
        'latitude': 21.5320,
        'longitude': 39.1420,
      },
      {
        'name': 'فندق كراون بلازا',
        'category': 'فنادق',
        'description': 'فندق مناسب للعائلات والرحلة العملية. غرف واسعة ومرافق متكاملة.',
        'address': 'حي الزهراء',
        'opening_hours': 'استقبال 24 ساعة',
        'tips': '• أسعار مناسبة\n• قريب من مولات التسوق',
        'latitude': 21.5480,
        'longitude': 39.2050,
      },
      {
        'name': 'فقيه أكواريوم',
        'category': 'أماكن ترفيهية',
        'description': 'أكبر حوض أسماك في السعودية. آلاف الأسماك والكائنات البحرية في أنفاق زجاجية تحت الماء.',
        'address': 'طريق المدينة، حي الفيصلية',
        'opening_hours': '10 ص - 10 م',
        'tips': '• مناسب للأطفال بشكل خاص\n• خصص 2-3 ساعات للزيارة',
        'latitude': 21.5050,
        'longitude': 39.2250,
      },
      {
        'name': 'حديقة الأمير متعب',
        'category': 'طبيعة',
        'description': 'حديقة عامة كبيرة في قلب جدة، مسارات مشي، ملاعب، ومناطق للنزهة العائلية. من أكثر الحدائق زيارة.',
        'address': 'حي الروضة، جدة',
        'opening_hours': '6 ص - 11 م',
        'tips': '• مثالي للمشي والرياضة صباحاً\n• يوجد ملاعب أطفال',
        'latitude': 21.5280,
        'longitude': 39.2080,
      },
      {
        'name': 'حديقة حي الجوهرة',
        'category': 'طبيعة',
        'description': 'حديقة حيوان وألعاب ترفيهية للعائلات. حيوانات محلية وعالمية ومدينة ألعاب.',
        'address': 'حي الجوهرة',
        'opening_hours': '4 م - 11 م (تختلف أيام الصيف)',
        'tips': '• تحقق من أوقات الفتح\n• مناسب للعائلات مع أطفال',
        'latitude': 21.5580,
        'longitude': 39.2350,
      },
      {
        'name': 'رد سي مول',
        'category': 'تسوق',
        'description': 'أحد أكبر مراكز التسوق في جدة. علامات عالمية، سينما، ومدينة ألعاب.',
        'address': 'طريق مكة-جدة السريع',
        'opening_hours': '10 ص - 12 ص',
        'tips': '• موقف سيارات واسع\n• سينما IMAX متوفرة',
        'latitude': 21.5650,
        'longitude': 39.1780,
      },
      {
        'name': 'مول العرب',
        'category': 'تسوق',
        'description': 'مركز تجاري ضخم للعلامات العالمية. تصميم عصري ومرافق ترفيهية.',
        'address': 'طريق المدينة',
        'opening_hours': '10 ص - 12 ص',
        'tips': '• خصص يوم للتسوق\n• سوق الطعام متنوع',
        'latitude': 21.4980,
        'longitude': 39.2420,
      },
      {
        'name': 'سيتي ووك',
        'category': 'تسوق',
        'description': 'سوق مفتوح على الواجهة البحرية. متاجر ومطاعم بإطلالة بحرية.',
        'address': 'كورنيش جدة',
        'opening_hours': '10 ص - 12 ص',
        'tips': '• امشِ على الكورنيش بعد التسوق\n• أجواء ليلية جميلة',
        'latitude': 21.5360,
        'longitude': 39.1510,
      },
      {
        'name': 'سوق البلد',
        'category': 'تسوق',
        'description': 'سوق تراثي للتحف، التوابل، والعطور. تجربة تسوق تاريخية.',
        'address': 'جدة البلد',
        'opening_hours': '9 ص - 10 م',
        'tips': '• تفاوض على الأسعار\n• اشترِ توابل وعطور كتذكار',
        'latitude': 21.4880,
        'longitude': 39.1960,
      },
      {
        'name': 'متحف جدة للمجسمات',
        'category': 'فعاليات',
        'description': 'متحف فني في الهواء الطلق للمنحوتات المعاصرة على كورنيش جدة.',
        'address': 'كورنيش جدة',
        'opening_hours': 'مفتوح 24 ساعة',
        'tips': '• زيارة مجانية\n• صور فنية مميزة للمنحوتات',
        'latitude': 21.5410,
        'longitude': 39.1570,
      },
      {
        'name': 'موسم جدة',
        'category': 'فعاليات',
        'description': 'فعاليات موسمية تضم حفلات، عروض، ومعارض. تحقق من البرنامج قبل الزيارة.',
        'address': 'مواقع متعددة في جدة',
        'opening_hours': 'وفق البرنامج',
        'tips': '• تابع برنامج الفعاليات\n• حجز مسبق للحفلات',
        'latitude': 21.5200,
        'longitude': 39.1650,
      },
      {
        'name': 'مسرح جدة',
        'category': 'فعاليات',
        'description': 'عروض مسرحية ومهرجانات ثقافية. وجهة للفنون والأداء.',
        'address': 'واجهة جدة البحرية',
        'opening_hours': 'وفق البرنامج',
        'tips': '• احجز تذاكر مسبقاً\n• برنامج متنوع للعائلات',
        'latitude': 21.5390,
        'longitude': 39.1540,
      },
      {
        'name': 'سنتر بوينت',
        'category': 'أماكن ترفيهية',
        'description': 'مركز ترفيهي ومدينة ألعاب للصغار والكبار. ألعاب إلكترونية ومسلية.',
        'address': 'طريق الملك عبدالعزيز',
        'opening_hours': '10 ص - 12 ص',
        'tips': '• بطاقات رصيد للعب\n• ألعاب مناسبة لجميع الأعمار',
        'latitude': 21.5100,
        'longitude': 39.1880,
      },
    ];

    final batch = db.batch();

    for (final p in places) {
      batch.insert('places', {
        'name': p['name'],
        'category': p['category'],
        'description': p['description'],
        'address': p['address'],
        'opening_hours': p['opening_hours'],
        'tips': p['tips'],
        'latitude': p['latitude'],
        'longitude': p['longitude'],
        'distance_to_next': null,
      });
    }

    await batch.commit(noResult: true);
  }

  /// استدعاء الأماكن حسب الفئات المحددة
  Future<List<Place>> getPlacesByCategories(List<String> categories) async {
    if (categories.isEmpty) return [];

    final db = await database;
    final placeholders = List.generate(categories.length, (_) => '?').join(', ');
    final results = await db.query(
      'places',
      where: 'category IN ($placeholders)',
      whereArgs: categories,
    );

    return results.map((m) => Place.fromMap(m)).toList();
  }

  Future<List<Place>> getAllPlaces() async {
    final db = await database;
    final results = await db.query('places');
    return results.map((m) => Place.fromMap(m)).toList();
  }

  Future<String?> getAppSetting(String key) async {
    final db = await database;
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return rows.first['value'] as String?;
  }

  Future<void> setAppSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
