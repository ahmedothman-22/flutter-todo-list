import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/widgets/custom_button.dart';
import 'package:tadweer/features/home/presentation/widgets/select_date_category.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTasksBottomSheet extends StatefulWidget {
  const AddTasksBottomSheet({super.key});

  @override
  State<AddTasksBottomSheet> createState() => _AddTasksBottomSheetState();
}

class _AddTasksBottomSheetState extends State<AddTasksBottomSheet> {
  final TextEditingController taskNamecontroller = TextEditingController();
  final TextEditingController taskDetailscontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  String selectedCategory = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Task',
                style: AppTextStyles.font16Regular.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15.h),
              AppTextFormField(
                hintText: 'Task Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The field is required';
                  }
                  return null;
                },
                controller: taskNamecontroller,
              ),
              SizedBox(height: 15.h),
              AppTextFormField(
                hintText: 'Task Details',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The field is required';
                  }
                  return null;
                },
                maxLines: 4,
                controller: taskDetailscontroller,
              ),
              SizedBox(height: 15.h),
              SelectDateandcategory(
                onDateSelected: (date) {
                  selectedDate = DateTime(date.year, date.month, date.day);
                },
                onCategorySelected: (category) {
                  selectedCategory = category;
                },
              ),
              SizedBox(height: 15.h),
              CustomButton(
                onTap: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final String uid = FirebaseAuth.instance.currentUser!.uid;
                            var newDocRef = FirebaseFirestore.instance.collection('tasks').doc();
                            
                            Map<String, dynamic> taskData = {
                              'id': newDocRef.id,
                              'userId': uid,
                              'name': taskNamecontroller.text.trim(),
                              'details': taskDetailscontroller.text.trim(),
                              'date': Timestamp.fromDate(selectedDate ?? DateTime.now()),
                              'category': selectedCategory.isEmpty ? 'General' : selectedCategory, 
                              'isDone': false,
                              'createdAt': FieldValue.serverTimestamp(),
                            };

                            await newDocRef.set(taskData);

                            if (mounted) {
                              Navigator.pop(context);
                            }
                          } catch (error) {
                            debugPrint("Error: $error");
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        }
                      },
                text: isLoading ? 'Loading...' : 'Add Task',
                color: DarkAppColors.primary800,
                width: MediaQuery.of(context).size.width,
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}