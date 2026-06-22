import 'dart:convert';
import 'dart:io';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../local/database/app_database.dart';
import 'dart:developer' as dev;

class DriveSyncDataSource {
  static const String _folderName = 'SnapWarranty_Backups';
  static const String _metadataFileName = 'sync_metadata.json';
  static const List<String> _driveScopes = [drive.DriveApi.driveFileScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _googleSignIn.initialize();
      _initialized = true;
    }
  }

  /// Attempts to sign in silently if a previous session exists.
  /// This prevents the login popup from appearing every time the app opens.
  Future<GoogleSignInAccount?> silentSignIn() async {
    try {
      await _ensureInitialized();
      // attemptLightweightAuthentication is the modern silent sign-in for 7.x
      final account = await _googleSignIn.attemptLightweightAuthentication();
      if (account != null) {
        dev.log('Silent Sign-In Success: \${account.email}', name: 'DriveSync');
      }
      return account;
    } catch (e) {
      dev.log('Silent Sign-In Error: \$e', name: 'DriveSync');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signIn() async {
    try {
      await _ensureInitialized();
      return await _googleSignIn.authenticate(scopeHint: _driveScopes);
    } catch (e) {
      dev.log('Drive SignIn Error: \$e', name: 'DriveSync');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  Future<drive.DriveApi?> _getDriveApi() async {
    await _ensureInitialized();

    // 1. Try silent/existing session first, then interactive
    final account =
        await _googleSignIn.attemptLightweightAuthentication() ??
        await _googleSignIn.authenticate(scopeHint: _driveScopes);

    // 2. Ensure Drive scopes are authorized
    final authorization = await account.authorizationClient.authorizeScopes(
      _driveScopes,
    );

    // 3. Create the authenticated client using the official 2026 extension
    final client = authorization.authClient(scopes: _driveScopes);

    return drive.DriveApi(client);
  }

  Future<String?> _getOrCreateFolder(drive.DriveApi api) async {
    final list = await api.files.list(
      q: "name = '\$_folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false",
      spaces: 'drive',
    );

    if (list.files != null && list.files!.isNotEmpty) {
      return list.files!.first.id;
    }

    final folder = drive.File()
      ..name = _folderName
      ..mimeType = 'application/vnd.google-apps.folder';

    final createdFolder = await api.files.create(folder);
    return createdFolder.id;
  }

  Future<void> syncWarranties(List<WarrantyEntry> items) async {
    final api = await _getDriveApi();
    if (api == null) throw Exception('Drive API not initialized');

    final folderId = await _getOrCreateFolder(api);
    if (folderId == null) throw Exception('Could not access backup folder');

    // 1. Upload Metadata
    final metadata = items.map((i) => i.toJson()).toList();
    final metadataJson = jsonEncode(metadata);

    final existingFiles = await api.files.list(
      q: "name = '\$_metadataFileName' and '\$folderId' in parents and trashed = false",
    );

    final media = drive.Media(
      Stream.value(utf8.encode(metadataJson)),
      metadataJson.length,
    );

    if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
      await api.files.update(
        drive.File(),
        existingFiles.files!.first.id!,
        uploadMedia: media,
      );
    } else {
      final metadataFile = drive.File()
        ..name = _metadataFileName
        ..parents = [folderId];
      await api.files.create(metadataFile, uploadMedia: media);
    }

    // 2. Upload Documents (Images/PDFs)
    for (final item in items) {
      if (item.receiptImagePath != null) {
        final file = File(item.receiptImagePath!);
        if (await file.exists()) {
          final fileName = item.receiptImagePath!.split('/').last;

          final check = await api.files.list(
            q: "name = '\$fileName' and '\$folderId' in parents and trashed = false",
          );

          if (check.files == null || check.files!.isEmpty) {
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
  }

  Future<List<Map<String, dynamic>>> downloadMetadata() async {
    final api = await _getDriveApi();
    if (api == null) return [];

    final list = await api.files.list(
      q: "name = '\$_metadataFileName' and trashed = false",
    );

    if (list.files == null || list.files!.isEmpty) return [];

    final response =
        await api.files.get(
              list.files!.first.id!,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final bytes = await response.stream.fold<List<int>>(
      [],
      (p, e) => p..addAll(e),
    );
    final decoded = jsonDecode(utf8.decode(bytes)) as List;
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<File?> downloadImage(String fileName, String localDir) async {
    final api = await _getDriveApi();
    if (api == null) return null;

    final list = await api.files.list(
      q: "name = '\$fileName' and trashed = false",
    );

    if (list.files == null || list.files!.isEmpty) return null;

    final response =
        await api.files.get(
              list.files!.first.id!,
              downloadOptions: drive.DownloadOptions.fullMedia,
            )
            as drive.Media;

    final localFile = File('\$localDir/\$fileName');
    final sink = localFile.openWrite();
    await response.stream.pipe(sink);
    await sink.close();

    return localFile;
  }
}
