class Mission {
  int id;
  String imageUrl;
  String title;
  String description;
  int totalAmount;
  int isLimited;

  Mission({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.totalAmount,
    required this.isLimited,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      description: json['description'],
      totalAmount: json['total_amount'],
      isLimited: json['is_limited'],
    );
  }
}
