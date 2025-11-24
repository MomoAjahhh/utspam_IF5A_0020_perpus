import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:peminjaman_buku/models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    _user = await StorageService.getCurrentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: Text('Profil Pengguna')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${_user!.fullName}'),
            Text('NIK: ${_user!.nik}'),
            Text('Email: ${_user!.email}'),
            Text('Alamat: ${_user!.alamat}'),
            Text('Telepon: ${_user!.noTelp}'),
            Text('Username: ${_user!.username}'),
            
          ],
        ),
      ),
    );
  }
}