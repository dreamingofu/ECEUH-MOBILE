import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';
import '../widgets/hero_card.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('Privacy Policy', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const HeroCard(
              kicker: 'Legal',
              title: 'Privacy Policy',
              desc: "What ECEUH and the Android app collect, how it's used, and the third-party services involved.",
              code: 'PRIVACY',
            ),
            const SizedBox(height: 16),
            _Section(title: 'Information We Collect', children: [
              'If you create an account we collect your email and a username — used solely to save your unit progress across devices. Anonymous usage stores nothing.',
            ]),
            _Section(title: 'How We Use Your Information', children: [
              'We use it to identify your account and sync progress. No ads, no resale.',
            ]),
            _Section(title: 'Third-Party Services', children: [
              'Supabase handles auth and progress storage. Vercel Analytics counts page views anonymously. Cloudflare R2 serves PDFs.',
            ]),
            _Section(title: 'Data Retention & Deletion', children: [
              'See the Delete Account page for the exact steps and timeline. All associated data is removed within 7 days of a deletion request.',
            ]),
            _Section(title: 'Contact', children: ['Questions? Email mail@felipejmiranda.com.']),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => launchUrl(Uri.parse('mailto:mail@felipejmiranda.com'),
                  mode: LaunchMode.externalApplication),
              icon: const Icon(Icons.mail_outline),
              label: const Text('Email us'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<String> children;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 18, color: t.text)),
        const SizedBox(height: 8),
        for (final paragraph in children) Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(paragraph, style: TextStyle(color: t.textSoft, fontSize: 14, height: 1.6)),
        ),
      ]),
    );
  }
}
