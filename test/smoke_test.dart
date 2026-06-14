import 'package:eceuh/data/courses.dart';
import 'package:eceuh/data/course_files.dart';
import 'package:eceuh/data/course_links.dart';
import 'package:eceuh/data/professors.dart';
import 'package:eceuh/models/file_entry.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('data integrity', () {
    test('every live course has hub + sections', () {
      for (final c in liveCourses) {
        expect(c.hub, isNotNull, reason: '${c.slug} missing hub');
        expect(c.sections, isNotNull, reason: '${c.slug} missing sections');
      }
    });

    test('every live course has a files + links entry', () {
      for (final c in liveCourses) {
        expect(kCourseFiles.containsKey(c.slug), isTrue, reason: '${c.slug} missing files map');
        expect(kCourseLinks.containsKey(c.slug), isTrue, reason: '${c.slug} missing links map');
      }
    });

    test('every file entry has at least one version', () {
      for (final entries in kCourseFiles.values) {
        for (final f in entries) {
          expect(f.versions, isNotEmpty, reason: '${f.title} has no versions');
        }
      }
    });

    test('rated professors expose a hue-stable initials pair', () {
      var rated = 0;
      for (final c in kProfessorCourses) {
        for (final p in c.profs) {
          if (p.hasRating) {
            rated++;
            expect(p.initials.length, inInclusiveRange(1, 3));
          }
        }
      }
      expect(rated, greaterThan(20), reason: 'Faculty Ledger needs a healthy pool');
    });

    test('quiz + exam counts sum versions, not entries', () {
      final quizzes = kCourseFiles['dld']!
          .where((f) => f.type == FileType.quiz)
          .fold(0, (s, f) => s + f.versionCount);
      expect(quizzes, greaterThanOrEqualTo(10));
    });
  });
}
