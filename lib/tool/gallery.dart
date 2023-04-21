import 'package:image_picker/image_picker.dart';

final ImagePicker _picker = ImagePicker();

///从相册中获取图片
Future<XFile?> getImageFromGallery() async {
  XFile? image =
      await _picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
  return image;
}

Future<XFile?> takePhoto() async {
  XFile? photo =
      await _picker.pickImage(source: ImageSource.camera, imageQuality: 60);
  return photo;
}
