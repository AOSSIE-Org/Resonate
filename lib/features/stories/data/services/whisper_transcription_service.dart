import 'dart:developer';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whisper_flutter_new/whisper_flutter_new.dart';

class WhisperTranscriptionService {
  WhisperTranscriptionService({WhisperModel model = WhisperModel.base})
    : whisper = Whisper(
        model: model,
        downloadHost:
            "https://huggingface.co/ggerganov/whisper.cpp/resolve/main",
      );

  final Whisper whisper;

  Future<String> transcribeChapter(String chapterId) async {
    log('Starting to Transcribe');
    final convertResult = await _convertMp4ToWav(chapterId);
    if (!convertResult) return "Transcription Failed";

    final storagePath = await getApplicationDocumentsDirectory();
    final transcription = await whisper.transcribe(
      transcribeRequest: TranscribeRequest(
        audio: '${storagePath.path}/recordings/$chapterId.wav',
        isTranslate: true, // Translate result from audio lang to english text
        isNoTimestamps: false,
      ),
    );

    return _convertToLrc(transcription.segments!);
  }

  Future<bool> _convertMp4ToWav(String chapterId) async {
    var conversionSuccess = false;
    final recordingsPath = await getApplicationDocumentsDirectory().then(
      (dir) => '${dir.path}/recordings',
    );
    final command =
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

  String _convertToLrc(List<WhisperTranscribeSegment?> segments) {
    final lrcContent = StringBuffer()
      ..writeln('[re:Resonate App - AOSSIE]')
      ..writeln('[ve:v1.0.0]');
    for (final segment in segments) {
      try {
        final line = _parseSegment(segment);
        if (line != null) lrcContent.writeln(line);
      } catch (e) {
        log(e.toString());
      }
    }
    return lrcContent.toString();
  }

  String? _parseSegment(WhisperTranscribeSegment? segment) {
    if (segment == null) return null;
    if (segment.text == '[BLANK_AUDIO]') return null;
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
