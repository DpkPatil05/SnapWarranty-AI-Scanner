import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    Color? iconColor,
    bool isError = false,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.hideCurrentSnackBar();
    
    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.all(24),
        content: GlassContainer(
          borderRadius: 16,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          border: Border.all(
            color: isError 
                ? Colors.redAccent.withValues(alpha: 0.4) 
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          child: Row(
            children: [
              Icon(
                icon, 
                color: iconColor ?? (isError ? Colors.redAccent : Colors.white70), 
                size: 20
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
