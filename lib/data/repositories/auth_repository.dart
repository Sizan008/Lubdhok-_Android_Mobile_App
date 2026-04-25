import 'package:firebase_auth/firebase_auth.dart';
import 'package:lubdhok/core/config/api_endpoints.dart';
import 'package:lubdhok/core/services/api_service.dart';
import 'package:lubdhok/core/services/local_storage_service.dart';
import 'package:lubdhok/data/models/user_model.dart';

class AuthRepository {
  final ApiService apiService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final LocalStorageService _localStorageService = LocalStorageService();

  AuthRepository(this.apiService);

  Future<UserCredential> signUpWithFirebase({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> signInWithFirebase({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> reloadFirebaseUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  Future<void> saveRoleForEmail(String email, String role) async {
    await _localStorageService.saveRoleForEmail(email, role);
  }

  Future<String?> getSavedRoleForEmail(String email) async {
    return _localStorageService.getRoleForEmail(email);
  }

  Future<UserModel> syncFirebaseUser({
    required String fullName,
    required String email,
    required String role,
    String? location,
  }) async {
    final response = await apiService.post(
      ApiEndpoints.firebaseSync,
      data: {
        'full_name': fullName,
        'email': email,
        'role': role,
        'location': location,
      },
    );

    await _localStorageService.saveRoleForEmail(email, role);
    return UserModel.fromJson(response.data);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}