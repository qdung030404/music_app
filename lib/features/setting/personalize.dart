import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/core/theme/app_theme.dart';
class Personalize extends StatelessWidget{
  const Personalize({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text('Thiết lập cá nhân'),
        elevation: 0,
      ),
      body:SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Giao diện:',
                style: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
            GetBuilder<ThemeService>(
              builder: (themeService) => SwitchListTile(
                value: themeService.isDarkMode,
                title: Text(themeService.isDarkMode ? 'tối ' : 'măc định '),
                onChanged: (val) {
                  themeService.switchTheme();
                },
                secondary: Icon(themeService.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              ),
            ),
            GetBuilder<ThemeService>(
              builder: (themeService) => SwitchListTile(
                value: themeService.isAutoChange,
                title: Text('Hiển thị theo ngày đêm'),
                onChanged: (val) {
                  themeService.isToggleTheme(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}