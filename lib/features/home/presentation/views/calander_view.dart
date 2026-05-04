import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ضفنا الـ import ده
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/features/home/models/task_model.dart';
import 'package:tadweer/features/home/presentation/widgets/custom_scaffold_bg.dart';
import 'package:tadweer/features/home/presentation/widgets/task_card.dart';

class CalanderView extends StatefulWidget {
  const CalanderView({super.key});

  @override
  State<CalanderView> createState() => _CalanderViewState();
}

class _CalanderViewState extends State<CalanderView> {
  final EasyDatePickerController controller = EasyDatePickerController();
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldBg(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: DarkAppColors.primary800,
        title: Text(
          'Calendar',
          style: AppTextStyles.font18SemiBold.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          EasyDateTimeLinePicker.itemBuilder(
            controller: controller,
            firstDate: DateTime(2025, 1, 1),
            currentDate: DateTime.now(),
            lastDate: DateTime(2030, 3, 18),
            focusedDate: selectedDate,
            itemExtent: 70.0.sp,
            itemBuilder: (context, date, isSelected, isDisabled, isToday, onTap) {
              return InkResponse(
                onTap: onTap,
                child: Container(
                  width: 35.0.w,
                  height: 45.0.h,
                  decoration: BoxDecoration(
                    color: isSelected ? DarkAppColors.primary800 : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected ? DarkAppColors.primary800 : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat.MMM().format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat.E().format(date),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            onDateChange: (newDate) {
              setState(() {
                selectedDate = DateTime(
                  newDate.year,
                  newDate.month,
                  newDate.day,
                );
              });
            },
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tasks')
                  .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildNoTasksWidget();
                }

                var docs = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var task = TaskModel.fromJson(
                      docs[index].data() as Map<String, dynamic>,
                    );
                    
                    task.id = docs[index].id;

                    return TaskCard(taskModel: task);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoTasksWidget() {
    return SingleChildScrollView( 
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Image.asset('assets/images/checklist.png', height: 80.h, width: 80.w),
          SizedBox(height: 20.h),
          Text(
            'No tasks for this day',
            style: AppTextStyles.font18Regular.copyWith(
              color: DarkAppColors.primary800,
            ),
          ),
          Text(
            'Let\'s add some tasks!',
            style: AppTextStyles.font16Regular.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}