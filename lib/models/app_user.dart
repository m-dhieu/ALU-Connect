enum UserRole { student, startup }

extension UserRoleParsing on String {
  UserRole toUserRole() => this == 'startup' ? UserRole.startup : UserRole.student;
}

// store user profile data separately from FirebaseAuth data
// link profile to user's Firebase uid
class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final UserRole role;
  final bool isVerifiedStartup;
  final String tagline;
  final String about;
  final String companySize;
  final String industry;
  final List<String> domains;

  const AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.isVerifiedStartup = false,
    this.tagline = '',
    this.about = '',
    this.companySize = '',
    this.industry = '',
    this.domains = const [],
  });

  // create AppUser from Firestore document data
  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      role: (data['role'] as String? ?? 'student').toUserRole(),
      isVerifiedStartup: data['isVerifiedStartup'] as bool? ?? false,
      tagline: data['tagline'] as String? ?? '',
      about: data['about'] as String? ?? '',
      companySize: data['companySize'] as String? ?? '',
      industry: data['industry'] as String? ?? '',
      domains: List<String>.from(data['domains'] as List? ?? const []),
    );
  }

  // convert AppUser data into Firestore document
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'isVerifiedStartup': isVerifiedStartup,
      'tagline': tagline,
      'about': about,
      'companySize': companySize,
      'industry': industry,
      'domains': domains,
    };
  }
}
