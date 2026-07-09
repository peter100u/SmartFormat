class MovaWebViewConfig {
  const MovaWebViewConfig({
    required this.initialUri,
    this.showLoadingBar = true,
    this.allowExternalScheme = true,
    this.javaScriptEnabled = false,
    this.supportMultipleWindows = false,
    this.allowedHosts = const <String>{},
  });

  factory MovaWebViewConfig.legalDocument({required Uri initialUri}) {
    return MovaWebViewConfig(
      initialUri: initialUri,
      showLoadingBar: true,
      allowExternalScheme: true,
      javaScriptEnabled: false,
      supportMultipleWindows: false,
      allowedHosts: {initialUri.host},
    );
  }

  final Uri initialUri;
  final bool showLoadingBar;
  final bool allowExternalScheme;
  final bool javaScriptEnabled;
  final bool supportMultipleWindows;
  final Set<String> allowedHosts;
}
