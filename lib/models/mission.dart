class Mission {
  int id;
  String image;
  String title;
  String description;
  int totalAmount;
  int limitAmout;
  int isLimited;
  bool active;

  Mission(
      {required this.id,
      required this.image,
      required this.title,
      required this.description,
      required this.totalAmount,
      required this.limitAmout,
      required this.isLimited,
      required this.active});

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id_mission'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      totalAmount: json['total_amount'],
      limitAmout: json['limit_amount'],
      isLimited: json['is_limited'],
      active: json['active'],
    );
  }
}
