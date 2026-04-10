import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/helpers/extensions.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/widgets/custom_button.dart';

class EmailVerifiedScreen extends StatefulWidget {
  const EmailVerifiedScreen({super.key});

  @override
  State<EmailVerifiedScreen> createState() => _EmailVerifiedScreenState();
}

class _EmailVerifiedScreenState extends State<EmailVerifiedScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              30.h.ph,
              Text(
                'Email Verified',
                style: AppTextStyles.font24Regular.copyWith(
                  color: textTheme.bodyLarge!.color,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.h),
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: DarkAppColors.grey900.withValues(alpha: .1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  color: DarkAppColors.primary800.withValues(alpha: .4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: DarkAppColors.primary800,
                ),
              ),
              10.h.ph,
              Text(
                'Please check your email and click on the verification link to verify your email address.',
                style: AppTextStyles.font18Regular.copyWith(
                  color: DarkAppColors.grey500,
                ),
                textAlign: TextAlign.center,
              ),
              20.h.ph,
              Container(
                padding: EdgeInsets.all(16.h),
                margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: DarkAppColors.grey900.withValues(alpha: .1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: DarkAppColors.primary800),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 35.sp,
                      color: DarkAppColors.primary800,
                    ),
                    10.h.ph,
                    Text(
                      'Already verified your email?',
                      style: AppTextStyles.font16Regular.copyWith(
                        color: DarkAppColors.grey0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    5.h.ph,
                    Text(
                      'Tap below to log in.',
                      style: AppTextStyles.font14Regular.copyWith(
                        color: DarkAppColors.grey500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              40.h.ph,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: CustomButton(
                      color: DarkAppColors.grey900,
                      text: 'Reset Email',
                      width: 150.w,
                      hight: 50.h,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: CustomButton(
                      onTap: () {
                        GoRouter.of(context).push(Routes.loginView);
                      },
                      text: 'Go to Login',
                      width: 150.w,
                      hight: 50.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
