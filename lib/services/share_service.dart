import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareService {
  static Future<void> shareLink({required String title, required String url}) async {
    await Share.share('$title\n$url', subject: title);
  }

  /// Opens [url] in the system browser / native PDF viewer.
  static Future<bool> openExternal(String url) async {
    final uri = Uri.parse(url);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Downloads [url] to the platform's app-documents directory.
  /// Returns the saved file path, or null on failure.
  static Future<String?> download(String url, {String? filename}) async {
    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final clean = url.split('?').first;
      final inferred = clean.split('/').last;
      final name = filename ?? (inferred.isEmpty ? 'file.pdf' : Uri.decodeComponent(inferred));
      final path = '${dir.path}${Platform.pathSeparator}$name';
      await dio.download(url, path);
      return path;
    } catch (_) {
      return null;
    }
  }
}
