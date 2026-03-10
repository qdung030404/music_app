import 'package:flutter/material.dart';
import 'package:music_app/features/setting/device_storage_info/device_storage.dart';


class DownloadSetting extends StatefulWidget {
  const DownloadSetting({super.key});

  @override
  State<DownloadSetting> createState() => _DownloadSettingState();
}

class _DownloadSettingState extends State<DownloadSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white,)),
        title: Text(
            'Tải Nhạc',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                title: Text(
                  'Chất lượng tải',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Luôn Hỏi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                    ),
                  ],
                ),
                onTap: (){},
              )
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20),
              child: Divider(),
            ),
            const Storage(),
          ],
        ),
      ),
    );
  }
}

