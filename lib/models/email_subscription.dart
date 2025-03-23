class EmailSubscription {
  final String email;
  final String location;
  final bool isVerified;
  final String verificationToken;
  final DateTime createdAt;
  final DateTime? verifiedAt;

  EmailSubscription({
    required this.email,
    required this.location,
    this.isVerified = false,
    required this.verificationToken,
    required this.createdAt,
    this.verifiedAt,
  });

  factory EmailSubscription.create(String email, String location) {
    // Tạo token xác thực ngẫu nhiên
    final token = DateTime.now().millisecondsSinceEpoch.toString() +
        email.hashCode.toString();

    return EmailSubscription(
      email: email,
      location: location,
      verificationToken: token,
      createdAt: DateTime.now(),
    );
  }

  EmailSubscription copyWith({
    String? email,
    String? location,
    bool? isVerified,
    String? verificationToken,
    DateTime? createdAt,
    DateTime? verifiedAt,
  }) {
    return EmailSubscription(
      email: email ?? this.email,
      location: location ?? this.location,
      isVerified: isVerified ?? this.isVerified,
      verificationToken: verificationToken ?? this.verificationToken,
      createdAt: createdAt ?? this.createdAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'location': location,
      'isVerified': isVerified,
      'verificationToken': verificationToken,
      'createdAt': createdAt.toIso8601String(),
      'verifiedAt': verifiedAt?.toIso8601String(),
    };
  }

  factory EmailSubscription.fromJson(Map<String, dynamic> json) {
    return EmailSubscription(
      email: json['email'],
      location: json['location'],
      isVerified: json['isVerified'] ?? false,
      verificationToken: json['verificationToken'],
      createdAt: DateTime.parse(json['createdAt']),
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'])
          : null,
    );
  }
}
