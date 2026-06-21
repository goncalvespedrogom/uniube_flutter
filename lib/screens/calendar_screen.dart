import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now(); // dia atual selecionado por padrão

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1).weekday;

    List tasksForSelectedDay = taskProvider.getTasksForDate(_selectedDay);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Calendário'),
        elevation: 0,
        backgroundColor: Colors.purple[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // cabeçalho do mês
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.purple),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                    });
                  },
                ),
                Text(
                  '${_focusedDay.month}/${_focusedDay.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.purple),
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Grid de dias
            Expanded(
              flex: 3,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1.1,
                ),
                itemCount: 42,
                itemBuilder: (context, index) {
                  final day = index - firstDay + 1;
                  if (day < 1 || day > daysInMonth) {
                    return Container();
                  }
                  final date = DateTime(_focusedDay.year, _focusedDay.month, day);
                  final tasksForDay = taskProvider.getTasksForDate(date);
                  final isToday = date.year == DateTime.now().year &&
                                  date.month == DateTime.now().month &&
                                  date.day == DateTime.now().day;
                  final isSelected = _selectedDay.year == date.year &&
                                     _selectedDay.month == date.month &&
                                     _selectedDay.day == date.day;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.purple[800]
                            : isToday
                                ? Colors.purple[50]
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? Colors.purple[800]!
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? Colors.purple[800]
                                      : Colors.black87,
                              fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                              fontSize: 15,
                            ),
                          ),
                          if (tasksForDay.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                tasksForDay.length > 3 ? 3 : tasksForDay.length,
                                (i) => Container(
                                  width: 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.white : Colors.purple,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            // card de tarefas do dia selecionado
            Expanded(
              flex: 2,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarefas do dia ${_selectedDay.day}/${_selectedDay.month}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple[800],
                        ),
                      ),
                      const Divider(color: Colors.purple),
                      if (tasksForSelectedDay.isEmpty)
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Nenhuma tarefa para este dia.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: ListView.builder(
                            itemCount: tasksForSelectedDay.length,
                            itemBuilder: (ctx, i) {
                              final task = tasksForSelectedDay[i];
                              return ListTile(
                                leading: Icon(
                                  task.isDone ? Icons.check_circle : Icons.circle_outlined,
                                  color: task.isDone ? Colors.green : Colors.purple,
                                  size: 20,
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(
                                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                                    color: task.isDone ? Colors.grey : Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () {
                                    taskProvider.removeTask(task.id);
                                  },
                                ),
                                dense: true,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
