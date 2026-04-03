import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';

class ArtistNotificationService {
  static final ArtistNotificationService _instance =
      ArtistNotificationService._internal();

  factory ArtistNotificationService() => _instance;

  ArtistNotificationService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void startObserving() {
    final user = _auth.currentUser;
    if (user == null) return;

    // Lấy danh sách nghệ sĩ đang follow
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('followed')
        .snapshots()
        .listen((followedSnapshot) {
      final followedArtistIds = followedSnapshot.docs.map((doc) => doc.id).toList();

      if (followedArtistIds.isEmpty) return;

      // Lắng nghe các bài hát mới của những nghệ sĩ này
      // Trong thực tế, bạn có thể lọc theo timestamp gần đây (ví dụ: trong vòng 24h)
      // Ở đây ta lắng nghe sự thay đổi của bộ sưu tập songs
      _firestore
          .collection('songs')
          .where('artistId', whereIn: followedArtistIds)
          .snapshots()
          .listen((songsSnapshot) {
        for (var change in songsSnapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final songData = change.doc.data();
            if (songData != null) {
              final songTitle = songData['title'] ?? 'Bài hát mới';
              final artistName = songData['artistName'] ?? 'Nghệ sĩ bạn quan tâm';

              // Tránh hiển thị thông báo cũ khi mới bắt đầu quan sát
              // Chúng ta có thể kiểm tra xem timestamp của bài hát có mới không
              final dynamic timestamp = songData['timestamp'];
              if (timestamp is Timestamp) {
                 final now = DateTime.now();
                 final songDate = timestamp.toDate();
                 // Nếu bài hát được thêm vào trong vòng 1 phút qua
                 if (now.difference(songDate).inSeconds < 60) {
                    NotificationService().showNotification(
                      id: change.doc.id.hashCode,
                      title: 'Có nhạc mới từ $artistName',
                      body: 'Hãy thưởng thức bài hát: $songTitle',
                    );
                 }
              }
            }
          }
        }
      });
    });
  }
}
