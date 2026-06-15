import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/share_service.dart';
import '../services/theme_service.dart';
import '../theme.dart';
import '../widgets/gold_button.dart';

/// "Kinetic Luxe" settings & profile screen. UI-only — profile fields and
/// notification toggles hold local session state with no backend; only the
/// appearance picker drives the real [ThemeService].
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController(text: 'Alex Cougar');
  final _emailController = TextEditingController(text: 'acougar@cougarnet.uh.edu');
  final _majorController = TextEditingController(text: 'Electrical & Computer Engineering');
  String _gradYear = '2027';

  bool _fileAlerts = true;
  bool _ratingAlerts = true;
  bool _securityAlerts = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _majorController.dispose();
    super.dispose();
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Not available in this preview.')),
    );
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated for this session.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final goldGradient = LinearGradient(colors: [t.goldStart, t.goldEnd]);
    final themeService = context.watch<ThemeService>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('Settings', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: t.border),
              ),
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 96, height: 96,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: goldGradient),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: scheme.surface),
                          child: Icon(Icons.bolt, size: 40, color: t.accent),
                        ),
                      ),
                      Positioned(
                        bottom: -2, right: -2,
                        child: GestureDetector(
                          onTap: _comingSoon,
                          child: Container(
                            width: 30, height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: t.accent,
                              shape: BoxShape.circle,
                              border: Border.all(color: t.card, width: 3),
                            ),
                            child: Icon(Icons.edit, size: 14, color: scheme.onPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Alex Cougar', style: textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text('Electrical & Computer Engineering',
                      style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 15)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      _Badge(label: 'ECE Major', color: t.accent),
                      _Badge(label: 'Class of 2027', color: scheme.secondary),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => ShareService.shareLink(
                        title: 'ECEUH — UH ECE Coursework Archive',
                        url: 'https://github.com/dreamingofu/eceuh',
                      ),
                      icon: const Icon(Icons.ios_share),
                      label: const Text('Share App'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              icon: Icons.badge_outlined,
              title: 'Profile Details',
              child: Column(
                children: [
                  _LabeledField(label: 'Full Name', controller: _nameController),
                  const SizedBox(height: 16),
                  _LabeledField(label: 'Cougarnet Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _LabeledField(label: 'Major / Track', controller: _majorController),
                  const SizedBox(height: 16),
                  _LabeledDropdown(
                    label: 'Expected Graduation',
                    value: _gradYear,
                    items: const ['2026', '2027', '2028', '2029'],
                    onChanged: (v) => setState(() => _gradYear = v),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(width: double.infinity, child: GoldButton(label: 'Save Changes', onTap: _saveProfile)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              icon: Icons.notifications_active_outlined,
              title: 'Notifications',
              child: Column(
                children: [
                  _NotificationToggle(
                    title: 'New File Uploads',
                    subtitle: 'Get notified when new lecture files, worksheets, or exams are added to your courses.',
                    value: _fileAlerts,
                    onChanged: (v) => setState(() => _fileAlerts = v),
                  ),
                  _NotificationToggle(
                    title: 'Faculty Rating Updates',
                    subtitle: 'Updates when new ratings and reviews are posted to the Faculty Ledger.',
                    value: _ratingAlerts,
                    onChanged: (v) => setState(() => _ratingAlerts = v),
                  ),
                  _NotificationToggle(
                    title: 'Security Alerts',
                    subtitle: 'Notifications for sign-ins from a new device or browser.',
                    value: _securityAlerts,
                    onChanged: (v) => setState(() => _securityAlerts = v),
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              child: Row(
                children: [
                  Expanded(
                    child: _ThemeOption(
                      icon: Icons.light_mode_outlined,
                      title: 'Crisp Gallery',
                      subtitle: 'High-contrast light mode for daytime study.',
                      selected: themeService.mode == ThemeMode.light,
                      onTap: () => themeService.setMode(ThemeMode.light),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ThemeOption(
                      icon: Icons.dark_mode_outlined,
                      title: 'Deep Midnight',
                      subtitle: 'Low-glare dark mode for late-night sessions.',
                      selected: themeService.mode == ThemeMode.dark,
                      onTap: () => themeService.setMode(ThemeMode.dark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () => context.go('/sign-in'),
                style: TextButton.styleFrom(foregroundColor: scheme.error),
                icon: const Icon(Icons.logout),
                label: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: TextStyle(fontFamily: t.sans, color: color, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.4)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.icon, required this.title, required this.child});
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: t.accent, size: 26),
              const SizedBox(width: 12),
              Text(title, style: textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.controller, this.keyboardType});
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.fieldLabel),
        const SizedBox(height: 8),
        TextField(controller: controller, keyboardType: keyboardType),
      ],
    );
  }
}

class _LabeledDropdown extends StatelessWidget {
  const _LabeledDropdown({required this.label, required this.value, required this.items, required this.onChanged});
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: t.fieldLabel),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: [for (final item in items) DropdownMenuItem(value: item, child: Text(item))],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ],
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  const _NotificationToggle({required this.title, required this.subtitle, required this.value, required this.onChanged, this.isLast = false});
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontFamily: t.serif, color: t.text, fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 12.5, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({required this.icon, required this.title, required this.subtitle, required this.selected, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Material(
      color: selected ? t.accent.withValues(alpha: 0.10) : t.overlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: selected ? t.accent : t.border, width: selected ? 1.5 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, color: t.accent, size: 26),
                  if (selected) Icon(Icons.check_circle, color: t.accent, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Text(title, style: TextStyle(fontFamily: t.serif, color: t.text, fontWeight: FontWeight.w700, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, style: TextStyle(fontFamily: t.sans, color: t.textMuted, fontSize: 11.5, height: 1.4)),
            ],
          ),
        ),
      ),
    );
  }
}
