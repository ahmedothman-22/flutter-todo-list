import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tadweer/core/helpers/shared_pref_helper.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/utils/shared_pref_keys.dart';
import 'package:tadweer/core/widgets/custom_button.dart';
import 'package:tadweer/features/onboarding/presentation/widgets/custom_page_Indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboard1.png",
      "title": "Manage your tasks",
      "desc": "You can easily manage all of your daily tasks in DoMe for free",
    },
    {
      "image": "assets/images/onboard2.png",
      "title": "Create daily routine",
      "desc": "Plan your day and stay organized بسهولة",
    },
    {
      "image": "assets/images/onboard3.png",
      "title": "Achieve your goals",
      "desc": "Track your progress and reach your goals faster",
    },
  ];

  void nextPage() {
    if (currentIndex == pages.length - 1) {
      SharedPrefHelper.setData(
        key: SharedPrefKeys.kIsOnBoardingSeen,
        value: true,
      );
      GoRouter.of(context).pushReplacement(Routes.loginView);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() async {
    await SharedPrefHelper.setData(
      key: SharedPrefKeys.kIsOnBoardingSeen,
      value: true,
    );
    if (!mounted) return;
    GoRouter.of(context).pushReplacement(Routes.loginView);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            const Spacer(),

            /// 🔹 PageView
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 🔹 التعديل هنا: حطينا الصورة جوه Expanded وحطينا fit
                      Expanded(
                        child: Image.asset(
                          page["image"]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        page["title"]!,
                        style: AppTextStyles.font32Regular.copyWith(
                          color: textTheme.bodyLarge!.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        page["desc"]!,
                        style: AppTextStyles.font14Regular.copyWith(
                          color: textTheme.bodyMedium!.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),

            const Spacer(),

            PageIndicator(currentIndex: currentIndex, totalPages: pages.length),

            const Spacer(),

            /// 🔹 Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onTap: skip,
                  text: "Skip",
                  color: Colors.black,
                  width: 90.w,
                ),
                CustomButton(
                  width: 90.w,
                  text: currentIndex == pages.length - 1 ? "Done" : "Next",
                  onTap: nextPage,
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}