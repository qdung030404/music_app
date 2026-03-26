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

  // Remove splash screen
  FlutterNativeSplash.remove();

  // await addMultipleSongs();
  runApp(const MusicApp());
}

Future<void> addMultipleSongs() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  WriteBatch batch = db.batch();

  List<Map<String, dynamic>> songs = [
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': '',
    },
  ];

  for (var song in songs) {
    DocumentReference docRef = db.collection('songs').doc();
    batch.set(docRef, song);
  }

  await batch.commit();
}

class SeedDataScreen extends StatelessWidget {
  const SeedDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await addMultipleSongs();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã thêm bài hát')),
              );
            }
          },
          child: const Text('Thêm nhiều bài hát'),
        ),
      ),
    );
  }
}
