import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/loading_indicator.dart';
import '../services/window_preferences.dart';
import 'setup_screen.dart';

bool get _isDesktop =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.windows;

class HomeScreen extends StatefulWidget {
  final String webUrl;

  const HomeScreen({super.key, required this.webUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WindowListener {
  late final WebViewController _controller;
  late final String _targetHost;
  bool _isLoading = true;
  double _loadingProgress = 0;

  @override
  void initState() {
    super.initState();
    _targetHost = Uri.parse(widget.webUrl).host;
    if (_isDesktop) windowManager.addListener(this);
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent('HermesApp/1.0 Flutter')
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() {
          _isLoading = true;
          _loadingProgress = 0;
        }),
        onProgress: (progress) => setState(() {
          _loadingProgress = progress / 100.0;
        }),
        onPageFinished: (_) => setState(() {
          _isLoading = false;
          _loadingProgress = 1.0;
        }),
        onNavigationRequest: (request) async {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.navigate;
          if (!uri.hasScheme ||
              uri.scheme == 'about' ||
              uri.scheme == 'blob' ||
              uri.scheme == 'data') {
            return NavigationDecision.navigate;
          }
          if (uri.scheme != 'http' && uri.scheme != 'https') {
            return NavigationDecision.prevent;
          }
          if (uri.host == _targetHost || uri.host.endsWith('.$_targetHost')) {
            return NavigationDecision.navigate;
          }
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return NavigationDecision.prevent;
        },
      ))
      ..loadRequest(Uri.parse(widget.webUrl));
  }

  @override
  void onWindowClose() async {
    await WindowPreferences.save();
    await windowManager.destroy();
  }

  @override
  void dispose() {
    if (_isDesktop) windowManager.removeListener(this);
    super.dispose();
  }

  void _reload() => _controller.reload();

  Future<void> _logout() async {
    await WebViewCookieManager().clearCookies();
    await _controller.clearCache();
    await _controller.clearLocalStorage();
    await _controller.loadRequest(Uri.parse(widget.webUrl));
  }

  Future<void> _changeUrl() async {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SetupScreen(canGoBack: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyR):
            const ReloadIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyR):
            const ReloadIntent(),
      },
      child: Actions(
        actions: {
          ReloadIntent: CallbackAction<ReloadIntent>(
            onInvoke: (_) => _reload(),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            body: SafeArea(
              child: Column(
              children: [
                HermesNavigationBar(
                  onLogout: _logout,
                  onReload: _reload,
                  onChangeUrl: _changeUrl,
                ),
                if (_isLoading)
                  LoadingIndicator(progress: _loadingProgress),
                Expanded(
                  child: WebViewWidget(controller: _controller),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReloadIntent extends Intent {
  const ReloadIntent();
}
