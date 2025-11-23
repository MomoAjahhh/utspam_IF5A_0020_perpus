class User {
  final String nama;
  final String nik;
  final String email;
  final String password;
  final String alamat; 
  final String noTelp;
  final String username;

  User({
    required this.nama,
    required this.nik,
    required this.email,
    required this.password,
    required this.alamat,
    required this.noTelp,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'nik': nik,
        'email': email,
        'password': password,
        'alamat': alamat,
        'noTelp': noTelp,
        'username': username,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        nama: json['nama'],
        nik: json['nik'],
        email: json['email'],
        password: json['password'],
        alamat: json['alamat'],
        noTelp: json['noTelp'],
        username: json['username'],
      );
}