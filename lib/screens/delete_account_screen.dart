import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme.dart';
import '../widgets/hero_card.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('Delete Account', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            const HeroCard(
              kicker: 'Account',
              title: 'Delete Your Account',
              desc: 'Request permanent removal of your ECEUH account and any data tied to it. Applies to both the website and the Android app.',
              code: 'DELETE',
            ),
            const SizedBox(height: 16),

            const _Card(title: 'What Gets Deleted', children: [
              'Your email address and username',
              'Your course progress across every unit',
              'Your sign-in session and credentials',
              'Any cached progress synced from previous devices',
            ]),
            const SizedBox(height: 12),
            const _Card(title: 'What Gets Kept', children: [
              'Nothing personal. All data associated with your account is permanently deleted within 7 days of your request.',
            ]),
            const SizedBox(height: 12),
            _Step(num: 1, title: 'Email a deletion request',
              body: 'Send an email to mail@felipejmiranda.com with the subject "Delete my account" and the email tied to your ECEUH account in the body. We will reply with confirmation within 7 days.',
              cta: FilledButton.icon(
                icon: const Icon(Icons.mail_outline),
                label: const Text('Send deletion request'),
                onPressed: () => launchUrl(Uri.parse(
                  'mailto:mail@felipejmiranda.com?subject=${Uri.encodeQueryComponent("Delete my account")}'
                  '&body=${Uri.encodeQueryComponent("Please delete my ECEUH account associated with this email address.")}',
                )),
              ),
            ),
            const _Step(num: 2, title: 'Confirmation',
              body: 'Once we process the request, we will reply with confirmation that your record has been removed from the Supabase database.'),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});
  final String title;
  final List<String> children;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 18, color: t.text)),
        const SizedBox(height: 8),
        for (final item in children) Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Container(width: 5, height: 5, decoration: BoxDecoration(color: t.accent, shape: BoxShape.circle)),
            ),
            Expanded(child: Text(item, style: TextStyle(color: t.textSoft, fontSize: 14, height: 1.55))),
          ]),
        ),
      ]),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.num, required this.title, required this.body, this.cta});
  final int num;
  final String title;
  final String body;
  final Widget? cta;
  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(58, 16, 18, 16),
      decoration: BoxDecoration(
        color: t.accent.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.accent.withValues(alpha: 0.20)),
      ),
      child: Stack(children: [
        Positioned(
          left: -42, top: 0,
          child: Container(
            width: 32, height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: t.accent, shape: BoxShape.circle),
            child: Text('$num', style: TextStyle(color: Colors.white, fontFamily: t.mono, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 16, color: t.text)),
          const SizedBox(height: 6),
          Text(body, style: TextStyle(color: t.textSoft, fontSize: 13.5, height: 1.55)),
          if (cta != null) Padding(padding: const EdgeInsets.only(top: 14), child: cta!),
        ]),
      ]),
    );
  }
}
