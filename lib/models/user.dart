class User {
  int id;
  String name;
  String email;
  String image;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.image});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      // os primeiros users na db não tinham ainda a tabela de imagem, ficaram a null
      // assim atribui-se o a imagem default
      image: json['image'] ?? 'default.png',
    );
  }
}
