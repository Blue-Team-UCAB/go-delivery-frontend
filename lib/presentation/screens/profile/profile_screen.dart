import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_delivery_frontend/presentation/widgets/navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final _phoneController = TextEditingController(text: "414 990 2172");
  final _nameController = TextEditingController(text: "Nombre de Usuario");

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Widget _buildEditableField(String title, TextEditingController controller,
      {Widget? prefix}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 70,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
        ),
        child: Row(
          children: [
            if (prefix != null) prefix,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  TextField(
                    controller: controller,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top: 8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return _buildEditableField(
      'Teléfono',
      _phoneController,
      prefix: Row(
        children: const [
          Text(
            '+58',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, {String? route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            context.go(route);
          }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : const NetworkImage(
                              'https://via.placeholder.com/150'),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildEditableField('Nombre de Usuario', _nameController),
                const SizedBox(height: 20),
                _buildPhoneField(),
                const SizedBox(height: 20),
                _buildButton(context, "Preferencias", route: "/preferences"),
                const SizedBox(height: 20),
                _buildButton(context, "GoDely Wallet", route: "/wallet"),
                const SizedBox(height: 20),
                _buildButton(context, "Direcciones", route: "/addresses"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) {},
      ),
    );
  }
}
