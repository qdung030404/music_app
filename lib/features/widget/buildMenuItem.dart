import 'package:flutter/material.dart';

Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    onTap: onTap,
    trailing: const Icon(Icons.chevron_right),
  );
}
