import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/services/email_service.dart';

class EmailTemplatePreviewScreen extends StatefulWidget {
  const EmailTemplatePreviewScreen({super.key});

  @override
  State<EmailTemplatePreviewScreen> createState() => _EmailTemplatePreviewScreenState();
}

class _EmailTemplatePreviewScreenState extends State<EmailTemplatePreviewScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Sarah');
  final TextEditingController _emailController = TextEditingController(text: 'sarah.botanist@example.com');
  String? _emailTemplate;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F2),
        elevation: 0,
        title: const Text(
          'Welcome Email Preview',
          style: TextStyle(
            color: Color(0xFF1A1612),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF1A1612)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Controls
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5D5C0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌿 Email Template Preview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1612),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Name Input
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Email Input
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Generate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _generatePreview,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Generating...'),
                              ],
                            )
                          : const Text(
                              '📧 Generate Email Preview',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  
                  if (_emailTemplate != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _copyToClipboard,
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy HTML'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B6B47),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _sendTestEmail,
                            icon: const Icon(Icons.send),
                            label: const Text('Send Test'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF228B22),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Preview Area
            if (_emailTemplate != null) ...[
              const Text(
                'Email Template HTML:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1612),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1612),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5D5C0)),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _emailTemplate!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Color(0xFF00FF00),
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 64,
                        color: const Color(0xFF8B6B47).withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Generate an email preview to see the\nbeautiful welcome template!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF5A4E3C).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _generatePreview() async {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both name and email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // Generate the email template
      await EmailService.sendWelcomeEmail(
        userEmail: _emailController.text.trim(),
        userName: _nameController.text.trim(),
      );
      
      // For demo purposes, we'll also generate and store the template
      final template = await EmailService.generateWelcomeEmailTemplate(
        userName: _nameController.text.trim(),
        userEmail: _emailController.text.trim(),
      );
      
      setState(() {
        _emailTemplate = template;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Email template generated successfully!'),
            backgroundColor: const Color(0xFF228B22),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _copyToClipboard() {
    if (_emailTemplate != null) {
      Clipboard.setData(ClipboardData(text: _emailTemplate!));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('📋 HTML copied to clipboard!'),
          backgroundColor: const Color(0xFF8B6B47),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  Future<void> _sendTestEmail() async {
    final success = await EmailService.sendWelcomeEmail(
      userEmail: _emailController.text.trim(),
      userName: _nameController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '📧 Test email sent!' : '❌ Failed to send email'),
          backgroundColor: success ? const Color(0xFF228B22) : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
