import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:tadweer/features/home/models/task_model.dart';

class ChatService {
  static const String _apiKey = 'AIzaSyDmercOQmHAPuk7gMLOC_rqfCDqY5pLC1E';
  
  final GenerativeModel _model;

  ChatService()
      : _model = GenerativeModel(
          model: 'gemini-2.5-flash', 
          apiKey: _apiKey,
        );

  Future<String> getChatResponse(String userPrompt, List<TaskModel> tasks) async {
    try {
      // 1. Convert the list of TaskModels into a readable string for the AI
      String tasksContext = tasks.isEmpty 
          ? "The user has no tasks currently." 
          : tasks.map((t) => "- ${t.name}: ${t.details} (Date: ${t.date}, Category: ${t.category}, Status: ${t.isDone ? 'Completed' : 'Pending'})").join("\n");

      // 2. Create a System Prompt to give the AI its identity and data
final fullPrompt = """
You are a strict AI productivity assistant.

RULES:
- Use ONLY the tasks below.
- If information is not in tasks, say: "Not found in your tasks."
- Do NOT guess.

TASKS:
$tasksContext

USER QUESTION:
$userPrompt
""";

      final content = [Content.text(fullPrompt)];
      final response = await _model.generateContent(content);
      
      return response.text ?? "I'm sorry, I couldn't process that.";
    } catch (e) {
      return "Error: Check your connection or API settings.";
    }
  }
}