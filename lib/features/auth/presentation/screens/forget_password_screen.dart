import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/helpers/app_validators.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/widgets/custom_button.dart';
import 'package:tadweer/core/widgets/custom_text_form_field.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushReplacement(Routes.loginView);
          },
          icon: Icon(Icons.arrow_back_ios, color: textTheme.bodyLarge!.color),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 25,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forget Password',
              style: AppTextStyles.font32SemiBold.copyWith(
                color: textTheme.bodyLarge!.color,
              ),
            ),
            Text(
              'enter your email address and we will send you a link to reset your password',
              style: AppTextStyles.font16Regular.copyWith(
                color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
            Text('Email', style: AppTextStyles.font14Regular),
            AppTextFormField(
              controller: emailController,
              hintText: 'Email',
              validator: (value) => AppValidators.email(value),
            ),
            CustomButton(text: 'Reset Password', onTap: () async {}),
          ],
        ),
      ),
    );
  }
}
