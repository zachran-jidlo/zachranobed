class Delivery {
  final String internalId;
  final String donor;
  final String state;

  Delivery({
    required this.internalId,
    required this.donor,
    required this.state,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      internalId: json['id'],
      donor: json['fields']['darce']['fields']['nazevProvozovny'],
      state: json['fields']['stav'],
    );
  }

  Map<String, dynamic> toJson() => {
        'fields': {'stav': state}
      };
}
