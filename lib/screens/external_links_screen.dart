import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/course_links.dart';
import '../data/courses.dart';
import '../models/link_entry.dart';
import '../theme.dart';
import '../widgets/hero_card.dart';

class ExternalLinksScreen extends StatelessWidget {
  const ExternalLinksScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final course = courseBySlug(slug);
    final links = kCourseLinks[slug] ?? const <LinkEntry>[];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('External Resources', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HeroCard(
              kicker: course?.title ?? 'Course',
              title: 'External Resources',
              desc: course?.sections?.links?.desc ?? 'Curated tools, simulators, and references.',
              code: 'LINKS',
            ),
            const SizedBox(height: 16),
            for (final l in links) _LinkCard(link: l),
          ],
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.link});
  final LinkEntry link;
  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => launchUrl(Uri.parse(link.url), mode: LaunchMode.externalApplication),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: t.border)),
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(link.title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700, fontSize: 18, color: t.text))),
                Text('Open →', style: TextStyle(color: t.accent, fontFamily: t.mono, fontSize: 12, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              Text(link.desc, style: TextStyle(color: t.textSoft, fontSize: 13, height: 1.55)),
            ]),
          ),
        ),
      ),
    );
  }
}
