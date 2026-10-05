import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:flutter_hello/main.dart';
import 'package:flutter_hello/models/note.dart';
import 'package:flutter_hello/services/notes_repository.dart';
import 'package:flutter_hello/services/session_repository.dart';

class FakeSessions implements SessionRepository {
  final _ctrl = StreamController<AuthState>.broadcast();

  @override
  Stream<AuthState> authStateChanges() => _ctrl.stream;

  @override
  Session? currentSession() => null;

  @override
  Future<void> signIn({required String email, required String password}) async {}

  @override
  Future<void> signOut() async {}
}

class FakeNotes implements NotesRepository {
  @override
  Future<void> add(String content) async {}

  @override
  Future<List<Note>> list() async => const [Note(content: 'hello from fake')];
}

Widget _app() => HelloApp(sessions: FakeSessions(), notes: FakeNotes());

void main() {
  testWidgets('Greet shows Hello, World by default', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_app());

    expect(find.text('Hello, World!'), findsWidgets);
  });

  testWidgets('Greet updates with name', (WidgetTester tester) async {
    await tester.pumpWidget(_app());

    await tester.enterText(find.byType(TextField).first, 'Ada');
    await tester.tap(find.text('Greet'));
    await tester.pump();

    expect(find.text('Hello, Ada!'), findsOneWidget);
  });

  testWidgets('Private button opens login', (WidgetTester tester) async {
    await tester.pumpWidget(_app());

    await tester.tap(find.text('Sign in for notes'));
    await tester.pumpAndSettle();

    expect(find.text('Private — sign in'), findsOneWidget);
  });
}
