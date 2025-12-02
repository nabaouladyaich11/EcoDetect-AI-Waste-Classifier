import 'package:ai_waste_classifier/widgets/profile_widgets/profile_text_field.dart';
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final bool isEditMode;
  final VoidCallback onToggleEditMode;
  final VoidCallback onSaveProfile;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.isEditMode,
    required this.onToggleEditMode,
    required this.onSaveProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with "Account Information" and Edit button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D5C3A),
                ),
              ),
              TextButton.icon(
                onPressed: onToggleEditMode,
                icon: Icon(
                  isEditMode ? Icons.close : Icons.edit,
                  size: 18,
                  color: const Color(0xFF1D5C3A),
                ),
                label: Text(
                  isEditMode ? 'Cancel' : 'Edit',
                  style: const TextStyle(
                    color: Color(0xFF1D5C3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Username field
          ProfileTextField(
            label: 'Username',
            controller: usernameController,
            enabled: isEditMode,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter a username';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email field
          ProfileTextField(
            label: 'Email',
            controller: emailController,
            enabled: isEditMode,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          if (isEditMode) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D5C3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed: onSaveProfile,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
