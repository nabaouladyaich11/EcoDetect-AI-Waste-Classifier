import 'package:ai_waste_classifier/widgets/home_widgets/home_header.dart';
import 'package:ai_waste_classifier/widgets/home_widgets/welcome_section.dart';
import 'package:ai_waste_classifier/widgets/home_widgets/upload_section.dart';
import 'package:ai_waste_classifier/widgets/home_widgets/waste_categories_section.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:ai_waste_classifier/screens/results/results_screen.dart';
import 'package:ai_waste_classifier/services/huggingface_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isClassifying = false;
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

  Future<void> _classifyWaste() async {
    if (_selectedImage == null) return;

    setState(() {
      _isClassifying = true;
    });

    try {
      // Use your real HuggingFace model!
      ClassificationResult result = await HuggingFaceService.classifyImage(_selectedImage!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            selectedImage: _selectedImage!,
            classificationResult: result.predictedClass,
            confidence: result.confidence,
            // Remove allPredictions if ResultsScreen doesn't support it yet
          ),
        ),
      );

    } catch (e) {
      _showErrorDialog('Classification failed: ${e.toString()}');
    } finally {
      setState(() {
        _isClassifying = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
                    // Removed isClassifying parameter
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