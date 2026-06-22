import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../widgets/glass/liquid_glass_background.dart';

class FullDocumentViewer extends StatelessWidget {
  final String path;
  final String title;

  const FullDocumentViewer({
    super.key,
    required this.path,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = path.toLowerCase().endsWith('.pdf');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: Stack(
        children: [
          const LiquidGlassBackground(),
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: isPdf
                    ? SfPdfViewer.file(
                        File(path),
                        canShowScrollHead: true,
                        canShowPaginationDialog: true,
                      )
                    : Image.file(File(path), fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
