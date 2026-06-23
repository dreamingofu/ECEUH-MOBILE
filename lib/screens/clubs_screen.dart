import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/clubs.dart';
import '../design/tokens.dart';
import '../models/club.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets/glass/glass_card.dart';
import '../widgets/glass/glass_chip.dart';
import '../widgets/search_field.dart';

class ClubsScreen extends StatefulWidget {
  const ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  // index 0 = header, 1 = search, 2..N = one per club in kClubs order
  late final List<Animation<double>> _a;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)
      ..forward();
    _a = List.generate(2 + kClubs.length, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  List<Club> get _filtered {
    if (_query.isEmpty) return kClubs;
    return kClubs.where((c) {
      return c.name.toLowerCase().contains(_query) ||
          c.description.toLowerCase().contains(_query) ||
          c.tags.any((tag) => tag.contains(_query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final clubs = _filtered;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
            Spacing.s2, Spacing.s2, Spacing.s2, Spacing.s3),
        children: [
          FadeSlide(
            animation: _a[0],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CAMPUS CLUBS',
                  style: TextStyle(
                    fontFamily: t.mono,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: t.accent,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find Your People.',
                  style: TextStyle(
                    fontFamily: t.serif,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -1,
                    color: t.text,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Student organizations for every engineer at UH Cullen.',
                  style: TextStyle(color: t.textMuted, fontSize: 14, height: 1.55),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.s2),
          FadeSlide(
            animation: _a[1],
            child: SearchField(
              hint: 'Search clubs or tags…',
              onChanged: (v) =>
                  setState(() => _query = v.trim().toLowerCase()),
            ),
          ),
          const SizedBox(height: Spacing.s2),
          if (clubs.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Center(
                child: Text(
                  'No clubs match "$_query".',
                  style: TextStyle(color: t.textDim, fontSize: 14),
                ),
              ),
            )
          else
            for (final club in clubs)
              FadeSlide(
                animation: _a[2 + kClubs.indexOf(club)],
                child: _ClubCard(
                  club: club,
                  onTap: () => context.push('/clubs/${club.slug}'),
                ),
              ),
        ],
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.club, required this.onTap});
  final Club club;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PressScale(
        borderRadius: BorderRadius.circular(Radii.lg),
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.all(Spacing.s2),
          radius: Radii.lg,
          elevation: AppElevation.soft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: t.accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(Radii.sm + 4),
                ),
                child: Icon(club.icon, color: t.accent, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      club.name,
                      style: TextStyle(
                        fontFamily: t.serif,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: t.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: t.textMuted, fontSize: 13, height: 1.45),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: club.tags
                          .map((tag) => GlassChip(
                                label: tag,
                                variant: GlassChipVariant.neutral,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.chevron_right, color: t.textDim),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
