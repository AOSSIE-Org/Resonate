import 'dart:io';
import 'dart:convert';

void main() {
  const sourceLocale = 'en';
  final i18nDir = Directory('lib/i18n');
  
  // Automatically discover all ARB files
  final targetLocales = <String>[];
  
  if (!i18nDir.existsSync()) {
    print('{"error": "i18n directory not found"}');
    return;
  }
  
  // Find all ARB files in the directory
  final arbFiles = i18nDir
      .listSync()
      .where((file) => file.path.endsWith('.arb'))
      .where((file) => file.path.contains('app_localization_'))
      .toList();
  
  // Extract locale codes from filenames
  for (final file in arbFiles) {
    final filename = file.path.split('/').last;
    // Extract locale from app_localization_XX.arb
    final match = RegExp(r'app_localization_(\w+)\.arb').firstMatch(filename);
    if (match != null) {
      final locale = match.group(1)!;
      if (locale != sourceLocale) {
        targetLocales.add(locale);
      }
    }
  }
  
  print('Found ${targetLocales.length} target languages: ${targetLocales.join(", ")}');
  
  final results = <String, dynamic>{};
  
  // Load source ARB file (English)
  final sourceFile = File('lib/i18n/app_localization_$sourceLocale.arb');
  
  if (!sourceFile.existsSync()) {
    print('{"error": "Source file not found"}');
    return;
  }
  
  try {
    final sourceContent = jsonDecode(sourceFile.readAsStringSync()) as Map<String, dynamic>;
    
    // Get all translation keys (excluding metadata)
    final sourceKeys = sourceContent.keys
        .where((key) => !key.startsWith('@'))
        .where((key) => key != '@@locale')
        .toList();
    
    // Check each target language
    for (final locale in targetLocales) {
      final targetFile = File('lib/i18n/app_localization_$locale.arb');
      
      try {
        final targetContent = jsonDecode(targetFile.readAsStringSync()) as Map<String, dynamic>;
        
        final targetKeys = targetContent.keys
            .where((key) => !key.startsWith('@'))
            .where((key) => key != '@@locale')
            .toSet();
        
        final missingKeys = sourceKeys
            .where((key) => !targetKeys.contains(key))
            .toList();
        
        if (missingKeys.isNotEmpty) {
          final coverage = ((sourceKeys.length - missingKeys.length) / sourceKeys.length * 100).round();
          
          results[locale] = {
            'missingKeys': missingKeys,
            'totalKeys': sourceKeys.length,
            'coverage': coverage,
            'missingCount': missingKeys.length
          };
        }
        
      } catch (e) {
        results[locale] = {
          'missingKeys': sourceKeys,
          'totalKeys': sourceKeys.length,
          'coverage': 0,
          'missingCount': sourceKeys.length,
          'error': 'Parse error: ${e.toString()}'
        };
      }
    }
    
  } catch (e) {
    print('{"error": "Failed to parse source file"}');
    return;
  }
  
  print(jsonEncode(results));
}
