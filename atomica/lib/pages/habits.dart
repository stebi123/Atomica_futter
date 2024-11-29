import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HabitPage extends StatefulWidget {
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  String reportText = '';
  List<String> generatedTasks = [];

  final TextEditingController currentStageController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController situationController = TextEditingController();

  // Method to save habit data to a JSON file
  Future<void> saveDataToFile(Map<String, String> data) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/habit_data.json');

      if (await file.exists()) {
        final fileContent = await file.readAsString();
        final List<dynamic> habitData = json.decode(fileContent);
        habitData.add(data);
        await file.writeAsString(json.encode(habitData));
      } else {
        await file.writeAsString(json.encode([data]));
      }
    } catch (error) {
      print('Error saving data to file: $error');
    }
  }

  // Method to send the data to the API
  Future<void> submitReport(
    String currentStage,
    String goal,
    String situation,
    Function(String, List<String>) updateReport,
  ) async {
    // Change the URL based on the platform (localhost for emulator)
    final url = Uri.parse('http://10.0.2.2:8000/generate-goal-report'); // Use 10.0.2.2 for Android emulator

    final Map<String, String> data = {
      'current_stage': currentStage,
      'goal': goal,
      'situation': situation,
    };

    // Save data to JSON file before posting
    await saveDataToFile(data);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final report = responseData['report'];
        final tasks = List<String>.from(responseData['tasks']);

        updateReport(report, tasks);
      } else {
        updateReport('Failed to generate report. Please try again.', []);
      }
    } catch (error) {
      updateReport('Error: $error', []);
    }
  }

  void updateReport(String report, List<String> tasks) {
    setState(() {
      reportText = report;
      generatedTasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF65E892),
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Your Details:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              buildInputField('Current Stage', currentStageController),
              SizedBox(height: 16),
              buildInputField('Goal', goalController),
              SizedBox(height: 16),
              buildInputField('Describe Your Situation', situationController, isMultiLine: true),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await submitReport(
                    currentStageController.text,
                    goalController.text,
                    situationController.text,
                    updateReport,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF65E892),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  elevation: 5,
                ),
                child: Text(
                  'Submit Report',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 30),
              if (reportText.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))],
                  ),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generated Report:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        reportText,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
              if (generatedTasks.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generated Tasks:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    ...generatedTasks.map((task) => Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              task,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            leading: Icon(Icons.check_circle, color: Colors.green),
                          ),
                        )),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller, {bool isMultiLine = false}) {
    return TextField(
      controller: controller,
      maxLines: isMultiLine ? 5 : 1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF65E892), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      ),
      style: TextStyle(color: Colors.black87),
    );
  }
}
