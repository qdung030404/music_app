import 'package:flutter/material.dart';

import '../../../core/services/device_storage_service.dart'; // <-- đường dẫn đúng
class Storage extends StatefulWidget {
  const Storage({super.key});
  @override
  State<Storage> createState() => _StorageState();
}
class _StorageState extends State<Storage> {
  double totalSpace = 0;
  double freeSpace = 0;
  double downloadedMusic = 0;
  double cache = 0;
  double other = 0;
  bool _loading = true;
  String _error = '';
  @override
  void initState() {
    super.initState();
    _loadStorageInfo();
  }
  Future<void> _loadStorageInfo() async {
    try {
      final data = await DeviceStorageService.getStorageInfo();
      setState(() {
        totalSpace = data['total']!;
        freeSpace = data['free']!;
        downloadedMusic = data['downloaded']!;
        cache = data['cache']!;
        other = data['other']!;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Text('❌ Lỗi: $_error',
          style: const TextStyle(color: Colors.red));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lưu trữ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
                TextButton.icon(
                  onPressed: () async {
                    setState(() => _loading = true);
                    await DeviceStorageService.clearCache();
                    await _loadStorageInfo();
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.orange, size: 18),
                  label: const Text(
                    'Xóa bộ nhớ tạm',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 12,
              width: double.infinity,
              child: Row(
                children: [
                  if (other > 0)
                    Flexible(
                      flex: (other * 1000).toInt(),
                      child: Container(color: Colors.deepPurple),
                    ),
                  if (downloadedMusic > 0)
                    Flexible(
                      flex: (downloadedMusic * 1000).toInt(),
                      child: Container(color: Colors.blue),
                    ),
                  if (cache > 0)
                    Flexible(
                      flex: (cache * 1000).toInt(),
                      child: Container(color: Colors.orange),
                    ),

                  if (freeSpace > 0)
                    Flexible(
                      flex: (freeSpace * 1000).toInt(),
                      child: Container(color: Colors.grey.shade800),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildStorageInfoRow(),
        ],
      ),
    );
  }
  Widget _buildStorageInfoRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLegendItem('Nhạc đã tải', Colors.blue, downloadedMusic),
            _buildLegendItem('Bộ nhớ tạm', Colors.orange, cache),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLegendItem('Khác', Colors.deepPurple, other),
            _buildLegendItem('Còn trống', Colors.grey.shade800, freeSpace),
          ],
        ),
      ],
    );
  }
  Widget _buildLegendItem(String title, Color color, double sizeInMB) {
    String displaySize;
    if (sizeInMB >= 1024) {
      displaySize = '${(sizeInMB / 1024).toStringAsFixed(1)} GB';
    } else {
      displaySize = '${sizeInMB.toStringAsFixed(1)} MB';
    }

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$title ($displaySize)',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}