import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/features/home/models/task_model.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  File? _profileImage;
  final User? user = FirebaseAuth.instance.currentUser;
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _getUserName();
  }

  // دالة لجلب الاسم من الفايرستور
  Future<void> _getUserName() async {
    if (user != null) {
      var doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          // دمج الاسم الأول والأخير
          userName =
              "${doc.data()?['firstName'] ?? ''} ${doc.data()?['lastName'] ?? ''}";
        });
      }
    }
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && mounted) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 16.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome back 👋',
              style: AppTextStyles.font14Regular.copyWith(
                color: textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
            Text(
              // الترتيب: الاسم من فايرستور -> الاسم من Auth -> قيمة افتراضية
              userName ?? user?.displayName ?? 'User',
              style: AppTextStyles.font18Bold.copyWith(
                color: textTheme.bodyLarge?.color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          // Chatbot Button
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: DarkAppColors.primary800.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(
                Icons.smart_toy_outlined,
                color: DarkAppColors.primary800,
                size: 22.sp,
              ),
              onPressed: () =>
                  context.push(Routes.chatbot, extra: <TaskModel>[]),
            ),
          ),
          // Profile Image
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : const AssetImage('assets/images/profile.jpg'))
                        as ImageProvider,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/home_image.png', height: 240.h),
                SizedBox(height: 24.h),
                Text(
                  'Stay productive today 🚀',
                  style: AppTextStyles.font20Regular.copyWith(
                    color: textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  user?.email ?? 'Your personal task manager',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.font16SemiBold.copyWith(
                    color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
