import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart'; // Import config untuk akses variabel supabase
import 'admin.dart';
import 'peminjam.dart';
import 'petugas.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  bool obscureText = true;
  bool isLoading = false;
  String? emailError;
  String? passwordError;
  String? generalError;

  Future<void> signIn() async {
    setState(() {
      emailError = null;
      passwordError = null;
      generalError = null;
    });

    if (emailController.text.isEmpty) {
      setState(() => emailError = "Email tidak boleh kosong");
      return;
    }
    if (passwordController.text.isEmpty) {
      setState(() => passwordError = "Password tidak boleh kosong");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (response.user != null) {
        // Ambil role dari tabel profiles
        final userData = await supabase
            .from('profiles')
            .select('role')
            .eq('id_user', response.user!.id)
            .single();

        String role = userData['role'];
        
        if (!mounted) return;

        // Navigasi ke halaman sesuai role
        if (role == 'admin') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminPage()));
        } else if (role == 'petugas') {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ApprovalPage()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PeminjamPage()));
        }
      }
    } on AuthException catch (error) {
      setState(() {
        if (error.message.contains("Invalid login credentials")) {
          generalError = "Email atau password salah";
        } else {
          generalError = error.message;
        }
      });
    } catch (error) {
      setState(() => generalError = "Terjadi kesalahan: $error");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Hi, Selamat Datang!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 60),

              _buildDecoratedInput(
                label: "Email",
                controller: emailController,
                hint: "Masukkan Email",
                errorText: emailError,
              ),

              const SizedBox(height: 25),

              _buildDecoratedInput(
                label: "Password",
                controller: passwordController,
                hint: "Masukkan Password",
                isPass: true,
                errorText: passwordError,
              ),

              if (generalError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    generalError!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF108A3E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("LOGIN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecoratedInput({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isPass = false,
    String? errorText,
  }) {
    bool hasError = errorText != null;
    Color themeColor = hasError ? Colors.redAccent : const Color(0xFF108A3E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: themeColor, width: 1.5),
              ),
              child: TextField(
                controller: controller,
                obscureText: isPass ? obscureText : false,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: InputBorder.none,
                  suffixIcon: isPass
                      ? IconButton(
                          icon: Icon(
                            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => setState(() => obscureText = !obscureText),
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                color: Colors.white,
                child: Text(
                  label,
                  style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(errorText, style: const TextStyle(color: Colors.redAccent, fontSize: 11)),
          ),
      ],
    );
  }
}