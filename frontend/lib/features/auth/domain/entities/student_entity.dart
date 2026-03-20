class StudentEntity {
  final String uid;
  final String fullName;
  final String email;
  final String? phone;
  final String? university;
  final String? studentNumber;
  final String? yearOfStudy;
  final String? profileImageUrl;
  final bool isStudentVerified;
  final bool isBankingCaptured;
  final DateTime createdAt;

  const StudentEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone,
    this.university,
    this.studentNumber,
    this.yearOfStudy,
    this.profileImageUrl,
    this.isStudentVerified = false,
    this.isBankingCaptured = false,
    required this.createdAt,
  });

  StudentEntity copyWith({
    String? fullName,
    String? phone,
    String? university,
    String? studentNumber,
    String? yearOfStudy,
    String? profileImageUrl,
    bool? isStudentVerified,
    bool? isBankingCaptured,
  }) {
    return StudentEntity(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email,
      phone: phone ?? this.phone,
      university: university ?? this.university,
      studentNumber: studentNumber ?? this.studentNumber,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isStudentVerified: isStudentVerified ?? this.isStudentVerified,
      isBankingCaptured: isBankingCaptured ?? this.isBankingCaptured,
      createdAt: createdAt,
    );
  }
}
