class Donation {
  int id;
  String name;
  String description;
  int amount;

  Donation({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'],
    );
  }
}
