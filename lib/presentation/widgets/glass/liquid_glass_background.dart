import 'package:flutter/material.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class LiquidGlassBackground extends StatelessWidget {
  const LiquidGlassBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedMeshGradient(
        colors: const [
          Color(0xFF1E1B4B), // Deepest Navy/Blue
          Color(0xFF312E81), // Dark Indigo
          Color(0xFF4338CA), // Royal Blue
          Color(0xFF581C87), // Deep Purple
        ],
        options: AnimatedMeshGradientOptions(
          speed: 0.8, // Slightly slower for a more premium/calm feel
          amplitude: 40,
          frequency: 3,
        ),
      ),
    );
  }
}
