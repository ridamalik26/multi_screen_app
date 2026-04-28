class AppUser {
  const AppUser({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      password: (json['password'] ?? '') as String,
    );
  }
}
