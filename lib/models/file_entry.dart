enum FileType { reference, classwork, quiz, exam, homework, lab }

extension FileTypeLabel on FileType {
  String get label => switch (this) {
        FileType.reference => 'Reference',
        FileType.classwork => 'Classwork',
        FileType.quiz => 'Quiz',
        FileType.exam => 'Exam',
        FileType.homework => 'Homework',
        FileType.lab => 'Lab',
      };
}

class FileEntry {
  const FileEntry({
    required this.type,
    required this.label,
    required this.title,
    required this.desc,
    required this.versions,
  });

  final FileType type;
  final String label;
  final String title;
  final String desc;
  final List<FileVersion> versions;

  FileVersion get primary => versions.firstWhere(
        (v) => v.url.toLowerCase().endsWith('.pdf'),
        orElse: () => versions.first,
      );

  int get versionCount => versions.length;
}

class FileVersion {
  const FileVersion({required this.label, required this.url});
  final String label;
  final String url;

  String get extension {
    final clean = url.split('?').first;
    final dot = clean.lastIndexOf('.');
    return dot == -1 ? '' : clean.substring(dot + 1).toUpperCase();
  }
}
