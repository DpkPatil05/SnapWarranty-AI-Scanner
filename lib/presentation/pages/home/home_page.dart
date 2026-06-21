import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesh_gradient/mesh_gradient.dart';
import '../../state/warranty_provider.dart';
import '../../widgets/glass/glass_container.dart';
import '../details/warranty_details_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warrantiesAsync = ref.watch(warrantyListProvider);

    // Listen for errors to show SnackBar
    ref.listen(warrantyListProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: Colors.redAccent.withValues(alpha: 0.8),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          // 1. Liquid Mesh Background
          Positioned.fill(
            child: AnimatedMeshGradient(
              colors: const [
                Color(0xFF6366F1), // Indigo
                Color(0xFFA855F7), // Purple
                Color(0xFFEC4899), // Pink
                Color(0xFF3B82F6), // Blue
              ],
              options: AnimatedMeshGradientOptions(
                speed: 1.0,
                amplitude: 30,
                frequency: 5,
              ),
            ),
          ),

          // 2. Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                warrantiesAsync.when(
                  data: (warranties) =>
                  warranties.isEmpty
                      ? _buildEmptyState()
                      : _buildWarrantyList(context, ref, warranties),
                  loading: () =>
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                  error: (e, _) =>
                  (warrantiesAsync.hasValue &&
                      warrantiesAsync.value!.isNotEmpty)
                      ? _buildWarrantyList(context, ref, warrantiesAsync.value!)
                      : _buildEmptyState(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context, ref),
    );
  }

  Widget _buildAppBar() {
    return SliverPadding(
      padding: const EdgeInsets.all(24.0),
      sliver: SliverToBoxAdapter(
        child: Column(
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
      ),
    );
  }

  Widget _buildEmptyState() {
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
                    Icons.receipt_long,
                    size: 48,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No warranties yet',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Snap a receipt to get started',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarrantyList(BuildContext context, WidgetRef ref,
      List<dynamic> warranties) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final item = warranties[index];
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.productName} deleted'),
                    behavior: SnackBarBehavior.floating,
                  ),
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
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: FileImage(File(item.receiptImagePath!)),
                                fit: BoxFit.cover,
                              ),
                            ),
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
                          child:
                          const Icon(Icons.inventory_2, color: Colors.white),
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
                                'Expires: ${item.expirationDate
                                    .toString()
                                    .split(' ')[0]}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                              )
                            else
                              Text(
                                'Expiry not set',
                                style: TextStyle(
                                  color: Colors.orangeAccent.withValues(
                                      alpha: 0.8),
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

  Widget _buildFloatingActionButton(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showImageSourceSheet(context, ref),
      backgroundColor: Colors.white.withValues(alpha: 0.2),
      elevation: 0,
      label: const Text('Scan Receipt', style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.add_a_photo, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
    );
  }

  void _showImageSourceSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          GlassContainer(
            borderRadius: 32,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Image Source',
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
                      onTap: () => _pickImage(ref, ImageSource.camera, context),
                    ),
                    _buildSourceOption(
                      context: context,
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () =>
                          _pickImage(ref, ImageSource.gallery, context),
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

  Future<void> _pickImage(WidgetRef ref,
      ImageSource source,
      BuildContext context,) async {
    Navigator.pop(context); // Close bottom sheet
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      ref
          .read(warrantyListProvider.notifier)
          .scanAndAddWarranty(File(image.path));
    }
  }
}
