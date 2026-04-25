import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = StateProvider<List<String>>((ref) => []);