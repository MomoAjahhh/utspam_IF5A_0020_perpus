import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:peminjaman_buku/views/bookListScreen.dart';
import 'package:peminjaman_buku/views/borrowScreen.dart';
import 'package:peminjaman_buku/views/historyScreen.dart';
import 'package:peminjaman_buku/views/profileScreen.dart';
import 'package:peminjaman_buku/views/welcomeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BookListScreen(),
    const BorrowScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  Future<String> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user_name') ?? 'Pengguna';
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_email');
    await prefs.remove('current_user_name');
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _getUserName(),
          builder: (context, snapshot) {
            return Text(
              "Selamat Datang, ${snapshot.data ?? 'Pengguna'}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            );
          },
        ),
        backgroundColor: Color(0xFF8E2DE2),
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _logout)
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF8E2DE2),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Daftar Buku'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Pinjam Buku'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}