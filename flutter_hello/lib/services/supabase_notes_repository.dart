import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/note.dart';
import 'notes_repository.dart';

class SupabaseNotesRepository implements NotesRepository {
  SupabaseNotesRepository({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<Note>> list() async {
    final rows = await _client
        .from('private_notes')
        .select('id,content,created_at')
        .order('created_at', ascending: false);
    return (rows as List)
        .map((e) => Note.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<void> add(String content) async {
    await _client.from('private_notes').insert({'content': content});
  }
}
