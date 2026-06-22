import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import 'package:gal/gal.dart';
import 'package:collection/collection.dart';
import '../../../domain/entities/warranty_item.dart';
import '../../state/warranty_provider.dart';
import '../../widgets/glass/glass_container.dart';
import 'full_document_viewer.dart';

class WarrantyDetailsPage extends ConsumerWidget {
  final WarrantyItem item;

  const WarrantyDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch for updates to this specific item
    final warrantiesAsync = ref.watch(warrantyListProvider);

    // Safely look up the current item in the state
    // If it's deleted, we'll use the passed 'item' as a fallback to avoid the "No element" error
    final currentItem =
        warrantiesAsync.maybeWhen(
          data: (list) => list.firstWhereOrNull((i) => i.id == item.id),
          orElse: () => null,
        ) ??
        item;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          currentItem.productName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (currentItem.receiptImagePath != null &&
              !currentItem.receiptImagePath!.toLowerCase().endsWith('.pdf'))
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () => _downloadReceipt(context, currentItem),
              tooltip: 'Save to Gallery',
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _confirmDelete(context, ref, currentItem),
            tooltip: 'Delete Warranty',
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedMeshGradient(
              colors: const [
                Color(0xFF6366F1),
                Color(0xFFA855F7),
                Color(0xFFEC4899),
                Color(0xFF3B82F6),
              ],
              options: AnimatedMeshGradientOptions(
                speed: 1.0,
                amplitude: 30,
                frequency: 5,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (currentItem.receiptImagePath != null)
                    GestureDetector(
                      onTap: () {
                        // Routing to your custom FullDocumentViewer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FullDocumentViewer(
                              path: currentItem.receiptImagePath!,
                              title: currentItem.productName,
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: 'receipt_${currentItem.id}',
                        child: GlassContainer(
                          padding: EdgeInsets.zero,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child:
                                currentItem.receiptImagePath!
                                    .toLowerCase()
                                    .endsWith('.pdf')
                                ? Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                    width: double.infinity,
                                    color: Colors.white.withValues(alpha: 0.1),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.redAccent,
                                          size: 64,
                                        ),
                                        SizedBox(height: 16),
                                        Text(
                                          'Tap to view PDF document',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Image.file(
                                    File(currentItem.receiptImagePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.4,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.white,
                                            size: 48,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          icon: Icons.inventory_2,
                          label: 'Product',
                          value: currentItem.productName,
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          label: 'Purchase Date',
                          value: currentItem.purchaseDate.toString().split(
                            ' ',
                          )[0],
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        if (currentItem.warrantyDurationMonths != null) ...[
                          InkWell(
                            onTap: () =>
                                _selectExpiryDate(context, ref, currentItem),
                            borderRadius: BorderRadius.circular(12),
                            child: _buildDetailRow(
                              icon: Icons.timer,
                              label: 'Warranty Duration',
                              value:
                                  '${currentItem.warrantyDurationMonths} Months',
                              trailing: const Icon(
                                Icons.edit,
                                color: Colors.white54,
                                size: 16,
                              ),
                            ),
                          ),
                          const Divider(color: Colors.white24, height: 32),
                          _buildDetailRow(
                            icon: Icons.event_available,
                            label: 'Expiration Date',
                            value: currentItem.expirationDate.toString().split(
                              ' ',
                            )[0],
                            valueColor: currentItem.isExpired
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                          ),
                        ] else
                          _buildAddExpiryOption(context, ref, currentItem),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (currentItem.receiptImagePath != null &&
                      !currentItem.receiptImagePath!.toLowerCase().endsWith(
                        '.pdf',
                      ))
                    GlassContainer(
                      padding: EdgeInsets.zero,
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () => _downloadReceipt(context, currentItem),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          contentPadding: const EdgeInsets.all(8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.save_alt,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            'Export Receipt',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Save the original image to your gallery',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white54,
                          ),
                        ),
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

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    WarrantyItem item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        title: const Text(
          'Delete Warranty?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove ${item.productName} from your vault?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(warrantyListProvider.notifier).deleteWarranty(item.id);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Warranty deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildAddExpiryOption(
    BuildContext context,
    WidgetRef ref,
    WarrantyItem item,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectExpiryDate(context, ref, item),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Set Expiration Date',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Duration not found in receipt',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_month, color: Colors.white54, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate(
    BuildContext context,
    WidgetRef ref,
    WarrantyItem item,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = item.purchaseDate.isAfter(now)
        ? item.purchaseDate.add(const Duration(days: 365))
        : now.add(const Duration(days: 365));

    final DateTime firstDate = item.purchaseDate;
    final DateTime lastDate = firstDate.add(const Duration(days: 365 * 20));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1B4B),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1B4B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final difference = picked.difference(item.purchaseDate).inDays;
      final months = (difference / 30).round();

      final updatedItem = item.copyWith(warrantyDurationMonths: months);
      await ref.read(warrantyListProvider.notifier).updateWarranty(updatedItem);
    }
  }

  Future<void> _downloadReceipt(BuildContext context, WarrantyItem item) async {
    if (item.receiptImagePath == null) return;

    try {
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }

      await Gal.putImage(item.receiptImagePath!);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✅ Receipt saved to gallery!'),
            backgroundColor: Colors.greenAccent.withValues(alpha: 0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to save: $e'),
            backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    Widget? trailing,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: valueColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing],
      ],
    );
  }
}
