class OfferedFood {

  final String id;
  final DateTime date;
  final String name;
  final String allergens;
  final int numberOfServings;
  final String packaging;
  final DateTime consumeBy;
  final int weekNumber;
  final String donorId;

  OfferedFood({
    required this.id,
    required this.date,
    required this.name,
    required this.allergens,
    required this.numberOfServings,
    required this.packaging,
    required this.consumeBy,
    required this.weekNumber,
    required this.donorId
  });

  factory OfferedFood.fromJson(Map<String, dynamic> json) {
    return OfferedFood(
      id: json['fields']['x_ID'],
      date: DateTime.parse(json['fields']['pridanoDne']),
      name: json['fields']['nazevPokrmu'],
      allergens: json['fields']['alergeny'],
      numberOfServings: json['fields']['pocetPorci'],
      packaging: json['fields']['baleni'],
      consumeBy: DateTime.parse(json['fields']['spotrebujteDo']),
      weekNumber: json['fields']['cisloTydne'],
      donorId: json['fields']['darce']['id']
    );
  }

  Map<String, dynamic> toJson() => {
    'fields': {
      'x_ID': id,
      'pridanoDne': date.toIso8601String(),
      'nazevPokrmu': name,
      'alergeny': allergens,
      'pocetPorci': numberOfServings,
      'baleni': packaging,
      'spotrebujteDo': consumeBy.toIso8601String(),
      'cisloTydne': weekNumber,
      'darce': {
        'id': donorId,
      }
    },
  };
}
