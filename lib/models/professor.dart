class ProfessorCourse {
  const ProfessorCourse({
    required this.id,
    required this.code,
    required this.title,
    required this.profs,
  });

  final String id;
  final String code;
  final String title;
  final List<Professor> profs;
}

class Professor {
  const Professor({
    required this.name,
    required this.shortName,
    required this.initials,
    required this.dept,
    this.overall,
    this.difficulty,
    this.wouldTake,
    this.rmpUrl,
  });

  final String name;
  final String shortName;
  final String initials;
  final String dept;
  final double? overall;
  final double? difficulty;
  final int? wouldTake;
  final String? rmpUrl;

  bool get hasRating => overall != null;
  String get title {
    final match = RegExp(r'^(Dr\.|Prof\.|Mr\.|Ms\.|Mrs\.)\s+').firstMatch(name);
    final prefix = match?.group(1) ?? '';
    return ('$prefix $shortName').trim();
  }
}
