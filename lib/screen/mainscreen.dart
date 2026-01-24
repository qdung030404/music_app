import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screen/tab/home/home.dart';
import 'package:music_app/screen/tab/setting/setting.dart';
import 'package:music_app/screen/tab/user/user.dart';
import 'package:music_app/screen/tab/discovery/discovery.dart';
import 'login/wrapper.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
      useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Wrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _tabs = [
    const HomeTabs(),
    const DiscoveryTab(),
    const UserTab(),
    const SettingTab(),

  ];
  signOut() async{
    await FirebaseAuth.instance.signOut();
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Music App'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => signOut(),
          child: const Icon(CupertinoIcons.square_arrow_right),)
      ),
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            return _tabs[index];
          },
        ),
    );
  }
}




