import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';
import '../../data/models/user_profile.dart';

final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value(null);
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) => doc.exists ? UserProfile.fromFirestore(doc) : null);
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);
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
          'Settings',
          style: context.primaryFont(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile Information',
                        style: context.primaryFont(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/profile-edit'),
                        child: Text(
                          'Edit',
                          style: context.secondaryFont(
                            color: const Color(0xFF5A4E3C),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  userProfileAsync.when(
                    data: (profile) => profile != null
                        ? _buildProfileInfo(context, profile)
                        : _buildEmptyProfile(context, user),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Text(
                      'Error loading profile: $error',
                      style: context.secondaryFont(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings Options
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, UserProfile profile) {
    return Column(
      children: [
        _buildInfoRow(context, 'Name', '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim()),
        const SizedBox(height: 12),
        _buildInfoRow(context, 'Email', profile.email),
        const SizedBox(height: 12),
        if (profile.dateOfBirth != null)
          _buildInfoRow(context, 'Date of Birth', 
              '${profile.dateOfBirth!.day}/${profile.dateOfBirth!.month}/${profile.dateOfBirth!.year}'),
        if (profile.dateOfBirth != null) const SizedBox(height: 12),
        if (profile.zodiacSign != null)
          _buildInfoRow(context, 'Zodiac Sign', 
              '${ZodiacSign.fromString(profile.zodiacSign)?.symbol ?? ''} ${profile.zodiacSign}'),
      ],
    );
  }

  Widget _buildEmptyProfile(BuildContext context, User? user) {
    return Column(
      children: [
        _buildInfoRow(context, 'Name', user?.displayName ?? 'Not set'),
        const SizedBox(height: 12),
        _buildInfoRow(context, 'Email', user?.email ?? 'Not set'),
        const SizedBox(height: 16),
        Text(
          'Complete your profile to get personalized content',
          style: context.secondaryFont(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => context.push('/profile-setup'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A4E3C),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            'Complete Profile',
            style: context.secondaryFont(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: context.secondaryFont(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? 'Not set' : value,
            style: context.secondaryFont(
              color: value.isEmpty ? Colors.grey.shade500 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'General',
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
              _buildSettingsItem(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications settings coming soon!')),
                  );
                },
              ),
              const Divider(height: 1, color: Color(0xFFE5E5E5)),
              _buildSettingsItem(
                context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                subtitle: 'Control your privacy settings',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy settings coming soon!')),
                  );
                },
              ),
              const Divider(height: 1, color: Color(0xFFE5E5E5)),
              _buildSettingsItem(
                context,
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon!')),
                  );
                },
              ),
              const Divider(height: 1, color: Color(0xFFE5E5E5)),
              _buildSettingsItem(
                context,
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) context.go('/login');
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error signing out: $e')),
                      );
                    }
                  }
                },
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
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
      ),
      title: Text(
        title,
        style: context.secondaryFont(
          fontWeight: FontWeight.w500,
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
}
