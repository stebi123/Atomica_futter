import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

Future<void> submitReport(
    String currentStage, String goal, String description, Function updateReport) async {
  final url = Uri.parse('http://127.0.0.1:8000/generate-goal-report');
  
  try {
    // Make a POST request to the API
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'current_stage': currentStage,
        'goal': goal,
        'description': description,
      }),
    );

    // Check if the response is successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      
      // Pass the generated report and tasks to the callback function
      updateReport(data['report']);
    } else {
      // Handle failure response
      throw Exception('Failed to generate report');
    }
  } catch (e) {
    // Handle errors
    print('Error: $e');
  }
}
