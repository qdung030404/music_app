import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/core/theme/app_theme.dart';
import 'package:music_app/features/setting/update_personal_information.dart';

import '../shared/widgets/buildMenuItem.dart';

class Personalize extends StatelessWidget {
  const Personalize({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Thiết lập cá nhân'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Giao diện:',
                style: TextStyle(fontSize: 20),
              ),
            ),
            GetBuilder<ThemeService>(
              builder: (themeService) {
                ThemeMode currentMode = themeService.isSystemMode
                    ? ThemeMode.system
                    : (themeService.isDarkMode
                          ? ThemeMode.dark
                          : ThemeMode.light);

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    VerticalRadioTile<ThemeMode>(
                      label: 'Mặc định',
                      value: ThemeMode.light,
                      groupValue: currentMode,
                      onChanged: (val) {
                        themeService.setLightMode();
                      },
                      image: Image.asset(
                        'assets/light_mode.png',
                        width: 100,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    VerticalRadioTile<ThemeMode>(
                      label: 'Chế độ tối',
                      value: ThemeMode.dark,
                      groupValue: currentMode,
                      onChanged: (val) {
                        themeService.setDarkMode();
                      },
                      image: Image.asset(
                        'assets/dark_mode.png',
                        width: 100,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    VerticalRadioTile<ThemeMode>(
                      label: 'Hệ thống',
                      value: ThemeMode.system,
                      groupValue: currentMode,
                      onChanged: (val) {
                        themeService.setSystemMode(true);
                      },
                      image: Image.asset(
                        'assets/auto_mode.png',
                        width: 100,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                );
              },
            ),
            GetBuilder<ThemeService>(
              builder: (themeService) => SwitchListTile(
                value: themeService.isAutoChange,
                title: Text('Hiển thị theo ngày đêm'),
                activeColor: const Color(0xFF00D9D9),
                activeTrackColor: const Color(0xFF00D9D9).withOpacity(0.3),
                onChanged: (val) {
                  themeService.isToggleTheme(val);
                },
              ),
            ),
            buildMenuItem(Icons.person, 'Cập nhật thông tin cá nhân', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdatePersonalInformation(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class VerticalRadioTile<T> extends StatelessWidget {
  final Widget image;
  final String label;
  final T value;
  final T groupValue;
  final Function(T?) onChanged;

  const VerticalRadioTile({
    super.key,
    required this.image,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Color(0xFF00D9D9) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: image,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
