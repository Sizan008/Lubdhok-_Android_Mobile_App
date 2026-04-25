import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubdhok/data/providers/auth_provider.dart';
import 'package:lubdhok/data/repositories/item_repository.dart';

final itemRepositoryProvider = Provider<ItemRepository>(
      (ref) => ItemRepository(ref.read(apiServiceProvider)),
);