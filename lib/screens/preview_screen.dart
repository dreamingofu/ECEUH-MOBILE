import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../services/share_service.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Mobile browsers / in-app WebViews can't render PDFs in an iframe.
    // Route every PDF through Google's docs viewer the same way the
    // website does — works for any publicly accessible URL.
    final isPdf = widget.url.toLowerCase().endsWith('.pdf');
    final src = isPdf
        ? 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeQueryComponent(widget.url)}'
        : widget.url;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(src));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        title: Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            tooltip: 'Open in browser',
            icon: const Icon(Icons.open_in_new),
            onPressed: () => launchUrl(Uri.parse(widget.url), mode: LaunchMode.externalApplication),
          ),
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.ios_share),
            onPressed: () => ShareService.shareLink(title: widget.title, url: widget.url),
          ),
          IconButton(
            tooltip: 'Save offline',
            icon: const Icon(Icons.download),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(const SnackBar(content: Text('Saving…')));
              final path = await ShareService.download(widget.url);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(SnackBar(content: Text(path == null ? "Couldn't save." : 'Saved.')));
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
