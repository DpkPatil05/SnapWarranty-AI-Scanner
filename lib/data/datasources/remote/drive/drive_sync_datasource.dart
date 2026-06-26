import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/app_constants.dart';
import 'dart:developer' as dev;

class DriveSyncDataSource {
  static const String _folderName = AppConstants.driveFolderName;
  static const String _metadataFileName = AppConstants.metadataFileName;
  static const List<String> _driveScopes = [drive.DriveApi.driveFileScope];

  // ─── Singleton ────────────────────────────────────────────────────────────
  // A single shared instance means _currentUser survives across all callers
  // within the same app session, even if the provider is read multiple times.
  static final DriveSyncDataSource _instance = DriveSyncDataSource._internal();

  static DriveSyncDataSource get instance => _instance;

  factory DriveSyncDataSource() => _instance;

  DriveSyncDataSource._internal();

  // ──────────────────────────────────────────────────────────────────────────

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;
  Future<void>? _initFuture;
  GoogleSignInAccount? _currentUser;

  /// True when we already have a valid signed-in account in memory.
  bool get isSignedIn => _currentUser != null;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (_initFuture != null) return _initFuture;

    _initFuture = _doInitialize();
    return _initFuture;
  }

  Future<void> _doInitialize() async {
    try {
      dev.log('Initializing GoogleSignIn...', name: 'DriveSync');
      await _googleSignIn.initialize(serverClientId: AppConstants.webClientId);
      _initialized = true;

      // Keep _currentUser in sync with platform-level auth events.
      _googleSignIn.authenticationEvents.listen((event) {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          _currentUser = event.user;
          dev.log('Session updated: ${_currentUser?.email}', name: 'DriveSync');
        } else if (event is GoogleSignInAuthenticationEventSignOut) {
          _currentUser = null;
          dev.log('Session cleared (SignOut)', name: 'DriveSync');
        }
      });
    } catch (e) {
      _initFuture = null; // Allow retry
      dev.log('GoogleSignIn initialization failed: $e', name: 'DriveSync');
      rethrow;
    }
  }

  /// Call this once at app startup (e.g. in main.dart or a top-level provider).
  /// It silently restores a previous session so the first backup/restore
  /// attempt never needs to show the sign-in UI.
  Future<void> restoreSession() async {
    try {
      await _ensureInitialized();
      if (_currentUser != null) return; // already have a session

      final account = await _googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        _currentUser = account;
        dev.log('Session pre-warmed for: ${account.email}', name: 'DriveSync');
      }
    } catch (e) {
      // Non-fatal — the user will be prompted interactively on first use.
      dev.log(
        'restoreSession failed (will sign in on demand): $e',
        name: 'DriveSync',
      );
    }
  }

  /// Silent-only sign-in. Returns null if the user has never signed in before.
  Future<GoogleSignInAccount?> silentSignIn() async {
    try {
      await _ensureInitialized();
      if (_currentUser != null) return _currentUser;

      final account = await _googleSignIn.attemptLightweightAuthentication();
      if (account != null) _currentUser = account;
      return account;
    } catch (e) {
      dev.log('Silent sign-in failed: $e', name: 'DriveSync');
      return null;
    }
  }

  /// Interactive sign-in — shows the Google account picker.
  Future<GoogleSignInAccount?> signIn() async {
    try {
      await _ensureInitialized();
      final account = await _googleSignIn.authenticate();
      _currentUser = account;
      return account;
    } catch (e) {
      dev.log('Interactive sign-in error: $e', name: 'DriveSync');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  /// Returns a ready-to-use DriveApi, handling all auth tiers automatically:
  ///   1. Existing in-memory session  → instant, no UI
  ///   2. Platform stored credentials → silent, no UI (fixes the reopen bug)
  ///   3. Interactive sign-in         → shows Google UI once, then never again
  Future<drive.DriveApi?> _getDriveApi() async {
    await _ensureInitialized();

    // Tier 1: already signed in this session.
    GoogleSignInAccount? account = _currentUser;

    // Tier 2: silently restore from platform credential store.
    //         This is what makes "reopen app" seamless.
    if (account == null) {
      account = await _googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        _currentUser = account; // ← was missing before; caused repeated prompts
        dev.log(
          'Silently restored session: ${account.email}',
          name: 'DriveSync',
        );
      }
    }

    // Tier 3: interactive — only reached if the user has truly never signed in.
    if (account == null) {
      try {
        account = await _googleSignIn.authenticate();
        _currentUser = account;
        dev.log(
          'Interactive sign-in succeeded: ${account.email}',
          name: 'DriveSync',
        );
      } catch (e) {
        dev.log('All auth tiers failed: $e', name: 'DriveSync');
        return null;
      }
    }

    try {
      final authorization = await account.authorizationClient.authorizeScopes(
        _driveScopes,
      );
      final client = authorization.authClient(scopes: _driveScopes);
      return drive.DriveApi(client);
    } catch (e) {
      // Token likely expired; clear so the next call tries to lightweight auth.
      dev.log(
        'Scope authorization failed (token expired?): $e',
        name: 'DriveSync',
      );
      _currentUser = null;
      return null;
    }
  }

  String _escape(String value) => value.replaceAll("'", "\\'");

  Future<String?> _getOrCreateFolder(drive.DriveApi api) async {
    try {
      final list = await api.files.list(
        q:
            "name = '${_escape(_folderName)}' and "
            "mimeType = 'application/vnd.google-apps.folder' and "
            "trashed = false",
      );

      if (list.files != null && list.files!.isNotEmpty) {
        final id = list.files!.first.id;
        if (id != null) return id;
      }

      final folder = drive.File()
        ..name = _folderName
        ..mimeType = 'application/vnd.google-apps.folder';

      final created = await api.files.create(folder);
      return created.id;
    } catch (e) {
      dev.log('Error in _getOrCreateFolder: $e', name: 'DriveSync');
      rethrow;
    }
  }

  Future<void> syncWarranties(List<dynamic> items) async {
    try {
      final api = await _getDriveApi();
      if (api == null) throw Exception('Please sign in to Google Drive');

      final folderId = await _getOrCreateFolder(api);
      if (folderId == null) throw Exception('Drive folder access failed');

      final metadata = items.map((i) => i.toJson()).toList();
      final metadataJson = jsonEncode(metadata);
      final media = drive.Media(
        Stream.value(utf8.encode(metadataJson)),
        metadataJson.length,
      );

      drive.FileList? existing;
      try {
        existing = await api.files.list(
          q:
              "name = '${_escape(_metadataFileName)}' and "
              "'$folderId' in parents and trashed = false",
        );
      } catch (e) {
        dev.log('Failed to query existing metadata: $e', name: 'DriveSync');
      }

      if (existing != null &&
          existing.files != null &&
          existing.files!.isNotEmpty) {
        final fileId = existing.files!.first.id!;
        await api.files.update(drive.File(), fileId, uploadMedia: media);
      } else {
        final metadataFile = drive.File()
          ..name = _metadataFileName
          ..parents = [folderId];
        await api.files.create(metadataFile, uploadMedia: media);
      }

      for (final item in items) {
        if (item.receiptImagePath != null) {
          final file = File(item.receiptImagePath!);
          if (await file.exists()) {
            final fileName = item.receiptImagePath!.split('/').last;

            drive.FileList? check;
            try {
              check = await api.files.list(
                q:
                    "name = '${_escape(fileName)}' and "
                    "'$folderId' in parents and trashed = false",
              );
            } catch (_) {}

            if (check == null || check.files == null || check.files!.isEmpty) {
              final driveFile = drive.File()
                ..name = fileName
                ..parents = [folderId];
              await api.files.create(
                driveFile,
                uploadMedia: drive.Media(file.openRead(), await file.length()),
              );
            }
          }
        }
      }
    } catch (e) {
      dev.log('Sync Error: $e', name: 'DriveSync');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> downloadMetadata() async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Please sign in to Google Drive');

    final folderId = await _getOrCreateFolder(api);
    if (folderId == null) return [];

    final list = await api.files.list(
      q:
          "name = '${_escape(_metadataFileName)}' and "
          "'$folderId' in parents and trashed = false",
    );

    if (list.files == null ||
        list.files!.isEmpty ||
        list.files!.first.id == null) {
      return [];
    }

    final media =
        await api.files.get(
              list.files!.first.id!,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final bytes = await media.stream.fold<List<int>>(
      [],
      (p, e) => p..addAll(e),
    );
    return (jsonDecode(utf8.decode(bytes)) as List)
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  Future<File?> downloadImage(String fileName, String localDir) async {
    final api = await _getDriveApi();
    if (api == null) return null;

    final folderId = await _getOrCreateFolder(api);
    if (folderId == null) return null;

    final list = await api.files.list(
      q:
          "name = '${_escape(fileName)}' and "
          "'$folderId' in parents and trashed = false",
    );

    if (list.files != null &&
        list.files!.isNotEmpty &&
        list.files!.first.id != null) {
      final media =
          await api.files.get(
                list.files!.first.id!,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;
      final localFile = File('$localDir/$fileName');
      await media.stream.pipe(localFile.openWrite());
      return localFile;
    }
    return null;
  }
}
