import 'package:flutter/material.dart';
import 'supabase_config.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase dari file config
  await SupabaseConfig.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventaris App',
      // Mengatur font global agar tidak perlu di-set di setiap halaman
      theme: ThemeData(
        primarySwatch: Colors.green, 
        fontFamily: 'Sans-Serif'
      ),
      home: const LoginPage(),
    );
  }
}