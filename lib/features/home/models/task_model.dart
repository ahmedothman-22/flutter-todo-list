import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String name;
  String details;
  DateTime date;
  String category;
  bool isDone;
  String id;
  String userId; 

  TaskModel({
    required this.name,
    required this.details,
    required this.date,
    required this.category,
    required this.userId, 
    this.id = '',
    this.isDone = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'date': date, 
      'category': category,
      'isDone': isDone,
      'userId': userId, 
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      details: json['details'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
      category: json['category'] ?? '',
      isDone: json['isDone'] ?? false,
      userId: json['userId'] ?? '', 
    );
  }
}