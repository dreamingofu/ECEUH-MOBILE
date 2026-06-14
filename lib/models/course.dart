class Course {
  const Course({
    required this.slug,
    required this.code,
    required this.title,
    this.archiveTitle,
    required this.desc,
    required this.level,
    required this.units,
    required this.art,
    required this.isLive,
    this.hub,
    this.sections,
  });

  final String slug;
  final String code;
  final String title;
  final String? archiveTitle;
  final String desc;
  final int level;
  final int units;
  final String art;
  final bool isLive;
  final CourseHub? hub;
  final CourseSections? sections;

  String get displayArchiveTitle => archiveTitle ?? title;
}

class CourseHub {
  const CourseHub({required this.routeName, required this.kicker, required this.title, required this.desc});
  final String routeName; // e.g. 'course'
  final String kicker;
  final String title;
  final String desc;
}

class CourseSections {
  const CourseSections({this.files, this.links, this.topics});
  final SectionRef? files;
  final SectionRef? links;
  final SectionRef? topics;
}

class SectionRef {
  const SectionRef({required this.title, required this.desc});
  final String title;
  final String desc;
}
