import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const String dbName = "perpustakaan.db";

  DbHelper._init();
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  factory DbHelper() {
    return instance;
  }

  Future<Database> get database async {
    _database = await _initDatabase(dbName);
    return _database!;
  }

  Future<Database> _initDatabase(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_lengkap TEXT NOT NULL,
      nik TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      alamat TEXT NOT NULL,
      telp TEXT NOT NULL,
      username TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
    ''');

    await db.execute(''' 
    CREATE TABLE books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT NOT NULL,
      genre TEXT NOT NULL,
      harga_rental INTEGER NOT NULL,
      cover_path TEXT NOT NULL,
      sinopsis TEXT NOT NULL
    )
    ''');

    await db.execute(''' 
    CREATE TABLE transactions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      book_id INTEGER NOT NULL,
      tgl_pinjam TEXT NOT NULL,
      durasi_pinjam INTEGER NOT NULL,
      total_biaya INTEGER NOT NULL,
      status TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES users (id),
      FOREIGN KEY (book_id) REFERENCES books (id)
    )
    ''');
    await _insertDummyData(db);
  }
  Future<void> _insertDummyData(Database db) async {
    List<Map<String, dynamic>> books = [
        {
          id: "1",
          title: "Pemrograman Flutter Dasar",
          genre: "Teknologi",
          pricePerDay: 5000,
          coverUrl: "https://picsum.photos/seed/book1/300/400",
          synopsis: "Belajar membuat aplikasi mobile dengan Flutter dari nol.",
        },
        {
          id: "2",
          title: "Algoritma dan Struktur Data",
          genre: "Algoritma",
          pricePerDay: 7000,
          coverUrl: "https://picsum.photos/seed/book2/300/400",
          synopsis: "Buku klasik algoritma dengan contoh bahasa C dan Java.",
        },
        {
          id: "1", // String karena model lama pakai String
          title: "Novel 1984", // ← judul sesuai DB
          genre: "Novel",
          pricePerDay: 30000, // ← harga_rental
          coverUrl: "assets/images/1984.jpg", // ← pakai asset lokal
          synopsis:
              "Novel “1984” bercerita tentang suatu masa di sekitar tahun 1984. Orwell menggambarkan masa itu sebagai masa yang penuh penderitaan...",
        },
        {
          id: "2",
          title: "Animal Farm",
          genre: "Novel",
          pricePerDay: 35000,
          coverUrl: "assets/images/animalfarm.jpg",
          synopsis:
              "Dongeng tentang para penguasa ini merupakan satir yang menggambarkan bagaimana sifat asli manusia dan karakternya ketika memiliki kekuasaan yang besar...",
        },
        {
          id: "3",
          title: "Don Quixote",
          genre: "Novel",
          pricePerDay: 25000,
          coverUrl: "assets/images/donquixote.jpg",
          synopsis:
              "Novel ini berkisah tentang sosok Alonso Quixando, seorang bangsawan Spanyol yang senang membaca kisah dongeng ksatria, sampai-sampai ia harus kehilangan akal...",
        ,
    ];
    for (var book in books) {
      await db.insert('books', book);
    }
  }
}