import 'package:flutter/material.dart';
import 'dart:io';

class ResultsScreen extends StatelessWidget {
  final File selectedImage;
  final String classificationResult;
  final double? confidence;

  const ResultsScreen({
    Key? key,
    required this.selectedImage,
    required this.classificationResult,
    this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Classification Result',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Display
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  selectedImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 30),

            // Classification Result Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Success Icon
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    'This item is classified as:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Result Text
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Text(
                      classificationResult.toUpperCase(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // Confidence Score (if provided)
                  if (confidence != null)
                    Column(
                      children: [
                        Text(
                          'Confidence: ${(confidence! * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: confidence!,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                              confidence! > 0.8 ? Colors.green :
                              confidence! > 0.6 ? Colors.orange : Colors.red
                          ),
                          minHeight: 8,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Disposal Tips Card
            _buildDisposalTipsCard(),

            SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    label: Text(
                      'Try Another',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Share or save functionality can be added here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Result saved!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: Icon(Icons.share, color: Colors.white),
                    label: Text(
                      'Share Result',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisposalTipsCard() {
    Map<String, Map<String, dynamic>> disposalInfo = {
      'plastic': {
        'icon': Icons.local_drink,
        'color': Colors.blue,
        'tips': [
          'Clean the item before disposal',
          'Check for recycling number',
          'Place in recycling bin',
          'Avoid single-use when possible'
        ],
      },
      'glass': {
        'icon': Icons.wine_bar,
        'color': Colors.green,
        'tips': [
          'Remove caps and lids',
          'Rinse container clean',
          'Place in glass recycling',
          'Can be recycled infinitely'
        ],
      },
      'metal': {
        'icon': Icons.build,
        'color': Colors.grey,
        'tips': [
          'Clean thoroughly',
          'Remove labels if possible',
          'Place in metal recycling',
          'Aluminum cans are highly valuable'
        ],
      },
      'cardboard': {
        'icon': Icons.inventory_2,
        'color': Colors.orange,
        'tips': [
          'Flatten the cardboard',
          'Remove tape and staples',
          'Keep dry before disposal',
          'Break down large boxes'
        ],
      },
      'paper': {
        'icon': Icons.description,
        'color': Colors.indigo,
        'tips': [
          'Keep paper clean and dry',
          'Remove plastic windows',
          'Shred sensitive documents',
          'Can be recycled 5-7 times'
        ],
      },
      'trash': {
        'icon': Icons.delete,
        'color': Colors.red,
        'tips': [
          'Non-recyclable waste',
          'Dispose in general waste bin',
          'Consider reducing usage',
          'Look for alternatives'
        ],
      },
    };

    String key = classificationResult.toLowerCase();
    var info = disposalInfo[key] ?? disposalInfo['trash']!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (info['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  info['icon'],
                  color: info['color'],
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Disposal Tips',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...((info['tips'] as List<String>).map((tip) => Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: info['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )).toList()),
        ],
      ),
    );
  }
}