import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadweer/core/helpers/shared_pref_helper.dart';
import 'package:tadweer/core/routing/app_router.dart';
import 'my_app.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // init Flutter
  await Firebase.initializeApp();
  await SharedPrefHelper.init();
  await ScreenUtil.ensureScreenSize();
  AppRouter.initRouter();

  runApp(MyApp());
}
