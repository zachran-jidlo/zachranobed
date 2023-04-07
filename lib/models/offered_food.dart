import 'package:intl/intl.dart';
import 'package:zachranobed/models/food_info.dart';

class OfferedFood {
  final String id;
  final DateTime date;
  final FoodInfo foodInfo;
  final String packaging;
  final DateTime consumeBy;
  final int weekNumber;
  final String donorId;

  OfferedFood({
    required this.id,
    required this.date,
    required this.foodInfo,
    required this.packaging,
    required this.consumeBy,
    required this.weekNumber,
    required this.donorId,
  });

  factory OfferedFood.fromJson(Map<String, dynamic> json) {
    return OfferedFood(
      id: json['fields']['x_ID'],
      date: DateTime.parse(json['fields']['pridanoDne']),
      foodInfo: FoodInfo(
        name: json['fields']['nazevPokrmu'],
        allergens: json['fields']['alergeny'],
        numberOfServings: json['fields']['pocetPorci'],
      ),
      packaging: json['fields']['baleni'],
      consumeBy: DateTime.parse(json['fields']['spotrebujteDo']),
      weekNumber: json['fields']['cisloTydne'],
      donorId: json['fields']['darce']['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'fields': {
          'x_ID': id,
          'pridanoDne': DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse(date.toString())
              .toIso8601String(),
          'nazevPokrmu': foodInfo.name,
          'alergeny': foodInfo.allergens,
          'pocetPorci': foodInfo.numberOfServings,
          'baleni': packaging,
          'spotrebujteDo': consumeBy.toIso8601String(),
          'cisloTydne': weekNumber,
          'darce': {
            'id': donorId,
          }
        }
      };
}
