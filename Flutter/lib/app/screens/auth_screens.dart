import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';
import 'main_shell.dart';
import 'onboarding_screens.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  bool _navigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppModel model = context.watch<AppModel>();
    if (!_navigated && model.isReady) {
      _timer ??= Timer(const Duration(milliseconds: 2800), _goNext);
    }
  }

  void _goNext() {
    if (!mounted || _navigated) return;
    _navigated = true;
    final AppModel model = context.read<AppModel>();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            model.isAuthenticated ? const AppShell() : const LoginPage(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double logoWidth = (constraints.maxWidth * 0.72).clamp(
            180.0,
            320.0,
          );
          final double logoHeight = (constraints.maxHeight * 0.20).clamp(
            112.0,
            180.0,
          );
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  palette.dark,
                  palette.secondary,
                  palette.primary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 2),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: logoWidth,
                        maxHeight: logoHeight,
                      ),
                      child: Image.asset(
                        'assets/images/kartik-logo-full-nobg.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Kartik Ai',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Training plans, nutrition, tracking, and coach support in one focused app.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xD9FFFFFF),
                          height: 1.45,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: const LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Color(0x33FFFFFF),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Loading your dashboard...',
                      style: TextStyle(
                        color: Color(0xD9FFFFFF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    final AuthActionResult result = await context.read<AppModel>().login(
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (!result.success) {
      setState(() => _error = result.error);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
    );
  }

  Future<void> _submitGoogle() async {
    setState(() => _error = null);
    final AuthActionResult result = await context
        .read<AppModel>()
        .signInWithGoogle();
    if (!mounted) return;
    if (!result.success) {
      setState(() => _error = result.error);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            result.isNewUser ? const LanguagePage() : const AppShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final AppModel model = context.watch<AppModel>();
    final bool backendReady = AppConfig.resolvedApiBaseUrl.isNotEmpty;
    final bool googleReady = backendReady && AppConfig.isGoogleSignInConfigured;
    final List<String> configWarnings = AppConfig.releaseWarnings;
    return Scaffold(
      backgroundColor: palette.background,
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 26),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      palette.dark,
                      palette.primary,
                      palette.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(34),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const StatusPill(
                      label: 'AI coach + live tracking',
                      background: Color(0x1FFFFFFF),
                      foreground: Colors.white,
                      icon: Icons.auto_awesome,
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Image.asset(
                        'assets/images/kartik-logo-full-nobg.png',
                        width: 220,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Train with structure, not guesswork.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Plans, nutrition, progress, and coach support all in one focused dashboard.',
                      style: TextStyle(color: Color(0xD9FFFFFF), height: 1.45),
                    ),
                    const SizedBox(height: 18),
                    const Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        StatusPill(
                          label: 'Workout plans',
                          background: Color(0x1FFFFFFF),
                          foreground: Colors.white,
                        ),
                        StatusPill(
                          label: 'Coach voice',
                          background: Color(0x1FFFFFFF),
                          foreground: Colors.white,
                        ),
                        StatusPill(
                          label: 'Progress exports',
                          background: Color(0x1FFFFFFF),
                          foreground: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FitnessCard(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to continue your routine and pick up where you left off.',
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    if (_error != null) ...<Widget>[
                      const SizedBox(height: 18),
                      _AuthError(message: _error!),
                    ],
                    if (configWarnings.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 18),
                      _BuildConfigNotice(messages: configWarnings),
                    ],
                    const SizedBox(height: 22),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.alternate_email_rounded),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: _obscurePassword,
                      prefix: const Icon(Icons.lock_outline_rounded),
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: palette.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    PrimaryButton(
                      label: 'Sign In',
                      loading: model.authBusy,
                      onPressed: backendReady ? _submit : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: <Widget>[
                        Expanded(child: Divider(color: palette.border)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                        ),
                        Expanded(child: Divider(color: palette.border)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Continue with Google',
                      outline: true,
                      icon: Icons.g_mobiledata_rounded,
                      loading: model.authBusy,
                      onPressed: googleReady ? _submitGoogle : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) => const SignupPage(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 14,
                      ),
                      children: <InlineSpan>[
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            color: palette.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _agreed = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _error = null);
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (!_agreed) {
      setState(() => _error = 'Please agree to the Terms & Privacy Policy');
      return;
    }
    final AuthActionResult result = await context.read<AppModel>().signup(
      _nameController.text,
      _emailController.text,
      _passwordController.text,
    );
    if (!mounted) return;
    if (!result.success) {
      setState(() => _error = result.error);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LanguagePage()),
    );
  }

  Future<void> _submitGoogle() async {
    setState(() => _error = null);
    final AuthActionResult result = await context
        .read<AppModel>()
        .signInWithGoogle();
    if (!mounted) return;
    if (!result.success) {
      setState(() => _error = result.error);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) =>
            result.isNewUser ? const LanguagePage() : const AppShell(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final AppModel model = context.watch<AppModel>();
    final bool backendReady = AppConfig.resolvedApiBaseUrl.isNotEmpty;
    final bool googleReady = backendReady && AppConfig.isGoogleSignInConfigured;
    final List<String> configWarnings = AppConfig.releaseWarnings;
    final int passwordLength = _passwordController.text.length;
    final Color strengthColor = passwordLength < 6
        ? palette.danger
        : passwordLength < 10
        ? palette.warning
        : palette.primary;
    final String strengthLabel = passwordLength < 6
        ? 'Weak'
        : passwordLength < 10
        ? 'Fair'
        : 'Strong';

    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: AppBackdrop(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 28),
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 28),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[palette.dark, palette.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginPage(),
                        ),
                      ),
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Join thousands on their fitness journey.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _AuthError(message: _error!),
                      ),
                    if (configWarnings.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _BuildConfigNotice(messages: configWarnings),
                      ),
                    AppTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'Kartik Sharma',
                      prefix: const Icon(Icons.person_outline_rounded),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.alternate_email_rounded),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Min. 6 characters',
                      obscureText: _obscurePassword,
                      prefix: const Icon(Icons.lock_outline_rounded),
                      onChanged: (_) => setState(() {}),
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$strengthLabel password',
                      style: TextStyle(
                        color: strengthColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmController,
                      label: 'Confirm Password',
                      hint: 'Re-enter your password',
                      obscureText: _obscureConfirm,
                      prefix: const Icon(Icons.verified_user_outlined),
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      value: _agreed,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        'I agree to the Terms of Service and Privacy Policy',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                      activeColor: palette.primary,
                      onChanged: (bool? value) =>
                          setState(() => _agreed = value ?? false),
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Create Account',
                      loading: model.authBusy,
                      onPressed: backendReady ? _submit : null,
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Sign up with Google',
                      outline: true,
                      icon: Icons.g_mobiledata_rounded,
                      loading: model.authBusy,
                      onPressed: googleReady ? _submitGoogle : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuthError extends StatelessWidget {
  const _AuthError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.danger.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.danger.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: palette.danger, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: palette.danger,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildConfigNotice extends StatelessWidget {
  const _BuildConfigNotice({required this.messages});

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.warning.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: palette.warning.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messages
            .map(
              (String message) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.info_outline, color: palette.warning, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message,
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  String? _error;
  bool _sent = false;
  bool _busy = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    final AuthActionResult result = await context
        .read<AppModel>()
        .resetPassword(_emailController.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = result.error;
      _sent = result.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        leading: BackButton(color: palette.textPrimary),
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _sent
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Icon(Icons.check_circle, size: 72, color: palette.primary),
                    const SizedBox(height: 20),
                    Text(
                      'Check Your Email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'We sent a password reset link to ${_emailController.text}.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      label: 'Back to Sign In',
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginPage(),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: palette.primaryLight,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Icon(
                        Icons.lock_open_outlined,
                        size: 36,
                        color: palette.primary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter your registered email address and we'll send you a reset link.",
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (_error != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDEDEC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFADBD8)),
                        ),
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: palette.danger,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      hint: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: 'Send Reset Link',
                      loading: _busy,
                      onPressed: _submit,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
