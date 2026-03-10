import 'package:flutter/material.dart';

Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    onTap: onTap,
    trailing: Icon(Icons.chevron_right),
  );
}