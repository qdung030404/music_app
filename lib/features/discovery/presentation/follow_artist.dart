import 'package:flutter/material.dart';
import 'package:music_app/data/model/artist.dart';
import 'package:music_app/features/discovery/wiget/albumplaylist.dart';
import '../../../data/datasources/user_activity_service.dart';
import '../wiget/followed_list.dart';
class FollowArtist extends StatefulWidget {
  const FollowArtist({super.key});

  @override
  State<FollowArtist> createState() => _FollowArtistState();
}

class _FollowArtistState extends State<FollowArtist> {
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !_showTitle) {
        setState(() {
          _showTitle = true;
        });
      } else if (_scrollController.offset <= 80 && _showTitle) {
        setState(() {
          _showTitle = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF06A0B5), Colors.black],
            stops: [0.01, 0.15]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: _showTitle ? Colors.black.withOpacity(0.8) : Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: AnimatedOpacity(
            opacity: _showTitle ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Text(
              'Nghệ sĩ',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: Colors.white),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32,),
                  const Center(
                    child: Text('Nghệ sĩ',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  StreamBuilder<List<Artist>>(
                      stream: UserActivityService().getFollowedArtist(),
                      builder: (context, snapshot) {
                        final count = snapshot.data?.length ?? 0;
                        if(count > 0){
                          return Center(
                            child: Text('$count nghệ sĩ • đã quan tâm',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        return SizedBox(height: 8);
                      }
                  ),
                  const SizedBox(height: 32),
                  const FollowedList(),
                  const SizedBox(height: 100),
                  // Khoảng trống ở dưới để test cuộn
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
