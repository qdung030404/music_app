import 'package:flutter/material.dart';

class SearchHistory extends StatelessWidget {
  final List<String> history;
  final Function(String) onSelect;
  final Function(String) onDelete;

  const SearchHistory({
    super.key,
    required this.history,
    required this.onSelect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'Lịch sử tìm kiếm trống',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: history.map((query) {
        return InputChip(
          label: Text(query),
          onDeleted: () => onDelete(query),
          deleteIconColor: Colors.black,
          backgroundColor: Colors.deepPurpleAccent,
          labelStyle: const TextStyle(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.white24),
          ),
          onPressed: () => onSelect(query),
        );
      }).toList(),
    );
  }
}
