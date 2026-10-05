import '../models/note.dart';

/// Notes boundary — same `private_notes` table as private.html / notes.py.
abstract class NotesRepository {
  Future<List<Note>> list();
  Future<void> add(String content);
}
