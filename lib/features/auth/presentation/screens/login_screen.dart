import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/helpers/app_validators.dart';
import 'package:tadweer/core/helpers/extensions.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/widgets/custom_button.dart';
import 'package:tadweer/core/widgets/custom_text_form_field.dart';
import 'package:tadweer/features/auth/presentation/widgets/custom_devider.dart';
import 'package:tadweer/features/auth/presentation/widgets/custom_social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final passwordFocusNode = FocusNode();
  String? email;
  String? password;
  bool isshown = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                SizedBox(height: 50.h),
                Text(
                  'Login',
                  style: AppTextStyles.font32SemiBold.copyWith(
                    color: textTheme.bodyLarge!.color,
                  ),
                ),
                SizedBox(height: 15.h),
                Text('Email', style: AppTextStyles.font14Regular),
                4.h.ph,
                AppTextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  hintText: 'Email',
                  validator: (value) => AppValidators.email(value),
                  prefixIcon: Icon(
                    Icons.email,
                    size: 20,
                    color: DarkAppColors.primary800,
                  ),
                  focusNode: passwordFocusNode,
                  controller: emailController,
                ),
                8.h.ph,
                Text('Password', style: AppTextStyles.font14Regular),
                4.h.ph,
                AppTextFormField(
                  isObscureText: isshown,
                  onChanged: (value) {
                    password = value;
                  },
                  hintText: 'Password',
                  validator: (value) => AppValidators.password(value),
                  suffixIcon: isshown
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              isshown = !isshown;
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
                              isshown = !isshown;
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
                  controller: passwordController,
                  maxLines: 1,
                ),
                TextButton(
                  onPressed: () {
                    GoRouter.of(context).push(Routes.forgetpasssword);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Forget Password ?',
                      style: AppTextStyles.font12SemiBold.copyWith(
                        color: Color(0xff8875FF),
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {}
                  },
                  text: 'Login',
                ),
                SizedBox(height: 10.h),
                CustomDevider(),
                SizedBox(height: 10.h),
                CustomButtonSignupLogin(
                  onTap: () async {
                    // LoginMethods.signInWithGoogle(context);
                  },
                  image: 'google.svg',
                  text: 'Login with Google',
                  color: Color(0xff000000),
                  width: MediaQuery.of(context).size.width,
                ),
                CustomButtonSignupLogin(
                  onTap: () async {},
                  image: 'facebook.svg',
                  text: 'Login with Facebook',
                  color: Color(0xff000000),
                  width: MediaQuery.of(context).size.width,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account ?",
                      style: AppTextStyles.font12Regular,
                    ),
                    TextButton(
                      onPressed: () {
                        GoRouter.of(
                          context,
                        ).pushReplacement(Routes.registerView);
                      },
                      child: Text(
                        '   Register',
                        style: AppTextStyles.font12SemiBold.copyWith(
                          color: Color(0xff8875FF),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
