import 'package:intl/intl.dart';
import 'package:zachranobed/models/food_info.dart';

class OfferedFood {
  final String id;
  final DateTime date;
  final FoodInfo foodInfo;
  final String packaging;
  final DateTime consumeBy;
  final String weekNumber;
  final String donor;

  OfferedFood({
    required this.id,
    required this.date,
    required this.foodInfo,
    required this.packaging,
    required this.consumeBy,
    required this.weekNumber,
    required this.donor,
  });

  factory OfferedFood.fromJson(Map<String, dynamic> json) {
    return OfferedFood(
      id: json['fields']['x_ID'],
      date: DateTime.parse(json['fields']['polozka2']),
      foodInfo: FoodInfo(
        name: json['fields']['polozka3'],
        allergens: (json['fields']['alergeny'] as List)
            .map((e) => e as String)
            .toList(),
        numberOfServings: json['fields']['pocetPorci'],
      ),
      packaging: json['fields']['baleni'],
      consumeBy: DateTime.parse(json['fields']['spotrebujteDo']),
      weekNumber: json['fields']['cisloTydne'],
      donor: json['fields']['darce']['fields']['nazevProvozovny'],
    );
  }

  Map<String, dynamic> toJson() => {
        'fields': {
          'x_ID': id,
          'polozka2': DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(date.toString())
              .toIso8601String(),
          'polozka3': foodInfo.name,
          'alergeny': foodInfo.allergens,
          'pocetPorci': foodInfo.numberOfServings,
          'baleni': packaging,
          'spotrebujteDo': consumeBy.toIso8601String(),
          'cisloTydne': weekNumber,
          'darce': {
            'id': donor,
          }
        }
      };
}
