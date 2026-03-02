import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/wrapper/wrapper.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music App',
      theme: ThemeData(
        useMaterial3: true,

      ),
      home: const Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
