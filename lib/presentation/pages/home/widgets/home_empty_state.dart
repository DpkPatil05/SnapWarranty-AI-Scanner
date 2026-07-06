import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snap_warranty/l10n/app_localizations.dart';
import '../../../state/warranty_provider.dart';
import '../../../widgets/glass/glass_container.dart';

class HomeEmptyState extends ConsumerWidget {
  const HomeEmptyState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final isSearching = query.isNotEmpty;
    final l10n = AppLocalizations.of(context)!;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSearching ? Icons.search_off : Icons.receipt_long,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isSearching ? 'No results found' : l10n.noWarranties,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSearching
                        ? 'Try a different search term'
                        : l10n.scanFirst,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
