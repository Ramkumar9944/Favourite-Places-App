import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/providers/user_places.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlacesScreen extends ConsumerStatefulWidget {
  const NewPlacesScreen({super.key});

  @override
  ConsumerState<NewPlacesScreen> createState() => _NewPlacesScreenState();
}

class _NewPlacesScreenState extends ConsumerState<NewPlacesScreen> {
  final titleController = TextEditingController();
  File? selectedImage;
  PlaceLocation? selectedLocation;

  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void saveHandler() {
    final enteredTitle = titleController.text;

    if (enteredTitle.isEmpty ||
        selectedImage == null ||
        selectedLocation == null) {
      return;
    }
    ref.read(UserPlacesProvider.notifier).addPlace(
          Place(
              title: enteredTitle,
              image: selectedImage!,
              location: selectedLocation!),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              maxLength: 50,
              decoration: const InputDecoration(labelText: "Title"),
              controller: titleController,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            const SizedBox(
              height: 10,
            ),
            ImageInput(
              onSelectImage: (image) {
                selectedImage = image;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            LocationInput(
              onSelectLocation: (location) {
                selectedLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: saveHandler,
              label: const Text("Add Place"),
            )
          ],
        ),
      ),
    );
  }
}
