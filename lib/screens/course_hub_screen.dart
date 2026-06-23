import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/course_files.dart';
import '../data/course_links.dart';
import '../data/courses.dart';
import '../models/file_entry.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets/hero_card.dart';
import '../widgets/hub_card.dart';

class CourseHubScreen extends StatefulWidget {
  const CourseHubScreen({super.key, required this.slug});
  final String slug;

  @override
  State<CourseHubScreen> createState() => _CourseHubScreenState();
}

class _CourseHubScreenState extends State<CourseHubScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _a;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: Motion.enter)..forward();
    _a = List.generate(3, (i) => Motion.stagger(_ctrl, i));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = courseBySlug(widget.slug);
    if (course == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Course not found.')));
    }
    final t = EceuhExtras.of(context);
    final files = kCourseFiles[widget.slug] ?? const <FileEntry>[];
    final links = kCourseLinks[widget.slug] ?? const <dynamic>[];
    final quizCount = files.where((f) => f.type == FileType.quiz).fold(0, (sum, f) => sum + f.versionCount);
    final testCount = files.where((f) => f.type == FileType.exam).fold(0, (sum, f) => sum + f.versionCount);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text(course.hub?.title ?? course.title, style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            FadeSlide(
              animation: _a[0],
              child: HeroCard(
                kicker: course.hub?.kicker ?? 'Course Hub',
                title: course.hub?.title ?? course.title,
                desc: course.hub?.desc ?? course.desc,
                code: course.code,
                trailing: Row(children: [
                  Expanded(child: _Stat(value: quizCount.toString(), label: 'Quizzes')),
                  const SizedBox(width: 8),
                  Expanded(child: _Stat(value: testCount.toString(), label: 'Tests')),
                  const SizedBox(width: 8),
                  Expanded(child: _Stat(value: links.length.toString(), label: 'External')),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            FadeSlide(
              animation: _a[1],
              child: HubCard(
                title: 'File Library',
                subtitle: course.sections?.files?.desc ?? 'Bucket-backed classwork and references.',
                icon: Icons.folder_outlined,
                tags: const ['Classwork', 'Quizzes', 'Reference'],
                onTap: () => context.push('/archives/course/${widget.slug}/files'),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlide(
              animation: _a[2],
              child: HubCard(
                title: 'External Resources',
                subtitle: course.sections?.links?.desc ?? 'Tools and references for the course.',
                icon: Icons.link,
                tags: const ['Simulators', 'Docs', 'Videos'],
                onTap: () => context.push('/archives/course/${widget.slug}/links'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: t.overlay,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: t.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: double.tryParse(value) ?? 0),
          duration: Motion.slow,
          curve: Motion.std,
          builder: (_, v, __) => Text(v.toInt().toString(),
            style: TextStyle(fontFamily: t.serif, fontSize: 22, fontWeight: FontWeight.w700, color: t.text)),
        ),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(color: t.textDim, fontSize: 10, letterSpacing: 0.8)),
      ]),
    );
  }
}
