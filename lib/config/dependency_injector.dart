import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Menyimpan dan menyediakan instance dependency aplikasi.
///
/// Class ini singleton, sehingga [ApiService] hanya dibuat satu kali
/// dan dipakai bersama oleh semua repository.
class DependencyInjector {
  DependencyInjector._internal();

  static final DependencyInjector _instance = DependencyInjector._internal();

  /// Mengembalikan instance tunggal [DependencyInjector].
  factory DependencyInjector() => _instance;

  /// Instance tunggal [ApiService].
  ///
  /// Dibuat saat pertama kali diakses (setelah `.env` dimuat).
  late final ApiService apiService = ApiService();

  /// Repository pengguna, bergantung pada abstraksi [UserRepository].
  late final UserRepository userRepository = UserRepositoryImpl(
    apiService: apiService,
  );

  /// Repository post, bergantung pada abstraksi [PostRepository].
  late final PostRepository postRepository = PostRepositoryImpl(
    apiService: apiService,
  );

  /// Menutup resource yang dipakai (HTTP client).
  void dispose() {
    apiService.dispose();
  }
}

/// Menyediakan [DependencyInjector] ke seluruh widget tree.
///
/// Ambil dependency dengan `DependencyProvider.of(context)`.
class DependencyProvider extends InheritedWidget {
  final DependencyInjector injector;

  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Mengambil [DependencyInjector] dari widget tree terdekat.
  static DependencyInjector of(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<DependencyProvider>();
    assert(
      provider != null,
      'DependencyProvider tidak ditemukan di widget tree',
    );
    return provider!.injector;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}
