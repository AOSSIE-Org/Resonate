import 'dart:developer';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:resonate/utils/constants.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class WhisperTranscriptionController extends GetxController {
  final Whisper whisper = Whisper(
    model: currentWhisperModel.value,
    downloadHost: "https://huggingface.co/ggerganov/whisper.cpp/resolve/main",
  );

  Future<String> transcribeChapter(String chapterId) async {
    log('Starting to Transcribe');
    final convertResult = await convertMp4ToWav(chapterId);
    if (convertResult) {
      final storagePath = await getApplicationDocumentsDirectory();
      final transcription = await whisper.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: '${storagePath.path}/recordings/$chapterId.wav',
          isTranslate: true, // Translate result from audio lang to english text
          isNoTimestamps: false, // Get segments in result,
        ),
      );

      return convertToLrc(transcription.segments!);
    }
    return "Transcription Failed";
  }

  Future<bool> convertMp4ToWav(String chapterId) async {
    bool conversionSuccess = false;
    final String recordingsPath = await getApplicationDocumentsDirectory().then(
      (dir) => '${dir.path}/recordings',
    );
    final String command =
        '-i "$recordingsPath/$chapterId.mp4" -ar 16000 -ac 1 -acodec pcm_s16le "$recordingsPath/$chapterId.wav"';

    await FFmpegKit.execute(command).then((session) async {
      final returnCode = await session.getReturnCode();

      if (ReturnCode.isSuccess(returnCode)) {
        log('✅ Conversion successful!');
        conversionSuccess = true;
      } else if (ReturnCode.isCancel(returnCode)) {
        log('⚠️ Conversion cancelled.');
      } else {
        final logs = await session.getAllLogsAsString();
        log('❌ FFmpeg error:\n$logs');
      }
    });
    return conversionSuccess;
  }

  String convertToLrc(List<WhisperTranscribeSegment?> transcriptionSegments) {
    final StringBuffer lrcContent = StringBuffer();
    lrcContent.writeln('[re:Resonate App - AOSSIE]');
    lrcContent.writeln('[ve:v1.0.0]');
    for (WhisperTranscribeSegment? segment in transcriptionSegments) {
      try {
        // Parse the log line
        final segmentString = _parseTranscriptionSegment(segment);
        if (segmentString != null) {
          // Convert to LRC format and add to content
          lrcContent.writeln(segmentString);
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return lrcContent.toString();
  }

  String? _parseTranscriptionSegment(WhisperTranscribeSegment? segment) {
    if (segment == null) return null;

    // Skip blank audio segments if desired
    if (segment.text == '[BLANK_AUDIO]') {
      return null;
    }

    return "[${segment.fromTs.toMinSecMs()}]${segment.text}";
  }
}

extension FormatAsMinSecMs on Duration {
  String toMinSecMs() {
    final sign = isNegative ? '-' : '';
    final ms = inMilliseconds.abs();
    final minutes = ms ~/ 60000;
    final seconds = (ms % 60000) ~/ 1000;
    final milliseconds = ms % 1000;
    return '$sign${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
  }
}
