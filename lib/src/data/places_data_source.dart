import '../models/place.dart';
// على الويب: بيانات مضمّنة | على الموبايل: SQLite
import 'places_data_source_io.dart'
    if (dart.library.html) 'places_data_source_web.dart' as impl;

/// واجهة مصدر بيانات الأماكن - تعمل مع SQLite على الموبايل والويب بدون قاعدة بيانات
abstract class PlacesDataSource {
  Future<List<Place>> getPlacesByCategories(List<String> categories);
}

PlacesDataSource getPlacesDataSource() => impl.getPlacesDataSource();
