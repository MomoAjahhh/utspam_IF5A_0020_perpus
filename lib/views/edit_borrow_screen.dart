import 'package:flutter/material.dart';
import '../models/book.dart';
import '../models/transaction.dart';

class EditBorrowScreen extends StatefulWidget {
  final Transaction transaction;
  final Book book;

  const EditBorrowScreen({
    super.key,
    required this.transaction,
    required this.book,
  });

  @override
  State<EditBorrowScreen> createState() => _EditBorrowScreenState();
}

class _EditBorrowScreenState extends State<EditBorrowScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tglCtr;
  late TextEditingController durasiCtr;

  late int totalBiaya;

  @override
  void initState() {
    super.initState();

    tglCtr = TextEditingController(text: widget.transaction.tglPinjam);
    durasiCtr = TextEditingController(
        text: widget.transaction.durasiPinjam.toString());

    totalBiaya = widget.transaction.totalBiaya;
  }

  void hitungBiaya() {
    int d = int.tryParse(durasiCtr.text) ?? 0;
    setState(() {
      totalBiaya = (d * widget.book.pricePerDay).toInt();
    });
  }

  void save() {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.transaction.copyWith(
      tglPinjam: tglCtr.text,
      durasiPinjam: int.parse(durasiCtr.text),
      totalBiaya: totalBiaya,
    );

    Navigator.pop(context, updated);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perubahan disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Peminjaman"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: tglCtr,
                decoration: const InputDecoration(
                  labelText: "Tanggal Pinjam",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),

              TextFormField(
                controller: durasiCtr,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Durasi Pinjam",
                  suffixText: "hari",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => hitungBiaya(),
              ),
              SizedBox(height: 20),

              Text(
                "Total Biaya: Rp $totalBiaya",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: save,
                  child: const Text("Simpan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
