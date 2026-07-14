import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// show real-time application status updates
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color aluDeepGreen = Color(0xFF0C4E33);

    // store mock status update logs
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'Application Shortlisted 🚀',
        'body': 'Soma Studio shortlisted you for the Flutter Developer Intern role. Stay tuned for interview scheduling parameters.',
        'time': '2h ago',
        'isUnread': true,
        'icon': '🤝',
        'color': const Color(0xFFE8F0FE),
      },
      {
        'title': 'New Opportunity Match ✨',
        'body': 'FarmWave just posted a new "ML Research Intern" position matching your interest fields in AgriTech.',
        'time': '1d ago',
        'isUnread': false,
        'icon': '🌾',
        'color': const Color(0xFFFFF7ED),
      },
      {
        'title': 'Application Under Review 📂',
        'body': 'Your submission tracking metric for FarmWave has successfully completed backend integration checks.',
        'time': '2d ago',
        'isUnread': false,
        'icon': '📝',
        'color': const Color(0xFFF1F3F5),
      }
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                'Mark read',
                style: GoogleFonts.inter(color: aluDeepGreen, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: item['isUnread'] ? const Color(0xFFF4FBF7) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item['isUnread'] ? aluDeepGreen.withValues(alpha: 0.15) : Colors.grey.shade100,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: item['color'], borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: Text(item['icon'], style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item['title'], style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black)),
                          Text(item['time'], style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['body'],
                        style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w500, height: 1.4),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
