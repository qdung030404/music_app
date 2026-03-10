import 'package:flutter/material.dart';
import 'package:music_app/features/widget/buildMenuItem.dart';

class Setting extends StatelessWidget {
   const Setting({super.key});

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.black,
       appBar: AppBar(
         backgroundColor: Colors.transparent,
         elevation: 0,
         title:
           Text('Thiết lập',
             style: TextStyle(
               color: Colors.white,
               fontSize: 18
             ),
           ),
         leading: IconButton(
           icon: const Icon(Icons.arrow_back, color: Colors.white,),
           onPressed: () => Navigator.pop(context)),
       ),
       body: SingleChildScrollView(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             buildMenuItem(Icons.brush_outlined, 'Cá nhân hóa', () {}),
             buildMenuItem(Icons.headphones, 'Tai nghe & Bluetooth', () {}),
             buildMenuItem(Icons.notifications_none_outlined, 'Thông báo', () {}),
             Padding(
               padding: EdgeInsets.symmetric(horizontal: 16),
               child: Divider(),
             ),
             buildMenuItem(Icons.info_outline, 'Thông tin ứng dụng', () {}),
             buildMenuItem(Icons.help_outline, 'Trợ giúp và báo lỗi', () {}),
             buildMenuItem(Icons.more_horiz_outlined, 'Khác', () {})
           ],
         ),
       )
     );
   }

}
