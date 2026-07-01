import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/services/update_manager.dart';
import '../../state/warranty_provider.dart';
import '../../widgets/glass/glass_snackbar.dart';
import '../../widgets/glass/liquid_glass_background.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_empty_state.dart';
import 'widgets/warranty_list_view.dart';
import 'widgets/scanning_overlay.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateManager.evaluateAndPromptUpdate();
      _initBannerAd();
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _initBannerAd() {
    final adService = ref.read(adServiceProvider);
    _bannerAd = adService.createBannerAd(
      logLabel: 'Home',
      onAdLoaded: (_) {
        if (mounted) setState(() => _isBannerAdLoaded = true);
      },
      onAdFailedToLoad: (ad, _) {
        ad.dispose();
        if (mounted) setState(() => _isBannerAdLoaded = false);
      },
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final warrantiesAsync = ref.watch(filteredWarrantiesProvider);
    final isScanning = ref.watch(documentScanningProvider);

    // Listen for scanning errors to show SnackBar
    ref.listen(warrantyListProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          GlassSnackBar.show(
            context,
            message: 'Error: \$error',
            icon: Icons.error_outline,
            isError: true,
          );
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          const LiquidGlassBackground(),

          // Content Layer
          SafeArea(
            child: CustomScrollView(
              slivers: [
                const HomeAppBar(),
                warrantiesAsync.when(
                  data: (warranties) {
                    if (warranties.isEmpty) {
                      return const HomeEmptyState();
                    }
                    return WarrantyListView(warranties: warranties);
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                  error: (e, _) =>
                      (warrantiesAsync.hasValue &&
                          warrantiesAsync.value!.isNotEmpty)
                      ? WarrantyListView(warranties: warrantiesAsync.value!)
                      : const HomeEmptyState(),
                ),
              ],
            ),
          ),

          // Decoupled Global Scan Loader Overlay
          if (isScanning) const ScanningOverlay(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      bottomNavigationBar: _isBannerAdLoaded
          ? SafeArea(
              child: SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : null,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showImageSourceSheet(context),
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      elevation: 0,
      label: const Text('Add Document', style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.add, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1B4B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Source',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () => _pickImage(ImageSource.camera, context),
                ),
                _buildSourceOption(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () => _pickImage(ImageSource.gallery, context),
                ),
                _buildSourceOption(
                  context: context,
                  icon: Icons.picture_as_pdf,
                  label: 'PDF',
                  onTap: () => _pickPdf(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    Navigator.pop(context);
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      final adService = ref.read(adServiceProvider);
      final analytics = ref.read(analyticsServiceProvider);
      try {
        await analytics.logScanStarted(source.name);
        ref.read(documentScanningProvider.notifier).setScanning(true);
        await ref
            .read(warrantyListProvider.notifier)
            .scanAndAddWarranty(File(image.path));
        // Increment ad counter after successful addition
        await adService.incrementAdditionCounter();
        await analytics.logScanCompleted('Unknown (Scanned)', true);
      } catch (e) {
        await analytics.logScanCompleted('Unknown (Failed)', false);
        rethrow;
      } finally {
        ref.read(documentScanningProvider.notifier).setScanning(false);
      }
    }
  }

  Future<void> _pickPdf(BuildContext context) async {
    Navigator.pop(context);

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final adService = ref.read(adServiceProvider);
      final analytics = ref.read(analyticsServiceProvider);
      try {
        await analytics.logScanStarted('pdf');
        ref.read(documentScanningProvider.notifier).setScanning(true);
        await ref
            .read(warrantyListProvider.notifier)
            .scanAndAddWarranty(File(result.files.single.path!));
        // Increment ad counter after successful addition
        await adService.incrementAdditionCounter();
        await analytics.logScanCompleted('Unknown (PDF)', true);
      } catch (e) {
        await analytics.logScanCompleted('Unknown (PDF Failed)', false);
        rethrow;
      } finally {
        ref.read(documentScanningProvider.notifier).setScanning(false);
      }
    }
  }
}
