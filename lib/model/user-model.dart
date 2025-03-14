class UserModel {
  String uid;
  String name;
  String avatar;
  String gender;

  UserModel(
      {required this.uid,
      required this.name,
      required this.avatar,
      required this.gender});

  UserModel.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            name: json['name']! as String,
            avatar: json['avatar']! as String,
            gender: json['gender']! as String);

  UserModel copyWith(
      {String? uid, String? name, String? avatar, String? gender}) {
    return UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        gender: gender ?? this.gender);
  }

  Map<String, Object?> toJson() {
    return {'uid': uid, 'name': name, 'avatar': avatar, 'gender': gender};
  }
}
