// lib/views/register_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:peminjaman_buku/models/user.dart';
import 'package:peminjaman_buku/views/welcome_screen.dart';
import 'package:peminjaman_buku/views/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Pengguna'),
        backgroundColor: const Color(0xFF8E2DE2),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _nikController,
                decoration: const InputDecoration(labelText: 'NIK', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'NIK wajib diisi';
                  if (v.length != 10) return 'NIK harus 10 digit';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'contoh@gmail.com',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return 'Email wajib diisi';
                  if (!v.endsWith('@gmail.com')) return 'Email harus @gmail.com';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: 'Alamat', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Alamat wajib diisi' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _noTelpController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon', border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'No. Telepon wajib diisi';
                  if (!RegExp(r'^08[0-9]{8,11}$').hasMatch(v)) {
                    return 'Format salah (contoh: 081234567890)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Username wajib diisi';
                  if (v.length < 4) return 'Username minimal 4 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                obscureText: true,
                validator: (v) {
                  if (v!.isEmpty) return 'Password wajib diisi';
                  if (v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E2DE2),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final newUser = User(
                    fullName: _namaController.text.trim(),
                    nik: _nikController.text.trim(),
                    email: _emailController.text.trim().toLowerCase(),
                    alamat: _alamatController.text.trim(),
                    noTelp: _noTelpController.text.trim(),
                    username: _usernameController.text.trim(),
                    password: _passwordController.text,
                  );

                  final prefs = await SharedPreferences.getInstance();
                  List<User> userList = [];

                  final String? usersJson = prefs.getString('users');
                  if (usersJson != null) {
                    userList = (json.decode(usersJson) as List)
                        .map((e) => User.fromJson(e as Map<String, dynamic>))
                        .toList();
                  }

                  if (userList.any((u) => u.email == newUser.email || u.nik == newUser.nik)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email atau NIK sudah terdaftar!'), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  userList.add(newUser);
                  await prefs.setString('users', json.encode(userList.map((u) => u.toJson()).toList()));

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registrasi berhasil! Silakan login'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  await Future.delayed(const Duration(milliseconds: 1500));

                  if (!mounted) return;

                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                child: const Text('Daftar', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _noTelpController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}