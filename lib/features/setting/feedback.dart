import 'package:flutter/material.dart';

import '../../core/services/feedback_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackService _feedbackService = FeedbackService();
  bool _isLoading = false;

  final List<String> _feedbackOptions = [
    'Lỗi phát nhạc',
    'Lỗi giao diện',
    'Góp ý tính năng',
    'Báo lỗi dữ liệu',
    'Khác',
  ];

  String? _selectedIssue;
  final _contentController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Góp ý & Báo lỗi'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn vấn đề cần hỗ trợ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedIssue,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                hint: const Text('Chọn một mục'),
                items: _feedbackOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedIssue = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Vui lòng chọn vấn đề' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Nội dung chi tiết',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'Nhập ý kiến hoặc mô tả lỗi bạn gặp phải tại đây...',
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Vui lòng nhập nội dung chi tiết'
                    : null,
              ),
              _buildInputField(
                context,
                title: 'Họ tên',
                controller: _nameController,
                validatorText: 'Vui lòng nhập họ tên',
              ),
              _buildInputField(
                context,
                title: 'Email',
                controller: _emailController,
                validatorText: 'Vui lòng nhập email',
                keyboardType: TextInputType.emailAddress,
              ),
              _buildInputField(
                context,
                title: 'Số điện thoại',
                controller: _phoneController,
                validatorText: 'Vui lòng nhập Số điện thoại',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              await _feedbackService.sendFeedback(
                                issueType: _selectedIssue!,
                                content: _contentController.text,
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                              );

                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Cảm ơn bạn đã gửi đóng góp ý kiến!',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
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
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00D9D9),
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
                          'Gửi góp ý',
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

  Widget _buildInputField(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required String validatorText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? validatorText : null,
        ),
      ],
    );
  }
}
