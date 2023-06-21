class User {
  int id;
  String name;
  String email;
  String image;
  String mobilePhone;
  String registerDate;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
    required this.mobilePhone,
    required this.registerDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id_user'],
      name: json['user']['name'],
      mobilePhone: json['user']['mobile_phone'],
      email: json['user']['email'],
      image: json['user']['image'],
      registerDate: json['user']['register_date'],
    );
  }
}
