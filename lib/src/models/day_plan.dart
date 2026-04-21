import 'place.dart';

/// نموذج يمثل خطة يوم واحد من الرحلة
class DayPlan {
  final int dayNumber;
  final List<Place> places;

  DayPlan({required this.dayNumber, required this.places});
}
