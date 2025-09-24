// ignore_for_file: deprecated_member_use

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:foodieland/core/app_routes.dart';
import 'package:foodieland/utils/app_theme/app_theme.dart';
import 'package:get/get.dart';

import '../features/splash_screen/splash_screens.dart';
import 'dependency_injection/dependency_injection.dart';

class FoodieLand extends StatefulWidget {
  const FoodieLand({super.key});

  @override
  State<FoodieLand> createState() => _FoodieLandState();
}

class _FoodieLandState extends State<FoodieLand> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialBinding: DependencyInjection(),
      initialRoute: SplashScreen.routeName,
      onGenerateRoute: AppRoutes.routes,
      theme: AppTheme.lightThemeData,
    );
  }
}
