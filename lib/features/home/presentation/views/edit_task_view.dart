import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tadweer/core/routing/routes.dart';
import 'package:tadweer/core/theme/app_colors/dark_app_colors.dart';
import 'package:tadweer/core/theme/app_texts/app_text_styles.dart';
import 'package:tadweer/core/widgets/custom_button.dart';
import 'package:tadweer/core/widgets/custom_text_form_field.dart';
import 'package:tadweer/features/home/models/task_model.dart';
import 'package:tadweer/features/home/presentation/widgets/category_selector.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController categoryController;
  late DateTime selectedDate;
  late bool isDone;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.task.name);
    detailsController = TextEditingController(text: widget.task.details);
    categoryController = TextEditingController(text: widget.task.category);
    selectedDate = widget.task.date;
    isDone = widget.task.isDone;
  }

  @override
  void dispose() {
    nameController.dispose();
    detailsController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: AppTextStyles.font16Regular.copyWith(
            color: colorScheme.secondary,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).pushReplacement(Routes.homeview);
          },
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.secondary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15.h,
          children: [
            Text(
              'Task Name',
              style: AppTextStyles.font16Regular.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            AppTextFormField(
              hintText: 'Task Name',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The field is required';
                }
                return null;
              },
              controller: nameController,
            ),
            Text(
              'Task Details',
              style: AppTextStyles.font16Regular.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            AppTextFormField(
              hintText: 'Task Details',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The field is required';
                }
                return null;
              },
              controller: detailsController,
            ),
            Text(
              'Task Category',
              style: AppTextStyles.font16Regular.copyWith(
                color: colorScheme.secondary,
              ),
            ),
            AppTextFormField(
              hintText: 'Task Category',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The field is required';
                }
                return null;
              },
              controller: categoryController,
              suffixIcon: IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return CategorySelector(
                        onCategorySelected: (category) {
                          setState(() {
                            categoryController.text = category;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                icon: Icon(Icons.category, color: DarkAppColors.primary800),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.calendar_today),
                SizedBox(width: 8.w),
                Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
                const Spacer(),
                TextButton(
                  onPressed: () => _pickDate(context),
                  child: const Text('Change Date'),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Task Status',
                  style: AppTextStyles.font16Regular.copyWith(
                    color: colorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: isDone,
                  activeColor: DarkAppColors.primary800,
                  inactiveThumbColor: colorScheme.secondary,
                  inactiveTrackColor: Colors.grey,
                  onChanged: (value) {
                    setState(() {
                      isDone = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 40.h),
            CustomButton(
              width: double.infinity,
              color: DarkAppColors.primary800,
              onTap: isLoading
                  ? null
                  : () async {
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        await FirebaseFirestore.instance
                            .collection('tasks')
                            .doc(widget.task.id)
                            .update({
                              'name': nameController.text.trim(),
                              'details': detailsController.text.trim(),
                              'category': categoryController.text.trim(),
                              'date': Timestamp.fromDate(selectedDate),
                              'isDone': isDone,
                            });

                        if (mounted) {
                          GoRouter.of(context).pushReplacement(Routes.homeview);
                        }
                      } catch (error) {
                        print("Error updating task: $error");
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
              text: isLoading ? 'Saving...' : 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }
}
