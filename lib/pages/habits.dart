import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HabitPage extends StatefulWidget {
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  String initialReport = '';
  String executionPlan = '';
  String goal = '';
  Map<String, dynamic> apiResponseUsage = {};

  final TextEditingController currentStageController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController situationController = TextEditingController();

  Future<void> submitReport(
    String currentStage,
    String goal,
    String situation,
    Function(String, String, String, Map<String, dynamic>) updateReport,
  ) async {
    final url = Uri.parse('http://127.0.0.1:8000/generate-goal-roadmap');

    final Map<String, String> data = {
      'current_stage': currentStage,
      'goal': goal,
      'situation': situation,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final initialReportText = responseData['initial_report']['llm_response'];
        final executionPlanText = responseData['execution_plan']['llm_response'];
        final apiGoal = responseData['goal'];
        final usage = responseData['initial_report']['usage'];

        updateReport(initialReportText, executionPlanText, apiGoal, usage);
      } else {
        updateReport('Failed to generate report', '', '', {});
      }
    } catch (error) {
      updateReport('Error: $error', '', '', {});
    }
  }

  void updateReport(
    String initialReportText,
    String executionPlanText,
    String apiGoal,
    Map<String, dynamic> usage,
  ) {
    setState(() {
      initialReport = initialReportText;
      executionPlan = executionPlanText;
      goal = apiGoal;
      apiResponseUsage = usage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF65E892),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Your Details:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
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
              if (goal.isNotEmpty)
                buildResultContainer('Goal:', goal),
              SizedBox(height: 20),
              if (initialReport.isNotEmpty)
                buildResultContainer('Initial Report:', initialReport),
              SizedBox(height: 20),
              if (executionPlan.isNotEmpty)
                buildResultContainer('Execution Plan:', executionPlan),
              SizedBox(height: 20),
              if (apiResponseUsage.isNotEmpty)
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
                        'API Usage Details:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      ...apiResponseUsage.entries.map((entry) => Text(
                        '${entry.key}: ${entry.value}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      )).toList(),
                    ],
                  ),
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

  Widget buildResultContainer(String title, String content) {
    return Container(
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
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
