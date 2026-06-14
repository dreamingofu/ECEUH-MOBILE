import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/file_entry.dart';
import '../services/share_service.dart';
import '../theme.dart';

class FileCard extends StatefulWidget {
  const FileCard({super.key, required this.entry});
  final FileEntry entry;

  @override
  State<FileCard> createState() => _FileCardState();
}

class _FileCardState extends State<FileCard> {
  late FileVersion _active;

  @override
  void initState() {
    super.initState();
    _active = widget.entry.primary;
  }

  Color _typeColor(BuildContext c) {
    final t = EceuhExtras.of(c);
    return switch (widget.entry.type) {
      FileType.quiz => t.accent,
      FileType.exam => const Color(0xFFB27A00),
      FileType.homework => const Color(0xFF16A34A),
      FileType.classwork => const Color(0xFF2563EB),
      FileType.lab => const Color(0xFF7C3AED),
      FileType.reference => t.textMuted,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    final entry = widget.entry;
    final hasVersions = entry.versions.length > 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: _typeColor(context).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  entry.label.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: _typeColor(context)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_active.label.toUpperCase()} · ${_active.extension}',
                style: TextStyle(color: t.textDim, fontSize: 11, letterSpacing: 0.8, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(entry.title, style: TextStyle(fontFamily: t.serif, fontSize: 19, fontWeight: FontWeight.w700, color: t.text)),
          if (entry.desc.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(entry.desc, style: TextStyle(color: t.textSoft, fontSize: 13, height: 1.55)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              _GhostBtn(icon: Icons.visibility_outlined, label: 'Preview', onTap: _openPreview),
              _GhostBtn(icon: Icons.ios_share, label: 'Share', onTap: () => ShareService.shareLink(title: entry.title, url: _active.url)),
              _SolidBtn(icon: Icons.download_outlined, label: 'Save', onTap: _saveOffline),
              if (hasVersions) _VersionPicker(
                versions: entry.versions,
                active: _active,
                onPicked: (v) => setState(() => _active = v),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openPreview() {
    final url = _active.url;
    context.push('/preview?url=${Uri.encodeQueryComponent(url)}&title=${Uri.encodeQueryComponent(widget.entry.title)}');
  }

  Future<void> _saveOffline() async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Saving for offline use…')));
    final path = await ShareService.download(_active.url);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(path == null ? 'Couldn\'t save the file.' : 'Saved.')));
  }
}

class _GhostBtn extends StatelessWidget {
  const _GhostBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _SolidBtn extends StatelessWidget {
  const _SolidBtn({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class _VersionPicker extends StatelessWidget {
  const _VersionPicker({required this.versions, required this.active, required this.onPicked});
  final List<FileVersion> versions;
  final FileVersion active;
  final ValueChanged<FileVersion> onPicked;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<FileVersion>(
      tooltip: 'Choose version',
      initialValue: active,
      onSelected: onPicked,
      itemBuilder: (c) => versions.map((v) =>
        PopupMenuItem(value: v, child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(v.label),
            const SizedBox(width: 12),
            Text(v.extension, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ],
        )),
      ).toList(),
      child: OutlinedButton.icon(
        onPressed: null,
        icon: const Icon(Icons.expand_more, size: 16),
        label: Text(active.label),
      ),
    );
  }
}
