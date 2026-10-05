import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteDetailScreen extends StatelessWidget {
  const NoteDetailScreen({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Note')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.content, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            if (note.createdAt != null)
              Text(note.createdAt!.toLocal().toString()),
          ],
        ),
      ),
    );
  }
}
