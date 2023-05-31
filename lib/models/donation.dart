class Donation {
  int id;
  int amount;
  String donationMessage;
  String donationDate;

  Donation({
    required this.id,
    required this.amount,
    required this.donationMessage,
    required this.donationDate,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id_donation'],
      amount: json['amount'],
      donationMessage: json['donation_message'],
      donationDate: json['donation_date'],
    );
  }
}
