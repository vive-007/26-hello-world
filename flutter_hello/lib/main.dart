import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config.dart';
import 'screens/login_screen.dart';
import 'screens/notes_screen.dart';
import 'services/notes_repository.dart';
import 'services/session_repository.dart';
import 'services/supabase_notes_repository.dart';
import 'services/supabase_session_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);  runApp(
    HelloApp(
      sessions: SupabaseSessionRepository(),
      notes: SupabaseNotesRepository(),
    ),
  );
}

class HelloApp extends StatelessWidget {
  const HelloApp({super.key, required this.sessions, required this.notes});

  final SessionRepository sessions;
  final NotesRepository notes;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello, World!',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: HelloPage(sessions: sessions, notes: notes),
    );
  }
}

class HelloPage extends StatefulWidget {
  const HelloPage({super.key, required this.sessions, required this.notes});

  final SessionRepository sessions;
  final NotesRepository notes;

  @override
  State<HelloPage> createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage> {
  final _nameController = TextEditingController();
  String _greeting = 'Hello, World!';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _greet() {
    final name = _nameController.text.trim();
    setState(() {
      _greeting = 'Hello, ${name.isEmpty ? 'World' : name}!';
    });
  }

  void _openPrivate() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            _PrivateGate(sessions: widget.sessions, notes: widget.notes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello, World!'),
        actions: [
          TextButton(
            onPressed: _openPrivate,
            child: const Text('Private', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: .center,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your name',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _greet(),
                ),
                const SizedBox(height: 12),
                FilledButton(onPressed: _greet, child: const Text('Greet')),
                const SizedBox(height: 16),
                Text(
                  _greeting,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                StreamBuilder(
                  stream: widget.sessions.authStateChanges(),
                  builder: (context, snapshot) {
                    final signedIn =
                        widget.sessions.currentSession() != null ||
                        snapshot.data?.session != null;
                    return OutlinedButton(
                      onPressed: _openPrivate,
                      child: Text(
                        signedIn ? 'Open my notes' : 'Sign in for notes',
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrivateGate extends StatelessWidget {
  const _PrivateGate({required this.sessions, required this.notes});

  final SessionRepository sessions;
  final NotesRepository notes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: sessions.authStateChanges(),
      builder: (context, snapshot) {
        final signedIn =
            sessions.currentSession() != null ||
            snapshot.data?.session != null;
        if (signedIn) return NotesScreen(notes: notes, sessions: sessions);
        return LoginScreen(sessions: sessions);
      },
    );
  }
}
