import 'package:flutter/material.dart';

class HermesNavigationBar extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onReload;
  final VoidCallback onChangeUrl;

  const HermesNavigationBar({
    super.key,
    required this.onLogout,
    required this.onReload,
    required this.onChangeUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: const Color(0xFF141425),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 18),
            onPressed: onReload,
            tooltip: 'Reload (⌘R)',
            padding: const EdgeInsets.symmetric(horizontal: 10),
            constraints: const BoxConstraints(),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 18, color: Colors.white54),
            onPressed: onChangeUrl,
            tooltip: 'Changer l\'URL',
            padding: const EdgeInsets.symmetric(horizontal: 6),
            constraints: const BoxConstraints(),
          ),
          const Spacer(),
          Text(
            'Hermes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: onLogout,
            icon: const Text(
              'Déconnexion',
              style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
            ),
            label: const Icon(Icons.logout, size: 16, color: Color(0xFFFF6B6B)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
