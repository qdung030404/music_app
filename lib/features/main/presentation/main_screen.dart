import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../home/presentation/home.dart';
import '../../search/presentation/search.dart';
import '../../discovery/presentation/discovery.dart';
import '../../home/widget/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final CupertinoTabController _controller;

  final List<Widget> _tabs = const [
    DiscoveryTab(),
    HomeTabs(),
    SearchTab(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = CupertinoTabController(initialIndex: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoTabScaffold(
          controller: _controller,
          tabBar: CupertinoTabBar(
            backgroundColor: Colors.black,
            border: const Border(
              top: BorderSide(
                color: Colors.white,
                width: 0.2,
              ),
            ),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.album), label: 'Discovery'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            ],
          ),
          tabBuilder: (context, index) {
            return CupertinoPageScaffold(
              backgroundColor: Colors.transparent,
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
