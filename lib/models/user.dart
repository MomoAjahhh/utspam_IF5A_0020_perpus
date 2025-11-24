class User {
  final String fullName;
  final String nik;
  final String email;
  final String alamat;
  final String noTelp;
  final String username;
  final String password;

  User({
    required this.fullName,
    required this.nik,
    required this.email,
    required this.alamat,
    required this.noTelp,
    required this.username,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json['fullName'] ?? '',
        nik: json['nik'] ?? '',
        email: json['email'] ?? '',
        alamat: json['address'] ?? '',
        noTelp: json['noTelp'] ?? '',
        username: json['username'] ?? '',
        password: json['password'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'nik': nik,
        'email': email,
        'address': alamat,
        'noTelp': noTelp,
        'username': username,
        'password': password,
      };

  // === Tambahan penting supaya StorageService TIDAK ERROR ===
  bool get isEmpty => fullName.isEmpty;

  static User empty() => User(
        fullName: '',
        nik: '',
        email: '',
        alamat: '',
        noTelp: '',
        username: '',
        password: '',
      );
}
