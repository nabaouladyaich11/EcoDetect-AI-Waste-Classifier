import 'package:ai_waste_classifier/widgets/profile_widgets/logout_button.dart';
import 'package:ai_waste_classifier/widgets/profile_widgets/profile_form.dart';
import 'package:ai_waste_classifier/widgets/profile_widgets/profile_header.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for user data (initially populated from stored data)
  final TextEditingController _usernameController =
      TextEditingController(text: 'User123');
  final TextEditingController _emailController =
      TextEditingController(text: 'user@example.com');

  bool _isEditMode = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save logic (e.g., update backend/local storage)
      setState(() {
        _isEditMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF1D5C3A),
        ),
      );
    }
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D5C3A),
            ),
          ),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement logout logic (clear session, navigate to login)
                Navigator.of(context).pop();
                // Navigator.of(context).pushReplacementNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 250, 255, 245),
                  Color.fromARGB(255, 220, 235, 210),
                ],
              ),
            ),
          ),

          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ProfileHeader(
                    username: _usernameController.text,
                    email: _emailController.text,
                  ),
                  const SizedBox(height: 32),
                  ProfileForm(
                    formKey: _formKey,
                    usernameController: _usernameController,
                    emailController: _emailController,
                    isEditMode: _isEditMode,
                    onToggleEditMode: _toggleEditMode,
                    onSaveProfile: _saveProfile,
                  ),
                  const SizedBox(height: 32),
                  LogoutButton(onLogout: _logout),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Footer image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/footer.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
