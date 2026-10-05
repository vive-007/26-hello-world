import 'package:supabase_flutter/supabase_flutter.dart';

/// Auth boundary — UI depends on this, never on Supabase directly.
abstract class SessionRepository {
  Stream<AuthState> authStateChanges();
  Session? currentSession();
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
}
