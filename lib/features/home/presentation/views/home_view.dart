import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/features/home/presentation/views/calander_view.dart';
import 'package:tadweer/features/home/presentation/views/index_view.dart';
import 'package:tadweer/features/home/presentation/views/profie_view.dart';
import 'package:tadweer/features/home/presentation/widgets/add_tasks_bottom_sheet.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  final List<Widget> tabs = const [IndexView(), CalanderView(), ProfileView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: currentIndex == 1
          ? Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: FloatingActionButton(
                backgroundColor: DarkAppColors.primary800,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.0),
                      ),
                    ),
                    builder: (context) {
                      return const AddTasksBottomSheet();
                    },
                  );
                },
                shape: const StadiumBorder(),
                child: const Icon(Icons.add, size: 25, color: Colors.white),
              ),
            )
          : null,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 16.0.h, bottom: 8.0.h),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          onTap: (tappedIndex) {
            setState(() {
              currentIndex = tappedIndex;
            });
          },
          selectedItemColor: DarkAppColors.primary800,
          unselectedItemColor: const Color.fromARGB(255, 158, 157, 158),
          elevation: 0,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 24),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}