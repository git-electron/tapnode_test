import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../document_import_service.dart';

@LazySingleton(as: GalleryImagePicker)
class GalleryImagePickerImpl implements GalleryImagePicker {
  const GalleryImagePickerImpl();

  @override
  Future<String?> pickImagePath() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      requestFullMetadata: false,
    );

    return image?.path;
  }
}
