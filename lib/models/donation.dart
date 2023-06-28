class Donation {
  int id;
  int userId;
  int missionId;
  int amount;
  String donationMessage;
  String donationDate;
  //
  String userName;
  String userImage;

  Donation({
    required this.id,
    required this.userId,
    required this.missionId,
    required this.amount,
    required this.donationMessage,
    required this.donationDate,
    required this.userImage,
    required this.userName,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id_donation'],
      userId: json['id_user'],
      missionId: json['id_mission'],
      amount: json['amount'],
      donationMessage: json['donation_message'],
      donationDate: json['donation_date'],
      userImage: json['image'],
      userName: json['name'],
    );
  }
}
