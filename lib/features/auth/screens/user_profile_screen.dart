// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodieland/components/action_button/action_button.dart';
import 'package:foodieland/components/custom_text_field/custom_text_field.dart';
import 'package:foodieland/components/input_card_container/input_card_container.dart';
import 'package:foodieland/features/auth/controllers/user_profile_controller.dart';
import 'package:foodieland/utils/app_colors/app_colors.dart';
import 'package:foodieland/utils/app_strings/app_strings.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});
  static final String routeName = '/user-profile-screen';

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameTEController = TextEditingController();
  final TextEditingController emailTEController = TextEditingController();
  final TextEditingController passwordTEController = TextEditingController();
  final TextEditingController bioTEController = TextEditingController();
  final UserProfileController _userProfileController =
      Get.find<UserProfileController>();
  File? localImage;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  bool isPasswordObscure = true;
  bool agreedToTerms = false;
  final user = Supabase.instance.client.auth.currentUser;
  // Toggle password visibility

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscure = !isPasswordObscure;
    });
  }

  // Toggle agreed to terms
  void toggleAgreedToTerms(bool? newValue) {
    setState(() {
      agreedToTerms = newValue ?? false;
    });
  }

  // Email Validator
  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emailcantempty;
    }
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(value)) {
      return AppStrings.entervalidmail;
    }
    return null;
  }

  // Password Validator
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordRequirement;
    }
    return null;
  }

  @override
  void dispose() {
    fullNameTEController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    bioTEController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        localImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.lightGray,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // actions: [
          //   IconButton(onPressed: () {}, icon: Icon(Icons.message_outlined)),
          //   const SizedBox(width: 10),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfilePhotoAddAndUpdate(screenWidth),
                  const SizedBox(height: 30),

                  InputCardContainer(
                    minHeight: 290,
                    children: [
                      CustomTextField(
                        controller: fullNameTEController,
                        labelText: AppStrings.firstName,
                        textInputAction: TextInputAction.next,
                      ),

                      CustomTextField(
                        controller: bioTEController,
                        labelText: AppStrings.bio,
                        textFieldLines: 3,
                        textInputAction: TextInputAction.next,
                      ),
                      CustomTextField(
                        controller: emailTEController,
                        labelText: AppStrings.email,
                        textFieldEditEnable: false,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),

                      CustomTextField(
                        controller: passwordTEController,
                        labelText: AppStrings.password,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        obscureText: isPasswordObscure,
                        enableValidation: true,
                        onToggleObscureText: togglePasswordVisibility,
                        validator: (String? value) {
                          if ((value?.length ?? 0) <= 6) {
                            return 'Enter a password more than 6 letters';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GetBuilder(
                    init: _userProfileController,
                    builder: (controller) {
                      return Visibility(
                        visible: controller.isLoading == false,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: ActionButton(
                          title: "Update Profile",
                          onPressed: _onTapUpdateProfile,
                          backgroundColor: Colors.black,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  GetBuilder(
                    init: _userProfileController,
                    builder: (controller) {
                      return Visibility(
                        visible: controller.isLoadingDelete == false,
                        replacement: Center(child: CircularProgressIndicator()),
                        child: ActionButton(
                          title: "Delete Profile",
                          onPressed: _confirmDeleteAlertDialog,
                          backgroundColor: Colors.grey,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapUpdateProfile() {
    if (passwordTEController.text.isNotEmpty) {
      if (_formKey.currentState!.validate()) {
        _userProfileController.updateUserData(
          fullName: fullNameTEController.text,
          bio: bioTEController.text,
          newPassword:
              passwordTEController.text.isNotEmpty
                  ? passwordTEController.text
                  : '',
          localImage: localImage,
        );
      }
    } else {
      _userProfileController.updateUserData(
        fullName: fullNameTEController.text,
        bio: bioTEController.text,
        localImage: localImage,
        newPassword:
            passwordTEController.text.isNotEmpty
                ? passwordTEController.text
                : '',
      );
    }
  }

  Future<void> _getUserData() async {
    if (user != null) {
      fullNameTEController.text = user!.userMetadata?['full_name'] ?? '';
      bioTEController.text = user!.userMetadata?['bio'] ?? '';
      emailTEController.text = user!.email ?? '';
    }
  }

  Widget _buildProfilePhotoAddAndUpdate(double screenWidth) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: screenWidth * 0.15,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                localImage != null
                    ? FileImage(localImage!)
                    : (user?.userMetadata?['avatar_url'] != null
                        ? NetworkImage(user!.userMetadata!['avatar_url'])
                        : null),
            child:
                (localImage == null &&
                        user!.userMetadata?['avatar_url'] == null)
                    ? Icon(Icons.person, size: 60, color: Colors.grey[700])
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: Icon(
                  (localImage == null &&
                          user!.userMetadata?['avatar_url'] == null)
                      ? Icons.add_a_photo
                      : Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAlertDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Are you sure?"),
            content: const Text("Do you really want to delete your account?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("No"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _userProfileController.deleteUser();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Yes"),
              ),
            ],
          ),
    );
  }
}
