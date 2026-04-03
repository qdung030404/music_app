import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/app.dart';

import 'core/config/firebase_options.dart';
import 'core/services/audio_device_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Get.putAsync(() => ThemeService().init());

  // Khởi động service theo dõi thiết bị âm thanh
  await AudioDeviceService().init();
  await NotificationService().init();

  // Remove splash screen
  FlutterNativeSplash.remove();

  runApp(const MusicApp());
}
