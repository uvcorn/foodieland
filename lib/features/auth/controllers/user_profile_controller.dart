import 'dart:convert';
import 'dart:io';
import 'package:foodieland/components/snackbar_helper/snackbar_helper.dart';
import 'package:foodieland/features/auth/screens/sign_in_screen.dart';
import 'package:foodieland/features/home/ui/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool _isLoadingDelete = false;

  bool get isLoading => _isLoading;
  bool get isLoadingDelete => _isLoadingDelete;

  Future<void> updateUserData({
    required String fullName,
    required String bio,
    required String? newPassword,
    required File? localImage,
  }) async {
    _isLoading = true;
    update();

    try {
      UserAttributes update;
      if (localImage != null) {
        final avatarUrl = await _uploadAvatar(localImage!);

        update = UserAttributes(
          data: {'avatar_url': avatarUrl, 'full_name': fullName, 'bio': bio},
        );
      } else if (newPassword != null && newPassword.isNotEmpty) {
        update = UserAttributes(
          data: {'full_name': fullName, 'bio': bio},
          password: newPassword,
        );
      } else {
        update = UserAttributes(data: {'full_name': fullName, 'bio': bio});
      }

      await supabase.auth.updateUser(update);

      SnackbarHelper.show(
        message: "Profile updated successfully",
        isSuccess: true,
      );
    } catch (e) {
      SnackbarHelper.show(
        message: "Error updating profile: $e",
        isSuccess: false,
      );
    } finally {
      _isLoading = false;
      update();
    }
  }


  Future<String?> _uploadAvatar(File imageFile) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final bucket = 'avatars';
      final filePath =
          '${user.id}/${DateTime.now().millisecondsSinceEpoch}.png';

      await supabase.storage
          .from(bucket)
          .upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
      );

      final publicUrl = supabase.storage.from(bucket).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }

  Future<void> deleteUser() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "No user logged in");
      return;
    }

    _isLoadingDelete = true;
    update();

    try {
      final response = await http.post(
        Uri.parse("https://vloxcpjrbpasnaieukli.supabase.co/functions/v1/user_delete_request"),
        headers: {
          "Authorization": "Bearer ${supabase.auth.currentSession?.accessToken}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": user.id}),
      );

      if (response.statusCode == 200) {
        await supabase.auth.signOut();
        SnackbarHelper.show(
          message: "Account deleted successfully",
          isSuccess: true,
        );


        Future.delayed(const Duration(milliseconds: 200), () {
          Get.offAllNamed(HomeScreen.routeName);
        });
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      SnackbarHelper.show(
        message: "Failed to delete account: $e",
        isSuccess: false,
      );
    } finally {
      _isLoadingDelete = false;
      update();
    }
  }

}
