import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/features/auth/view/screens/sign_in.dart';
import 'package:music_app/features/main/view/main_screen.dart';
import '../../core/services/artist_notification_service.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => Wrapper_State();
}

class Wrapper_State extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Start observing new songs from followed artists
            ArtistNotificationService().startObserving();
            return const HomeScreen();
          } else {
            return const Loginpage();
          }
        },
      ),
    );
  }
}
