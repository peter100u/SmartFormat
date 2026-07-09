import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../l10n/app_localizations.dart';
import 'mova_embedded_webview.dart';
import 'mova_webview_config.dart';

class MovaWebViewPage extends StatefulWidget {
  const MovaWebViewPage({required this.title, required this.config, super.key});

  final String title;
  final MovaWebViewConfig config;

  @override
  State<MovaWebViewPage> createState() => _MovaWebViewPageState();
}

class _MovaWebViewPageState extends State<MovaWebViewPage> {
  InAppWebViewController? _controller;
  double _progress = 0;
  bool _canGoBack = false;
  bool _canGoForward = false;
  String? _errorMessage;
  Uri? _failedUri;

  bool get _isLoading => _progress > 0 && _progress < 1;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: l10n.webViewRefreshTooltip,
            onPressed: _controller == null ? null : _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
        bottom: widget.config.showLoadingBar
            ? PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: _isLoading
                    ? LinearProgressIndicator(value: _progress)
                    : const SizedBox(height: 2),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: _errorMessage == null
                ? MovaEmbeddedWebView(
                    config: widget.config,
                    onWebViewCreated: (controller) {
                      _controller = controller;
                    },
                    onLoadStart: (_) {
                      setState(() {
                        _errorMessage = null;
                        _failedUri = null;
                        _progress = 0.1;
                      });
                    },
                    onLoadStop: (_) async {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _progress = 1;
                      });
                      await _syncNavigationState();
                    },
                    onProgressChanged: (progress) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                    onLoadError: (uri, message) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _failedUri = uri;
                        _errorMessage = message;
                        _progress = 1;
                      });
                    },
                  )
                : _WebViewErrorState(
                    title: l10n.webViewLoadFailedTitle,
                    message: _errorMessage!,
                    failedUrl: _failedUri?.toString(),
                    retryLabel: l10n.webViewRetryAction,
                    onRetry: _reload,
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _canGoBack ? _goBack : null,
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.webViewBackAction),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _canGoForward ? _goForward : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(l10n.webViewForwardAction),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goBack() async {
    await _controller?.goBack();
    await _syncNavigationState();
  }

  Future<void> _goForward() async {
    await _controller?.goForward();
    await _syncNavigationState();
  }

  Future<void> _reload() async {
    setState(() {
      _errorMessage = null;
      _failedUri = null;
      _progress = 0.1;
    });
    await _controller?.reload();
    await _syncNavigationState();
  }

  Future<void> _syncNavigationState() async {
    final controller = _controller;
    if (controller == null || !mounted) {
      return;
    }
    final canGoBack = await controller.canGoBack();
    final canGoForward = await controller.canGoForward();
    if (!mounted) {
      return;
    }
    setState(() {
      _canGoBack = canGoBack;
      _canGoForward = canGoForward;
    });
  }
}

class _WebViewErrorState extends StatelessWidget {
  const _WebViewErrorState({
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.failedUrl,
  });

  final String title;
  final String message;
  final String retryLabel;
  final String? failedUrl;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              failedUrl == null ? message : '$message\n$failedUrl',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}
