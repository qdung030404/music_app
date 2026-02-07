import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_app/app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'core/config/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
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
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
    },
    {
      'title': '',
      'artistId': '',
      'albumId': 'xyz',
      'duration': 180,
      'image': '',
      'source': '',
      'is_favorite': ''
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
