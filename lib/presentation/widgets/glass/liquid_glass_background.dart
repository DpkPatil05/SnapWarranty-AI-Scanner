import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class LiquidGlassBackground extends StatelessWidget {
  const LiquidGlassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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
    );
  }
}
