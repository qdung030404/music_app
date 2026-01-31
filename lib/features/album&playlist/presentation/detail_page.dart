import 'package:flutter/material.dart';

import '../widget/infomation.dart';

class AlbumDetail extends StatelessWidget {
  const AlbumDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return AlbumDetailState();
  }
}
class AlbumDetailState extends StatefulWidget {
  const AlbumDetailState({super.key});

  @override
  State<AlbumDetailState> createState() => _AlbumDetailStateState();
}

class _AlbumDetailStateState extends State<AlbumDetailState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz, color: Colors.white))
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                 child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Album_Infomation(),
                    ],
                  )
              )
          )
      ),
    );
  }
}

