import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/transaction.dart';
import '../data/db_helper.dart';

class BorrowScreen extends StatefulWidget {
  final Book book;
  final int userId;

  const BorrowScreen({
    super.key,
    required this.book,
    required this.userId,
  });


  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  final _formKey = GlobalKey<FormState>();

  final tglCtr = TextEditingController();
  final durasiCtr = TextEditingController();
  int total = 0;

  final DbHelper db = DbHelper();

  @override
  void initState() {
    super.initState();
    tglCtr.text = _today();
  }

  String _today() {
    final now = DateTime.now();
    return "${now.year}-${now.month}-${now.day}";
  }

  void hitung() {
    int d = int.tryParse(durasiCtr.text) ?? 0;
    setState(() {
      total = (d * widget.book.pricePerDay).toInt();
    });
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    final tr = Transaction(
      id: null,
      userId: widget.userId,
      bookId: int.parse(widget.book.id),   // aman
      tglPinjam: tglCtr.text,
      durasiPinjam: int.parse(durasiCtr.text),
      totalBiaya: total,
      status: "AKTIF",
    );

    final dbConn = await db.database;
    await dbConn.insert("transactions", tr.toMap());

    if (!mounted) return;

    Navigator.pop(context, tr);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Peminjaman berhasil!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pinjam Buku"),
        backgroundColor: Color(0xFF8E2DE2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              // INFO BUKU
              //
              Text(
                widget.book.id,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(widget.book.genre),
              SizedBox(height: 20),

              //
              // INPUT TANGGAL MULAI
              //
              TextFormField(
                controller: tglCtr,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Tanggal Pinjam",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              //
              // DURASI PINJAM
              //
              TextFormField(
                controller: durasiCtr,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Durasi Pinjam (hari)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => hitung(),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Isi durasi";
                  if (int.tryParse(v) == null) return "Harus angka";
                  return null;
                },
              ),
              SizedBox(height: 20),

              //
              // TOTAL BIAYA
              //
              Text(
                "Total Biaya: Rp $total",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const Spacer(),

              //
              // TOMBOL SIMPAN
              //
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submit,
                  child: const Text("Pinjam"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
