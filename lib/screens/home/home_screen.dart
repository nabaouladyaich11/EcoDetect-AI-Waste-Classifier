import 'package:ai_waste_classifier/widgets/home_widgets/home_header.dart';
import 'package:ai_waste_classifier/widgets/home_widgets/welcome_section.dart';
import 'package:ai_waste_classifier/widgets/home_widgets/upload_section.dart';
import 'package:ai_waste_classifier/widgets/home_widgets/waste_categories_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _classifyWaste() {
    if (_selectedImage == null) return;
    // TODO: Implement waste classification logic
    print('Classifying waste image: ${_selectedImage?.path}');
    // Navigate to results screen or show classification result
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WelcomeSection(),
                  const SizedBox(height: 28),
                  UploadSection(
                    selectedImage: _selectedImage,
                    onPickImage: _pickImageFromGallery,
                    onClearImage: _clearImage,
                    onClassifyWaste: _classifyWaste,
                  ),
                  const SizedBox(height: 28),
                  const WasteCategoriesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
