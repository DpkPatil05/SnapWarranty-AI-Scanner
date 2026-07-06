import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:snap_warranty/l10n/app_localizations.dart';

import '../../state/locale_provider.dart';
import '../../state/warranty_provider.dart';
import '../../widgets/glass/glass_container.dart';
import '../../widgets/glass/glass_snackbar.dart';
import '../../widgets/glass/liquid_glass_background.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
          l10n.vaultSettings,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          const LiquidGlassBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildSyncCard(l10n),
                const SizedBox(height: 24),
                _buildRestoreCard(l10n),
                const SizedBox(height: 24),
                _buildLanguageCard(l10n),
                const SizedBox(height: 24),
                _buildNotificationCard(l10n),
                const SizedBox(height: 24),
                _buildRateAppCard(l10n),
                const SizedBox(height: 24),
                _buildInfoCard(l10n),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    l10n.version(_version),
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

  Widget _buildSyncCard(AppLocalizations l10n) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_upload,
                color: Colors.blueAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.cloudBackup,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.backupDescription,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isBackingUp ? null : () => _handleSync(l10n),
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
              label: Text(_isBackingUp ? l10n.backingUp : l10n.backupToDrive),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestoreCard(AppLocalizations l10n) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.cloud_download,
                color: Colors.greenAccent,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.restoreVault,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.restoreDescription,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isRestoring ? null : () => _handleRestore(l10n),
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
              label: Text(
                _isRestoring ? l10n.restoring : l10n.restoreFromDrive,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(AppLocalizations l10n) {
    final currentLocale = ref.watch(localeStateProvider);
    String currentLanguageName = l10n.systemDefault;
    if (currentLocale?.languageCode == 'en') currentLanguageName = l10n.english;
    if (currentLocale?.languageCode == 'hi') currentLanguageName = l10n.hindi;
    if (currentLocale?.languageCode == 'mr') currentLanguageName = l10n.marathi;

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, color: Colors.cyanAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.language,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLanguageDialog(context, l10n),
              icon: const Icon(Icons.translate, size: 18),
              label: Text(currentLanguageName),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations l10n) {
    final currentLocale = ref.watch(localeStateProvider);
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: GlassContainer(
            borderRadius: 32,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.language,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10),
                _buildLanguageDialogOption(
                  context,
                  l10n.systemDefault,
                  null,
                  currentLocale == null,
                ),
                _buildLanguageDialogOption(
                  context,
                  l10n.english,
                  'en',
                  currentLocale?.languageCode == 'en',
                ),
                _buildLanguageDialogOption(
                  context,
                  l10n.hindi,
                  'hi',
                  currentLocale?.languageCode == 'hi',
                ),
                _buildLanguageDialogOption(
                  context,
                  l10n.marathi,
                  'mr',
                  currentLocale?.languageCode == 'mr',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDialogOption(
    BuildContext context,
    String label,
    String? code,
    bool isSelected,
  ) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: () {
          ref.read(localeStateProvider.notifier).setLocale(code);
          Navigator.pop(context);
        },
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.cyanAccent, size: 20)
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildNotificationCard(AppLocalizations l10n) {
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
              Text('Reminders'),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.remindersDescription,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () =>
                  ref.read(notificationServiceProvider).requestPermissions(),
              icon: const Icon(Icons.settings, size: 18, color: Colors.white70),
              label: Text(
                l10n.managePermissions,
                style: const TextStyle(color: Colors.white),
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

  Widget _buildRateAppCard(AppLocalizations l10n) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.star_rate, color: Colors.yellowAccent, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.supportUs,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.supportDescription,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final reviewService = ref.read(reviewServiceProvider);
                GlassSnackBar.show(
                  context,
                  message: 'Opening Store Review...',
                  icon: Icons.rate_review,
                );
                await reviewService.requestReview();
              },
              icon: const Icon(Icons.rate_review, size: 18),
              label: Text(l10n.rateAndReview),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n) {
    return GlassContainer(
      child: Column(
        children: [
          _buildInfoRow(
            Icons.security,
            l10n.privateSecure,
            l10n.privateSecureDesc,
          ),
          const Divider(color: Colors.white10, height: 32),
          _buildInfoRow(
            Icons.sync_lock,
            l10n.encryptedSync,
            l10n.encryptedSyncDesc,
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

  Future<void> _handleSync(AppLocalizations l10n) async {
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
          message: l10n.backupComplete,
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
        );
      }
    } catch (e) {
      developer.log('Error during backup', error: e, name: 'SettingsPage');
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: l10n.error(e.toString()),
          icon: Icons.error_outline,
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isBackingUp = false);
    }
  }

  Future<void> _handleRestore(AppLocalizations l10n) async {
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
          message: l10n.restoreComplete,
          icon: Icons.check_circle,
          iconColor: Colors.greenAccent,
        );
      }
    } catch (e) {
      if (mounted) {
        GlassSnackBar.show(
          context,
          message: l10n.error(e.toString()),
          icon: Icons.error_outline,
          isError: true,
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }
}
