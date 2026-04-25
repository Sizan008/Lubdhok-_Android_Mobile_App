import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/core/services/api_service.dart';
import 'package:lubdhok/core/services/firebase_auth_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) => FirebaseAuthService());