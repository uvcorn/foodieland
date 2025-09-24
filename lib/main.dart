import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodieland/core/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/blog/blog_repository/blog_repo_function.dart';

final repository = BlogRepository(supabase: Supabase.instance.client);
void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: dotenv.env["URL"]!,
    anonKey: dotenv.env["ANON_KEY"]!,
  );

  runApp(FoodieLand());
}
