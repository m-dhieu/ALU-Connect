import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// store opportunities in Firestore
class Opportunity {
  final String id;
  final String postedByUid;
  final String companyName;
  final String logoInit;
  final Color logoColor;
  final String roleTitle;
  final String description;
  final String workplaceSetting;
  final String duration;
  final String jobType;
  final String department;
  final String stipend;
  final int spotsAvailable;
  final List<String> skillsTags;
  final List<String> responsibilities;
  final DateTime createdAt;

  const Opportunity({
    required this.id,
    required this.postedByUid,
    required this.companyName,
    required this.logoInit,
    required this.logoColor,
    required this.roleTitle,
    required this.description,
    required this.workplaceSetting,
    required this.duration,
    required this.jobType,
    required this.department,
    required this.stipend,
    required this.spotsAvailable,
    this.skillsTags = const [],
    this.responsibilities = const [],
    required this.createdAt,
  });

  // remaining spots display text
  String get spotsLeftLabel => '$spotsAvailable spot${spotsAvailable == 1 ? '' : 's'} left';

  // default deadline 30 days after posting
  static const int listingLifetimeDays = 30;

  String get daysLeftLabel {
    final int daysRemaining = listingLifetimeDays - DateTime.now().difference(createdAt).inDays;
    if (daysRemaining <= 0) return 'Closing today';
    return '${daysRemaining}d left';
  }

  factory Opportunity.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Opportunity(
      id: doc.id,
      postedByUid: data['postedByUid'] as String? ?? '',
      companyName: data['companyName'] as String? ?? '',
      logoInit: data['logoInit'] as String? ?? '',
      logoColor: Color(int.parse((data['logoColorHex'] as String? ?? '#0C4E33').replaceFirst('#', '0xFF'))),
      roleTitle: data['roleTitle'] as String? ?? '',
      description: data['description'] as String? ?? '',
      workplaceSetting: data['workplaceSetting'] as String? ?? '',
      duration: data['duration'] as String? ?? '',
      jobType: data['jobType'] as String? ?? '',
      department: data['department'] as String? ?? '',
      stipend: data['stipend'] as String? ?? '',
      spotsAvailable: data['spotsAvailable'] as int? ?? 1,
      skillsTags: List<String>.from(data['skillsTags'] as List? ?? const []),
      responsibilities: List<String>.from(data['responsibilities'] as List? ?? const []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postedByUid': postedByUid,
      'companyName': companyName,
      'logoInit': logoInit,
      'logoColorHex': '#${logoColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
      'roleTitle': roleTitle,
      'description': description,
      'workplaceSetting': workplaceSetting,
      'duration': duration,
      'jobType': jobType,
      'department': department,
      'stipend': stipend,
      'spotsAvailable': spotsAvailable,
      'skillsTags': skillsTags,
      'responsibilities': responsibilities,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // update listing fields without changing original posting date
  Map<String, dynamic> toUpdateMap() {
    final map = toMap();
    map.remove('createdAt');
    return map;
  }

  Opportunity copyWith({
    String? roleTitle,
    String? description,
    String? workplaceSetting,
    String? duration,
    String? jobType,
    String? department,
    String? stipend,
    int? spotsAvailable,
    List<String>? skillsTags,
    List<String>? responsibilities,
  }) {
    return Opportunity(
      id: id,
      postedByUid: postedByUid,
      companyName: companyName,
      logoInit: logoInit,
      logoColor: logoColor,
      roleTitle: roleTitle ?? this.roleTitle,
      description: description ?? this.description,
      workplaceSetting: workplaceSetting ?? this.workplaceSetting,
      duration: duration ?? this.duration,
      jobType: jobType ?? this.jobType,
      department: department ?? this.department,
      stipend: stipend ?? this.stipend,
      spotsAvailable: spotsAvailable ?? this.spotsAvailable,
      skillsTags: skillsTags ?? this.skillsTags,
      responsibilities: responsibilities ?? this.responsibilities,
      createdAt: createdAt,
    );
  }

  // convert Firestore opportunities into UI format
  Map<String, dynamic> toDisplayMap() {
    return {
      'id': id,
      'postedByUid': postedByUid,
      'logoInit': logoInit,
      'logoColor': logoColor,
      'companyName': companyName,
      'roleTitle': roleTitle,
      'workplaceSetting': workplaceSetting,
      'duration': duration,
      'jobType': jobType,
      'department': department,
      'category': department,
      'stipend': stipend.isEmpty ? 'Unpaid' : stipend,
      'spotsLeft': spotsLeftLabel,
      'daysLeft': daysLeftLabel,
      'aboutText': description,
      'skillsTags': skillsTags,
      'responsibilities': responsibilities,
    };
  }
}
