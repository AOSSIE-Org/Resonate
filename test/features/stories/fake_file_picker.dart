import 'package:file_picker/file_picker.dart';


class FakeFilePicker extends FilePicker {
  FilePickerResult? next;
  FileType? lastType;
  List<String>? lastAllowedExtensions;

  void queue(String path) {
    next = FilePickerResult([
      PlatformFile(name: path.split('/').last, path: path, size: 1),
    ]);
  }

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    lastType = type;
    lastAllowedExtensions = allowedExtensions;
    final result = next;
    // One queued file answers one pick, so a later pick with nothing queued
    // reads as the user cancelling.
    next = null;
    return result;
  }
}
