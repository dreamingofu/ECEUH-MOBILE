import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/clubs.dart';
import '../design/tokens.dart';
import '../models/club.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets/glass/glass_card.dart';
import '../widgets/glass/glass_chip.dart';
import '../widgets/hero_card.dart';

class ClubDetailScreen extends StatefulWidget {
  const ClubDetailScreen({super.key, required this.slug});
  final String slug;

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)
      ..forward();
    _a = List.generate(3, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) =>
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final club = clubBySlug(widget.slug);
    if (club == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Club not found.')),
      );
    }

    final t = EceuhExtras.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          club.name,
          style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              Spacing.s2, 12, Spacing.s2, Spacing.s3),
          children: [
            FadeSlide(
              animation: _a[0],
              child: HeroCard(
                kicker: 'Campus Club',
                title: club.name,
                desc: club.description,
                code: club.tags.first.toUpperCase(),
                trailing: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: club.tags
                      .map((tag) => GlassChip(
                            label: tag,
                            variant: GlassChipVariant.accent,
                          ))
                      .toList(),
                ),
              ),
            ),
            if (club.meetingTime != null || club.location != null) ...[
              const SizedBox(height: Spacing.s2),
              FadeSlide(
                animation: _a[1],
                child: _DetailsCard(
                  meetingTime: club.meetingTime,
                  location: club.location,
                ),
              ),
            ],
            if (club.hasLinks) ...[
              const SizedBox(height: Spacing.s2),
              FadeSlide(
                animation: _a[2],
                child: _LinksCard(club: club, onLaunch: _launch),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({this.meetingTime, this.location});
  final String? meetingTime;
  final String? location;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.s2),
      radius: Radii.lg,
      elevation: AppElevation.soft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DETAILS',
            style: TextStyle(
              fontFamily: t.mono,
              fontSize: 11,
              color: t.accent,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          if (meetingTime != null)
            _InfoRow(
                icon: Icons.schedule, label: 'Meets', value: meetingTime!),
          if (meetingTime != null && location != null)
            const SizedBox(height: 12),
          if (location != null)
            _InfoRow(
                icon: Icons.place_outlined,
                label: 'Location',
                value: location!),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: t.accent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(Radii.sm + 2),
          ),
          child: Icon(icon, color: t.accent, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontFamily: t.mono,
                  fontSize: 10,
                  color: t.accent,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(color: t.text, fontSize: 14, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LinksCard extends StatelessWidget {
  const _LinksCard({required this.club, required this.onLaunch});
  final Club club;
  final Future<void> Function(String url) onLaunch;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    final links = <(IconData, String, String)>[
      if (club.websiteUrl != null)
        (Icons.language, 'Website', club.websiteUrl!),
      if (club.instagramUrl != null)
        (Icons.photo_camera_outlined, 'Instagram', club.instagramUrl!),
      if (club.discordUrl != null)
        (Icons.forum_outlined, 'Discord', club.discordUrl!),
      if (club.contactEmail != null)
        (Icons.mail_outline, 'Email', 'mailto:${club.contactEmail}'),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(Spacing.s2),
      radius: Radii.lg,
      elevation: AppElevation.soft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LINKS',
            style: TextStyle(
              fontFamily: t.mono,
              fontSize: 11,
              color: t.accent,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: links
                .map((link) => _LinkButton(
                      icon: link.$1,
                      label: link.$2,
                      onTap: () => onLaunch(link.$3),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(Radii.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(Radii.pill),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: t.overlay,
            borderRadius: BorderRadius.circular(Radii.pill),
            border: Border.all(color: t.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: t.accent),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: t.sans,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: t.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
