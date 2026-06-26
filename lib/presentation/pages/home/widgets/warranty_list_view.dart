import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/warranty_item.dart';
import '../../../state/warranty_provider.dart';
import '../../../widgets/glass/glass_container.dart';
import '../../../widgets/glass/glass_snackbar.dart';
import '../../details/warranty_details_page.dart';

class WarrantyListView extends ConsumerWidget {
  final List<WarrantyItem> warranties;

  const WarrantyListView({super.key, required this.warranties});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = warranties[index];
          final isPdf =
              item.receiptImagePath?.toLowerCase().endsWith('.pdf') ?? false;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Dismissible(
              key: Key(item.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.delete_sweep, color: Colors.white),
              ),
              onDismissed: (direction) {
                ref.read(warrantyListProvider.notifier).deleteWarranty(item.id);
                GlassSnackBar.show(
                  context,
                  message: '\${item.productName} deleted',
                  icon: Icons.delete_outline,
                );
              },
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WarrantyDetailsPage(item: item),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(24),
                child: GlassContainer(
                  child: Row(
                    children: [
                      if (item.receiptImagePath != null)
                        Hero(
                          tag: 'receipt_\${item.id}',
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              image: isPdf
                                  ? null
                                  : DecorationImage(
                                      image: FileImage(
                                        File(item.receiptImagePath!),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            child: isPdf
                                ? const Icon(
                                    Icons.picture_as_pdf,
                                    color: Colors.redAccent,
                                  )
                                : null,
                          ),
                        )
                      else
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.inventory_2,
                            color: Colors.white,
                          ),
                        ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (item.expirationDate != null)
                              Text(
                                'Expires: \${item.expirationDate.toString().split('
                                ')[0]}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              )
                            else
                              Text(
                                'Expiry not set',
                                style: TextStyle(
                                  color: Colors.orangeAccent.withValues(
                                    alpha: 0.8,
                                  ),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        item.expirationDate == null
                            ? Icons.help_outline
                            : (item.isExpired ? Icons.warning : Icons.verified),
                        color: item.expirationDate == null
                            ? Colors.white54
                            : (item.isExpired
                                  ? Colors.orangeAccent
                                  : Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }, childCount: warranties.length),
      ),
    );
  }
}
