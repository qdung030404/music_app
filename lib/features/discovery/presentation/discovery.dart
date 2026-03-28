import 'package:flutter/material.dart';

import '../widget/History.dart';
import '../widget/library_card_list.dart';
import '../widget/page_storage/albumplaylist.dart';

class DiscoveryTab extends StatelessWidget {
  const DiscoveryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: 32,
              right: 16,
              bottom: 8,
              left: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Thư viện',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          const LibraryCardList(),
          const History(),
          const SizedBox(
            height: 400, // Adjust height as needed
            child: Albumplaylist(),
          ),
        ],
      ),
    );
  }
}
