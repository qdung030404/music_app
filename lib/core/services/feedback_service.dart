import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendFeedback({
    required String issueType,
    required String content,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final user = _auth.currentUser;
      
      await _firestore.collection('feedbacks').add({
        'userId': user?.uid ?? 'anonymous',
        'issueType': issueType,
        'content': content,
        'userName': name,
        'userEmail': email,
        'userPhone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending', // Có thể dùng để theo dõi trạng thái xử lý
      });
    } catch (e) {
      throw Exception('Lỗi khi gửi góp ý: $e');
    }
  }
}
