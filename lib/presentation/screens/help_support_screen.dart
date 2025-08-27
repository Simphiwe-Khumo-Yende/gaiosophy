import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/typography.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Help & Support',
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
            // Introduction
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
                    Icons.support_agent,
                    size: 48,
                    color: const Color(0xFF5A4E3C),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We\'re here to help!',
                    style: context.primaryFont(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Have questions or encountered an issue? We\'d love to help you get the most out of Gaiosophy.',
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

            // Support Options
            Text(
              'Get Support',
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
                  _buildSupportItem(
                    context,
                    icon: Icons.email_outlined,
                    title: 'Email Support',
                    subtitle: 'Send us an email and we\'ll get back to you',
                    onTap: () => _sendEmail(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E5E5)),
                  _buildSupportItem(
                    context,
                    icon: Icons.bug_report_outlined,
                    title: 'Report a Bug',
                    subtitle: 'Found a bug? Let us know so we can fix it',
                    onTap: () => _reportBug(),
                  ),
                  const Divider(height: 1, color: Color(0xFFE5E5E5)),
                  _buildSupportItem(
                    context,
                    icon: Icons.lightbulb_outline,
                    title: 'Feature Request',
                    subtitle: 'Suggest new features or improvements',
                    onTap: () => _requestFeature(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // FAQ Section
            Text(
              'Frequently Asked Questions',
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildFAQItem(
                      context,
                      question: 'How do I update my profile information?',
                      answer: 'Go to Settings > Profile Information > Edit to update your profile details.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      context,
                      question: 'How does the personalized content work?',
                      answer: 'Based on your zodiac sign and preferences, we curate seasonal wisdom, plant care tips, and recipes that align with your astrological profile.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      context,
                      question: 'Can I use the app offline?',
                      answer: 'Some content is available offline after being downloaded. You\'ll see an offline indicator when content is available without internet.',
                    ),
                    const SizedBox(height: 16),
                    _buildFAQItem(
                      context,
                      question: 'How do I delete my account?',
                      answer: 'Please contact us at siphiweyende371@gmail.com to request account deletion. We\'ll help you through the process.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Icon(
        icon,
        color: const Color(0xFF5A4E3C),
        size: 28,
      ),
      title: Text(
        title,
        style: context.secondaryFont(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
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

  Widget _buildFAQItem(BuildContext context, {
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 8),
      title: Text(
        question,
        style: context.secondaryFont(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      children: [
        Text(
          answer,
          style: context.secondaryFont(
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'siphiweyende371@gmail.com',
      query: 'subject=Gaiosophy Support Request',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _reportBug() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'siphiweyende371@gmail.com',
      query: 'subject=Gaiosophy Bug Report&body=Please describe the bug you encountered:%0D%0A%0D%0ASteps to reproduce:%0D%0A1.%0D%0A2.%0D%0A3.%0D%0A%0D%0AExpected behavior:%0D%0A%0D%0AActual behavior:%0D%0A',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _requestFeature() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'siphiweyende371@gmail.com',
      query: 'subject=Gaiosophy Feature Request&body=Please describe the feature you would like to see:%0D%0A%0D%0AWhy would this feature be useful:%0D%0A%0D%0AAny additional details:%0D%0A',
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
