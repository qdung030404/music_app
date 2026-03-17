import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/features/setting/feedback.dart';
import 'package:music_app/features/setting/headphone_&_bluetooth.dart';
import 'package:music_app/features/setting/personalize.dart';
import 'package:music_app/features/widget/buildMenuItem.dart';
import 'package:music_app/features/setting/other_setting.dart';


class Setting extends StatelessWidget {
   const Setting({super.key});

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: const Text('Thiết lập'),
         leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () => Navigator.pop(context)),
       ),
       body: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [

             buildMenuItem(Icons.brush_outlined, 'Cá nhân hóa', () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => Personalize())
               );
             }),
             buildMenuItem(Icons.headphones, 'Tai nghe & Bluetooth', () {
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => HeadphoneBluetooth())
               );
             }),
             buildMenuItem(Icons.notifications_none_outlined, 'Thông báo', () {}),
             const Padding(
               padding: EdgeInsets.symmetric(horizontal: 16),
               child: Divider(),
             ),
             buildMenuItem(Icons.info_outline, 'Thông tin ứng dụng', () {

             }),
             buildMenuItem(Icons.feedback_outlined, 'Góp ý & báo lỗi', () {
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => FeedbackPage())
               );
             }),
             const Padding(
               padding: EdgeInsets.symmetric(horizontal: 16),
               child: Divider(),
             ),
             buildMenuItem(Icons.more_horiz_outlined, 'Khác', () {
               Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => const OtherSetting()),
               );
             }),
             buildMenuItem(Icons.logout, 'Đăng xuất', (){FirebaseAuth.instance.signOut();})
           ],
         ),
       )
     );
   }

}
