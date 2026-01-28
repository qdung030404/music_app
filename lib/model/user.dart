class User {
  String uid;
  String username;
  String email;
  String imageUrl;

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
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