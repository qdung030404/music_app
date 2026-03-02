import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class BuildHeader extends StatefulWidget {
  const BuildHeader({super.key});

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  String _selectAtion = 'none';
  int _menuCount = 0;
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      children: [
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'logout') {
              await FirebaseAuth.instance.signOut();
            }
            setState(() {
              _selectAtion = value;
              _menuCount++;
            });
          },
          color: Colors.grey[100],
          elevation: 8,
          itemBuilder: (context) => [
            const PopupMenuItem(
                value: 'Setting',
                child: ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.lightBlue,
                  ),
                  title: Text('Cài đặt'),
                  contentPadding: EdgeInsets.zero,
                )),
            const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.lightBlue,
                  ),
                  title: Text('Đăng xuất'),
                  contentPadding: EdgeInsets.zero,
                ))
          ],
          child: CircleAvatar(
            radius: 20,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!)
                : null,
            child: user?.photoURL == null
                ? const Icon(Icons.person, size: 22)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back !',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Text(
                  user?.displayName ??
                      user?.email?.split('@')[0] ??
                      'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,)
              ),
            ],
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart, color: Colors.white)),
      ],
    );
  }
}