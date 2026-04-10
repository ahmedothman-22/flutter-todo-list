import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/helpers/app_validators.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/widgets/custom_button.dart';
import 'package:tadweer/core/widgets/custom_text_form_field.dart';
import 'package:tadweer/features/auth/presentation/widgets/custom_devider.dart';
import 'package:tadweer/features/auth/presentation/widgets/custom_social_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final passwordFocusNode = FocusNode();
  final confirmpasswordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordShown = true;
  bool isConfirmPasswordShown = true;
  String? email;
  String? password;
  String? confirmPassword;
  String? userName;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.h,
                children: [
                  SizedBox(height: 50.h),
                  Text(
                    'Register',
                    style: AppTextStyles.font32SemiBold.copyWith(
                      color: textTheme.bodyLarge!.color,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.h,
                        children: [
                          Text(
                            'First Name',
                            style: AppTextStyles.font14Regular,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,

                            child: AppTextFormField(
                              controller: firstNameController,
                              onChanged: (firstName) {
                                setState(() {
                                  firstName = firstName;
                                });
                              },
                              hintText: 'First Name',
                              validator: (value) => AppValidators.name(value),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.h,
                        children: [
                          Text('Last Name', style: AppTextStyles.font14Regular),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.43,
                            child: AppTextFormField(
                              controller: lastNameController,
                              hintText: 'Last Name',
                              validator: (value) => AppValidators.name(value),
                              maxLines: 1,
                              onChanged: (lastName) {
                                setState(() {
                                  lastName = lastName;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text('Email', style: AppTextStyles.font14Regular),
                  AppTextFormField(
                    maxLines: 1,
                    onChanged: (data) {
                      setState(() {
                        email = data;
                      });
                    },
                    hintText: 'Email',
                    validator: (value) => AppValidators.email(value),
                    prefixIcon: Icon(
                      Icons.email,
                      size: 20.sp,
                      color: DarkAppColors.primary800,
                    ),
                    focusNode: passwordFocusNode,
                    controller: emailController,
                  ),
                  Text('Password', style: AppTextStyles.font14Regular),
                  AppTextFormField(
                    maxLines: 1,
                    isObscureText: isPasswordShown,
                    onChanged: (data) {
                      setState(() {
                        password = data;
                      });
                    },
                    hintText: 'Password',
                    validator: (value) => AppValidators.password(value),
                    suffixIcon: isPasswordShown
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordShown = !isPasswordShown;
                              });
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: colorScheme.secondary,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordShown = !isPasswordShown;
                              });
                            },
                            icon: Icon(
                              Icons.visibility_off,
                              color: colorScheme.secondary,
                            ),
                          ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      size: 20.sp,
                      color: DarkAppColors.primary800,
                    ),
                    focusNode: confirmpasswordFocusNode,
                    controller: passwordController,
                  ),
                  Text('Confirm Password', style: AppTextStyles.font14Regular),
                  AppTextFormField(
                    maxLines: 1,
                    isObscureText: isConfirmPasswordShown,
                    onChanged: (data) {
                      setState(() {
                        confirmPassword = data;
                      });
                    },
                    hintText: 'Confirm Password',
                    validator: (value) => AppValidators.confirmPassword(
                      value,
                      passwordController.text,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      size: 20.sp,
                      color: DarkAppColors.primary800,
                    ),
                    controller: confirmPasswordController,
                    suffixIcon: isConfirmPasswordShown
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordShown =
                                    !isConfirmPasswordShown;
                              });
                            },
                            icon: Icon(
                              Icons.visibility,
                              color: colorScheme.secondary,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordShown =
                                    !isConfirmPasswordShown;
                              });
                            },
                            icon: Icon(
                              Icons.visibility_off,
                              color: colorScheme.secondary,
                            ),
                          ),
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    text: 'Register',
                    color: DarkAppColors.primary800,
                    width: MediaQuery.of(context).size.width,
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        GoRouter.of(context).push(Routes.emailVerifiedView);
                      }
                    },
                  ),
                  SizedBox(height: 5.h),
                  CustomDevider(),
                  SizedBox(height: 5.h),
                  CustomButtonSignupLogin(
                    image: 'google.svg',
                    text: 'Register with Google',
                    color: Color(0xff000000),
                    width: MediaQuery.of(context).size.width,
                  ),
                  CustomButtonSignupLogin(
                    image: 'facebook.svg',
                    text: 'Register with Facebook',
                    color: Color(0xff000000),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'already have an account ?',
                        style: AppTextStyles.font12Regular.copyWith(
                          color: textTheme.bodyMedium!.color,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(
                            context,
                          ).pushReplacement(Routes.loginView);
                        },
                        child: Text(
                          '   Login',
                          style: AppTextStyles.font14Regular.copyWith(
                            color: DarkAppColors.primary800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
