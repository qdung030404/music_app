import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../home/presentation/home.dart';
import '../../settings/presentation/screen/setting.dart';
import '../../discovery/presentation/screens/discovery.dart';
import '../../home/widget/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _tabs = const [
    HomeTabs(),
    DiscoveryTab(),
    SettingTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
            ],
          ),
          tabBuilder: (context, index) {
            return CupertinoPageScaffold(
              backgroundColor: const Color(0xFF1A1A2E),
              child: SafeArea(
                bottom: false,
                child: _tabs[index],
              ),
            );
          },
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 60), // Above the tab bar
            child: MiniPlayer(),
          ),
        ),
      ],
    );
  }
}
