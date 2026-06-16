import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../motion.dart';
import '../theme.dart';
import '../widgets/gold_button.dart';

/// "Kinetic Luxe" sign-in screen. UI-only — there is no auth backend, so
/// Sign In / Biometric Entry simulate a brief authentication and land on
/// the home dashboard, and "Explore without signing in" skips straight there.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _remember = false;
  bool _loading = false;

  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
    // logo, title/subtitle, form card, footer
    _a = List.generate(4, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_loading) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);
    context.go('/home');
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not available in this preview.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final goldGradient = LinearGradient(colors: [t.goldStart, t.goldEnd]);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter(color: t.accent))),
          Positioned(top: -140, left: -100, child: _Glow(color: t.accent, size: 320)),
          Positioned(bottom: -100, right: -80, child: _Glow(color: scheme.secondaryContainer, size: 260)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: Tween(begin: 0.6, end: 1.0).animate(_a[0]),
                        child: FadeTransition(
                          opacity: _a[0],
                          child: Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: goldGradient,
                              boxShadow: [BoxShadow(color: t.goldEnd.withValues(alpha: 0.3), blurRadius: 24, offset: const Offset(0, 10))],
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.bolt, color: scheme.onPrimary, size: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeSlide(
                        animation: _a[1],
                        child: Column(
                          children: [
                            Text('ECEUH', style: textTheme.displayLarge?.copyWith(color: t.accent, letterSpacing: -1.5)),
                            const SizedBox(height: 4),
                            Text('ECE COURSEWORK ARCHIVE', style: textTheme.labelSmall?.copyWith(color: t.textMuted)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 36),
                      FadeSlide(
                        animation: _a[2],
                        child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: t.overlay,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sign In', style: textTheme.displaySmall),
                            const SizedBox(height: 4),
                            Text('Access your ECE course archive and faculty ratings.',
                              style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 14, height: 1.5)),
                            const SizedBox(height: 28),
                            Text('Institutional Email', style: t.fieldLabel),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'cougar@cougarnet.uh.edu',
                                prefixIcon: Icon(Icons.alternate_email, color: t.textMuted),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Password', style: t.fieldLabel),
                                GestureDetector(
                                  onTap: _comingSoon,
                                  child: Text('Forgot?', style: TextStyle(fontFamily: t.sans, color: t.accent, fontSize: 13, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              decoration: InputDecoration(
                                hintText: '••••••••••••',
                                prefixIcon: Icon(Icons.lock_outline, color: t.textMuted),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: t.textMuted),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: 24, height: 24,
                                  child: Checkbox(
                                    value: _remember,
                                    onChanged: (v) => setState(() => _remember = v ?? false),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text('Remember this device for 30 days',
                                  style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              child: GoldButton(label: 'Sign In', onTap: _signIn, loading: _loading),
                            ),
                            const SizedBox(height: 26),
                            Row(
                              children: [
                                Expanded(child: Divider(color: t.border)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('OR CONTINUE WITH', style: textTheme.labelSmall?.copyWith(color: t.textDim, fontSize: 11)),
                                ),
                                Expanded(child: Divider(color: t.border)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: OutlinedButton.icon(
                                onPressed: _signIn,
                                icon: const Icon(Icons.fingerprint),
                                label: const Text('Biometric Entry'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: () => context.go('/home'),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 14),
                                    children: [
                                      const TextSpan(text: 'First time here? '),
                                      TextSpan(text: 'Explore without signing in', style: TextStyle(color: t.accent, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ),  // FadeSlide (form card)
                      const SizedBox(height: 32),
                      FadeSlide(
                        animation: _a[3],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FooterLink(label: 'Privacy Policy', onTap: () => context.push('/privacy')),
                            const SizedBox(width: 24),
                            _FooterLink(
                              label: 'Support',
                              onTap: () => launchUrl(Uri.parse('https://github.com/dreamingofu/eceuh'), mode: LaunchMode.externalApplication),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

/// Soft radial glow used as ambient background decoration.
class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color.withValues(alpha: 0.14), color.withValues(alpha: 0)]),
        ),
      ),
    );
  }
}

/// Sparse dot-grid texture echoing the Kinetic Luxe background pattern.
class _DotGridPainter extends CustomPainter {
  const _DotGridPainter({required this.color});
  final Color color;

  static const _spacing = 32.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.10);
    for (double y = 0; y < size.height; y += _spacing) {
      for (double x = 0; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotGridPainter oldDelegate) => oldDelegate.color != color;
}
