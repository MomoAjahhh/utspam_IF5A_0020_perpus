import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/book.dart';

class DetailBorrowScreen extends StatelessWidget {
  final Transaction transaction;
  final Book book;

  const DetailBorrowScreen({
    super.key,
    required this.transaction,
    required this.book,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'AKTIF':
        return Colors.blue;
      case 'SELESAI':
        return Colors.green;
      case 'DIBATALKAN':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Peminjaman"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Judul Buku:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(book.id),
            SizedBox(height: 10),

            Text("Genre:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(book.genre),
            SizedBox(height: 10),

            Text("Tanggal Pinjam:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(transaction.tglPinjam),
            SizedBox(height: 10),

            Text("Durasi Pinjam:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${transaction.durasiPinjam} hari"),
            SizedBox(height: 10),

            Text("Total Biaya:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Rp ${transaction.totalBiaya}"),
            SizedBox(height: 10),

            Text("Status:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              transaction.status,
              style: TextStyle(
                color: _statusColor(transaction.status),
                fontWeight: FontWeight.bold,
              ),
            ),

            Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Kembali"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
