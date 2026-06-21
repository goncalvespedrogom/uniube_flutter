import 'package:flutter/material.dart';
import 'calendar_screen.dart';
import 'task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    CalendarScreen(),
    TaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple[800],
        unselectedItemColor: Colors.grey.shade500,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendário',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Tarefas',
          ),
        ],
      ),
    );
  }
}
