import 'package:file_picker/file_picker.dart';
import 'package:resonate/core/services/media_picker_service.dart';

// Stands in for MediaPickerService, which is the seam the pages actually call.
//
// This used to extend FilePicker and be installed via `FilePicker.platform`.
// file_picker 12 removed that injection point entirely: FilePicker is now a
// final class with only static methods, so it cannot be subclassed or swapped.
// Faking the service instead is also the layer the MVVM audit put there for
// this purpose, so no production code needs a test-only hook.
class FakeFilePicker implements MediaPickerService {
  PickedFile? next;
  String? nextImagePath;
  List<String>? lastAllowedExtensions;

  // MediaPickerService.pickFile derives the FileType from whether extensions
  // were supplied; mirroring that here keeps the existing assertions honest.
  FileType get lastType =>
      lastAllowedExtensions == null ? FileType.any : FileType.custom;

  void queue(String path) {
    final name = path.split('/').last;
    final dot = name.lastIndexOf('.');
    next = PickedFile(
      path: path,
      extension: dot == -1 ? null : name.substring(dot + 1),
    );
  }

  @override
  Future<PickedFile?> pickFile({List<String>? allowedExtensions}) async {
    lastAllowedExtensions = allowedExtensions;
    final result = next;
    // One queued file answers one pick, so a later pick with nothing queued
    // reads as the user cancelling.
    next = null;
    return result;
  }

  @override
  Future<String?> pickImage({
    ImagePickSource source = ImagePickSource.gallery,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final path = nextImagePath;
    nextImagePath = null;
    return path;
  }

  @override
  Future<String?> pickCoverImage({
    ImagePickSource source = ImagePickSource.gallery,
  }) => pickImage(source: source);
}
