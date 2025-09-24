import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodieland/core/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/blog/blog_repository/blog_repo_function.dart';
//import 'features/blog/data/blog_data.dart';



final repository = BlogRepository(supabase: Supabase.instance.client);
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.env["URL"]!,
    anonKey: dotenv.env["ANON_KEY"]!,
  );


  // Upload all blogs
 // await repository.uploadAllBlogs(blogList);


  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => FoodieLand(), // Wrap your app
    ),
  );
}
