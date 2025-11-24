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

  static Future<void> initDummyData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_booksKey) == null) {
      final List<Book> dummyBooks = [
        Book(
          id: "1",
          title: "Pemrograman Flutter Dasar",
          genre: "Teknologi",
          pricePerDay: 20000,
          coverUrl: "https://picsum.photos/seed/book1/300/400",
          synopsis: "Belajar membuat aplikasi mobile dengan Flutter dari awal.",
        ),
        Book(
          id: "2",
          title: "Algoritma dan Struktur Data",
          genre: "Algoritma",
          pricePerDay: 7000,
          coverUrl: "https://picsum.photos/seed/book2/300/400",
          synopsis: "Buku klasik algoritma dengan contoh bahasa C dan Java.",
        ),
        Book(
          id: "3", 
          title: "Novel 1984", 
          genre: "Novel",
          pricePerDay: 30000, 
          coverUrl: "assets/images/1984.jpg", 
          synopsis:
              "Novel “1984” bercerita tentang suatu masa di sekitar tahun 1984. Orwell menggambarkan masa itu sebagai masa yang penuh penderitaan...",
        ),
        Book(
          id: "4",
          title: "Animal Farm",
          genre: "Novel",
          pricePerDay: 35000,
          coverUrl: "assets/images/animalfarm.jpg",
          synopsis:
              "Dongeng tentang para penguasa ini merupakan satir yang menggambarkan bagaimana sifat asli manusia dan karakternya ketika memiliki kekuasaan yang besar...",
        ),
        Book(
          id: "5",
          title: "Don Quixote",
          genre: "Novel",
          pricePerDay: 25000,
          coverUrl: "assets/images/donquixote.jpg",
          synopsis:
              "Novel ini berkisah tentang sosok Alonso Quixando, seorang bangsawan Spanyol yang senang membaca kisah dongeng ksatria, sampai-sampai ia harus kehilangan akal...",
        ),
      ];

      await prefs.setString(
        _booksKey,
        jsonEncode(dummyBooks.map((e) => e.toJson()).toList()),
      );
    }
  }

  
  static Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_usersKey);

    List<User> users = data == null
        ? []
        : (jsonDecode(data) as List).map((e) => User.fromJson(e)).toList();

    
    if (users.any(
      (u) => u.email == user.email || u.username == user.username,
    )) {
      throw Exception("Email atau username sudah digunakan");
    }

    users.add(user);

    await prefs.setString(
      _usersKey,
      jsonEncode(users.map((u) => u.toJson()).toList()),
    );
  }

  
  static Future<User?> login(String identifier, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;

    List<User> users = (jsonDecode(usersJson) as List)
        .map((e) => User.fromJson(e))
        .toList();

    User user = users.firstWhere(
      (u) =>
          (u.email == identifier || u.nik == identifier) &&
          u.password == password,
      orElse: () => User.empty(), 
    );

    if (user.isEmpty) return null; 

    
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

  
  static Future<List<Book>> getBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_booksKey);
    if (json == null) return [];

    return (jsonDecode(json) as List).map((e) => Book.fromJson(e)).toList();
  }

  
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
