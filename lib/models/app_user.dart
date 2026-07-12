/// The two account types ALU Connect supports. Kept as an enum (rather than
/// a raw string) so the compiler catches typos like 'stundet' at build time
/// instead of us finding out at runtime.
enum UserRole { student, startup }

extension UserRoleParsing on String {
  UserRole toUserRole() => this == 'startup' ? UserRole.startup : UserRole.student;
}

/// Our own user profile record, stored in Firestore at `users/{uid}`.
///
/// FirebaseAuth's `User` object only knows the account's email/uid/whether
/// it's verified — it has no idea if someone is a student or a startup, or
/// whether a startup has been vetted as a real ALU-recognized venture. That
/// extra business data lives here, in a document we control, keyed by the
/// same uid FirebaseAuth assigns.
class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final UserRole role;

  /// Only meaningful when role == startup. A startup account is created as
  /// unverified and only becomes visible to students once an admin flips
  /// this to true, restricting opportunity postings to vetted ALU ventures.
  final bool isVerifiedStartup;

  const AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.isVerifiedStartup = false,
  });

  /// Builds an AppUser from a Firestore document snapshot's data map.
  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] as String? ?? '',
      fullName: data['fullName'] as String? ?? '',
      role: (data['role'] as String? ?? 'student').toUserRole(),
      isVerifiedStartup: data['isVerifiedStartup'] as bool? ?? false,
    );
  }

  /// The reverse of fromMap — what we write to Firestore on account creation.
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'isVerifiedStartup': isVerifiedStartup,
    };
  }
}
