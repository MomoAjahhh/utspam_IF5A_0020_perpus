import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/transaction.dart';
import '../views/detail_borrow_screen.dart';
import '../models/book.dart';
import '../data/db_helper.dart';
import 'home_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Transaction>> transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    transactionsFuture = StorageService.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Riwayat Pinjam Buku"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Transaction>>(
        future: transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "Belum ada riwayat peminjaman",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final transactions = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final trans = transactions[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      trans.bookId.toString(),
                      width: 60,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    trans.book?.title ?? "Judul Buku",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Peminjam: User ID ${trans.userId}"),
                      Text("Total: Rp ${trans.totalBiaya}"),
                      Text(
                        "Status: ${_statusToString(trans.status)}",
                        style: TextStyle(
                          color: trans.status == "dibatalkan"
                              ? Colors.red
                              : trans.status == "selesai"
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final db = DbHelper();
                    final conn = await db.database;

                    // Ambil data book berdasarkan ID
                    final res = await conn.query(
                      "books",
                      where: "id = ?",
                      whereArgs: [trans.bookId.toString()],
                    );

                    final book = Book.fromJson(res.first);

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailBorrowScreen(transaction: trans, book: book),
                      ),
                    );

                    setState(() {
                      _loadTransactions();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.home, color: Colors.white),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );
        },
      ),
    );
  }

  String _statusToString(String status) {
  switch (status.toUpperCase()) {
    case "AKTIF":
      return "Aktif";
    case "SELESAI":
      return "Selesai";
    case "DIBATALKAN":
      return "Dibatalkan";
    default:
      return "Tidak diketahui";
  }
}

}
