// lib/views/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:peminjaman_buku/models/user.dart';
import 'package:peminjaman_buku/views/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user'); // hapus session

    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome', // BALIK KE WELCOME SCREEN
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Color(0xFF8E2DE2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("Data pengguna tidak ditemukan\nSilakan login ulang"),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // HEADER ORANYE + AVATAR + NAMA + USERNAME
                Container(
                  width: double.infinity,
                  color: Color(0xFF8E2DE2),
                  padding: const EdgeInsets.only(top: 20, bottom: 50),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 65, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user['nama_lengkap'] ?? "User",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "@${user['username'] ?? 'username'}",
                        style: const TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // DETAIL AKUN
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Detail Akun",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(Icons.badge, "NIK", user['nik'] ?? "-"),
                        const Divider(height: 1),
                        _buildInfoRow(Icons.email, "Email", user['email'] ?? "-"),
                        const Divider(height: 1),
                        _buildInfoRow(Icons.phone, "No. Telepon", user['telp'] ?? user['noTelp'] ?? "-"),
                        const Divider(height: 1),
                        _buildInfoRow(Icons.location_on, "Alamat", user['alamat'] ?? "-"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // TOMBOL KELUAR APLIKASI
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text(
                        "KELUAR APLIKASI",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[50],
                        foregroundColor: Colors.pink[800],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString('current_user');
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.blue[50],
        child: Icon(icon, color: Colors.blue[700], size: 22),
      ),
      title: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}