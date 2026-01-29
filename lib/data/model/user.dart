import 'package:music_app/domain/entities/user_entity.dart';
export 'package:music_app/domain/entities/user_entity.dart';


class UserModel extends User {
  UserModel({
    required super.uid,
    required super.username,
    required super.email,
    required super.imageUrl});

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'avatar': imageUrl,
    };
  }
}