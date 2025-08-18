import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../data/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  
  bool _loading = false;
  String? _error;
  int _currentStep = 0;
  DateTime? _selectedDate;
  String? _selectedZodiacSign;

  final List<String> _zodiacSigns = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else {
      _submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep = 0);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFD2691E),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: const Color(0xFF8B6B47),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_currentStep == 1 && (_selectedDate == null || _selectedZodiacSign == null)) {
      setState(() => _error = 'Please fill all fields');
      return;
    }
    
    setState(() { _loading = true; _error = null; });
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );
      
      // Update user profile with additional info
      await userCredential.user?.updateDisplayName(
        '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'
      );
      
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'firstName': _firstNameCtrl.text.trim(),
        'lastName': _lastNameCtrl.text.trim(),
        'dateOfBirth': _selectedDate,
        'zodiacSign': _selectedZodiacSign,
        'email': _emailCtrl.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      if (mounted) context.go('/');
    } on FirebaseAuthException catch (e) {
      setState(() { _error = e.message; });
    } catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _google() async {
    setState(() { _loading = true; _error = null; });
    try {
      await AuthService(FirebaseAuth.instance).signInWithGoogle();
      if (mounted) context.go('/');
    } on Exception catch (e) {
      setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/autumn.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            MediaQuery.of(context).padding.bottom - 48,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Mystical Header with botanical elements
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFD2691E).withOpacity(0.1),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.eco_outlined,
                              size: 30,
                              color: const Color(0xFF8B6B47).withOpacity(0.5),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFD2691E).withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.person_add_outlined,
                                size: 40,
                                color: Color(0xFF8B6B47),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.eco_outlined,
                              size: 30,
                              color: const Color(0xFF8B6B47).withOpacity(0.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Begin Your Journey',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Serif',
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your herbalist profile',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Registration Form Card
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 500), // Max width for larger screens
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Progress indicator
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD2691E),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: _currentStep >= 1 
                                          ? const Color(0xFFD2691E) 
                                          : const Color(0xFFD2691E).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _currentStep == 0 ? 'Step 1: Account Details' : 'Step 2: Personal Information',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8B6B47),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            // Step 1: Account Details
                            if (_currentStep == 0) ...[
                              TextFormField(
                                controller: _emailCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                ),
                                validator: (v) => (v==null||v.isEmpty)?'Enter email':null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordCtrl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                  helperText: 'At least 6 characters',
                                  helperStyle: TextStyle(color: const Color(0xFF8B6B47).withOpacity(0.7)),
                                ),
                                validator: (v) => (v==null||v.length<6)?'Min 6 chars':null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _confirmCtrl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                ),
                                validator: (v) => v!=_passwordCtrl.text?'Passwords do not match':null,
                              ),
                            ],
                            
                            // Step 2: Personal Information
                            if (_currentStep == 1) ...[
                              TextFormField(
                                controller: _firstNameCtrl,
                                decoration: InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                ),
                                validator: (v) => (v==null||v.isEmpty)?'Enter first name':null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _lastNameCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                ),
                                validator: (v) => (v==null||v.isEmpty)?'Enter last name':null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _dobCtrl,
                                readOnly: true,
                                onTap: _selectDate,
                                decoration: InputDecoration(
                                  labelText: 'Date of Birth',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                ),
                                validator: (v) => (v==null||v.isEmpty)?'Select date of birth':null,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                value: _selectedZodiacSign,
                                decoration: InputDecoration(
                                  labelText: 'Zodiac Sign',
                                  labelStyle: const TextStyle(color: Color(0xFF8B6B47)),
                                  prefixIcon: const Icon(Icons.star_outline, color: Color(0xFF8B6B47)),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.3)),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFFD2691E), width: 2),
                                  ),
                                ),
                                items: _zodiacSigns.map((String sign) {
                                  return DropdownMenuItem<String>(
                                    value: sign,
                                    child: Text(sign, style: const TextStyle(color: Color(0xFF8B6B47))),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() => _selectedZodiacSign = newValue);
                                },
                                validator: (v) => v == null ? 'Select your zodiac sign' : null,
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            
                            // Navigation buttons
                            Row(
                              children: [
                                if (_currentStep > 0) ...[
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _previousStep,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF8B6B47),
                                        side: BorderSide(color: const Color(0xFF8B6B47).withOpacity(0.5)),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text('Previous'),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                ],
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _loading ? null : _nextStep,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD2691E),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _loading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            _currentStep == 0 ? 'Next' : 'Create Account',
                                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                            
                            if (_error != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            
                            // Google Sign-in option (only show on Step 1)
                            if (_currentStep == 0) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: const Color(0xFF8B6B47).withOpacity(0.3))),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    child: Text('or', style: TextStyle(color: Color(0xFF8B6B47))),
                                  ),
                                  Expanded(child: Divider(color: const Color(0xFF8B6B47).withOpacity(0.3))),
                                ],
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: _loading ? null : _google,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF8B6B47),
                                  side: const BorderSide(color: Color(0xFF8B6B47)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.login, color: Color(0xFF8B6B47)),
                                label: const Text(
                                  'Sign up with Google',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Navigation to login
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.7),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.white.withOpacity(0.9)),
                            ),
                            const TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: Color(0xFFD2691E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Decorative element
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.spa_outlined,
                          size: 20,
                          color: const Color(0xFF8B6B47).withOpacity(0.3),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          height: 1,
                          width: 50,
                          color: const Color(0xFF8B6B47).withOpacity(0.3),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.spa_outlined,
                          size: 20,
                          color: const Color(0xFF8B6B47).withOpacity(0.3),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Terms and conditions
                    Text(
                      'By creating an account, you agree to our',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF8B6B47).withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Terms of Service',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD2691E),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Text(
                          ' and ',
                          style: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF8B6B47).withOpacity(0.7),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD2691E),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
