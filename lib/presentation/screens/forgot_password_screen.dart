import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/typography.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../data/services/password_reset_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _loading = false;
  bool _emailSent = false;
  String? _error;
  
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() { 
      _loading = true; 
      _error = null;
    });
    
    try {
      final result = await PasswordResetService.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      if (result['success'] == true) {
        setState(() {
          _emailSent = true;
        });
        
        // Log the successful attempt
        PasswordResetService.logPasswordResetAttempt(
          email: _emailController.text.trim(),
          success: true,
        );
      } else {
        setState(() {
          _error = result['message'] as String? ?? 'Failed to send password reset email.';
        });
        
        // Log the failed attempt
        PasswordResetService.logPasswordResetAttempt(
          email: _emailController.text.trim(),
          success: false,
          errorCode: result['error'] as String?,
        );
      }
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred. Please try again.';
      });
      
      // Log the failed attempt
      PasswordResetService.logPasswordResetAttempt(
        email: _emailController.text.trim(),
        success: false,
        errorCode: 'unknown',
      );
    } finally {
      setState(() { _loading = false; });
    }
  }

  Future<void> _resendEmail() async {
    setState(() { _emailSent = false; });
    await _sendPasswordResetEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5A4E3C)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reset Password',
          style: context.primaryHeadlineMedium.copyWith(
            color: const Color(0xFF5A4E3C),
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                
                // Header Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B4513).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.key,
                    size: 40,
                    color: Color(0xFF8B4513),
                  ),
                ),
                const SizedBox(height: 30),
                
                // Title and Description
                Text(
                  _emailSent ? 'Check Your Email' : 'Forgot Your Password?',
                  style: context.primaryHeadlineLarge.copyWith(
                    color: const Color(0xFF5A4E3C),
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                Text(
                  _emailSent 
                    ? 'We\'ve sent a password reset link to your email address. Please check your inbox and spam folder.'
                    : 'No worries! Enter your email address and we\'ll send you a link to reset your password.',
                  style: context.secondaryBodyLarge.copyWith(
                    color: const Color(0xFF6B5E4C),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                if (!_emailSent) ...[
                  // Email Input
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address',
                        style: context.secondaryFont(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFFE5D5C0),
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            hintStyle: context.secondaryFont(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF8B4513),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email address';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Send Reset Email Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _sendPasswordResetEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Send Reset Link',
                            style: context.secondaryFont(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                ] else ...[
                  // Email Sent Success State
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.green.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade600,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Email sent to ${_emailController.text.trim()}',
                            style: context.secondaryBodyMedium.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Resend Email Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: _loading ? null : _resendEmail,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF8B4513),
                        side: const BorderSide(
                          color: Color(0xFF8B4513),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B4513)),
                            ),
                          )
                        : Text(
                            'Resend Email',
                            style: context.secondaryFont(
                              fontSize: 18,
                              color: const Color(0xFF8B4513),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Return to Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.go('/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B4513),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Return to Login',
                        style: context.secondaryFont(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
                
                // Error Message
                if (_error != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: context.secondaryBodyMedium.copyWith(
                              color: Colors.red.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const Spacer(),
                
                // Help Text
                if (!_emailSent) ...[
                  Text(
                    'Remember your password?',
                    style: context.secondaryBodyMedium.copyWith(
                      color: const Color(0xFF6B5E4C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Text(
                      'Back to Login',
                      style: context.secondaryFont(
                        fontSize: 16,
                        color: const Color(0xFF8B4513),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Didn\'t receive the email? Check your spam folder or',
                    style: context.secondaryBodyMedium.copyWith(
                      color: const Color(0xFF6B5E4C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _resendEmail,
                    child: Text(
                      'try again',
                      style: context.secondaryFont(
                        fontSize: 16,
                        color: const Color(0xFF8B4513),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
