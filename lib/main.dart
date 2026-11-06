import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/app_config.dart';
import 'screens/home_screen.dart';
import 'utils/logger.dart';

/// Entry point aplikasi.
///
/// Memuat konfigurasi dari file `.env` sebelum menjalankan aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env
  await dotenv.load(fileName: ".env");

  // Periksa konfigurasi
  if (!AppConfig.isConfigured()) {
    Logger.warning('Konfigurasi .env tidak lengkap. Periksa file .env Anda.');
  }

  // --- BUKTI LOGGER (sementara, hapus setelah screenshot) ---
  Logger.debug('Contoh debug');
  Logger.info('Contoh info');
  Logger.warning('Contoh warning');
  Logger.error('Contoh error', Exception('gagal'));
  Logger.info('Login dengan token: abc123xyz');
  // --- AKHIR BUKTI LOGGER ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPL & Keamanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
