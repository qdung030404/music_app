import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_app/data/datasources/user_activity_service.dart';

class UpdatePersonalInformation extends StatefulWidget {
  const UpdatePersonalInformation({super.key});

  @override
  State<UpdatePersonalInformation> createState() =>
      _UpdatePersonalInformationState();
}

class _UpdatePersonalInformationState extends State<UpdatePersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _userActivityService = UserActivityService();
  final _imagePicker = ImagePicker();

  bool _isLoading = false;
  File? _pickedImage;

  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = _currentUser?.displayName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  // ─── Chọn ảnh từ gallery ───────────────────────────────────────────────────
  Future<void> _pickImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
      maxHeight: 512,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  // ─── Upload lên Firebase Storage, trả về download URL ─────────────────────
  Future<String> _uploadAvatar(File imageFile) async {
    final uid = _currentUser!.uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child('avatars')
        .child('$uid.jpg');

    final uploadTask = ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // ─── Lưu thay đổi ─────────────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final newName = _nameController.text.trim();

      // 1. Đổi displayName
      await _currentUser?.updateDisplayName(newName);

      // 2. Upload avatar nếu có chọn ảnh mới
      if (_pickedImage != null) {
        final avatarUrl = await _uploadAvatar(_pickedImage!);
        await _currentUser?.updatePhotoURL(avatarUrl);
      }

      // 3. Reload để lấy thông tin mới nhất
      await FirebaseAuth.instance.currentUser?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      // 4. Sync lên Firestore
      if (refreshedUser != null) {
        await _userActivityService.updatePersonalInformation(refreshedUser);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? Colors.grey.shade900 : Colors.grey.shade100;

    Widget avatarChild;
    if (_pickedImage != null) {
      avatarChild = ClipOval(
        child: Image.file(
          _pickedImage!,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
        ),
      );
    } else if (_currentUser?.photoURL != null) {
      avatarChild = ClipOval(
        child: Image.network(
          _currentUser!.photoURL!,
          width: 96,
          height: 96,
          fit: BoxFit.cover,
          errorBuilder: (_, _, e) => const Icon(Icons.person, size: 48),
        ),
      );
    } else {
      avatarChild = const Icon(Icons.person, size: 48);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Cập nhật thông tin cá nhân'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar ──────────────────────────────────────────────────
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: isDark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200,
                      child: avatarChild,
                    ),
                    Positioned(
                      bottom: 0,
                      right: -4,
                      child: GestureDetector(
                        onTap: _isLoading ? null : _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00D9D9),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.black : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Email (read-only) ────────────────────────────────────────
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _currentUser?.email ?? '',
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ),

              if (_pickedImage != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Ảnh mới đã chọn — nhấn Lưu để cập nhật',
                    style: TextStyle(
                      color: const Color(0xFF00D9D9),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],

              // ── Tên hiển thị ─────────────────────────────────────────────
              const SizedBox(height: 28),
              const Text(
                'Tên hiển thị',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nhập tên hiển thị...',
                  filled: true,
                  fillColor: fillColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Tên hiển thị không được để trống'
                    : null,
              ),

              // ── Nút Lưu ──────────────────────────────────────────────────
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9D9),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Lưu thay đổi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
