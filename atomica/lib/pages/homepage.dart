import 'package:flutter/material.dart';
import 'package:atomica/pages/about.dart';
import 'package:atomica/pages/habits.dart';
import 'package:atomica/pages/history.dart';
import 'package:atomica/pages/profile.dart';
import 'package:animated_text_kit/animated_text_kit.dart';  // Import the package

class HabitHomePage extends StatefulWidget {
  @override
  _HabitHomePageState createState() => _HabitHomePageState();
}

class _HabitHomePageState extends State<HabitHomePage> {
  int _selectedIndex = 0;  // Default selected index for the navigation bar
  List<String> toDoTasks = [];  // List to store to-do tasks
  List<String> completedTasks = [];  // List to store completed tasks
  List<String> historyTasks = [];  // List to store task history
  TextEditingController taskController = TextEditingController();  // Controller for input field

  // Function to handle bottom navbar item taps
  void _onNavBarTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HabitPage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage(historyTasks: historyTasks)));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else if (index == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
    }
  }

  // Function to mark task as complete
  void completeTask(int index) {
    setState(() {
      completedTasks.add(toDoTasks[index]);
      historyTasks.add(toDoTasks[index]);
      toDoTasks.removeAt(index);
    });
  }

  // Function to add a new task
  void addTask() {
    String newTask = taskController.text.trim();
    if (newTask.isNotEmpty) {
      setState(() {
        toDoTasks.add(newTask);
        taskController.clear();
      });
    }
  }

  // Build the habit home page UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          child:  AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Actomica',
                textStyle: TextStyle(
                  fontSize: 22.0, // Adjusted for better readability
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                speed: Duration(milliseconds: 100), // Typing speed
              ),
              FadeAnimatedText(
                'Reach your goal on time..',
                textStyle: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(179, 0, 0, 0),
                ),
                duration: Duration(milliseconds: 2000), // Fade duration
              ),
              RotateAnimatedText(
                'Habits to Goals',
                textStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                duration: Duration(milliseconds: 1500),
              ),
            ],
            repeatForever: true,
            pause: Duration(milliseconds: 500), // Pause between animations
          ),
        ),
        backgroundColor: Color(0xFF65E892),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello Sreesh,\nHow was your day?',
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Let’s build some positive habits to reach your goals! Below are some quick updates:',
              style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  buildHabitBox('Morning Routine', Icons.sunny),
                  buildHabitBox('Exercise', Icons.fitness_center),
                  buildHabitBox('Study', Icons.book),
                  buildHabitBox('Meditation', Icons.self_improvement),
                  buildToDoContainer(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Color(0xFF65E892),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            navBarItem(Icons.list_alt, 'Habits', 0),
            navBarItem(Icons.history, 'History', 1),
            SizedBox(width: 50), // Spacer for FAB
            navBarItem(Icons.person, 'Profile', 3),
            navBarItem(Icons.info, 'Info', 4),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onNavBarTapped(0),  // Navigate to Habits page on tap
        child: Icon(Icons.home, size: 28),
        backgroundColor: Color(0xFF41A06F),
        foregroundColor: Colors.white,
        elevation: 4.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Function to create a navigation bar item
  Widget navBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => _onNavBarTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _selectedIndex == index ? Colors.white : Colors.black54),
          Text(
            label,
            style: TextStyle(color: _selectedIndex == index ? Colors.white : Colors.black54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Function to create a habit box UI element
  Widget buildHabitBox(String title, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF3D289B), size: 40),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3D289B)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Function to create the to-do container UI
  Widget buildToDoContainer() {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To-Do List',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3D289B)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: toDoTasks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(toDoTasks[index]),
                              trailing: IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => completeTask(index),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: 'Type a new task...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: addTask,
                child: Text('Add'),
                style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 183, 255, 218)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
