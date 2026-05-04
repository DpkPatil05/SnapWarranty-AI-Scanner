import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../state/warranty_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // Helper method to open the camera or gallery
  Future<void> _pickImage(WidgetRef ref, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      // Send the image to the AI!
      ref
          .read(warrantyListProvider.notifier)
          .scanAndAddWarranty(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warrantyState = ref.watch(warrantyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapWarranty Vault',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: warrantyState.when(
        // 1. Loading State (Shows while AI is thinking)
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("AI is reading your receipt..."),
            ],
          ),
        ),
        // 2. Error State
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Oops: $error', textAlign: TextAlign.center),
          ),
        ),
        // 3. Data State (The List)
        data: (warranties) {
          if (warranties.isEmpty) {
            return const Center(
              child: Text('No warranties saved yet. Snap a receipt!'),
            );
          }
          return ListView.builder(
            itemCount: warranties.length,
            itemBuilder: (context, index) {
              final item = warranties[index];
              final isExpired = item.isExpired;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    item.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Purchased: ${item.purchaseDate.toLocal().toString().split(' ')[0]}\n'
                    'Expires: ${item.expirationDate.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: Icon(
                    isExpired ? Icons.warning : Icons.check_circle,
                    color: isExpired ? Colors.red : Colors.green,
                  ),
                  // Long press to delete
                  onLongPress: () {
                    ref
                        .read(warrantyListProvider.notifier)
                        .deleteWarranty(item.id);
                  },
                ),
              );
            },
          );
        },
      ),
      // The floating action button triggers the camera modal
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ref, ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Upload from Gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ref, ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        icon: const Icon(Icons.document_scanner),
        label: const Text('Scan Receipt'),
      ),
    );
  }
}
