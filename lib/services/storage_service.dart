import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../models/user.dart';
import '../models/transaction.dart';

class StorageService {
  static const String _usersKey = 'users';
  static const String _booksKey = 'books';
  static const String _transactionsKey = 'transactions';
  static const String _currentUserKey = 'current_user';

  // DUMMY BOOKS
  static Future<void> initDummyData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_booksKey) == null) {
      final List<Book> dummyBooks = [
        Book(
          id: "1",
          title: "Pemrograman Flutter Dasar",
          genre: "Teknologi",
          pricePerDay: 5000,
          coverUrl: "https://picsum.photos/seed/book1/300/400",
          synopsis: "Belajar membuat aplikasi mobile dengan Flutter dari nol.",
        ),
        Book(
          id: "2",
          title: "Algoritma dan Struktur Data",
          genre: "Algoritma",
          pricePerDay: 7000,
          coverUrl: "https://picsum.photos/seed/book2/300/400",
          synopsis: "Buku klasik algoritma dengan contoh bahasa C dan Java.",
        ),
      ];

      await prefs.setString(
        _booksKey,
        jsonEncode(dummyBooks.map((e) => e.toJson()).toList()),
      );
    }
  }

  // REGISTER USER
  static Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);

    List<User> users =
        data == null ? [] : (jsonDecode(data) as List).map((e) => User.fromJson(e)).toList();

    // Cek email & username unik
    if (users.any((u) => u.email == user.email || u.username == user.username)) {
      throw Exception("Email atau username sudah digunakan");
    }

    users.add(user);

    await prefs.setString(
      _usersKey,
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }

  // LOGIN USER
  static Future<User?> login(String identifier, String password) async {
  final prefs = await SharedPreferences.getInstance();
  final String? usersJson = prefs.getString(_usersKey);
  if (usersJson == null) return null;

  List<User> users =
      (jsonDecode(usersJson) as List).map((e) => User.fromJson(e)).toList();

  User user = users.firstWhere(
    (u) => (u.email == identifier || u.nik == identifier) &&
           u.password == password,
    orElse: () => User.empty(), // ✔ aman
  );

  if (user.isEmpty) return null; // ✔ cek gagal login

  // simpan user yg login
  await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
  return user;
}


  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_currentUserKey);

    return data == null ? null : User.fromJson(jsonDecode(data));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // BOOKS
  static Future<List<Book>> getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_booksKey);
    if (json == null) return [];

    return (jsonDecode(json) as List).map((e) => Book.fromJson(e)).toList();
  }

  // TRANSACTIONS
  static Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_transactionsKey);
    if (json == null) return [];

    return (jsonDecode(json) as List)
        .map((e) => Transaction.fromMap(e))
        .toList();
  }

  static Future<void> addTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getTransactions();

    list.add(transaction);

    await prefs.setString(
      _transactionsKey,
      jsonEncode(list.map((e) => e.toMap()).toList()),
    );
  }
}
