import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../utils/assets_path/assets_path.dart';

//  Blog image upload to supabase storage-- --
class BlogRepository {
  final SupabaseClient supabase;

  BlogRepository({required this.supabase});

  Future<String?> uploadImage(File image) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      await Supabase.instance.client.storage
          .from('blog_images')
          .upload(fileName, image);

      // public URL generate
      final publicUrl = Supabase.instance.client.storage
          .from('blog_images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      debugPrint("Image upload error: $e");
      return null;
    }
  }

  // upload blog to supabase----------------------------
  Future<void> saveBlogToSupabase(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    File? image,
  ) async {
    try {
      final supabase = Supabase.instance.client;

      //  User check
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) throw "User not logged in!";

      final userName = user.userMetadata!['full_name'] ?? "Unknown";
      final userAvatar =
          user.userMetadata!['avatar_url'] ?? AssetsPath.profileAvatar;

      //  Image upload
      String? imageUrl;
      if (image != null) {
        final fileExt = image.path.split('.').last;
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

        // Upload to storage
        await supabase.storage
            .from('blog_images') // তোমার bucket
            .upload(fileName, image);

        // get public URL
        imageUrl = supabase.storage.from('blog_images').getPublicUrl(fileName);
      }

      // Insert blog data
      await supabase.from('blogs').insert({
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'image_url': imageUrl,
        'author': userName,
        'author_img': userAvatar,
        'date': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Blog posted successfully!")),
      );
      print(" Blog posted successfully!");
    } catch (e) {
      print(" Error saving blog: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving blog: $e")));
    }
  }

  /// data fetch from supabase -------------------------------------------------

  Future<List<Map<String, dynamic>>> fetchBlogs({
    int page = 1,
    int limit = 5,
  }) async {
    final from = (page - 1) * limit;
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase
          .from('blogs')
          .select()
          .order('date', ascending: false)
          .range(from, from + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print(" Error fetching blogs: $e");
      return [];
    }
  }

  //// For demo purpose/////////////////////////////////
  //   Future<void> uploadAllBlogs(List<Blog> blogs) async {
  //     for (var blog in blogs) {
  //       try {
  //         final response = await supabase.from('blogs').insert({
  //           'title': blog.title,
  //           'subtitle': blog.subtitle,
  //           'author': blog.author,
  //           'date': blog.date.toIso8601String(), // DateTime -> String
  //           'image': blog.image,
  //           'author_img': blog.authorImg,
  //           'content': jsonEncode(blog.content), // List -> JSON string
  //         });
  //         print('Uploaded blog: ${blog.title}');
  //       } catch (e) {
  //         print('Error uploading blog: ${blog.title}, $e');
  //       }
  //     }
  //   }
  /////////////////////////////////////////
}
