import 'package:image_picker/image_picker.dart';

PickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    // the io methods are not working for web flutter apps so that's why we use readAsBytes
    return _file.readAsBytes();
  }
  print('Please select an user avatar');
}
