import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/glass/glass_snackbar.dart';
import '../../widgets/glass/liquid_glass_background.dart';
import '../../state/warranty_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isBackingUp = false;
  bool _isRestoring = false;
  String _version = '...';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = '${info.version}+${info.buildNumber}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Vault Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          const LiquidGlassBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildSyncCard(),
                const SizedBox(height: 24),
                _buildRestoreCard(),
                const SizedBox(height: 24),
                _buildNotificationCard(),
                const SizedBox(height: 24),
                _buildInfoCard(),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Version $_version',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncCard() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_upload, color: Colors.blueAccent, size: 28),
              SizedBox(width: 12),
              Text(
                'Cloud Backup',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Upload your receipts to Google Drive. This keeps your vault safe if you lose your phone.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isBackingUp ? null : _handleSync,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
              icon: _isBackingUp
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const FaIcon(FontAwesomeIcons.google, size: 18),
              label: Text(_isBackingUp ? 'Backing up...' : 'Backup to Drive'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreCard() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.cloud_download, color: Colors.greenAccent, size: 28),
              SizedBox(width: 12),
              Text(
                'Restore Vault',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Recover your warranties and images from a previous backup on Google Drive.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isRestoring ? null : _handleRestore,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
              icon: _isRestoring
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.settings_backup_restore),
              label: Text(_isRestoring ? 'Restoring...' : 'Restore from Drive'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: Colors.orangeAccent,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'Reminders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Get notified 30 days before and on the day your warranty expires.',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () =>
                  ref.read(notificationServiceProvider).requestPermissions(),
              icon: const Icon(Icons.settings, size: 18, color: Colors.white70),
              label: const Text(
                'Manage Permissions',
                style: TextStyle(color: Colors.white),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return GlassContainer(
      child: Column(
        children: [
          _buildInfoRow(
            Icons.security,
            'Private & Secure',
            'Only you can access your Drive data.',
          ),
          const Divider(color: Colors.white10, height: 32),
          _buildInfoRow(
            Icons.sync_lock,
            'Encrypted Sync',
            'Metadata is handled securely via OAuth2.',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleSync() async {
    setState(() => _isBackingUp = true);
    final analytics = ref.read(analyticsServiceProvider);
    try {
      await analytics.logSyncStarted();
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: 'Starting Google Drive Backup...',
          icon: Icons.sync,
        );
      }

      await ref.read(warrantyListProvider.notifier).syncToDrive();

      await analytics.logSyncCompleted(true);
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: 'Backup complete!',
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
        );
      }
    } catch (e) {
      developer.log('Error during backup', error: e, name: 'SettingsPage');
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: 'Backup failed: $e',
          icon: Icons.error_outline,
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isBackingUp = false);
    }
  }

  Future<void> _handleRestore() async {
    setState(() => _isRestoring = true);
    try {
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: 'Restoring from Google Drive...',
          icon: Icons.cloud_download,
        );
      }

      await ref.read(warrantyListProvider.notifier).restoreFromDrive();

      if (mounted) {
        GlassSnackBar.show(
          context,
          message: 'Restore complete!',
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
        );
      }
    } catch (e) {
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: 'Restore failed: $e',
          icon: Icons.error_outline,
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }
}
