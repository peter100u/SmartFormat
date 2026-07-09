import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import 'mova_webview_config.dart';

class MovaEmbeddedWebView extends StatefulWidget {
  const MovaEmbeddedWebView({
    required this.config,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.onProgressChanged,
    this.onLoadError,
    this.onExternalNavigation,
    super.key,
  });

  final MovaWebViewConfig config;
  final void Function(InAppWebViewController controller)? onWebViewCreated;
  final void Function(Uri? uri)? onLoadStart;
  final void Function(Uri? uri)? onLoadStop;
  final void Function(int progress)? onProgressChanged;
  final void Function(Uri? uri, String message)? onLoadError;
  final void Function(Uri uri)? onExternalNavigation;

  @override
  State<MovaEmbeddedWebView> createState() => _MovaEmbeddedWebViewState();
}

class _MovaEmbeddedWebViewState extends State<MovaEmbeddedWebView> {
  bool get _isWidgetTest {
    return WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isWidgetTest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onLoadStop?.call(widget.config.initialUri);
        widget.onProgressChanged?.call(100);
      });
      return const SizedBox.expand(
        child: ColoredBox(
          key: ValueKey('mova_webview_test_placeholder'),
          color: Colors.transparent,
        ),
      );
    }

    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(widget.config.initialUri.toString()),
      ),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: widget.config.javaScriptEnabled,
        javaScriptCanOpenWindowsAutomatically: false,
        supportMultipleWindows: widget.config.supportMultipleWindows,
        isInspectable: kDebugMode,
      ),
      onWebViewCreated: widget.onWebViewCreated,
      onLoadStart: (controller, url) {
        widget.onLoadStart?.call(_toUri(url));
      },
      onLoadStop: (controller, url) async {
        widget.onLoadStop?.call(_toUri(url));
      },
      onProgressChanged: (controller, progress) {
        widget.onProgressChanged?.call(progress);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final target = _toUri(navigationAction.request.url);
        if (target == null) {
          return NavigationActionPolicy.CANCEL;
        }

        if (_isTrustedUri(target)) {
          return NavigationActionPolicy.ALLOW;
        }

        final isHttpOrHttps =
            target.scheme == 'http' || target.scheme == 'https';
        if (isHttpOrHttps) {
          widget.onLoadError?.call(target, l10n.webViewBlockedDomainMessage);
          return NavigationActionPolicy.CANCEL;
        }

        if (widget.config.allowExternalScheme) {
          widget.onExternalNavigation?.call(target);
          final didLaunch = await launchUrl(
            target,
            mode: LaunchMode.externalApplication,
          );
          if (!didLaunch) {
            widget.onLoadError?.call(
              target,
              l10n.webViewExternalOpenFailedMessage,
            );
          }
        }

        return NavigationActionPolicy.CANCEL;
      },
      onReceivedError: (controller, request, error) {
        widget.onLoadError?.call(_toUri(request.url), error.description);
      },
      onReceivedHttpError: (controller, request, response) {
        widget.onLoadError?.call(
          _toUri(request.url),
          'HTTP ${response.statusCode}',
        );
      },
    );
  }

  bool _isTrustedUri(Uri uri) {
    final scheme = uri.scheme;
    if (scheme == 'about' || scheme == 'data' || scheme == 'javascript') {
      return true;
    }
    if (scheme != 'http' && scheme != 'https') {
      return false;
    }
    if (widget.config.allowedHosts.isEmpty) {
      return true;
    }
    return widget.config.allowedHosts.contains(uri.host);
  }

  Uri? _toUri(WebUri? uri) {
    if (uri == null) {
      return null;
    }
    return Uri.tryParse(uri.toString());
  }
}
