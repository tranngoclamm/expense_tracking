class Category {
  String icon;
  String name;
  String type;

  Category({required this.name, required this.icon, required this.type});

  Category.fromJson(Map<String, dynamic> json)
      : this(
      name: json['name'] as String,
      icon: json['icon'] as String, // Đọc đường dẫn ảnh từ JSON
      type: json['type'] as String);

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon, 'type': type};
  }
}
