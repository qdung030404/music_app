import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BuildHeader extends StatelessWidget {

  const BuildHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? const Icon(Icons.person, size: 22)
              : null,
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.white)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.white)),
      ],
    );
  }
}
