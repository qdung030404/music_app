import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService{
  final auth = FirebaseAuth.instance;
  final googleSignIn = GoogleSignIn();
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  String? validate(String email, [String? password, String? confirmPassword] ) {
    if (email.trim().isEmpty) {
      return 'Vui lòng nhập email';
    }
    if (!_isValidEmail(email.trim())) {
      return 'Email không hợp lệ';
    }
    if (password != null && password.trim().isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (password != null && password.trim().length < 6){
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (password != null && confirmPassword != null && password.trim() != confirmPassword.trim()) {
      return 'Mật khẩu không khớp';
    }
    return null;
  }
  Future<bool> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser == null) return false;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential);
      return true;
    } catch(e){
      return false;
    }
  }
  Future<String?> signIn(String email, String password) async {
    var error = validate(email, password);
    if (error != null) {
      return error;
    }
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Người dùng không tồn tại';
      } else if (e.code == 'wrong-password') {
        return 'Sai mật khẩu';
      } else if (e.code == 'invalid-email') {
        return 'Email không hợp lệ';
      } else if (e.code == 'invalid-credential') {
        return 'Email hoặc mật khẩu không đúng';
      } else {
        return 'Đăng nhập thất bại';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi';
    }
  }

  Future<String?> signUp(String email, String password, String confirmPassword) async {
    var error = validate(email, password, confirmPassword);
    if (error != null) {
      return error;
    }
    try {
      await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email đã được sử dụng';
      } else if (e.code == 'weak-password') {
        return 'Mật khẩu quá yếu';
      } else if (e.code == 'invalid-email') {
        return 'Email không hợp lệ';
      } else {
        return 'Đăng ký thất bại';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi';
    }
  }
  Future<String?> resetPassword(String email) async {
    var error = validate(email);
    if (error != null) {
      return error;
    }
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Email không tồn tại';
      } else if (e.code == 'invalid-email') {
        return 'Email không hợp lệ';
      } else {
        return 'Gửi email thất bại';
      }
    } catch (e) {
      return 'Đã xảy ra lỗi';
    }
  }
  Future<String?> sendEmailVerification() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return 'Không tìm thấy người dùng';
      }
      if (user.emailVerified) {
        return 'Email đã được xác thực';
      }
      await user.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        return 'Gửi quá nhiều yêu cầu. Vui lòng thử lại sau';
      }
      return 'Gửi email xác thực thất bại';
    } catch (e) {
      return 'Đã xảy ra lỗi';
    }
  }

  Future<bool> isEmailVerified() async {
    await auth.currentUser?.reload();
    return auth.currentUser?.emailVerified ?? false;
  }
  Future<void> googleSignOut() async{
    await googleSignIn.signOut();
    await auth.signOut();
  }
}