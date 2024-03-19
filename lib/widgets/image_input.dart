import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onSelectImage});

  final void Function(File image) onSelectImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? capturedImage;
  void takePicture() async {
    final imageePicker = ImagePicker();
    final pickedImage =
        await imageePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }
    setState(() {
      capturedImage = File(pickedImage.path);
    });
    widget.onSelectImage(capturedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: takePicture,
      icon: const Icon(Icons.camera),
      label: const Text("Take a picture"),
    );

    if (capturedImage != null) {
      content = GestureDetector(
        onTap: takePicture,
        child: Image.file(
          capturedImage!,
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
