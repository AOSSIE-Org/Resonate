import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/media_picker_service.g.dart';

enum ImagePickSource { camera, gallery }

class PickedFile {
  const PickedFile({required this.path, required this.extension});

  final String path;
  final String? extension;
}

// Wraps the platform media pickers so pages don't construct them directly.
class MediaPickerService {
  const MediaPickerService();

  Future<String?> pickImage({
    ImagePickSource source = ImagePickSource.gallery,
    double? maxWidth,
    double? maxHeight,
  }) async {
    final file = await ImagePicker().pickImage(
      source: source == ImagePickSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    return file?.path;
  }

  Future<PickedFile?> pickFile({List<String>? allowedExtensions}) async {
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensions == null ? FileType.any : FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    final file = result?.files.single;
    final path = file?.path;
    if (file == null || path == null) return null;
    return PickedFile(path: path, extension: file.extension);
  }
}

@Riverpod(keepAlive: true)
MediaPickerService mediaPickerService(Ref ref) => const MediaPickerService();
