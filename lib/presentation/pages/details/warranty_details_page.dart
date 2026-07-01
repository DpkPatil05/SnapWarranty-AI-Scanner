import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../domain/entities/warranty_item.dart';
import '../../../domain/services/ad_service_interface.dart';
import '../../state/warranty_provider.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/glass/glass_detail_row.dart';
import '../../widgets/glass/glass_snackbar.dart';
import '../../widgets/glass/liquid_glass_background.dart';
import 'full_document_viewer.dart';

class WarrantyDetailsPage extends ConsumerStatefulWidget {
  final WarrantyItem item;

  const WarrantyDetailsPage({super.key, required this.item});

  @override
  ConsumerState<WarrantyDetailsPage> createState() =>
      _WarrantyDetailsPageState();
}

class _WarrantyDetailsPageState extends ConsumerState<WarrantyDetailsPage> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adService = ref.read(adServiceProvider);
      final analytics = ref.read(analyticsServiceProvider);

      _loadBannerAd(adService);
      adService.loadInterstitialAd();
      adService.incrementViewCounter();
      analytics.logWarrantyViewed(widget.item.id, widget.item.productName);
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd(IAdService adService) {
    _bannerAd = adService.createBannerAd(
      logLabel: 'Details',
      onAdLoaded: (_) {
        if (mounted) setState(() => _isBannerAdLoaded = true);
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        if (mounted) setState(() => _isBannerAdLoaded = false);
      },
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final warrantiesAsync = ref.watch(warrantyListProvider);

    final currentItem =
        warrantiesAsync.maybeWhen(
          data: (list) => list.firstWhereOrNull((i) => i.id == widget.item.id),
          orElse: () => null,
        ) ??
        widget.item;

    final isPdf =
        currentItem.receiptImagePath?.toLowerCase().endsWith('.pdf') ?? false;

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
          if (currentItem.receiptImagePath != null)
            IconButton(
              icon: const Icon(Icons.download, color: Colors.white),
              onPressed: () => _downloadReceipt(context, currentItem),
              tooltip: isPdf ? 'Download PDF' : 'Save to Gallery',
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
          const LiquidGlassBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (currentItem.receiptImagePath != null)
                    GestureDetector(
                      onTap: () {
                        ref.read(adServiceProvider).showInterstitialAd();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullDocumentViewer(
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
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                              child: Stack(
                                children: [
                                  // Positioned MUST be the direct child of the Stack
                                  Positioned.fill(
                                    child: AbsorbPointer(
                                      child: isPdf
                                          ? SfPdfViewer.file(
                                              File(
                                                currentItem.receiptImagePath!,
                                              ),
                                              canShowScrollHead: false,
                                              enableDoubleTapZooming: false,
                                              enableTextSelection: false,
                                            )
                                          : Image.file(
                                              File(
                                                currentItem.receiptImagePath!,
                                              ),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.broken_image,
                                                        color: Colors.white,
                                                        size: 48,
                                                      ),
                                                    );
                                                  },
                                            ),
                                    ),
                                  ),
                                  // Preview Overlay Icon
                                  Positioned(
                                    right: 16,
                                    bottom: 16,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white24,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                        GlassDetailRow(
                          icon: Icons.inventory_2,
                          label: 'Product',
                          value: currentItem.productName,
                        ),
                        const Divider(color: Colors.white24, height: 32),
                        GlassDetailRow(
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
                            child: GlassDetailRow(
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
                          GlassDetailRow(
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
                  if (currentItem.receiptImagePath != null)
                    GlassContainer(
                      padding: EdgeInsets.zero,
                      child: Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            ref.read(adServiceProvider).showInterstitialAd();
                            _downloadReceipt(context, currentItem);
                          },
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
                            child: Icon(
                              isPdf ? Icons.picture_as_pdf : Icons.save_alt,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            isPdf ? 'Open Document' : 'Export Receipt',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            isPdf
                                ? 'View the full high-quality document'
                                : 'Save the original image to your gallery',
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
      bottomNavigationBar: _isBannerAdLoaded
          ? SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
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
        GlassSnackBar.show(
          context,
          message: 'Warranty deleted',
          icon: Icons.delete_forever,
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
                      'Duration not found in document',
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
    final DateTime firstDate = item.purchaseDate;
    final DateTime lastDate = firstDate.add(const Duration(days: 365 * 20));
    final DateTime initialDate = item.purchaseDate.isAfter(now)
        ? item.purchaseDate.add(const Duration(days: 365))
        : now.add(const Duration(days: 365));

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
              secondary: Color(0xFFA855F7),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF1E1B4B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Colors.white10),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
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

      if (context.mounted) {
        GlassSnackBar.show(
          context,
          message: 'Expiration updated!',
          icon: Icons.calendar_today,
          iconColor: Colors.greenAccent,
        );
      }
    }
  }

  Future<void> _downloadReceipt(BuildContext context, WarrantyItem item) async {
    if (item.receiptImagePath == null) return;
    final isPdf = item.receiptImagePath!.toLowerCase().endsWith('.pdf');
    final analytics = ref.read(analyticsServiceProvider);

    try {
      if (!isPdf) {
        final hasAccess = await Gal.hasAccess();
        if (!hasAccess) {
          await Gal.requestAccess();
        }
        await Gal.putImage(item.receiptImagePath!);
        await analytics.logImageExported(item.id, item.productName);
        if (context.mounted) {
          GlassSnackBar.show(
            context,
            message: 'Receipt saved to gallery!',
            icon: Icons.check_circle,
            iconColor: Colors.greenAccent,
          );
        }
      } else {
        await analytics.logImageExported(item.id, item.productName);
        if (context.mounted) {
          GlassSnackBar.show(
            context,
            message: 'PDF document is ready in your vault',
            icon: Icons.picture_as_pdf,
            iconColor: Colors.blueAccent,
          );
        }
      }
    } catch (e) {
      await analytics.logError(e.toString(), 'downloadReceipt');
      if (context.mounted) {
        GlassSnackBar.show(
          context,
          message: 'Failed to save: $e',
          icon: Icons.error_outline,
          isError: true,
        );
      }
    }
  }
}
