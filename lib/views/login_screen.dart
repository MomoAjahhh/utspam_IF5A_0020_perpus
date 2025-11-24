import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:peminjaman_buku/models/user.dart';
import 'package:peminjaman_buku/views/register_screen.dart';
import 'package:peminjaman_buku/views/home_screen.dart';
import 'package:peminjaman_buku/views/welcome_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrNikController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8E2DE2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
              (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailOrNikController,
                decoration: const InputDecoration(
                  labelText: 'Email atau NIK',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8E2DE2),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            final prefs = await SharedPreferences.getInstance();
                            final String? usersJson = prefs.getString('users');
                            if (usersJson == null) {
                              _showSnackBar(
                                'Belum ada akun. Silakan registrasi dulu.',
                                Colors.red,
                              );
                              setState(() => _isLoading = false);
                              return;
                            }

                            List<User> users = (json.decode(usersJson) as List)
                                .map((e) => User.fromJson(e))
                                .toList();

                            final input = _emailOrNikController.text.trim();

                            User? loggedInUser;
                            for (var user in users) {
                              if (user.email.toLowerCase() ==
                                      input.toLowerCase() ||
                                  user.nik == input) {
                                if (user.password == _passwordController.text) {
                                  loggedInUser = user;
                                  break;
                                }
                              }
                            }

                            if (loggedInUser != null) {
                              // SIMPAN SESSION DENGAN CARA PALING AMAN (tanpa toJson)
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                'current_user',
                                jsonEncode({
                                  'nama_lengkap': loggedInUser.fullName,
                                  'nik': loggedInUser.nik,
                                  'email': loggedInUser.email,
                                  'alamat': loggedInUser.alamat,
                                  'telp': loggedInUser.noTelp,
                                  'username': loggedInUser.username,
                                  'password': loggedInUser
                                      .password, // boleh disimpan karena lokal
                                }),
                              );

                              _showSnackBar('Login berhasil!', Colors.green);

                              // PAKAI CARA NAVIGASI PALING AMAN
                              if (!mounted) return;
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/home',
                                (route) => false,
                              );
                            } else {
                              _showSnackBar(
                                'Email/NIK atau password salah!',
                                Colors.red,
                              );
                            }
                            setState(() => _isLoading = false);
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text('Belum punya akun? Registrasi di sini'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
