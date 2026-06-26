import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/warranty_provider.dart';
import '../../../widgets/glass/glass_container.dart';

class HomeSearchBar extends ConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      borderRadius: 16,
      child: TextField(
        onChanged: (value) =>
            ref.read(searchQueryProvider.notifier).update(value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search receipts...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Colors.white70),
        ),
      ),
    );
  }
}
