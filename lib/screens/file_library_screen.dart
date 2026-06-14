import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/course_files.dart';
import '../data/courses.dart';
import '../models/file_entry.dart';
import '../theme.dart';
import '../widgets/file_card.dart';
import '../widgets/hero_card.dart';

class FileLibraryScreen extends StatefulWidget {
  const FileLibraryScreen({super.key, required this.slug});
  final String slug;

  @override
  State<FileLibraryScreen> createState() => _FileLibraryScreenState();
}

class _FileLibraryScreenState extends State<FileLibraryScreen> {
  FileType? _filter;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final course = courseBySlug(widget.slug);
    final entries = kCourseFiles[widget.slug] ?? const <FileEntry>[];
    final shown = _filter == null ? entries : entries.where((e) => e.type == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        title: Text('File Library', style: TextStyle(fontFamily: t.serif, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            HeroCard(
              kicker: course?.title ?? 'Course',
              title: 'File Library',
              desc: 'Bucket-backed classwork and references for ${course?.code ?? 'this course'}. Preview opens the file inline; Save downloads it for offline use.',
              code: 'R2_SYNC',
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FilterChip(label: 'All', selected: _filter == null, onSelected: () => setState(() => _filter = null)),
                  for (final type in FileType.values)
                    _FilterChip(label: type.label, selected: _filter == type, onSelected: () => setState(() => _filter = type)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (shown.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Center(child: Text('No files yet for this filter.', style: TextStyle(color: t.textDim))),
              )
            else
              ...shown.map((e) => FileCard(entry: e)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onSelected});
  final String label;
  final bool selected;
  final VoidCallback onSelected;
  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        labelStyle: TextStyle(
          fontFamily: t.sans, fontSize: 12, fontWeight: FontWeight.w600,
          letterSpacing: 0.6,
          color: selected ? t.accent : t.textMuted,
        ),
        backgroundColor: t.overlay,
        selectedColor: t.accent.withValues(alpha: 0.10),
        side: BorderSide(color: selected ? t.accent.withValues(alpha: 0.4) : t.border),
        shape: const StadiumBorder(),
      ),
    );
  }
}
