import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _numberCtrl= TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _numberCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    final email = _emailCtrl.text.trim().toLowerCase();

    setState(() => _loading = true);
    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: _passwordCtrl.text,
      );
      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': _nameCtrl.text.trim(),
        'email': email,
        'phone': _numberCtrl.text.trim(),
        'avatarAsset': '',
      });
      // Account creation also signs the user in, so AuthGate (below this
      // pushed route) has already swapped to Home in the background — pop
      // back to reveal it.
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.code == 'email-already-in-use'
            ? 'An account with this email already exists.'
            : (e.message ?? 'Sign up failed.');
      });
    } on FirebaseException catch (e) {
      // The auth account was created, but writing the profile doc failed
      // (e.g. Firestore rules not yet propagated). Surface it instead of
      // failing silently.
      setState(() => _error = 'Account created, but saving your profile failed: ${e.message}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/maega_logo.png',
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Create account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Sign up to get started',
                    style: TextStyle(fontSize: 14, color: kTextGrey),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: _fieldDecoration(
                      label: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration(
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter your email';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _numberCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: _fieldDecoration(
                      label: 'Mobile Number',
                      icon: Icons.phone_outlined,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter your mobile number' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePass,
                    decoration: _fieldDecoration(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass ? Icons.visibility_off : Icons.visibility,
                          color: kTextGrey,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter a password';
                      if (v.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    decoration: _fieldDecoration(
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: kTextGrey,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Confirm your password';
                      if (v != _passwordCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: kRed, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kRed,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: kTextGrey, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: kRed,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kTextGrey),
      suffixIcon: suffix,
      labelStyle: const TextStyle(color: kTextGrey),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kRed, width: 1.5),
      ),
    );
  }
}
