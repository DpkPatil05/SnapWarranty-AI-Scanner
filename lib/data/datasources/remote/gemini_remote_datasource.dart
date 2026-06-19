import 'dart:convert';
import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';

class GeminiRemoteDataSource {
  final FirebaseFunctions _functions;

  GeminiRemoteDataSource({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  Future<Map<String, dynamic>> extractDataFromReceipt(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      // Determine mime type based on file extension
      final extension = image.path.split('.').last.toLowerCase();
      final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';

      final result = await _functions
          .httpsCallable('extractWarrantyData')
          .call({
            'base64Image': base64Image,
            'mimeType': mimeType,
          });

      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      throw Exception('Failed to extract data via Cloud Functions: $e');
    }
  }
}
