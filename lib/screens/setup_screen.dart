import 'package:flutter/material.dart';
import '../services/app_preferences.dart';
import 'home_screen.dart';

class SetupScreen extends StatefulWidget {
  final bool canGoBack;

  const SetupScreen({super.key, this.canGoBack = false});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  String? _error;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _focus.requestFocus();
      if (widget.canGoBack) {
        final saved = await AppPreferences.getUrl();
        if (saved != null && mounted) {
          _controller.text = saved;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  String? _validate(String raw) {
    final url = raw.trim();
    if (url.isEmpty) return 'Entrez une URL';
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return 'URL invalide (ex: https://hermes.exemple.com)';
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return 'L\'URL doit commencer par http:// ou https://';
    }
    return null;
  }

  Future<void> _connect() async {
    final url = _controller.text.trim();
    final error = _validate(url);
    if (error != null) {
      setState(() => _error = error);
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final normalized = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    await AppPreferences.saveUrl(normalized);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => HomeScreen(webUrl: normalized)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141425),
      body: SafeArea(child: Stack(
        children: [
          if (widget.canGoBack)
            Positioned(
              top: 12,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white54),
                tooltip: 'Retour',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          Center(
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + titre
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5817EB), Color(0xFF4A9EFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bolt, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Hermes',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              Text(
                'URL du WebUI',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                focusNode: _focus,
                onSubmitted: (_) => _connect(),
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'https://hermes.exemple.com',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                  errorText: _error,
                  filled: true,
                  fillColor: const Color(0xFF1E1E35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF5817EB), width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: _loading ? null : _connect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5817EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Se connecter',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
          ),
        ],
      )),
    );
  }
}
