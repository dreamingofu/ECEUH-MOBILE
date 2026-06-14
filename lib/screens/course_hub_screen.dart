import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/course_files.dart';
import '../data/course_links.dart';
import '../data/courses.dart';
import '../models/file_entry.dart';
import '../theme.dart';
import '../widgets/hero_card.dart';
import '../widgets/hub_card.dart';

class CourseHubScreen extends StatelessWidget {
  const CourseHubScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final course = courseBySlug(slug);
    if (course == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Course not found.')));
    }
    final t = EceuhExtras.of(context);
    final files = kCourseFiles[slug] ?? const <FileEntry>[];
    final links = kCourseLinks[slug] ?? const <dynamic>[];
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
            HeroCard(
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
            const SizedBox(height: 16),
            HubCard(
              title: 'File Library',
              subtitle: course.sections?.files?.desc ?? 'Bucket-backed classwork and references.',
              icon: Icons.folder_outlined,
              tags: const ['Classwork', 'Quizzes', 'Reference'],
              onTap: () => context.push('/archives/course/$slug/files'),
            ),
            const SizedBox(height: 12),
            HubCard(
              title: 'External Resources',
              subtitle: course.sections?.links?.desc ?? 'Tools and references for the course.',
              icon: Icons.link,
              tags: const ['Simulators', 'Docs', 'Videos'],
              onTap: () => context.push('/archives/course/$slug/links'),
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
        Text(value, style: TextStyle(fontFamily: t.serif, fontSize: 22, fontWeight: FontWeight.w700, color: t.text)),
        const SizedBox(height: 4),
        Text(label.toUpperCase(), style: TextStyle(color: t.textDim, fontSize: 10, letterSpacing: 0.8)),
      ]),
    );
  }
}
