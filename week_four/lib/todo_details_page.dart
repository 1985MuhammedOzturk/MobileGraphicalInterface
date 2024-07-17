import 'package:flutter/material.dart';

class TodoDetailsPage extends StatelessWidget {
  final int id;
  final String title;
  final VoidCallback onDelete;

  TodoDetailsPage({
    required this.id,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ID: $id', style: TextStyle(fontSize: 18)),
          SizedBox(height: 10),
          Text('Title: $title', style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
