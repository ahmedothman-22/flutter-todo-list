import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';    
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/features/home/presentation/widgets/change_acount_image.dart';
import 'package:tadweer/features/home/presentation/widgets/change_acount_name.dart';
import 'package:tadweer/features/home/presentation/widgets/change_acount_password.dart';
import 'package:tadweer/features/home/presentation/widgets/log_out.dart';
import 'package:tadweer/features/home/presentation/widgets/number_of_task_done_or_left.dart';
import 'package:tadweer/features/home/presentation/widgets/profile_list_tile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? user = FirebaseAuth.instance.currentUser;
  String accountName = "Loading...";
  String? imagePath;
  int doneTasksCount = 0;
  int leftTasksCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchTaskStats();
    _loadLocalImage();
  }

  // جلب اسم المستخدم من Firestore
  Future<void> _fetchUserData() async {
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && mounted) {
        setState(() {
          accountName = "${doc.data()?['firstName'] ?? ''} ${doc.data()?['lastName'] ?? ''}";
        });
      }
    }
  }

  // جلب إحصائيات التاسكات من Firestore
  Future<void> _fetchTaskStats() async {
    if (user != null) {
      final tasksQuery = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: user!.uid)
          .get();

      int done = 0;
      int left = 0;

      for (var doc in tasksQuery.docs) {
        if (doc.data()['isDone'] == true) {
          done++;
        } else {
          left++;
        }
      }

      if (mounted) {
        setState(() {
          doneTasksCount = done;
          leftTasksCount = left;
        });
      }
    }
  }

  Future<void> _loadLocalImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePath = prefs.getString('profile_image_path');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 16.0.w, right: 16.w, top: 16.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                'Profile',
                style: AppTextStyles.font24Regular.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
              SizedBox(height: 20.h),
              
              // الصورة الشخصية
              CircleAvatar(
                radius: 40.r,
                backgroundColor: Colors.grey[300],
                backgroundImage: imagePath != null && File(imagePath!).existsSync()
                    ? FileImage(File(imagePath!))
                    : (user?.photoURL != null 
                        ? NetworkImage(user!.photoURL!) 
                        : const AssetImage('assets/images/profile.jpg')) as ImageProvider,
              ),

              SizedBox(height: 12.h),
              Text(
                accountName,
                style: AppTextStyles.font16Regular.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
              
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NumberOfTaskDoneOrLeft(text: '$leftTasksCount Tasks Left'),
                  NumberOfTaskDoneOrLeft(text: '$doneTasksCount Tasks Done'),
                ],
              ),

              Divider(height: 40.h, color: Colors.grey, thickness: .5, endIndent: 15.w, indent: 15.w),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'App Settings',
                    style: AppTextStyles.font16Regular.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                      ProfileListTile(
                        title: 'Settings',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Settings feature will be available in the next update!',
                                style: AppTextStyles.font14Regular.copyWith(color: Colors.white),
                              ),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: Icons.settings,
                      ),
                  Divider(height: 30.h, color: Colors.grey, thickness: .5, endIndent: 15.w, indent: 15.w),
                  Text(
                    'Account',
                    style: AppTextStyles.font24Regular.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const ChangeAcountName(),
                  const ChangeAcountPassword(),
                  const ChangeAcountImage(),
                  Divider(height: 30.h, color: Colors.grey, thickness: .5, endIndent: 15.w, indent: 15.w),
                  const LogOut(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}