import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maega_app/widgets/maega_logo.dart';
import '../constants.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _error = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
      // AuthGate (below this route) has already swapped to Home in the
      // background by the time the auth-state change reaches it — pop back
      // to reveal it if this LoginScreen was pushed on top of something.
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      const invalidCodes = {'user-not-found', 'wrong-password', 'invalid-credential'};
      setState(() {
        _error = invalidCodes.contains(e.code)
            ? 'Invalid email or password.'
            : (e.message ?? 'Login failed.');
      });
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
                  // Center(
                  //   child: Image.asset(
                  //     'assets/images/maega_logo.png',
                  //     height: 120,
                  //   ),
                  // ),
                  MaegaLogo(),

                  const SizedBox(height: 32),
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Login to continue',
                    style: TextStyle(fontSize: 14, color: kTextGrey),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration(
                      label: 'Email',
                      icon: Icons.email_outlined,
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter your email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscure,
                    decoration: _fieldDecoration(
                      label: 'Password',
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: kTextGrey,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter your password' : null,
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
                      onPressed: _loading ? null : _login,
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
                              'Login',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: kTextGrey, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignupScreen()),
                        ),
                        child: const Text(
                          'Sign Up',
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
