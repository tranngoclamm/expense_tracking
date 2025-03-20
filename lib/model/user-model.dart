class UserModel {
  String uid;
  String name;
  String email;
  String role;
  String avatar;
  String gender;

  UserModel(
      {required this.uid,
      required this.name,
        required this.email,
        required this.role,
        required this.avatar,
      required this.gender});

  UserModel.fromJson(Map<String, Object?> json)
      : this(
            uid: json['uid']! as String,
            name: json['name']! as String,
            email: json['email']! as String,
            role: json['role']! as String,
            avatar: json['avatar']! as String,
            gender: json['gender']! as String);

  UserModel copyWith(
      {String? uid, String? name, String? email, String? role, String? avatar, String? gender}) {
    return UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        role: role ?? this.role,
        avatar: avatar ?? this.avatar,
        gender: gender ?? this.gender);
  }

  Map<String, Object?> toJson() {
    return {'uid': uid, 'name': name,'email': email,'role': role, 'avatar': avatar, 'gender': gender};
  }
}
