import 'book.dart';

class Transaction {
  int? id;
  int bookId;
  int userId;
  String tglPinjam;
  int durasiPinjam;
  int totalBiaya;
  String status;

  // Tambahan: objek Book
  Book? book;

  Transaction({
    this.id,
    required this.bookId,
    required this.userId,
    required this.tglPinjam,
    required this.durasiPinjam,
    required this.totalBiaya,
    required this.status,
    this.book, // tambahan
  });

  Transaction copyWith({
    int? id,
    int? bookId,
    int? userId,
    String? tglPinjam,
    int? durasiPinjam,
    int? totalBiaya,
    String? status,
    Book? book,
  }) {
    return Transaction(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      userId: userId ?? this.userId,
      tglPinjam: tglPinjam ?? this.tglPinjam,
      durasiPinjam: durasiPinjam ?? this.durasiPinjam,
      totalBiaya: totalBiaya ?? this.totalBiaya,
      status: status ?? this.status,
      book: book ?? this.book, // tambahan
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'tgl_pinjam': tglPinjam,
      'durasi_pinjam': durasiPinjam,
      'total_biaya': totalBiaya,
      'status': status,
      // Book tidak ikut disimpan ke database
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      bookId: map['book_id'],
      userId: map['user_id'],
      tglPinjam: map['tgl_pinjam'],
      durasiPinjam: map['durasi_pinjam'],
      totalBiaya: map['total_biaya'],
      status: map['status'],
      // book nanti diisi manual ketika load data
    );
  }
}
