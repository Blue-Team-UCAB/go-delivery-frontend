import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_event.dart';
import 'package:go_delivery_frontend/application/BLoc/user/current/current_user_state.dart';
import 'package:go_delivery_frontend/application/BLoc/user/update_image/update_image_bloc.dart';
import 'package:go_delivery_frontend/application/BLoc/user/update_image/update_image_event.dart';
import 'package:go_delivery_frontend/application/BLoc/user/update_image/update_image_state.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
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
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CurrentUserBloc>().add(FetchCurrentUser());
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final croppedFile = await _cropImage(pickedFile.path);

      if (croppedFile != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image', croppedFile.path);

        if (!mounted) return;

        setState(() {
          _profileImage = File(croppedFile.path);
        });
        context
            .read<UserImageBloc>()
            .add(UpdateUserImage(image: _profileImage!));
      }
    }
  }

  Future<CroppedFile?> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(
        ratioX: 1.0,
        ratioY: 1.0,
      ),
      maxWidth: 800,
      maxHeight: 800,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 80,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Recortar imagen',
          toolbarColor: const Color(0xD36A00B1),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    return croppedFile;
  }

  Widget _buildEditableField(String title, TextEditingController controller,
      {Widget? prefix, String? hintText, TextInputType? keyboardType}) {
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
                    keyboardType: keyboardType,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(top: 8),
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
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
      body: BlocListener<UserImageBloc, UserImageState>(
        listener: (context, state) {
          if (state is UserImageSuccess) {
            context.read<CurrentUserBloc>().add(FetchCurrentUser());
          } else if (state is UserImageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Error al actualizar la imagen de perfil: ${state.message}'),
            ));
          }
        },
        child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
          builder: (context, state) {
            if (state is CurrentUserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CurrentUserLoaded) {
              _nameController.text = state.name;
              _phoneController.text = state.phone;
              _profileImage ??=
                  state.image.isNotEmpty ? null : File(state.image);

              return SafeArea(
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
                              radius: 80,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: state.image.isNotEmpty
                                  ? NetworkImage(state.image)
                                  : (_profileImage != null
                                      ? FileImage(_profileImage!)
                                      : const AssetImage(
                                              'assets/icon/user_150x150.png')
                                          as ImageProvider),
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
                        _buildEditableField(
                          'Nombre de Usuario',
                          _nameController,
                          hintText: 'Ingrese su nombre',
                        ),
                        const SizedBox(height: 20),
                        _buildEditableField(
                          'Número de Teléfono',
                          _phoneController,
                          hintText: 'Ingrese su número de teléfono',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        _buildButton(context, "Preferencias",
                            route: "/preferences"),
                        const SizedBox(height: 20),
                        _buildButton(context, "GoDely Wallet",
                            route: "/wallet"),
                        const SizedBox(height: 20),
                        _buildButton(context, "Direcciones",
                            route: "/addresses"),
                      ],
                    ),
                  ),
                ),
              );
            } else if (state is CurrentUserError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }

            return const Center(
                child: Text('No se han cargado los datos del usuario.'));
          },
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: 3,
        onItemTapped: (index) {},
      ),
    );
  }
}
