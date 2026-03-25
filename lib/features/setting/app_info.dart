import 'package:flutter/material.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin ứng dụng'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // App Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF00D9D9).withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00D9D9).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/splash_logo.png', // Hoặc logo thực của bạn
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.music_note_rounded,
                      size: 60,
                      color: Color(0xFF00D9D9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Musium',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Phiên bản 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              
              // Description Card
              _buildInfoCard(
                title: 'Giới thiệu',
                content: 'Ứng dụng nghe nhạc trực tuyến hàng đầu, mang đến cho bạn trải nghiệm âm thanh chất lượng cao và kho nhạc khổng lồ từ Jamendo API.',
                theme: theme,
              ),
              
              const SizedBox(height: 16),
              
              // Features Card
              _buildInfoCard(
                title: 'Tính năng chính',
                content: '• Nghe nhạc trực tuyến miễn phí\n'
                        '• Tìm kiếm bài hát, nghệ sĩ và album\n'
                        '• Theo dõi nghệ sĩ yêu thích\n'
                        '• Chế độ offline (tải nhạc)\n'
                        '• Giao diện tùy biến theo ngày/đêm',
                theme: theme,
              ),
              
              const SizedBox(height: 40),
              
              // Social Links or Developer info
              Column(
                children: [
                  Text(
                    'Phát triển bởi',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Music Team',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 60),
              // Copyright
              Text(
                '© 2024 Music App. All Rights Reserved.',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required ThemeData theme,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark 
            ? Colors.grey[900] 
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00D9D9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
