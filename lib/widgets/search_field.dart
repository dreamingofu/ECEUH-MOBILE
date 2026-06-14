import 'package:flutter/material.dart';

import '../theme.dart';

/// Search input that mirrors the home-page .palette field. Hooks into a
/// real index in v2 — for now it's wired to onChanged for callers.
class SearchField extends StatelessWidget {
  const SearchField({super.key, this.hint = 'Search course files, archives, and faculty…', this.onChanged});
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final t = EceuhExtras.of(context);
    return TextField(
      onChanged: onChanged,
      style: TextStyle(fontFamily: t.sans, color: t.text),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: t.textDim),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
