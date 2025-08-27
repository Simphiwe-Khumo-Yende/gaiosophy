import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/typography.dart';

// Provider for user privacy settings
final privacySettingsProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.exists ? doc.data() : null);
});

class PrivacySettingsScreen extends ConsumerWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacySettingsAsync = ref.watch(privacySettingsProvider);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Privacy Settings',
          style: context.primaryFont(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Privacy Introduction
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 48,
                    color: const Color(0xFF5A4E3C),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Privacy Matters',
                    style: context.primaryFont(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Control how your data is used and shared. We are committed to protecting your privacy and being transparent about data usage.',
                    style: context.secondaryFont(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Privacy Controls
            Text(
              'Privacy Controls',
              style: context.primaryFont(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            privacySettingsAsync.when(
              data: (settings) => _buildPrivacyControls(context, user, settings),
              loading: () => _buildLoadingState(context),
              error: (error, _) => _buildErrorState(context),
            ),
            
            const SizedBox(height: 32),

            // Privacy Information
            Text(
              'Privacy Information',
              style: context.primaryFont(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoItem(
                    context,
                    icon: Icons.description_outlined,
                    title: 'Privacy Policy',
                    subtitle: 'Read our full privacy policy',
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E5E5)),
                  _buildInfoItem(
                    context,
                    icon: Icons.delete_outline,
                    title: 'Delete Account',
                    subtitle: 'Permanently delete your account and data',
                    onTap: () => _showDeleteAccountDialog(context),
                    textColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyControls(BuildContext context, User? user, Map<String, dynamic>? settings) {
    final dataCollection = settings?['dataCollectionEnabled'] ?? true;
    final analytics = settings?['analyticsEnabled'] ?? true;
    final personalization = settings?['personalizationEnabled'] ?? true;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPrivacyToggle(
            context,
            user,
            'dataCollectionEnabled',
            'Data Collection',
            'Allow collection of usage data to improve the app',
            dataCollection,
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          _buildPrivacyToggle(
            context,
            user,
            'analyticsEnabled',
            'Analytics',
            'Help us understand how you use the app',
            analytics,
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          _buildPrivacyToggle(
            context,
            user,
            'personalizationEnabled',
            'Personalization',
            'Use your data to personalize content recommendations',
            personalization,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyToggle(
    BuildContext context,
    User? user,
    String settingKey,
    String title,
    String subtitle,
    bool value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.secondaryFont(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: context.secondaryFont(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF5A4E3C),
            onChanged: (newValue) => _updatePrivacySetting(user, settingKey, newValue),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'Error loading privacy settings',
          style: context.secondaryFont(
            color: Colors.red.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(
        icon,
        color: textColor ?? const Color(0xFF5A4E3C),
        size: 28,
      ),
      title: Text(
        title,
        style: context.secondaryFont(
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: context.secondaryFont(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }

  Future<void> _updatePrivacySetting(User? user, String settingKey, bool value) async {
    if (user == null) return;
    
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({settingKey: value});
    } catch (e) {
      debugPrint('Error updating privacy setting: $e');
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: context.primaryFont(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data We Collect:',
                style: context.secondaryFont(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '• Profile information (name, email, date of birth)\n'
                '• Usage data and app interactions\n'
                '• Device information for app optimization\n'
                '• Preferences and settings',
                style: context.secondaryFont(),
              ),
              const SizedBox(height: 16),
              Text(
                'How We Use Your Data:',
                style: context.secondaryFont(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '• Personalize your content experience\n'
                '• Improve app functionality\n'
                '• Send notifications (with your permission)\n'
                '• Provide customer support',
                style: context.secondaryFont(),
              ),
              const SizedBox(height: 16),
              Text(
                'Data Sharing:',
                style: context.secondaryFont(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'We do not sell or share your personal data with third parties for marketing purposes. Data is only shared with service providers necessary for app functionality.',
                style: context.secondaryFont(),
              ),
              const SizedBox(height: 16),
              Text(
                'For questions about our privacy practices, contact us at siphiweyende371@gmail.com',
                style: context.secondaryFont(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: context.secondaryFont(
                color: const Color(0xFF5A4E3C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: context.primaryFont(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        content: Text(
          'This action cannot be undone. All your data will be permanently deleted.\n\nTo proceed with account deletion, please contact us at siphiweyende371@gmail.com with your account details.',
          style: context.secondaryFont(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: context.secondaryFont(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _contactForDeletion();
            },
            child: Text(
              'Contact Support',
              style: context.secondaryFont(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _contactForDeletion() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'siphiweyende371@gmail.com',
      query: 'subject=Account Deletion Request&body=I would like to delete my Gaiosophy account.%0D%0A%0D%0AAccount Email: ${FirebaseAuth.instance.currentUser?.email ?? ""}%0D%0A%0D%0APlease confirm the deletion of my account and all associated data.',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
