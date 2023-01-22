class OfferedFood {

  final DateTime date;
  final String name;
  final String allergens;
  final int numberOfServings;
  final String packaging;
  final DateTime consumeBy;

  OfferedFood({
    required this.date,
    required this.name,
    required this.allergens,
    required this.numberOfServings,
    required this.packaging,
    required this.consumeBy
  });

  factory OfferedFood.fromJson(Map<String, dynamic> json) {
    return OfferedFood(
      date: DateTime.parse(json['fields']['pridanoDne']),
      name: json['fields']['nazevPokrmu'],
      allergens: json['fields']['alergeny'],
      numberOfServings: json['fields']['pocetPorci'],
      packaging: json['fields']['baleni'],
      consumeBy: DateTime.parse(json['fields']['spotrebujteDo'])
    );
  }
}
