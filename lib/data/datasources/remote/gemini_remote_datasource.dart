import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/constants/ai_prompts.dart';
import '../../../core/error/exceptions.dart';

class GeminiRemoteDataSource {
  final GenerativeModel _model;

  GeminiRemoteDataSource({required String apiKey})
    : _model = GenerativeModel(model: 'gemini-3.5-flash', apiKey: apiKey);

  Future<Map<String, dynamic>> extractDataFromReceipt(File file) async {
    dev.log('extractDataFromReceipt: Reading bytes', name: 'GeminiRemote');
    try {
      final bytes = await file.readAsBytes();

      final extension = file.path.split('.').last.toLowerCase();
      String mimeType;

      if (extension == 'pdf') {
        mimeType = 'application/pdf';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      } else {
        mimeType = 'image/jpeg';
      }

      dev.log('MimeType: $mimeType', name: 'GeminiRemote');

      final prompt = AiPrompts.receiptWarrantyExtraction;

      final content = [
        Content.multi([TextPart(prompt), DataPart(mimeType, bytes)]),
      ];

      dev.log(
        'Generating content via Gemini 3.5 Flash...',
        name: 'GeminiRemote',
      );
      final response = await _model.generateContent(content);
      final responseText = response.text?.trim() ?? '{}';
      dev.log('Raw response received', name: 'GeminiRemote');

      final cleanedJson = responseText
          .replaceFirst('```json', '')
          .replaceFirst('```', '')
          .trim();

      return jsonDecode(cleanedJson) as Map<String, dynamic>;
    } on GenerativeAIException catch (e) {
      dev.log('Gemini AI Exception', error: e, name: 'GeminiRemote');
      if (e.message.contains('503') || e.message.contains('UNAVAILABLE')) {
        throw AiProcessingException('AI is currently busy', isBusy: true);
      }
      throw AiProcessingException('AI extraction failed: ${e.message}');
    } catch (e, st) {
      dev.log(
        'Unexpected error in extractDataFromReceipt',
        name: 'GeminiRemote',
        error: e,
        stackTrace: st,
      );
      throw AiProcessingException('Failed to process document');
    }
  }
}
