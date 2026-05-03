import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flash_english/domain/repositories/unit_repository.dart';

import 'package:flash_english/infrastructure/repositories/unit_repository_impl.dart';

final unitRepositoryProvider = Provider<UnitRepository>((ref) {
  return UnitRepositoryImpl();
});
