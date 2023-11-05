import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../helper/permission/permission.dart';

class ProfileImgEditing extends StatefulWidget {
  const ProfileImgEditing({
    Key? key,
  }) : super(key: key);

  @override
  _ProfileImgEditingState createState() => _ProfileImgEditingState();
}

class _ProfileImgEditingState extends State<ProfileImgEditing> {
  String imagePath = "";
  final PermissionService _permissionService = PermissionService();

  Future<void> _pickImage() async {
    ImagePicker _picker = ImagePicker();
    var imagePike = await _picker.pickImage(source: ImageSource.gallery);
    imagePath = imagePike!.path;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          (imagePath == "")
              ? const CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo.jpg"),
                )
              : CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image.file(
                      File(imagePath),
                      width: 115,
                      height: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Positioned(
            right: 100,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.blueGrey),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: _pickImage,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    );
  }
}
