import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/features/home/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.taskModel});
  final TaskModel taskModel;

  @override
  Widget build(BuildContext context) {
    DateFormat formattedDate = DateFormat('dd-MM-yyyy');

    return Card(
      shadowColor: Colors.grey.shade300,
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color: Colors.grey.shade100,
      child: Slidable(
        key: ValueKey(taskModel.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: .5,
          children: [
            SlidableAction(
              onPressed: (BuildContext context) {
                showDialog(
                  context: context,
                  builder: (dialogContext) { 
                    return AlertDialog(
                      title: const Text('Delete Task'),
                      content: const Text(
                        'Are you sure you want to delete this task?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (taskModel.id.isNotEmpty) {
                              await FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(taskModel.id)
                                  .delete();
                            }
                            if (dialogContext.mounted) Navigator.pop(dialogContext);
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
            ),
            SlidableAction(
              onPressed: (context) {
                GoRouter.of(context).push(Routes.taskediting, extra: taskModel);
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.edit_outlined,
              label: 'Edit',
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                height: 75.h,
                width: 4.w,
                decoration: BoxDecoration(
                  color: taskModel.isDone ? Colors.green : DarkAppColors.primary800,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 15.w),
              Expanded( // أضفنا Expanded هنا عشان لو النص طويل ما يعملش Overflow
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      taskModel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14Regular.copyWith(
                        color: taskModel.isDone ? Colors.green : Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: taskModel.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      taskModel.details,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font14Regular.copyWith(
                        color: Colors.grey,
                        decoration: taskModel.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        const Icon(Icons.category, size: 16, color: Colors.grey),
                        SizedBox(width: 5.w),
                        Text(
                          taskModel.category,
                          style: AppTextStyles.font14Regular.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (taskModel.id.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(taskModel.id)
                            .update({'isDone': !taskModel.isDone}); 
                      }
                    },
                    child: taskModel.isDone
                        ? Container(
                            height: 35.h,
                            width: 60.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.transparent, 
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Text(
                              'Done!',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: DarkAppColors.primary800,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            height: 35.h,
                            width: 60.w,
                            child: Icon(Icons.check, color: Colors.white, size: 24.sp),
                          ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_month, size: 16.sp, color: Colors.grey),
                      SizedBox(width: 5.w),
                      Text(
                        formattedDate.format(taskModel.date),
                        style: AppTextStyles.font12Regular.copyWith(color: Colors.grey),
                      ),
                    ],
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