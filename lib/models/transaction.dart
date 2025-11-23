class Transaction {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookCover;
  final String userEmail;
  final int days;
  final int totalPrice;
  final DateTime borrowDate;
  String status; 

  Transaction({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookCover,
    required this.userEmail,
    required this.days,
    required this.totalPrice,
    required this.borrowDate,
    this.status = "dipinjam",
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookId': bookId,
        'bookTitle': bookTitle,
        'bookCover': bookCover,
        'userEmail': userEmail,
        'days': days,
        'totalPrice': totalPrice,
        'borrowDate': borrowDate.toIso8601String(),
        'status': status,
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'],
        bookId: json['bookId'],
        bookTitle: json['bookTitle'],
        bookCover: json['bookCover'],
        userEmail: json['userEmail'],
        days: json['days'],
        totalPrice: json['totalPrice'],
        borrowDate: DateTime.parse(json['borrowDate']),
        status: json['status'] ?? "dipinjam",
      );
}