import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/core/services/api_service.dart';
import 'package:lubdhok/data/models/user_model.dart';
import 'package:lubdhok/data/repositories/auth_repository.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(ref.read(apiServiceProvider)),
);

final currentUserProvider = StateProvider<UserModel?>((ref) => null);

final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});