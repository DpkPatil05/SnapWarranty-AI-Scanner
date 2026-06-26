import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

import '../../state/warranty_provider.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/glass/glass_snackbar.dart';
import '../../widgets/glass/liquid_glass_background.dart';
import '../details/warranty_details_page.dart';
import '../settings/settings_page.dart';

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
            message: 'Error: $error',
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
                _buildAppBar(context),
                warrantiesAsync.when(
                  data: (warranties) {
                    if (warranties.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildWarrantyList(context, warranties);
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                  error: (e, _) =>
                      (warrantiesAsync.hasValue &&
                          warrantiesAsync.value!.isNotEmpty)
                      ? _buildWarrantyList(context, warrantiesAsync.value!)
                      : _buildEmptyState(),
                ),
              ],
            ),
          ),

          // Decoupled Global Scan Loader Overlay
          if (isScanning)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: GlassContainer(
                    blur: 20,
                    opacity: 0.2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 24),
                        const Text(
                          'Analyzing Document',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'AI is reading your data...',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SnapWarranty',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'Your digital warranty vault',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
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

  Widget _buildEmptyState() {
    final query = ref.watch(searchQueryProvider);
    final isSearching = query.isNotEmpty;

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
                    isSearching ? 'No results found' : 'No warranties yet',
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
                        : 'Add a receipt or PDF to get started',
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

  Widget _buildWarrantyList(BuildContext context, List<dynamic> warranties) {
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
                  message: '${item.productName} deleted',
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
                          tag: 'receipt_${item.id}',
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
                                'Expires: ${item.expirationDate.toString().split(' ')[0]}',
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
      builder: (context) => GlassContainer(
        borderRadius: 32,
        padding: const EdgeInsets.all(24),
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

    // Reverted back to the standard pickFiles() method
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
